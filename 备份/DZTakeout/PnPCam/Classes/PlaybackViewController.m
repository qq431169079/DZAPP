//
//  PlaybackViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaybackViewController.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"

@interface PlaybackViewController ()

@end

@implementation PlaybackViewController

@synthesize navigationBar;
@synthesize imageView;
@synthesize m_pRecPathMgt;
@synthesize m_nSelectIndex;
@synthesize strDID;
@synthesize strDate;
@synthesize imagePauseNormal;
@synthesize imagePausePressed;
@synthesize imagePlayNormal;
@synthesize imagePlayPressed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) StartPlayback: (NSString*) filepath
{
    if (m_pLocalPlayback == NULL) {
        m_pLocalPlayback = new CLocalPlayback();
        m_pLocalPlayback->SetPlaybackDelegate(self);
        if (!m_pLocalPlayback->StartPlayback((char*)[filepath UTF8String])) {
            SAFE_DELETE(m_pLocalPlayback);
            return NO;
        }
    }
    
    return YES;
}

- (void) StopPlayback
{
    //NSLog(@"StopPlayback");
    //NSLog(@"AAAAAAAAAAAAAAAAA");
    [m_playbackstoplock lock];
    if(m_pLocalPlayback == NULL)
    {
        [m_playbackstoplock unlock];
        return ;
    }
    
    m_pLocalPlayback->SetPlaybackDelegate(nil);
    SAFE_DELETE(m_pLocalPlayback);
    
   
    //NSLog(@"BBBBBBBBBBBBB");
    
    IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [IPCamDelegate switchBack];
    
    [m_playbackstoplock unlock];
}

- (NSString*) GetRecordPath: (NSString*)strFileName
{
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    

    strPath = [strPath stringByAppendingPathComponent:strFileName];
    //NSLog(@"strPath: %@", strPath);
    return strPath;
    
    
}

- (void) btnPlayControl: (id) sender
{
    //NSLog(@"btnPlayControl");
    m_bPlayPause = !m_bPlayPause ;
    m_pLocalPlayback->Pause(m_bPlayPause);
    if (m_bPlayPause) {
        [playButton setImage:imagePlayNormal forState:UIControlStateNormal] ;
        [playButton setImage:imagePlayPressed forState:UIControlStateHighlighted];
    }else{
        [playButton setImage:imagePauseNormal forState:UIControlStateNormal] ;
        [playButton setImage:imagePausePressed forState:UIControlStateHighlighted];
    }
        
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    m_pLocalPlayback = NULL;
    m_bPlayPause = NO;
    m_bHideToolBar = NO;
    myGLViewController = nil;
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    m_playbackstoplock = [[NSCondition alloc] init];
    
    
    CGRect getFrame = [[UIScreen mainScreen]applicationFrame];
    m_nScreenHeight = getFrame.size.width;
    m_nScreenWidth = getFrame.size.height;
    
    navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navigationBar.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"navbk.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.alpha = 0.6f;
    
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strDate];
    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];    
    [navigationBar setItems:array];
    
    [item release];
    [back release];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
    [imageGR setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:imageGR];
    [imageGR release];

    
    //load image
    self.imagePlayNormal = [UIImage imageNamed:@"video_play_pause_normal.png"];
    self.imagePlayPressed = [UIImage imageNamed:@"video_play_pause_pressed.png"] ;
    self.imagePauseNormal = [UIImage imageNamed:@"video_play_play_normal.png"];
    self.imagePausePressed = [UIImage imageNamed:@"video_play_play_pressed.png"];
    
    //-------------bottomView--------------------------------------
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame] ;
    float bottomViewHeight = 80 ;
    float bottomViewX = 0;
    float bottomViewY = screenRect.size.width - bottomViewHeight ;
    float bottomViewWidth = screenRect.size.height;
    
    //NSLog(@"bottomViewX: %f, bottomViewY: %f, bottomViewWidth: %f, bottomViewHeight: %f", bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight);
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    bottomView.alpha = 0.6f ;
    
    float sliderX = 10 ;
    float sliderY = 5 ;
    float sliderWidth = bottomView.frame.size.width - 2 * sliderX ;
    float sliderHeight = 30 ;
    slider = [[UISlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight)];
    slider.userInteractionEnabled = NO;
    [bottomView addSubview:slider] ;
    
    
    float startLabelX = 10 ;
    float startLabelY = sliderY + sliderHeight + 5 ;
    float startLabelWidth = 100;
    float startLabelHeight = 30 ;
    startLabel = [[UILabel alloc] initWithFrame:CGRectMake(startLabelX, startLabelY, startLabelWidth, startLabelHeight)] ;
    startLabel.text = @"00:00:00";
    startLabel.textAlignment = UITextAlignmentLeft ;
    startLabel.backgroundColor = [UIColor clearColor];
    startLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:startLabel];
    
    
    float endLabelWidth = 100;
    float endLabelX = bottomView.frame.size.width - 10 - 100 ;
    float endLabelY = sliderY + sliderHeight + 5 ;
    float endLabelHeight = 30 ;
    endLabel = [[UILabel alloc] initWithFrame:CGRectMake(endLabelX, endLabelY, endLabelWidth, endLabelHeight)] ;
    endLabel.text = @"00:00:00";
    endLabel.textAlignment = UITextAlignmentRight;
    endLabel.textColor = [UIColor whiteColor];
    endLabel.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:endLabel];
    
    
    float centerX = bottomView.frame.size.width / 2;
    float playButtonX = centerX - 20 ;
    float playButtonY = sliderY + sliderHeight;
    float playButtonWidth = 40;
    float playButtonHeight = 40;
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(playButtonX, playButtonY, playButtonWidth, playButtonHeight)];
    [playButton addTarget:self action:@selector(btnPlayControl:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setImage:imagePauseNormal forState:UIControlStateNormal] ;
    [playButton setImage:imagePausePressed forState:UIControlStateHighlighted];
    [bottomView addSubview:playButton];
    
    [self.view addSubview:bottomView];
    //[slider release];
    //[startLabel release];
    //[endLabel release];
    //[playButton release];
    
    //=====================================================================
    
    NSMutableArray *pathArray = [m_pRecPathMgt GetTotalPathArray:strDID date:strDate];
    if (pathArray == nil) {
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    }
    
    if (m_nSelectIndex >= [pathArray count]) {
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    }
    
//    for (NSString *path in pathArray) {
//        NSLog(@"path: %@", path);
//    }
    
    NSString *strRecFileName = [pathArray objectAtIndex:m_nSelectIndex];
    //NSLog(@"strRecFileName: %@, m_nSelectIndex: %d", strRecFileName, m_nSelectIndex);
    
    NSString *strRecPath = [self GetRecordPath:strRecFileName];
    //NSLog(@"strRecPath: %@", strRecPath);
    
    if (![self StartPlayback:strRecPath]) {
        [self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    }
    
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
    if (version >= 6.0) {
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
        [bottomView release];
        bottomView = nil;
    }
    if (playButton != nil) {
        [playButton release];
        playButton = nil;
    }
}

- (void) CreateGLView
{
    if (myGLViewController != nil) {
        return;
    }
    
    myGLViewController = [[MyGLViewController alloc] init];
    myGLViewController.view.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
    [self.view addSubview:myGLViewController.view];
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
    self.m_pRecPathMgt = nil;
    self.strDID = nil;
    self.strDate = nil;
    if (bottomView != nil) {
        [bottomView release];
        bottomView = nil;
    }
    if (playButton != nil) {
        [playButton release];
        playButton = nil;
    }
    if (startLabel != nil) {
        [startLabel release];
        startLabel = nil;
    }
    if (endLabel != nil) {
        [endLabel release];
        endLabel = nil;
    }
    if (slider != nil) {
        [slider release];
        slider = nil;
    }
    self.imagePlayNormal = nil;
    self.imagePlayPressed = nil;
    self.imagePauseNormal = nil;
    self.imagePausePressed = nil;
    
    if (myGLViewController != nil) {
        [myGLViewController release];
        myGLViewController = nil;
    }
    
    if (m_playbackstoplock != nil) {
        [m_playbackstoplock release];
        m_playbackstoplock = nil;
    }
    [super dealloc];
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    //NSLog(@"1111111111");
    [self StopPlayback];
    //NSLog(@"22222222");
    return NO;
}

#pragma mark -
#pragma mark performOnMainThread
- (void) updateImage: (UIImage*) image
{
    imageView.image = image;
   // [image release];
}

- (void) updateTotalTime: (NSNumber*) totalTime
{
    m_nTotalTime = [totalTime intValue];
    
    endLabel.text = [self secTimeToString:[totalTime intValue]];
    
    [slider setMinimumValue:0];
    [slider setMaximumValue:[totalTime intValue]];
}

- (void) updateCurrTime: (NSNumber*) currTime
{
    startLabel.text = [self secTimeToString:[currTime intValue]];
    [slider setValue:[currTime intValue]];
}

#pragma mark -
#pragma mark other
- (NSString*) secTimeToString: (NSInteger) secTime
{
    int hour = secTime / 60 / 60;
    int minute = (secTime - hour * 3600 ) / 60;
    int sec = (secTime - hour * 3600 - minute * 60) ;
    
    NSString *strTime = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, sec];
    return strTime;
    
}

- (void) DelayStop
{
    [self performSelector:@selector(StopPlayback) withObject:nil afterDelay:1.0f];
}

#pragma mark -
#pragma mark playbackDelegate

- (void) PlaybackData:(Byte *)yuv length:(int)length width:(int)width height:(int)height
{
    //NSLog(@"PlaybackData... length: %d, width: %d, height: %d", length, width, height);
    [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:NO];
    [myGLViewController WriteYUVFrame:yuv Len:length width:width height:height];
}

- (void) PlaybackData:(UIImage *)image
{
    //NSLog(@"PlaybackData");
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
}

- (void) PlaybackPos:(NSInteger)nPos
{
    //NSLog(@"PlaybackPos, nPos: %d", nPos);
    
    [self performSelectorOnMainThread:@selector(updateCurrTime:) withObject:[NSNumber numberWithInt:nPos] waitUntilDone:NO];
}

- (void) PlaybackStop
{
    //NSLog(@"PlaybackStop");
    [self PlaybackPos:m_nTotalTime];
    [self performSelectorOnMainThread:@selector(DelayStop) withObject:nil waitUntilDone:NO];
    //[self performSelectorOnMainThread:@selector(StopPlayback) withObject:nil waitUntilDone:NO];
    //[self performSelector:@selector(StopPlayback) withObject:nil afterDelay:1.0f];
}

- (void) PlaybackTotalTime:(NSInteger)nTotalTime
{
    //NSLog(@"PlaybackTotalTime: %d", nTotalTime);
    [self performSelectorOnMainThread:@selector(updateTotalTime:) withObject:[NSNumber numberWithInt:nTotalTime] waitUntilDone:NO];
    
    
}

@end
