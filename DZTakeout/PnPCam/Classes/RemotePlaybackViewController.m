//
//  PlaybackViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RemotePlaybackViewController.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"

@interface RemotePlaybackViewController ()
{
    BOOL changeSliderValue;
}

@end

@implementation RemotePlaybackViewController

@synthesize navigationBar;
@synthesize imageView;
@synthesize strDID;
@synthesize m_strFileName;
@synthesize m_pPPPPMgnt;
@synthesize m_strName;
@synthesize progressView;
@synthesize LblProgress;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) StopPlayback
{
    [m_playbackstoplock lock];
    
    m_pPPPPMgnt->PPPPStopPlayback((char*)[strDID UTF8String]);
    m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], nil);
    
    IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [IPCamDelegate switchBack];
    
    [m_playbackstoplock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    CGPoint center = CGPointMake(winsize.height/2, winsize.width/2);
    progressView.center = center;
    LblProgress.center = center;
    m_bPlayPause = NO;
    m_bHideToolBar = NO;
    myGLViewController = nil;
    
    self.imageView.backgroundColor = [UIColor grayColor];
    
    m_playbackstoplock = [[NSCondition alloc] init];
    
    
    CGRect getFrame = [[UIScreen mainScreen]applicationFrame];
    m_nScreenHeight = getFrame.size.width;
    m_nScreenWidth = getFrame.size.height;
    
    navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navigationBar.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"navbk.png"];
    if ([IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.alpha = 0.6f;
    
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:m_strName];
    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    [navigationBar setItems:array];
    
//    [item release];
//    [back release];
//
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
    [imageGR setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:imageGR];
//    [imageGR release];
    
    
    //-------------bottomView--------------------------------------
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame] ;
    float bottomViewHeight = 60 ;
    float bottomViewX = 0;
    float bottomViewY = screenRect.size.width - bottomViewHeight ;
    float bottomViewWidth = screenRect.size.height;
    
    //NSLog(@"bottomViewX: %f, bottomViewY: %f, bottomViewWidth: %f, bottomViewHeight: %f", bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight);
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    bottomView.alpha = 0.6f ;
    bottomView.userInteractionEnabled = YES;
    CGRect rectLabel = bottomView.bounds;
    
    UILabel *fileNameLabel = [[UILabel alloc] initWithFrame:rectLabel];
    fileNameLabel.textAlignment = NSTextAlignmentCenter;
    fileNameLabel.text = m_strFileName;
    fileNameLabel.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    fileNameLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:fileNameLabel];
    fileNameLabel.userInteractionEnabled = YES;
//    [fileNameLabel release];
    
    [self.view addSubview:bottomView];
    CGRect rect = bottomView.bounds;
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20.f, 0.f, CGRectGetWidth(rect) - 40.f, 20.f)];
    [self.slider addTarget:self action:@selector(dragVideoProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(begindragVideoPress:) forControlEvents:UIControlEventTouchDown];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = self.record_Size;
    [bottomView addSubview:self.slider];
    self.LblProgress.text = NSLocalizedStringFromTable(@"Connecting", @STR_LOCALIZED_FILE_NAME,nil);
    self.LblProgress.textColor = [UIColor whiteColor];
    [self.progressView startAnimating];
    self.playLength = 0;
    //=====================================================================
    
    m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], self);
    if (!m_pPPPPMgnt->PPPPStartPlayback((char*)[strDID UTF8String],(char*)[m_strFileName UTF8String], 0)) {
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)begindragVideoPress:(UISlider *)slider {
    changeSliderValue = YES;
    
}

- (void) dragVideoProgress:(UISlider*) slider{
    changeSliderValue = NO;
    NSInteger value = self.slider.value;
    self.playLength = value;
    
    if(value >= self.record_Size - 1024*500)
    {
        [self stopPlaybackLiveStream];
        [self PlayEnd:nil];
    }
    else
    {
        self.progressView.hidden = NO;
        [self.view bringSubviewToFront:self.progressView];
        
        [self startPlayBackLiveStream];
    }
}

- (void) startPlayBackLiveStream
{
    
    if (!m_pPPPPMgnt->PPPPStartPlayback((char*)[strDID UTF8String],(char*)[m_strFileName UTF8String], (int)self.playLength))
    {
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    }
}

- (void) stopPlaybackLiveStream{
    
    [m_playbackstoplock lock];
    
    m_pPPPPMgnt->PPPPStopPlayback((char*)[strDID UTF8String]);
    m_pPPPPMgnt->SetPlaybackDelegate((char*)[strDID UTF8String], nil);
    
    [m_playbackstoplock unlock];
    
}

- (void) PlayEnd:(id) sender{
    self.playLength = self.record_Size;
    self.slider.value = self.playLength;
//    [mytoast showWithText:@"播放结束"];
    
}

- (void) imageTouched: (UITapGestureRecognizer*)sender
{
    m_bHideToolBar = !m_bHideToolBar ;
    
    [navigationBar setHidden:m_bHideToolBar];
    [bottomView setHidden:m_bHideToolBar];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 6.0) {//ios6
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        
        CGRect rectScreen = [[UIScreen mainScreen] applicationFrame];
        
        self.view.frame = rectScreen;//CGRectMake(0,0,480,320);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (bottomView != nil) {
//        [bottomView release];
        bottomView = nil;
    }
    if (playButton != nil) {
//        [playButton release];
        playButton = nil;
    }
}

- (void) CreateGLView
{
    if (myGLViewController != nil) {
        return;
    }
    
    myGLViewController = [[IJKSDLGLView alloc] initWithFrame:CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight)];
    myGLViewController.backgroundColor = [UIColor blackColor];
    myGLViewController.userInteractionEnabled = YES;
    [self.view addSubview:myGLViewController];
    [self.view bringSubviewToFront:navigationBar];
    [self.view bringSubviewToFront:bottomView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.imageView = nil;
    self.strDID = nil;
    self.m_strFileName = nil;
    self.m_strName = nil;
    self.progressView = nil;
    self.LblProgress = nil;
    
    if (bottomView != nil) {
//        [bottomView release];
        bottomView = nil;
    }
    
    if (myGLViewController != nil) {
//        [myGLViewController release];
        myGLViewController = nil;
    }
    
    if (m_playbackstoplock != nil) {
//        [m_playbackstoplock release];
        m_playbackstoplock = nil;
    }
//    [super dealloc];
}

#pragma mark -
#pragma mark performOnMainThread
- (void) updateImage: (UIImage*) image
{
    imageView.image = image;
    // [image release];
}

- (void) hideView
{
    [self.progressView setHidden:YES];
    [self.LblProgress setHidden:YES];
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self StopPlayback];
    return NO;
}

#pragma mark -
#pragma mark- p2p回调
- (void) VideoDataLength:(int) length AvheadType:(int)type szdid:(NSString*)szdid
{
    if (![strDID isEqualToString:szdid]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.playLength += length;
                       if (type == 100)
                       {
                           [self performSelector:@selector(PlayEnd:) withObject:nil afterDelay:10];
                       }
                       if (!changeSliderValue) {
                           [self.slider setValue:self.playLength animated:YES];
                       }
                       
                   });
}

- (void)YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp
{
    [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:NO];
    
    SDL_VoutOverlay stOverlay;
    memset(&stOverlay, 0, sizeof(stOverlay));
    stOverlay.w = (int)width ;
    stOverlay.h = (int)height;
    stOverlay.pitches[0] = width;
    stOverlay.pitches[1] = stOverlay.pitches[2] = width /2;
    stOverlay.pixels[0] = yuv;
    stOverlay.pixels[1] = yuv + width*height;
    stOverlay.pixels[2] = yuv + width*height*5/4;
    
    [myGLViewController display:&stOverlay];
}

- (void)ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp
{
    [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
}

- (void)H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger)timestamp
{
    
}

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp szdid:(NSString*)szdid{
    
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp szdid:(NSString*)szdid{
    
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp szdid:(NSString*)szdid{
    
}

@end
