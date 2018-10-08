//
//  Split-screenViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-2-19.
//
//

#import "Split-screenViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "obj_common.h"
#import "PPPPDefine.h"
#import "APICommon.h"
#define BOOL_bPlaying "BOOL_bPlaying"
#define BGColor [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3f];
@interface Split_screenViewController ()

@end

@implementation Split_screenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender{
    /*if ([self.timer0 isValid]) {
     [self.timer0 invalidate];
     [_timer0 release];
     self.timer0 = nil;
     }
     if ([self.timer1 isValid]) {
     [self.timer1 invalidate];
     [_timer1 release];
     self.timer1 = nil;
     }
     
     if ([self.timer2 isValid]) {
     [self.timer2 invalidate];
     [_timer2 release];
     self.timer2 = nil;
     }
     
     if ([self.timer3 isValid]) {
     [self.timer3 invalidate];
     [_timer3 release];
     self.timer3 = nil;
     }*/
    self.time0Sec = 0;
    self.time1Sec = 0;
    self.time2Sec = 0;
    self.time3Sec = 0;
    NSLog(@"cameraIsstartLive  %@",_cameraIsStartLive);
    _isPushPlayVc = NO;
    
    //[self performSelectorOnMainThread:@selector(StopAll) withObject:nil waitUntilDone:NO];
    [NSThread detachNewThreadSelector:@selector(StopAll:) toTarget:self withObject:nil];
    
    IpCameraClientAppDelegate* ipcamDelegate = (IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate;
    [ipcamDelegate switchBack];
    //    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //    [alert show];
    //    [alert release];
    //    _anAlert = [[[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil] autorelease];
    //    [_anAlert show];
    //
    //    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayback:) userInfo:nil repeats:NO];
    
}

- (void)delayback:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_anAlert dismissWithClickedButtonIndex:0 animated:YES];
        
    });
}

- (void)StopAll:(id)sender{
    //NSLog(@"StopAll");
    
    if (self.ppppChannelMgt != NULL) {
        /*self.ppppChannelMgt->StopPPPPLivestream([[_camdic objectForKey:@STR_DID] UTF8String]);
         self.ppppChannelMgt->StopPPPPLivestream([self.str_uid UTF8String]);*/
        /*for (NSString* camdid in _cameraInfos){
         self.ppppChannelMgt->StopPPPPLivestream([camdid UTF8String]);
         }*/
        switch (([_cameraInfos count] - 4 * _currentPage)/4 ? 4 : [_cameraInfos count]%4){
            case 4:
                if ([(NSNumber*)[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 3]] boolValue]) {
                    self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:_currentPage * 4 + 3] UTF8String]);
                    [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 3]];
                }
                
            case 3:
                if ([(NSNumber*)[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 2]]boolValue]) {
                    self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:_currentPage * 4 + 2] UTF8String]);
                    [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 2]];
                }
                
            case 2:
                if ([(NSNumber*)[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 1]]boolValue]) {
                    self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:_currentPage * 4 + 1] UTF8String]);
                    [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 1]];
                }
                
            case 1:
                if ([(NSNumber*)[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 0]]boolValue]) {
                    self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:_currentPage * 4 + 0] UTF8String]);
                    [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:_currentPage * 4 + 0]];
                }
                
                
            default:
                
                break;
        }
    }
    
    NSLog(@"cameraIsStartLive  %@",_cameraIsStartLive);
    if (_isPushPlayVc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *cameraDic = [self.cameraDics objectAtIndex:((UITapGestureRecognizer*)sender).view.tag];
            NSLog(@"cameraDic  %@",cameraDic);
            if (cameraDic == nil) {
                return;
            }
            NSString *strDID = [cameraDic objectForKey:@STR_DID];
            NSString *strName = [cameraDic objectForKey:@STR_NAME];
            NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            //pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[strDID UTF8String], 0, 0);
            
            
            IpCameraClientAppDelegate *IPCamDelegate =  (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate] ;
            PlayViewController* playViewController;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_iPad" bundle:nil];
            }else{
                playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
            }
            playViewController.m_pPPPPChannelMgt = self.ppppChannelMgt;
            playViewController.strDID = strDID;
            playViewController.cameraName = strName;
            playViewController.m_nP2PMode = [nPPPPMode intValue];
            playViewController.b_split = YES;
            
            NSLog(@"strDID  %@",strDID);
            [IPCamDelegate switchPlayView:playViewController];
        });
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    _bPlaying = NO;
    _bManualStop = NO;
    _mark = 0;
    _currentPage = 0;
    _oldPage = 0;
    
    // _timeoutTimer = nil;
    _anAlert = nil;
    _imageView0 = nil;
    _imageView1 = nil;
    _imageView2 = nil;
    _imageView3 = nil;
    
    _myGlViewCtr0 = nil;
    _myGlViewCtr1 = nil;
    _myGlViewCtr2 = nil;
    _myGlViewCtr3 = nil;
    
    self.winsize = [UIScreen mainScreen].bounds.size;
    self.view.autoresizesSubviews = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // self.tapGestures = [[NSMutableArray alloc] init];
    self.cameraInfos = [[NSMutableArray alloc] init];
    self.cameraInfoDic = [[NSMutableDictionary alloc] init];
    //self.imageViews = [[NSMutableArray alloc] init];
    //self.myGlViews = [[NSMutableArray alloc] init];
    self.cameraDics = [[NSMutableArray alloc] init];
    self.cameraNames = [[NSMutableArray alloc] init];
    self.cameramodeDic = [[NSMutableDictionary alloc] init];
    self.cameraIsStartLive = [[NSMutableDictionary alloc] init];
    //self.displayViews = [[NSMutableArray alloc] init];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, _winsize.width, 340)];
    
    [self performSelectorOnMainThread:@selector(initCameraInfo) withObject:nil waitUntilDone:YES];
    
    
    /* UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
     button.layer.cornerRadius = 5.0f;
     button.layer.masksToBounds = YES;
     [button setTitle:@"lll" forState:UIControlStateNormal];
     [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
     button.backgroundColor = [UIColor redColor];
     [self.view addSubview:button];
     [button release];*/
    self.timeoutSec = 180;
    self.time0Sec = 180;
    self.time1Sec = 180;
    self.time2Sec = 180;
    self.time3Sec = 180;
    
    self.naBar = [[UINavigationBar alloc] init];
    self.timeoutLabel = [[UILabel alloc] init];
    self.timeoutLabel.hidden = YES;
    self.timeoutLabel.textAlignment = NSTextAlignmentCenter;
    self.timeoutLabel.font = [UIFont systemFontOfSize:13.f];
    self.timeoutLabel.backgroundColor = [UIColor clearColor];
    self.timeoutLabel.textColor = [UIColor redColor];
    self.timeoutLabel.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.timeoutSec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.naBar.frame = CGRectMake(0.f, 0.f, _winsize.height, 44.f);
        self.timeoutLabel.frame = CGRectMake(0.f, 44.f, _winsize.height, 44.f);
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.naBar.frame = CGRectMake(0.f, 0.f, _winsize.width, 44.f);
        self.timeoutLabel.frame = CGRectMake(0.f, 44.f, _winsize.width, 44.f);
    }
    [self.view addSubview:self.timeoutLabel];
    self.naBar.barStyle = UIBarStyleBlackOpaque;
    self.naBar.delegate = self;
    self.naBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sortbg"]];
    [self.view addSubview:self.naBar];
    
    UINavigationItem* item1 = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Splite", @STR_LOCALIZED_FILE_NAME, nil)];
    UIBarButtonItem* Baritem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    item1.leftBarButtonItem = Baritem;
    [self.naBar setItems:[NSArray arrayWithObject:item1]];

    
    //    if ([_cameraInfos count] == 0) {
    //        [self back:nil];
    //        return;
    //    }
    
    /*if (self.ppppChannelMgt != NULL) {
     
     for (NSString* camdid in _cameraInfos){
     //  [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camdid];
     }
     }*/
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //_currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    //NSLog(@"currentPage  %d",_currentPage);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //_currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    //    if (2 * scrollView.contentOffset.x >= scrollView.frame.size.width) {
    //        _currentPage += 1;
    //    }
    //    if (scrollView.contentOffset.x <= 0) {
    //        _currentPage -= 1;
    //    }
    //    NSLog(@"currentPage  %d  oldPage  %d  scrollView.contentOffset.x  %f",_currentPage,_oldPage,scrollView.contentOffset.x);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    //NSLog(@"currentPage  %d",_currentPage);
    
    
    if (_currentPage != _oldPage) {
        [self performSelectorOnMainThread:@selector(DisMissOldDisPlayView:) withObject:[NSNumber numberWithInt:_oldPage] waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(CreateDisPlayView:) withObject:[NSNumber numberWithInt:_currentPage] waitUntilDone:YES];
    }
    _oldPage = _currentPage;
}

- (void)startLiveStream:(NSString*)camdid{
    NSInteger substream = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_ResolutionValue",camdid]];
    if (self.ppppChannelMgt->StartPPPPLivestream([camdid UTF8String], 10,(int)substream, self) == 0) {
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:camdid  waitUntilDone:NO];
    }else{
        [_cameraIsStartLive setObject:[NSNumber numberWithBool:YES] forKey:camdid];
    }
}

- (void)initCameraInfo{
    /*if ([self.cameraListMgt GetCount] <= 0) {
     return;
     }*/
    BOOL bPlaying = NO;
    for (int i = 0; i < [self.cameraListMgt GetCount]; i++){
        NSDictionary* camdic = [self.cameraListMgt GetCameraAtIndex:i];
        if (camdic == nil) {
            continue;
        }
        NSString* camdid = [camdic objectForKey:@STR_DID];
        NSString* camStatus = [camdic objectForKey:@STR_PPPP_STATUS];
        NSString* camname = [camdic objectForKey:@STR_NAME];
        NSNumber* p2p_mode = [camdic objectForKey:@STR_PPPP_MODE];
        if ([camStatus intValue] == PPPP_STATUS_ON_LINE) {
            [_cameraDics addObject:camdic];
            [_cameraInfos addObject:camdid];
            [_cameraNames addObject:camname];
            [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:camdid];
            [_cameramodeDic setObject:p2p_mode forKey:camdid];
            [_cameraInfoDic setObject:[NSNumber numberWithBool:bPlaying] forKey:camdid];
        }
    }
    if ([_cameraInfos count] == 0) {
        self.anAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"NoCamera", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles: nil] ;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO] ;
        [self.anAlert show];
        
        return;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    _numberofPages = [_cameraInfos count]/4 + (([_cameraInfos count]%4==0) ? 0 : 1);
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.scrollView.frame = CGRectMake(0.f, 44.f, _winsize.height, _winsize.width - 44.f);
            self.scrollView.contentSize = CGSizeMake(_winsize.height * _numberofPages, _winsize.width - 44.f);
        }else{
            self.scrollView.frame = CGRectMake(0.f, 44.f, _winsize.height, _winsize.width - 44.f);
            self.scrollView.contentSize = CGSizeMake(_winsize.height * _numberofPages, _winsize.width - 44.f);
        }
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.scrollView.frame = CGRectMake(0, 44.f, _winsize.width, _winsize.height - 44.f - 20.f);
            self.scrollView.contentSize = CGSizeMake(_winsize.width * _numberofPages, _winsize.height - 44.f - 20.f);
        }else{
            self.scrollView.frame = CGRectMake(0.f, 44.f, _winsize.width, _winsize.height - 44.f - 20.f);
            self.scrollView.contentSize = CGSizeMake(_winsize.width*_numberofPages, _winsize.height - 44.f - 20.f);
        }
    }
    // NSLog(@"%@",NSStringFromCGRect(self.scrollView.frame));
    //_scrollView.backgroundColor = [UIColor greenColor];
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    [self performSelectorOnMainThread:@selector(CreateBackGroundView:) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(CreateDisPlayView:) withObject:[NSNumber numberWithInt:_currentPage] waitUntilDone:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    [self back:nil];
}

- (void)dismissAlert{
    [self.anAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self back:nil];
    if (self.timer != nil) {
        [self.timer invalidate];
    }
}

/*
 self.imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 320 * curP, 10, 120, 120)];
 [self.scrollView addSubview:_imageView0];
 
 self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(180 + 320 * curP, 10, 120, 120)];
 [self.scrollView addSubview:_imageView1];
 
 self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 320 * curP, 230, 120, 120)];
 [self.scrollView addSubview:_imageView2];
 
 self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(180 + 320 * curP, 230, 120, 120)];
 [self.scrollView addSubview:_imageView3];
 
 */

/*
 switch (([_cameraInfos count] - 4 * i)/4 ? 4 : [_cameraInfos count]%4) {
 case 4:
 [[self.view viewWithTag:(i * 4 + 153)] setFrame:CGRectMake(275.f + i * _winsize.height, 125.f, 165.f, 105.f)];
 [[self.view viewWithTag:(i * 4 + 203)] setFrame:CGRectMake(275.f + i * _winsize.height, 125.f + 75, 165.f, 40.f)];
 [[self.view viewWithTag:(i * 4 + 253)] setFrame:CGRectMake(62.5f, 32.5f, 40, 40)];
 NSLog(@"view class : %@",[[self.view viewWithTag:(i * 4 + 153)] class]);
 
 case 3:
 [[self.view viewWithTag:(i * 4 + 152)] setFrame:CGRectMake(40.f + i * _winsize.height, 125.f, 165.f, 105.f)];
 [[self.view viewWithTag:(i * 4 + 202)] setFrame:CGRectMake(40.f + i * _winsize.height, 125.f + 75.f, 165.f, 40.f)];
 [[self.view viewWithTag:(i * 4 + 252)] setFrame:CGRectMake(62.5f, 32.5f, 40, 40)];
 case 2:
 [[self.view viewWithTag:(i * 4 + 151)] setFrame:CGRectMake(275.f + i * _winsize.height, 10.f, 165.f, 105.f)];
 [[self.view viewWithTag:(i * 4 + 201)] setFrame:CGRectMake(275.f + i * _winsize.height , 10.f + 75.f, 165.f, 40.f)];
 [[self.view viewWithTag:(i * 4 + 251)] setFrame:CGRectMake(62.5f, 32.5f, 40, 40)];
 case 1:
 [[self.view viewWithTag:(i * 4 + 150)] setFrame:CGRectMake(40.f + i * _winsize.height, 10.f, 165.f, 105.f)];
 [[self.view viewWithTag:(i * 4 + 200)] setFrame:CGRectMake(40.f + i * _winsize.height, 10.f + 75.f, 165.f, 40.f)];
 [[self.view viewWithTag:(i * 4 + 250)] setFrame:CGRectMake(62.5f, 32.5f, 40, 40)];
 default:
 break;
 }
 
 */

- (void)CreateBackGroundView:(id)sender{
    UIImageView* iv;
    UILabel* label;
    UIActivityIndicatorView* activityV ;
    //NSLog(@"camnames  =  %@",_cameraNames);
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        float iv_Height = (_winsize.width - 44.f - 4.f)/2;
        float iv_width =  iv_Height * _winsize.height/_winsize.width;
        
        for (int i = 0; i < _numberofPages; i++) {
            
            switch (([_cameraInfos count] - 4 * i)/4 ? 4 : ([_cameraInfos count]%4 == 3 ? [_cameraInfos count]%4 : 0)) {
                case 4:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_width + (_winsize.height - 2 * iv_width)*2/3) + i * _winsize.height, iv_Height + 3.f, iv_width, iv_Height)];
                    
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 153;
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = i * 4 + 253;
                    [iv addSubview:activityV];

                    
                    [self.scrollView addSubview:iv];
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 3)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];//BGColor;
                    label.font = [UIFont fontWithName:@"System" size:13.f];
                    label.tag = i * 4 + 353;
                    [self.scrollView addSubview:label];
                    
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv_width, 25.f)];
                    label.tag = 4 * i + 203;
                    label.hidden = YES;
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    
                    [self.scrollView addSubview:label];
                    [self.scrollView bringSubviewToFront:label];

                case 3:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake((_winsize.height - iv_width*2)/3 + i * _winsize.height, iv_Height + 3.f, iv_width, iv_Height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 152;
                    [self.scrollView addSubview:iv];
                    
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = 4 * i + 252;
                    [iv addSubview:activityV];

                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 2)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];//BGColor;
                    label.font = [UIFont fontWithName:@"System" size:13.f];
                    label.tag = i * 4 + 352;
                    [self.scrollView addSubview:label];

                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake((_winsize.height - iv_width*2)/3 + i * _winsize.height, iv.frame.origin.y + iv.frame.size.height - 25.f, iv_width, iv_Height)];
                    label.tag = 4 * i + 202;
                    label.hidden = YES;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];

                case 2:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_width + (_winsize.height - iv_width*2)*2/3) + i * _winsize.height, 1.f, iv_width, iv_Height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 151;
                    [self.scrollView addSubview:iv];
                    
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = 4 * i + 251;
                    [iv addSubview:activityV];
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 1)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];//BGColor;
                    label.font = [UIFont fontWithName:@"System" size:13.f];
                    label.tag = i * 4 + 351;
                    [self.scrollView addSubview:label];
                    
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x , iv.frame.origin.y + iv.frame.size.height - 25.f, iv_width, 25.f)];
                    label.tag = 4 * i + 201;
                    label.hidden = YES;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];

                case 1:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake((_winsize.height - iv_width*2)/3 + i * _winsize.height, 1.f, iv_width, iv_Height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 150;
                    [self.scrollView addSubview:iv];
                    
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = 4 * i + 250;
                    [iv addSubview:activityV];
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];//BGColor;
                    label.font = [UIFont fontWithName:@"System" size:13.f];
                    label.tag = i * 4 + 350;
                    [self.scrollView addSubview:label];
                    
                    
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake((_winsize.height - iv_width*2)/3 + i * _winsize.height, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
                    label.tag = 4 * i + 200;
                    label.hidden = YES;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];

                default:
                    break;
            }
        }
        
        float iv1Height = _winsize.width - 44.f;
        float iv1Width = iv1Height * _winsize.height / _winsize.width;
        float iv1X = (self.scrollView.frame.size.width - iv1Width)/2;
        float iv1Y = (self.scrollView.frame.size.height - iv1Height)/2;
        
        NSLog(@"iv1Height %f  iv1Width %f iv1X %f iv1Y %f",iv1Height,iv1Width,iv1X,iv1Y);
        
        float iv2Width = (_winsize.height - 4)/2;
        float iv2Height = iv2Width * 3/4/*_winsize.width / _winsize.height*/;
        float iv2_left_X = (self.scrollView.frame.size.width - iv2Width * 2)/3;
        float iv2_right_x = 2 * iv2_left_X + iv2Width;
        float iv2Y = (self.scrollView.frame.size.height - iv2Height )/2;
        switch ([_cameraInfos count]%4) {
                
            case 1:
                /*iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_width + (_winsize.height - 2 * iv_width)*2/3) + (_numberofPages - 1) * _winsize.height, 1.f, iv_width, iv_Height)];
                 iv.backgroundColor = [UIColor blackColor];
                 iv.tag = 4 * (_numberofPages - 1) + 151;
                 [self.scrollView addSubview:iv];
                 [iv release];
                 */
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(iv1X + (_numberofPages - 1) * _winsize.height, iv1Y, iv1Width, iv1Height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 150;
                [self.scrollView addSubview:iv];
                
                activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                [activityV startAnimating];
                activityV.tag = 4 * (_numberofPages - 1) + 250;
                [iv addSubview:activityV];

                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                label.text = [_cameraNames objectAtIndex:((_numberofPages - 1) * 4 + 0)];
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];//BGColor;
                label.font = [UIFont fontWithName:@"System" size:13.f];
                label.tag = (_numberofPages - 1) * 4 + 350;
                [self.scrollView addSubview:label];

                
                
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
                label.tag = 4 * (_numberofPages - 1) + 200;
                label.hidden = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];

                
                NSLog(@"iv.frame  %@  150v  %@",NSStringFromCGRect(iv.frame),NSStringFromCGRect([self.view viewWithTag:150].frame));

                break;
            case 2:
                /*iv = [[UIImageView alloc] initWithFrame:CGRectMake((_winsize.height - 2 * iv_width)/3 + (_numberofPages - 1) * _winsize.height, iv_Height + 3.f, iv_width, iv_Height)];
                 iv.backgroundColor = [UIColor blackColor];
                 iv.tag = 4 * (_numberofPages - 1) + 152;
                 [self.scrollView addSubview:iv];
                 
                 [iv release];*/
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(iv2_left_X + (_numberofPages - 1) * _winsize.height, iv2Y, iv2Width, iv2Height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 150;
                [self.scrollView addSubview:iv];
                
                activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                [activityV startAnimating];
                activityV.tag = 4 * (_numberofPages - 1) + 250;
                [iv addSubview:activityV];

                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                label.text = [_cameraNames objectAtIndex:((_numberofPages - 1) * 4 + 0)];
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];//BGColor;
                label.font = [UIFont fontWithName:@"System" size:13.f];
                label.tag = (_numberofPages - 1) * 4 + 350;
                [self.scrollView addSubview:label];
           
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
                label.tag = 4 * (_numberofPages - 1) + 200;
                label.hidden = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];

                
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(iv2_right_x + (_numberofPages - 1) * _winsize.height, iv2Y, iv2Width, iv2Height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 151;
                [self.scrollView addSubview:iv];
                
                activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                [activityV startAnimating];
                activityV.tag = 4 * (_numberofPages - 1) + 251;
                [iv addSubview:activityV];

                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                label.text = [_cameraNames objectAtIndex:((_numberofPages - 1) * 4 + 1)];
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];//BGColor;
                label.font = [UIFont fontWithName:@"System" size:13.f];
                label.tag = (_numberofPages - 1) * 4 + 351;
                [self.scrollView addSubview:label];

                
                
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
                label.tag = 4 * (_numberofPages - 1) + 201;
                label.hidden = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];


                
                break;
            case 3:
                iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_width + (_winsize.height - iv_width * 2)*2/3) + (_numberofPages - 1) * _winsize.height, iv_Height + 3.f, iv_width, iv_Height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 153;
                
                [self.scrollView addSubview:iv];

            default:
                break;
        }
        /*}else{
         float iv_Height = 135.f;
         float iv_With = 135.f *  _winsize.height/_winsize.width;
         for (int i = 0; i < _numberofPages; i++) {
         UIActivityIndicatorView* activityV ;
         switch (([_cameraInfos count] - 4 * i)/4 ? 4 : [_cameraInfos count]%4) {
         case 4:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 153;
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = i * 4 + 253;
         [iv addSubview:activityV];
         [activityV release];
         [self.scrollView addSubview:iv];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 3)];
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];//BGColor;
         label.font = [UIFont fontWithName:@"System" size:13.f];
         label.tag = i * 4 + 353;
         [self.scrollView addSubview:label];
         [label release];
         
         //[self.view bringSubviewToFront:iv];
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv_With, 25.f)];
         label.tag = 4 * i + 203;
         // label.text = [_cameraNames objectAtIndex:(i * 4 + 3)];
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];//BGColor;
         label.textColor = [UIColor whiteColor];
         label.hidden = YES;
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [self.scrollView bringSubviewToFront:label];
         [iv release];
         [label release];
         case 3:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 152;
         [self.scrollView addSubview:iv];
         
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = 4 * i + 252;
         [iv addSubview:activityV];
         [activityV release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv_With, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 2)];
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];//BGColor;
         label.font = [UIFont fontWithName:@"System" size:13];
         label.tag = i * 4 + 352;
         [self.scrollView addSubview:label];
         [label release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv_With, 25.f)];
         //label.text = [_cameraNames objectAtIndex:(i * 4 + 2)];
         label.tag = 4 * i + 202;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];//BGColor;//[UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.hidden = YES;
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         [iv release];
         case 2:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 1.f, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 151;
         [self.scrollView addSubview:iv];
         
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = 4 * i + 251;
         [iv addSubview:activityV];
         [activityV release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 1)];
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];//BGColor;
         label.font = [UIFont fontWithName:@"System" size:13];
         label.tag = i * 4 + 351;
         [self.scrollView addSubview:label];
         [label release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x , iv.frame.origin.y + iv.frame.size.height - 25.f, iv_With, 25.f)];
         //label.text = [_cameraNames objectAtIndex:(i * 4 + 1)];
         label.tag = 4 * i + 201;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];//BGColor;//[UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         label.hidden = YES;
         [self.scrollView addSubview:label];
         [label release];
         [iv release];
         case 1:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((_winsize.height - iv_With * 2)/3 + i * _winsize.height, 1.f, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 150;
         [self.scrollView addSubview:iv];
         
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = 4 * i + 250;
         [iv addSubview:activityV];
         [activityV release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];//BGColor;
         label.font = [UIFont fontWithName:@"System" size:13];
         label.tag = i * 4 + 350;
         [self.scrollView addSubview:label];
         [label release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
         //label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
         label.tag = 4 * i + 200;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         label.hidden = YES;
         [self.scrollView addSubview:label];
         [label release];
         [iv release];
         default:
         break;
         }
         }
         
         if ([_cameraInfos count]%4 != 0) {
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(275.f + (_numberofPages - 1) * _winsize.height, 125.f, 165.f, 105.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 153;
         [self.scrollView addSubview:iv];
         [iv release];
         
         
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(40.f + (_numberofPages - 1) * _winsize.height, 125.f, 165.f, 105.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 152;
         [self.scrollView addSubview:iv];
         [iv release];
         
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(275.f + (_numberofPages - 1) * _winsize.height, 10.f, 165.f, 105.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 151;
         [self.scrollView addSubview:iv];
         [iv release];
         
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(40.f + (_numberofPages - 1) * _winsize.height, 10.f, 165.f, 105.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 150;
         [self.scrollView addSubview:iv];
         [iv release];
         }
         switch ([_cameraInfos count]%4 + 1) {
         
         case 2:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_With + (_winsize.height - iv_With * 2)*2/3) + (_numberofPages - 1) * _winsize.height, 1.f, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 151;
         [self.scrollView addSubview:iv];
         [iv release];
         case 3:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((_winsize.height - iv_With * 2)/3 + (_numberofPages - 1) * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 152;
         [self.scrollView addSubview:iv];
         [iv release];
         
         case 4:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_With + (_winsize.height - iv_With * 2)*2/3) + (_numberofPages - 1) * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 153;
         [self.scrollView addSubview:iv];
         [iv release];
         
         default:
         break;
         }
         }*/
        
    }else if(orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationPortrait){
        //if (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM()) {
        UIActivityIndicatorView* activityV ;
        float iv_width = (_winsize.width - 4.f)/2;
        float iv_height = iv_width  * 3/4/*_winsize.width / _winsize.height*/;
        float up_iv_y = (self.scrollView.frame.size.height - iv_height*2)/3;
        float down_iv_y = 2 * up_iv_y + iv_height;
        float left_iv_x = (self.scrollView.frame.size.width - iv_width*2)/3;
        float right_iv_x = 2 * left_iv_x + iv_width;
        for (int i = 0; i < _numberofPages; i++) {
            
            switch (([_cameraInfos count] - 4 * i)/4 ? 4 : ([_cameraInfos count]%4 == 3 ? 3 : 0)) {
                case 4:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake(right_iv_x + _winsize.width * i, down_iv_y, iv_width, iv_height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 153;
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = i * 4 + 253;
                    [iv addSubview:activityV];
  
                    
                    [self.scrollView addSubview:iv];
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 3)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.tag = 4 * i + 353;
                    label.font = [UIFont fontWithName:@"System" size:13];
                    label.backgroundColor = [UIColor clearColor];
                    [self.scrollView addSubview:label];

                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv_height - 25.f, iv.frame.size.width, 25.f)];
                    label.tag = 4 * i + 203;
                    //label.text = [_cameraNames objectAtIndex:(i * 4 + 3)];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.hidden = YES;
                    //label.textColor = [UIColor redColor];
                    
                    [self.scrollView addSubview:label];
                    [self.scrollView bringSubviewToFront:label];

                    label = nil;
                case 3:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake(left_iv_x + _winsize.width * i, down_iv_y, iv_width, iv_height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 152;
                    [self.scrollView addSubview:iv];
                    
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = 4 * i + 252;
                    [iv addSubview:activityV];
     
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 2)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    label.tag = i * 4 + 352;
                    [self.scrollView addSubview:label];
    
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv_height - 25.f, iv.frame.size.width, 25.f)];
                    //label.text = [_cameraNames objectAtIndex:(i * 4 + 2)];
                    label.tag = 4 * i + 202;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.hidden = YES;
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];

                case 2:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake(right_iv_x + _winsize.width * i, up_iv_y, iv_width, iv_height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 151;
                    [self.scrollView addSubview:iv];
                    
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = 4 * i + 251;
                    [iv addSubview:activityV];
            
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 1)];
                    label.tag = 4 * i + 351;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];
                
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x , iv.frame.origin.y + iv_height - 25.f, iv_width, 25.f)];
                    //label.text = [_cameraNames objectAtIndex:(i * 4 + 1)];
                    label.tag = 4 * i + 201;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.hidden = YES;
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];
         
                case 1:
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake(left_iv_x + _winsize.width * i, up_iv_y, iv_width, iv_height)];
                    iv.backgroundColor = [UIColor blackColor];
                    iv.tag = 4 * i + 150;
                    [self.scrollView addSubview:iv];
                    
                    activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                    [activityV startAnimating];
                    activityV.tag = 4 * i + 250;
                    [iv addSubview:activityV];
          
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                    label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
                    label.tag = 4 * i + 350;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];
          
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv_height - 25.f, iv_width, 25.f)];
                    //label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
                    label.tag = 4 * i + 200;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.hidden = YES;
                    label.font = [UIFont fontWithName:@"System" size:13];
                    [self.scrollView addSubview:label];
     
                default:
                    break;
            }
        }
        /* if ([_cameraInfos count]%4 != 0) {
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(165 + _winsize.width * (_numberofPages - 1), 180, 135, 120)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 153;
         [self.scrollView addSubview:iv];
         [iv release];
         
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(20 + _winsize.width * (_numberofPages - 1), 180, 135, 120)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 152;
         [self.scrollView addSubview:iv];
         [iv release];
         
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(165 + _winsize.width * (_numberofPages - 1), 10, 135, 120)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 151;
         [self.scrollView addSubview:iv];
         [iv release];
         
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(20 + _winsize.width * (_numberofPages - 1), 10, 135, 120)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 150;
         [self.scrollView addSubview:iv];
         [iv release];
         }*/
        
        float ivWidth1 = _winsize.width;
        float ivHeight1 = ivWidth1 * 3/4/*_winsize.width / _winsize.height*/;
        float iv1_x = 0.f;
        float iv1_y = (self.scrollView.frame.size.height  - ivHeight1)/2 ;
        
        CGSize iv2Size = [self fitImageViewSize];
        float iv2_x = (_winsize.width - iv2Size.width)/2;
        float iv2_up_y = (self.scrollView.frame.size.height - iv2Size.height * 2)/3;
        float iv2_down_y = self.scrollView.frame.size.height - iv2_up_y - iv2Size.height;
        switch ([_cameraInfos count]%4) {
                
            case 1:
                /*iv = [[UIImageView alloc] initWithFrame:CGRectMake(right_iv_x + _winsize.width * (_numberofPages - 1), up_iv_y, iv_width, iv_height)];
                 iv.backgroundColor = [UIColor blackColor];
                 iv.tag = 4 * (_numberofPages - 1) + 151;
                 [self.scrollView addSubview:iv];
                 [iv release];*/
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(iv1_x + _winsize.width * (_numberofPages - 1), iv1_y, ivWidth1, ivHeight1)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 150;
                [self.scrollView addSubview:iv];
                
                activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                [activityV startAnimating];
                activityV.tag = 4 * (_numberofPages - 1) + 250;
                [iv addSubview:activityV];
            
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                label.text = [_cameraNames objectAtIndex:((_numberofPages - 1) * 4 + 0)];
                label.tag = 4 * (_numberofPages - 1) + 350;
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];
   
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + ivHeight1 - 25.f, ivWidth1, 25.f)];
                //label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
                label.tag = 4 * (_numberofPages - 1) + 200;
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.hidden = YES;
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];

                
                break;
            case 2:
                /*iv = [[UIImageView alloc] initWithFrame:CGRectMake(left_iv_x + _winsize.width * (_numberofPages - 1), down_iv_y, iv_width, iv_height)];
                 iv.backgroundColor = [UIColor blackColor];
                 iv.tag = 4 * (_numberofPages - 1) + 152;
                 [self.scrollView addSubview:iv];
                 [iv release];*/
                
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(iv2_x + _winsize.width * (_numberofPages - 1), iv2_up_y, iv2Size.width, iv2Size.height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 150;
                [self.scrollView addSubview:iv];
                
                activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                [activityV startAnimating];
                activityV.tag = 4 * (_numberofPages - 1) + 250;
                [iv addSubview:activityV];
        
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                label.text = [_cameraNames objectAtIndex:((_numberofPages - 1) * 4 + 0)];
                label.tag = 4 * (_numberofPages - 1) + 350;
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];
   
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
                //label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
                label.tag = 4 * (_numberofPages - 1) + 200;
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.hidden = YES;
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];

                
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(iv2_x + _winsize.width * (_numberofPages - 1), iv2_down_y, iv2Size.width, iv2Size.height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 151;
                [self.scrollView addSubview:iv];
                
                activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
                [activityV startAnimating];
                activityV.tag = 4 * (_numberofPages - 1) + 251;
                [iv addSubview:activityV];
     
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
                label.text = [_cameraNames objectAtIndex:((_numberofPages - 1) * 4 + 1)];
                label.tag = 4 * (_numberofPages - 1) + 351;
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];

                
                label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y + iv.frame.size.height - 25.f, iv.frame.size.width, 25.f)];
                //label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
                label.tag = 4 * (_numberofPages - 1) + 201;
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.hidden = YES;
                label.font = [UIFont fontWithName:@"System" size:13];
                [self.scrollView addSubview:label];

                break;
            case 3:
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(right_iv_x + _winsize.width * (_numberofPages - 1), down_iv_y, iv_width, iv_height)];
                iv.backgroundColor = [UIColor blackColor];
                iv.tag = 4 * (_numberofPages - 1) + 153;
                [self.scrollView addSubview:iv];

                
                break;
            default:
                break;
        }
        /*}else{
         for (int i = 0; i < _numberofPages; i++) {
         UIActivityIndicatorView* activityV ;
         switch (([_cameraInfos count] - 4 * i)/4 ? 4 : [_cameraInfos count]%4) {
         case 4:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(385.f + _winsize.width * i, 334.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 153;
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = i * 4 + 253;
         [iv addSubview:activityV];
         [activityV release];
         
         [self.scrollView addSubview:iv];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 3)];
         label.tag = 4 * i + 353;
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(385.f + _winsize.width * i, 334 + 270.f, 382.f, 40)];
         label.tag = 4 * i + 203;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];
         label.hidden = YES;
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [self.scrollView bringSubviewToFront:label];
         
         [label release];
         [iv release];
         case 3:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(1 + _winsize.width * i, 334.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 152;
         [self.scrollView addSubview:iv];
         
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = 4 * i + 252;
         [iv addSubview:activityV];
         [activityV release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 2)];
         label.tag = 4 * i + 352;
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(1 + _winsize.width * i, 334.f + 270.f, 382.f, 40)];
         label.tag = 4 * i + 202;
         label.hidden = YES;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         [iv release];
         case 2:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(385.f + _winsize.width * i, 10.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 151;
         [self.scrollView addSubview:iv];
         
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = 4 * i + 251;
         [iv addSubview:activityV];
         [activityV release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 1)];
         label.tag = 4 * i + 351;
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(385.f + _winsize.width * i, 10.f + 270.f, 382.f, 40)];
         label.tag = 4 * i + 201;
         label.hidden = YES;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         [iv release];
         case 1:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(1 + _winsize.width * i, 10.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * i + 150;
         [self.scrollView addSubview:iv];
         
         activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         activityV.frame = CGRectMake(iv.frame.size.width/2 - 20, iv.frame.size.height/2 - 20, 40, 40);
         [activityV startAnimating];
         activityV.tag = 4 * i + 250;
         [iv addSubview:activityV];
         [activityV release];
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x, iv.frame.origin.y, iv.frame.size.width, 25.f)];
         label.text = [_cameraNames objectAtIndex:(i * 4 + 0)];
         label.tag = 4 * i + 350;
         label.textAlignment = NSTextAlignmentLeft;
         label.backgroundColor = [UIColor clearColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         
         
         label = [[UILabel alloc] initWithFrame:CGRectMake(1.f + _winsize.width * i, 10.f + 270.f, 382.f, 40.f)];
         label.tag = 4 * i + 200;
         label.hidden = YES;
         label.textAlignment = NSTextAlignmentCenter;
         label.backgroundColor = [UIColor clearColor];
         label.textColor = [UIColor whiteColor];
         label.font = [UIFont fontWithName:@"System" size:13];
         [self.scrollView addSubview:label];
         [label release];
         [iv release];
         default:
         break;
         }
         }
         switch ([_cameraInfos count]%4 + 1) {
         case 2:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(385.f + _winsize.width * (_numberofPages - 1), 10.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 151;
         [self.scrollView addSubview:iv];
         [iv release];
         case 3:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(1 + _winsize.width * (_numberofPages - 1), 334.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 152;
         [self.scrollView addSubview:iv];
         [iv release];
         case 4:
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(385.f + _winsize.width * (_numberofPages - 1), 334.f, 382.f, 300.f)];
         iv.backgroundColor = [UIColor blackColor];
         iv.tag = 4 * (_numberofPages - 1) + 153;
         [self.scrollView addSubview:iv];
         [iv release];
         default:
         break;
         }
         }*/
    }
    
}

- (void)DisMissOldDisPlayView:(NSNumber*)oldPag
{
    
    [self.view viewWithTag:(_currentPage * 4 + 200)].hidden = YES;
    [self.view viewWithTag:(_currentPage * 4 + 201)].hidden = YES;
    [self.view viewWithTag:(_currentPage * 4 + 202)].hidden = YES;
    [self.view viewWithTag:(_currentPage * 4 + 203)].hidden = YES;
    if ([self.timer0 isValid]) {
        [self.timer0 invalidate];
        self.timer0 = nil;
    }
    if ([self.timer1 isValid]) {
        [self.timer1 invalidate];

        self.timer1 = nil;
    }
    
    if ([self.timer2 isValid]) {
        [self.timer2 invalidate];
 
        self.timer2 = nil;
    }
    
    if ([self.timer3 isValid]) {
        [self.timer3 invalidate];

        self.timer3 = nil;
    }
    self.time0Sec = 0;
    self.time1Sec = 0;
    self.time2Sec = 0;
    self.time3Sec = 0;
    
    int oldP = [oldPag intValue];
    if (_myGlViewCtr0 != nil || _imageView0 != nil) {
        if ([[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:oldP*4  +0]] boolValue]) {
            self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:oldP*4 + 0] UTF8String]);
            NSString* strdid = [_cameraInfos objectAtIndex:oldP*4 + 0];
            [_cameraInfoDic setObject:[NSNumber numberWithBool:NO] forKey:strdid];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel* label = (UILabel*)[self.view viewWithTag:(oldP * 4 + 200)] ;
            label.text = nil;//[_cameraNames objectAtIndex:(oldP * 4 + 0)];
       
            label = nil;
        });
        
        if (_imageView0 != nil) {
            [_imageView0 removeFromSuperview];
        
            _imageView0 = nil;
        }
        if (_myGlViewCtr0 != nil) {
            [_myGlViewCtr0.view removeFromSuperview];
         
            _myGlViewCtr0 = nil;
            
        }
    }
    if (_myGlViewCtr1 != nil || _imageView1 != nil){
        if ([[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:oldP*4  + 1]] boolValue]) {
            self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:oldP*4 + 1] UTF8String]);
            NSString* strdid = [_cameraInfos objectAtIndex:oldP*4 + 1];
            [_cameraInfoDic setObject:[NSNumber numberWithBool:NO] forKey:strdid];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel* label = (UILabel*)[self.view viewWithTag:(oldP * 4 + 201)] ;
            label.text = nil;//[_cameraNames objectAtIndex:(oldP * 4 + 1)];
        
            label = nil;
        });
        
        
        if (_imageView1 != nil) {
            [_imageView1 removeFromSuperview];

            _imageView1 = nil;
        }
        if (_myGlViewCtr1 != nil) {
            [_myGlViewCtr1.view removeFromSuperview];
 
            _myGlViewCtr1 = nil;
            
        }
    }
    if (_myGlViewCtr2 != nil || _imageView2 != nil) {
        if ([_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:oldP * 4 + 2]]) {
            self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:oldP*4 + 2] UTF8String]);
            NSString* strdid = [_cameraInfos objectAtIndex:oldP*4 + 2];
            [_cameraInfoDic setObject:[NSNumber numberWithBool:NO] forKey:strdid];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel* label = (UILabel*)[self.view viewWithTag:(oldP * 4 + 202)];
            label.text = nil;//[_cameraNames objectAtIndex:(oldP * 4 + 2)];
   
            label = nil;
        });
        
        
        if (_imageView2 != nil) {
            [_imageView2 removeFromSuperview];

            _imageView2 = nil;
        }
        if (_myGlViewCtr2 != nil) {
            [_myGlViewCtr2.view removeFromSuperview];

            _myGlViewCtr2 = nil;
        }
        
    }
    if (_myGlViewCtr3 != nil || _imageView3 != nil) {
        if ([[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:oldP*4 + 3]] boolValue]) {
            self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:oldP*4 + 3] UTF8String]);
            NSString* strdid = [_cameraInfos objectAtIndex:oldP*4 + 3];
            [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:strdid];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel* label = (UILabel*)[self.view viewWithTag:(oldP * 4 + 203)];
            label.text = nil;//[_cameraNames objectAtIndex:(oldP * 4 + 3)];

            label = nil;
        });
        
        
        if (_imageView3 != nil) {
            [_imageView3 removeFromSuperview];

            _imageView3 = nil;
        }
        if (_myGlViewCtr3 != nil) {
            [_myGlViewCtr3.view removeFromSuperview];

            _myGlViewCtr3 = nil;
        }
        
    }
}

/*case 4:
 self.myGlViewCtr0 = [[MyGLViewController alloc] init];
 _myGlViewCtr0.view.frame = CGRectMake(20 + 320 * curP, 10, 120, 120);
 _myGlViewCtr0.view.backgroundColor = [UIColor blackColor];
 [self.scrollView addSubview:_myGlViewCtr0.view];
 
 self.myGlViewCtr1 = [[MyGLViewController alloc] init];
 _myGlViewCtr1.view.frame = CGRectMake(180 + 320 * curP, 10, 120, 120);
 _myGlViewCtr1.view.backgroundColor = [UIColor blackColor];
 [self.scrollView addSubview:_myGlViewCtr1.view];
 
 
 self.myGlViewCtr2 = [[MyGLViewController alloc] init];
 _myGlViewCtr2.view.frame = CGRectMake(20 + 320 * curP, 230, 120, 120);
 _myGlViewCtr2.view.backgroundColor = [UIColor blackColor];
 [self.scrollView addSubview:_myGlViewCtr2.view];
 
 
 self.myGlViewCtr3 = [[MyGLViewController alloc] init];
 _myGlViewCtr3 = [[MyGLViewController alloc] init];
 _myGlViewCtr3.view.frame = CGRectMake(180 + 320 * curP, 230, 120, 120);
 _myGlViewCtr3.view.backgroundColor = [UIColor redColor];
 [self.scrollView addSubview:_myGlViewCtr3.view];
 
 self.imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 320 * curP, 10, 120, 120)];
 [self.scrollView addSubview:_imageView0];
 
 self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(180 + 320 * curP, 10, 120, 120)];
 [self.scrollView addSubview:_imageView1];
 
 self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 320 * curP, 230, 120, 120)];
 [self.scrollView addSubview:_imageView2];
 
 self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(180 + 320 * curP, 230, 120, 120)];
 [self.scrollView addSubview:_imageView3];
 
 camuid = [_cameraInfos objectAtIndex:0 + curP * 4];
 [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
 
 camuid = [_cameraInfos objectAtIndex:1 + curP * 4];
 [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
 
 camuid = [_cameraInfos objectAtIndex:2 + curP * 4];
 [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
 
 camuid = [_cameraInfos objectAtIndex:3 + curP * 4];
 [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
 
 break;
 default:
 break;
 }*/



- (void)CreateDisPlayView:(NSNumber*)curPag{
    if (self.ppppChannelMgt == NULL) {
        return;
    }
    //    NSLog(@"_cameraInfoDic  %@",_cameraInfoDic);
    //    NSLog(@"_cameramode    %@",_cameramodeDic);
    self.timeoutLabel.hidden = YES;
    //NSLog(@"timeout  %@",self.timeoutTimer);
    int curP = [curPag intValue];
    NSString* camuid;
    UIActivityIndicatorView* activityV;
    switch (([_cameraInfos count] - 4 * curP)/4 ? 4 : [_cameraInfos count]%4) {
        case 4:
            /*self.myGlViewCtr3 = [[MyGLViewController alloc] init];
             _myGlViewCtr3 = [[MyGLViewController alloc] init];
             _myGlViewCtr3.view.frame = CGRectMake(165 + 320 * _currentPage, 170, 135, 135);
             _myGlViewCtr3.view.backgroundColor = [UIColor redColor];
             [self.scrollView addSubview:_myGlViewCtr3.view];
             */
            
            self.imageView3 = [[UIImageView alloc] initWithFrame:[self.view viewWithTag:(curP * 4 + 153)].frame];
            [self.scrollView addSubview:_imageView3];
            
            activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityV.frame = CGRectMake(self.imageView3.frame.size.width/2 - 20, self.imageView3.frame.size.height/2 - 20, 40, 40);
            [activityV startAnimating];
            activityV.tag = curP * 4 + 303;
            [self.imageView3 addSubview:activityV];

            
            
            
            camuid = [_cameraInfos objectAtIndex:3 + curP * 4];
            //[NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
            [self performSelectorOnMainThread:@selector(startLiveStream:) withObject:camuid waitUntilDone:YES];
            //[self performSelector:@selector(startLiveStream:) withObject:camuid afterDelay:3.f];
        case 3:
            /*self.myGlViewCtr2 = [[MyGLViewController alloc] init];
             _myGlViewCtr2.view.frame = CGRectMake(20 + 320 * curP, 170, 135, 135);
             _myGlViewCtr2.view.backgroundColor = [UIColor blackColor];
             [self.scrollView addSubview:_myGlViewCtr2.view];
             */
            self.imageView2 = [[UIImageView alloc] initWithFrame:[self.view viewWithTag:(curP * 4 + 152)].frame];
            [self.scrollView addSubview:_imageView2];
            
            activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityV.frame = CGRectMake(self.imageView2.frame.size.width/2 - 20, self.imageView2.frame.size.height/2 - 20, 40, 40);
            [activityV startAnimating];
            activityV.tag = curP * 4 + 302;
            [self.imageView2 addSubview:activityV];
      
            
            
            camuid = [_cameraInfos objectAtIndex:2 + curP * 4];
            //[NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
            [self performSelectorOnMainThread:@selector(startLiveStream:) withObject:camuid waitUntilDone:YES];
            //[self performSelector:@selector(startLiveStream:) withObject:camuid afterDelay:3.f];
            
            
        case 2:
            /*self.myGlViewCtr1 = [[MyGLViewController alloc] init];
             _myGlViewCtr1.view.frame = CGRectMake(165 + 320 * curP, 10, 135, 135);
             //_myGlViewCtr1.view.backgroundColor = [UIColor blackColor];
             [self.scrollView addSubview:_myGlViewCtr1.view];
             */
            self.imageView1 = [[UIImageView alloc] initWithFrame:[self.view viewWithTag:(curP * 4 + 151)].frame];
            [self.scrollView addSubview:_imageView1];
            
            activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityV.frame = CGRectMake(self.imageView1.frame.size.width/2 - 20, self.imageView1.frame.size.height/2 - 20, 40, 40);
            [activityV startAnimating];
            activityV.tag = curP * 4 + 301;
            [self.imageView1 addSubview:activityV];
    
            
            
            camuid = [_cameraInfos objectAtIndex:1 + curP * 4];
            //[NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
            [self performSelectorOnMainThread:@selector(startLiveStream:) withObject:camuid waitUntilDone:YES];
            //[self performSelector:@selector(startLiveStream:) withObject:camuid afterDelay:3.f];
        case 1:
            /* self.myGlViewCtr0 = [[MyGLViewController alloc] init];
             _myGlViewCtr0.view.frame = CGRectMake(20 + 320 * curP, 10, 135, 135);
             _myGlViewCtr0.view.backgroundColor = [UIColor redColor];
             [self.scrollView addSubview:_myGlViewCtr0.view];
             */
            self.imageView0 = [[UIImageView alloc] initWithFrame:[self.view viewWithTag:(curP * 4 + 150)].frame];
            [self.scrollView addSubview:_imageView0];
            
            activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityV.frame = CGRectMake(self.imageView0.frame.size.width/2 - 20, self.imageView0.frame.size.height/2 - 20, 40, 40);
            [activityV startAnimating];
            activityV.tag = curP * 4 + 300;
            [self.imageView0 addSubview:activityV];

            
            NSLog(@"self.imageView0  %@  150v  %@",NSStringFromCGRect(self.imageView0.frame),NSStringFromCGRect([self.view viewWithTag:150].frame));
            
            camuid = [_cameraInfos objectAtIndex:0 + curP * 4];
            //[NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];
            [self performSelectorOnMainThread:@selector(startLiveStream:) withObject:camuid waitUntilDone:YES];
            
        default:
            break;
            
    }
    _imageView0.userInteractionEnabled = YES;
    _imageView1.userInteractionEnabled = YES;
    _imageView2.userInteractionEnabled = YES;
    _imageView3.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PushsignalView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [_imageView0 addGestureRecognizer:tapGesture];
    tapGesture.view.tag = 0 + curP * 4;

    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PushsignalView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [_imageView1 addGestureRecognizer:tapGesture];
    tapGesture.view.tag = 1 + curP * 4;

    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PushsignalView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [_imageView2 addGestureRecognizer:tapGesture];
    tapGesture.view.tag = 2 + curP * 4;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PushsignalView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [_imageView3 addGestureRecognizer:tapGesture];
    tapGesture.view.tag = 3 + curP * 4;
    
    for (UIView* view in [self.scrollView subviews]){
        if ([view isKindOfClass:[UILabel class]]) {
            [self.scrollView bringSubviewToFront:(UILabel*)view];
        }
    }
    
}

- (void)PushsignalView:(UITapGestureRecognizer*)tapGesture{
    //    if ([self.timer0 isValid]) {
    //        [self.timer0 invalidate];
    //        [_timer0 release];
    //        self.timer0 = nil;
    //    }
    //    if ([self.timer1 isValid]) {
    //        [self.timer1 invalidate];
    //        [_timer1 release];
    //        self.timer1 = nil;
    //    }
    //
    //    if ([self.timer2 isValid]) {
    //        [self.timer2 invalidate];
    //        [_timer2 release];
    //        self.timer2 = nil;
    //    }
    //
    //    if ([self.timer3 isValid]) {
    //        [self.timer3 invalidate];
    //        [_timer3 release];
    //        self.timer3 = nil;
    //    }
    _isPushPlayVc = YES;
    self.time0Sec = 0;
    self.time1Sec = 0;
    self.time2Sec = 0;
    self.time3Sec = 0;
    _imageView0.userInteractionEnabled = NO;
    _imageView1.userInteractionEnabled = NO;
    _imageView2.userInteractionEnabled = NO;
    _imageView3.userInteractionEnabled = NO;
    NSLog(@"cameraIsStartLive  %@",_cameraIsStartLive);
    [self.view removeGestureRecognizer:tapGesture];
    NSLog(@"removeGestureRecognizer");
    //[self performSelectorOnMainThread:@selector(StopAll) withObject:nil waitUntilDone:YES];
    [NSThread detachNewThreadSelector:@selector(StopAll:) toTarget:self withObject:tapGesture];
    NSLog(@"StopAll");
    
    
}

- (void)StopPlay:(id)sender{
    //_bManualStop = YES;
    NSString* did = (NSString*)sender;
    if (self.ppppChannelMgt != NULL) {
        // self.ppppChannelMgt->StopPPPPLivestream([[_camdic objectForKey:@STR_DID] UTF8String]);
        self.ppppChannelMgt->StopPPPPLivestream([did UTF8String]);
        [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:did];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)updateImage:(NSArray*)arr{
    UIImage* image = [arr objectAtIndex:0];
    NSString* strdid = [arr objectAtIndex:1];
    switch ([_cameraInfos indexOfObject:strdid] % 4) {
        case 0:
            _imageView0.image = image;
            break;
        case 1:
            _imageView1.image = image;
            break;
        case 2:
            _imageView2.image = image;
            break;
        case 3:
            _imageView3.image = image;
            break;
        default:
            break;
    };
}

- (CGSize)fitImageViewSize{
    float iv_width = _winsize.width;
    float iv_height = _winsize.width * _winsize.width/_winsize.height;
    float max_iv_height = (self.scrollView.frame.size.height- 4.f)/2;
    // NSLog(@"iv_width  %f  iv_height %f  max_iv_height %f",iv_width,iv_height,max_iv_height);
    if (iv_height > max_iv_height) {
        iv_height = max_iv_height;
        iv_width = iv_height * _winsize.height/_winsize.width;
    }
    return CGSizeMake(iv_width, iv_height);
}

#pragma  mark UINavigationBarDelegate
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item{
    IpCameraClientAppDelegate* ipcamDelegate = (IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate;
    _isPushPlayVc = NO;
    [self performSelectorOnMainThread:@selector(StopAll:) withObject:nil waitUntilDone:NO];
    [ipcamDelegate switchBack];
}

#pragma mark -
#pragma mark PPPPStatusProtocol
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    if (_bManualStop == YES) {
        return;
    }
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS && status == PPPP_STATUS_DISCONNECT) {
        //self.ppppChannelMgt->StopPPPPLivestream([strDID UTF8String]);
    }
}

#pragma mark -
#pragma mark ParamNotifyProtocol
- (void) ParamNotify: (int) paramType params:(void*) params{
    
}

#pragma mark -
#pragma mark ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp{
    //NSLog(@"image notify");
    /*
     if (image != nil) {
     [image retain];
     [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
     }*/
}

- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp{
    //NSLog(@"length %d  width %d height %d",length,width,height);
    
    //[_myGlViewCtr WriteYUVFrame:yuv Len:length width:width height:height];
}

- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
    
}

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp szdid:(NSString*)szdid{
    if (_currentPage != _oldPage) {
        return;
    }
    if (![(NSNumber*)[self.cameraInfoDic objectForKey:szdid] boolValue]) {
        [self.cameraInfoDic setObject:[NSNumber numberWithBool:YES] forKey:szdid];
        //[self performSelectorOnMainThread:@selector(createmyGlPlayView:) withObject:[NSNumber numberWithInt:[_cameraInfos indexOfObject:szdid] % 4] waitUntilDone:YES];
        switch ([_cameraInfos indexOfObject:szdid] % 4) {
                
            case 0:
                for (UIView* aview in [self.imageView0 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                    }
                }
                self.time0Sec = 180;
                _imageView0.userInteractionEnabled = YES;
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 200)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time0Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                self.timer0 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer0:) userInfo:nil repeats:YES];
                            });
                        }
                        
          
                        label = nil;
                    });
                }
                break;
            case 1:
                for (UIView* aview in [self.imageView1 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                    }
                }
                //NSLog(@"imageview 1");
                self.time1Sec = 180;
                _imageView1.userInteractionEnabled = YES;
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 201)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time1Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer1:) userInfo:nil repeats:YES];
                            });
                        }

                        label = nil;
                        
                    });
                    
                }
                //NSLog(@"J P E G");
                break;
            case 2:
                for (UIView* aview in [self.imageView2 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                    }
                }
                self.time2Sec = 180;
                _imageView2.userInteractionEnabled = YES;
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 202)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time2Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
  
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer2:) userInfo:nil repeats:YES] ;
                                NSLog(@"timer呕吐");
                            });
                        }
                        
                        label = nil;
                        
                    });
                    
                }
                //NSLog(@"J P E G");
                break;
            case 3:
                for (UIView* aview in [self.imageView3 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                        NSLog(@"activityV  %@",NSStringFromCGRect(aview.frame));
                    }
                }
                self.time3Sec = 180;
                _imageView3.userInteractionEnabled = YES;
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 203)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time3Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer3:) userInfo:nil repeats:YES] ;
                            });
                        }

                        label = nil;
                        
                    });
                    
                }
                //NSLog(@"J P E G  %@",[(UILabel*)[self.view viewWithTag:(_currentPage * 4 + 203)] text]);
                break;
                
            default:
                break;
        }
        
    }
    if (image != nil) {

        [self performSelectorOnMainThread:@selector(updateImage:) withObject:[NSArray arrayWithObjects:image, szdid, nil] waitUntilDone:NO];
    }
    //NSLog(@"jpeg");
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp szdid:(NSString*)szdid{
    if (_currentPage != _oldPage) {
        return;
    }
    /*if ([IpCameraClientAppDelegate is43Version]) {
     if (![(NSNumber*)[self.cameraInfoDic objectForKey:szdid] boolValue]) {
     [self.cameraInfoDic setObject:[NSNumber numberWithBool:YES] forKey:szdid];
     //[self performSelectorOnMainThread:@selector(createmyGlPlayView:) withObject:[NSNumber numberWithInt:[_cameraInfos indexOfObject:szdid] % 4] waitUntilDone:YES];
     switch ([_cameraInfos indexOfObject:szdid] % 4) {
     
     case 0:
     for (UIView* aview in [self.imageView0 subviews])
     {
     if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
     [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
     }
     }
     self.time0Sec = 180;
     _imageView0.userInteractionEnabled = YES;
     if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
     dispatch_async(dispatch_get_main_queue(), ^{
     UILabel* label = [(UILabel*)[self.view viewWithTag:(_currentPage * 4 + 200)] retain];
     label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time0Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
     label.font = [UIFont systemFontOfSize:10.f];
     label.textColor = [UIColor redColor];
     if (label.hidden == YES) {
     dispatch_async(dispatch_get_main_queue(), ^{
     label.hidden = NO;
     self.timer0 = [[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer0:) userInfo:nil repeats:YES] retain];
     });
     }
     
     [label release];
     label = nil;
     });
     }
     break;
     case 1:
     for (UIView* aview in [self.imageView1 subviews])
     {
     if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
     [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
     }
     }
     self.time1Sec = 180;
     _imageView1.userInteractionEnabled = YES;
     if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
     dispatch_async(dispatch_get_main_queue(), ^{
     UILabel* label = [(UILabel*)[self.view viewWithTag:(_currentPage * 4 + 201)] retain];
     label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time1Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
     label.font = [UIFont systemFontOfSize:10.f];
     label.textColor = [UIColor redColor];
     
     if (label.hidden == YES) {
     dispatch_async(dispatch_get_main_queue(), ^{
     label.hidden = NO;
     self.timer1 = [[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer1:) userInfo:nil repeats:YES] retain];
     });
     }
     
     
     [label release];
     label = nil;
     
     });
     
     }
     NSLog(@"4.3");
     break;
     case 2:
     for (UIView* aview in [self.imageView2 subviews])
     {
     if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
     [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
     }
     }
     self.time2Sec = 180;
     _imageView2.userInteractionEnabled = YES;
     if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
     dispatch_async(dispatch_get_main_queue(), ^{
     UILabel* label = [(UILabel*)[self.view viewWithTag:(_currentPage * 4 + 202)] retain];
     label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time2Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
     label.font = [UIFont systemFontOfSize:10.f];
     label.textColor = [UIColor redColor];
     [label release];
     if (label.hidden == YES) {
     dispatch_async(dispatch_get_main_queue(), ^{
     label.hidden = NO;
     self.timer2 = [[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer2:) userInfo:nil repeats:YES] retain];
     NSLog(@"timer呕吐");
     });
     }
     
     label = nil;
     
     });
     
     }
     NSLog(@"4.3");
     break;
     case 3:
     for (UIView* aview in [self.imageView3 subviews])
     {
     if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
     [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
     NSLog(@"activityV  %@",NSStringFromCGRect(aview.frame));
     }
     }
     self.time3Sec = 180;
     _imageView3.userInteractionEnabled = YES;
     if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
     dispatch_async(dispatch_get_main_queue(), ^{
     UILabel* label = [(UILabel*)[self.view viewWithTag:(_currentPage * 4 + 203)] retain];
     label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time3Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
     label.font = [UIFont systemFontOfSize:10.f];
     label.textColor = [UIColor redColor];
     if (label.hidden == YES) {
     dispatch_async(dispatch_get_main_queue(), ^{
     label.hidden = NO;
     self.timer3 = [[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer3:) userInfo:nil repeats:YES] retain];
     });
     }
     
     [label release];
     label = nil;
     
     });
     
     }
     NSLog(@"4.3  %@",[(UILabel*)[self.view viewWithTag:(_currentPage * 4 + 203)] text]);
     break;
     
     default:
     break;
     }
     
     }
     UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
     if (image != nil) {
     [image retain];
     [self performSelectorOnMainThread:@selector(updateImage:) withObject:[NSArray arrayWithObjects:image, szdid, nil] waitUntilDone:NO];
     }
     return;
     }*/
    if (![(NSNumber*)[self.cameraInfoDic objectForKey:szdid] boolValue]) {
        [self.cameraInfoDic setObject:[NSNumber numberWithBool:YES] forKey:szdid];
        [self performSelectorOnMainThread:@selector(createmyGlPlayView:) withObject:[NSNumber numberWithInt:[_cameraInfos indexOfObject:szdid] % 4 + 1] waitUntilDone:YES];
        switch ([_cameraInfos indexOfObject:szdid] % 4) {
                NSLog(@"Y U V");
            case 0:
                
                // _imageView0.userInteractionEnabled = YES;
                for (UIView* aview in [self.imageView0 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                    }
                }
                self.time0Sec = 180;
                _imageView0.userInteractionEnabled = YES;
                [self.view bringSubviewToFront:_myGlViewCtr0.view];
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 200)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time0Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                
                                self.timer0 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer0:) userInfo:nil repeats:YES] ;
                            });
                        }

                        label = nil;
                        
                    });
                    
                }
                
                break;
            case 1:
                // _imageView1.userInteractionEnabled = YES;
                for (UIView* aview in [self.imageView1 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                    }
                }
                self.time1Sec = 180;
                _imageView1.userInteractionEnabled = YES;
                [self.view bringSubviewToFront:_myGlViewCtr1.view];
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 201)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time1Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                
                                self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer1:) userInfo:nil repeats:YES];
                            });
                        }

                        label = nil;
                        
                    });
                    
                }
                
                break;
            case 2:
                // _imageView2.userInteractionEnabled = YES;
                for (UIView* aview in [self.imageView2 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                        NSLog(@"YUV  ac");
                    }
                }
                self.time2Sec = 180;
                _imageView2.userInteractionEnabled = YES;
                [self.view bringSubviewToFront:_myGlViewCtr2.view];
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 202)];
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time2Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                
                                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer2:) userInfo:nil repeats:YES];
                            });
                        }
    
                        label = nil;
                        
                    });
                    
                }
                
                break;
            case 3:
                
                
                //
                // _imageView3.userInteractionEnabled = YES;
                for (UIView* aview in [self.imageView3 subviews])
                {
                    if ([aview isMemberOfClass:[UIActivityIndicatorView class]]) {
                        [self performSelectorOnMainThread:@selector(stopActivityView:) withObject:aview waitUntilDone:NO];
                    }
                }
                self.time3Sec = 180;
                _imageView3.userInteractionEnabled = YES;
                [self.view bringSubviewToFront:_myGlViewCtr3.view];
                if ([[_cameramodeDic objectForKey:szdid] integerValue] == PPPP_MODE_RELAY) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel* label = (UILabel*)[self.view viewWithTag:(_currentPage * 4 + 203)] ;
                        label.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time3Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
                        label.font = [UIFont systemFontOfSize:10.f];
                        label.textColor = [UIColor redColor];
                        if (label.hidden == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.hidden = NO;
                                
                                self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer3:) userInfo:nil repeats:YES] ;
                            });
                        }

                        label = nil;
                        
                    });
                    
                }
                
                break;
                
            default:
                break;
        }
        //[self performSelectorOnMainThread:@selector(createmyGlView:) withObject:szdid waitUntilDone:YES];
    }
    
    switch ([_cameraInfos indexOfObject:szdid] % 4) {
        case 0:
            //NSLog(@"YUV view Frame  %@  150View %@  image0 %@",NSStringFromCGRect(_myGlViewCtr0.view.frame),NSStringFromCGRect([self.view viewWithTag:150].frame),NSStringFromCGRect(self.imageView0.frame));
            [_myGlViewCtr0 WriteYUVFrame:yuv Len:length width:width height:height];
            break;
        case 1:
            //NSLog(@"YUV view Frame  %@   151View %@",NSStringFromCGRect(_myGlViewCtr1.view.frame),NSStringFromCGRect([self.view viewWithTag:151].frame));
            [_myGlViewCtr1 WriteYUVFrame:yuv Len:length width:width height:height];
            //[self YUVNotify:yuv length:length width:width height:height];
            break;
        case 2:
            [_myGlViewCtr2 WriteYUVFrame:yuv Len:length width:width height:height];
            break;
        case 3:
            
            [_myGlViewCtr3 WriteYUVFrame:yuv Len:length width:width height:height];
            break;
        default:
            break;
    }
    
}

- (void)handleTimer0:(id)sender{
    if (self.time0Sec <= 0) {
        int i = _currentPage*4;
        //[self.view viewWithTag:(_currentPage * 4 + 200)].hidden = YES;
        
        int mode = [[_cameramodeDic objectForKey:[_cameraInfos objectAtIndex:i]] integerValue];
        if (mode == PPPP_MODE_RELAY) {
            if ([[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:i]] boolValue]) {
                self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:i] UTF8String]);
                [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:i]];
            }
            
            // _imageView0.userInteractionEnabled = NO;
            [(UILabel*)[self.view viewWithTag:(i + 200)]setText:NSLocalizedStringFromTable(@"RelayModeEnd", @STR_LOCALIZED_FILE_NAME, nil)];
            [(UILabel*)[self.view viewWithTag:(i + 200)] setTextColor:[UIColor redColor]];
            [(UILabel*)[self.view viewWithTag:(i + 200)] setFont:[UIFont systemFontOfSize:10.f]];
            
        }
        if ([self.timer0 isValid]) {
            [self.timer0 invalidate];

            self.timer0 = nil;
        }
        return;
    }
    NSLog(@"self.timer0");
    self.time0Sec -= 1.f;
    
    ((UILabel*)[self.view viewWithTag:(_currentPage * 4 + 200)]).text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time0Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
}

- (void)handleTimer1:(id)sender{
    if (self.time1Sec <= 0) {
        int i = _currentPage*4;
        //[self.view viewWithTag:(_currentPage * 4 + 201)].hidden = YES;
        
        int mode = [[_cameramodeDic objectForKey:[_cameraInfos objectAtIndex:i + 1]] integerValue];
        if (mode == PPPP_MODE_RELAY) {
            if ([[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:i + 1]] boolValue]) {
                self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:i + 1] UTF8String]);
                [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:i + 1]];
            }
            
            // _imageView1.userInteractionEnabled = NO;
            [(UILabel*)[self.view viewWithTag:(i + 201)]setText:NSLocalizedStringFromTable(@"RelayModeEnd", @STR_LOCALIZED_FILE_NAME, nil)];
            [(UILabel*)[self.view viewWithTag:(i + 201)] setTextColor:[UIColor redColor]];
            [(UILabel*)[self.view viewWithTag:(i + 201)] setFont:[UIFont systemFontOfSize:10.f]];
            
        }
        if ([self.timer1 isValid]) {
            [self.timer1 invalidate];

            self.timer1 = nil;
        }
        return;
    }
    NSLog(@"self.timer1  %d",self.time1Sec);
    self.time1Sec -= 1.f;
    
    ((UILabel*)[self.view viewWithTag:(_currentPage * 4 + 201)]).text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time1Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
}

- (void)handleTimer2:(id)sender{
    if (self.time2Sec <= 0) {
        int i = _currentPage*4;
        //[self.view viewWithTag:(_currentPage * 4 + 202)].hidden = YES;
        
        int mode = [[_cameramodeDic objectForKey:[_cameraInfos objectAtIndex:i + 2]] integerValue];
        if (mode == PPPP_MODE_RELAY) {
            if ([[_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:i + 2]] boolValue]) {
                self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:i + 2] UTF8String]);
                [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:i + 2]];
            }
            
            //  _imageView2.userInteractionEnabled = NO;
            [(UILabel*)[self.view viewWithTag:(i + 202)]setText:NSLocalizedStringFromTable(@"RelayModeEnd", @STR_LOCALIZED_FILE_NAME, nil)];
            [(UILabel*)[self.view viewWithTag:(i + 202)] setTextColor:[UIColor redColor]];
            [(UILabel*)[self.view viewWithTag:(i + 202)] setFont:[UIFont systemFontOfSize:10.f]];
            
        }
        if ([self.timer2 isValid]) {
            [self.timer2 invalidate];
  
            self.timer2 = nil;
        }
        return;
    }
    NSLog(@"self.timer2");
    self.time2Sec -= 1.f;
    
    ((UILabel*)[self.view viewWithTag:(_currentPage * 4 + 202)]).text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time2Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
}

- (void)handleTimer3:(id)sender{
    if (self.time3Sec <= 0) {
        int i = _currentPage*4;
        //[self.view viewWithTag:(_currentPage * 4 + 203)].hidden = YES;
        
        int mode = [[_cameramodeDic objectForKey:[_cameraInfos objectAtIndex:i + 3]] integerValue];
        if (mode == PPPP_MODE_RELAY) {
            if ([_cameraIsStartLive objectForKey:[_cameraInfos objectAtIndex:i + 3]]) {
                self.ppppChannelMgt->StopPPPPLivestream([[_cameraInfos objectAtIndex:i + 3] UTF8String]);
                [_cameraIsStartLive setObject:[NSNumber numberWithBool:NO] forKey:[_cameraInfos objectAtIndex:i + 3]];
            }
            
            //  _imageView3.userInteractionEnabled = NO;
            [(UILabel*)[self.view viewWithTag:(i + 203)]setText:NSLocalizedStringFromTable(@"RelayModeEnd", @STR_LOCALIZED_FILE_NAME, nil)];
            [(UILabel*)[self.view viewWithTag:(i + 203)] setTextColor:[UIColor redColor]];
            [(UILabel*)[self.view viewWithTag:(i + 203)] setFont:[UIFont systemFontOfSize:10.f]];
            
        }
        if ([self.timer3 isValid]) {
            [self.timer3 invalidate];

            self.timer3 = nil;
        }
        return;
    }
    NSLog(@"self.timer3");
    self.time3Sec -= 1.f;
    
    ((UILabel*)[self.view viewWithTag:(_currentPage * 4 + 203)]).text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),self.time3Sec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
    
    

}


- (void)createmyGlPlayView:(NSNumber*)mark{
    int m = [mark intValue];
    switch (m) {
        case 4:
            self.myGlViewCtr3 = [[MyGLViewController alloc] init];
            _myGlViewCtr3 = [[MyGLViewController alloc] init];
            _myGlViewCtr3.view.frame = [self.view viewWithTag:(_currentPage * 4 + 153)].frame;
            _myGlViewCtr3.view.backgroundColor = [UIColor blackColor];
            [self.scrollView addSubview:_myGlViewCtr3.view];
            
            break;

            
        case 3:
            self.myGlViewCtr2 = [[MyGLViewController alloc] init];
            _myGlViewCtr2.view.frame = [self.view viewWithTag:(_currentPage * 4 + 152)].frame;
            _myGlViewCtr2.view.backgroundColor = [UIColor blackColor];
            [self.scrollView addSubview:_myGlViewCtr2.view];
            
            break;

            
            
            
        case 2:
            self.myGlViewCtr1 = [[MyGLViewController alloc] init];
            _myGlViewCtr1.view.frame = [self.view viewWithTag:(_currentPage * 4 + 151)].frame;
            _myGlViewCtr1.view.backgroundColor = [UIColor blackColor];
            [self.scrollView addSubview:_myGlViewCtr1.view];
            
            break;

             
//             camuid = [_cameraInfos objectAtIndex:1 + curP * 4];
//             [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];*/
            
        case 1:
            self.myGlViewCtr0 = [[MyGLViewController alloc] init];
            _myGlViewCtr0.view.frame = [self.view viewWithTag:(_currentPage * 4 + 150)].frame;
            _myGlViewCtr0.view.backgroundColor = [UIColor blackColor];
            [self.scrollView addSubview:_myGlViewCtr0.view];
            
            break;
            
            /*activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
             activityV.frame = CGRectMake(47.5, 47.5, 40, 40);
             [activityV startAnimating];
             [self.imageView0 addSubview:activityV];
             [activityV release];
             
             
             camuid = [_cameraInfos objectAtIndex:0 + curP * 4];
             [NSThread detachNewThreadSelector:@selector(startLiveStream:) toTarget:self withObject:camuid];*/
            
        default:
            break;
            
    }
    
    for (UIView* view in [self.scrollView subviews]){
        if ([view isKindOfClass:[UILabel class]]) {
            [self.scrollView bringSubviewToFront:(UILabel*)view];
        }
    }
    
}

- (void)stopActivityView:(UIView*)aview{
    [(UIActivityIndicatorView*)aview stopAnimating];
    aview.hidden = YES;
}

- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp szdid:(NSString*)szdid{
    
}

- (void)createImageView:(NSString*)szdid{
    
}

- (void)createmyGlView:(NSString*)szdid{
    
}
//- (UIViewController*)viewController:(UIView*)view {
//    for (UIView* next = [view superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
//}

#pragma mark -
#pragma mark Autorotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    NSLog(@"should  Autorotate");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    return YES;
}

////视图旋转动画前一半发生之前自动调用
//
//-(void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    NSLog(@"will Animate First Half   %d",toInterfaceOrientation);
//}
////视图旋转动画后一半发生之前自动调用
//
//-(void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
//    NSLog(@"will Animate Second Half %d",fromInterfaceOrientation);
//}
//视图旋转之前自动调用
/*float iv_Height = 135.f;
 float iv_With = 135.f *  _winsize.height/_winsize.width;
 for (int i = 0; i < _numberofPages; i++) {
 UIActivityIndicatorView* activityV ;
 switch (([_cameraInfos count] - 4 * i)/4 ? 4 : [_cameraInfos count]%4) {
 case 4:
 iv = [[UIImageView alloc] initWithFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];*/
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"currentPage %d",_currentPage);
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.naBar.frame = CGRectMake(0.f, 0.f, _winsize.height, 44.f);
        [UIView animateWithDuration:1.f animations:^{
            
            //[self.naBar popNavigationItemAnimated:YES];
            //UINavigationItem* item = [[UINavigationItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Sqlite", @STR_LOCALIZED_FILE_NAME, nil)];
            self.timeoutLabel.frame = CGRectMake(0.f, 44.f, _winsize.height, 30.f);
            
            self.scrollView.frame = CGRectMake(0.f, 44.f, _winsize.height, _winsize.width - 44.f);
            self.scrollView.contentOffset = CGPointMake(_winsize.height * _currentPage,0);
            self.scrollView.contentSize = CGSizeMake(_winsize.height * _numberofPages, _winsize.width - 44.f);
            
            float iv_Height = (_winsize.width - 44.f - 4.f)/2;
            float iv_With = iv_Height * _winsize.height/_winsize.width;
            //self.scrollView.backgroundColor = [UIColor greenColor];
            // NSLog(@"self.scrollView.contentOffset   %f   %d",self.scrollView.contentOffset.x,_currentPage);
            //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //                float iv_Height = 135.f;
            //                float iv_With = 135.f *  _winsize.height/_winsize.width;
            for (int i = 0; i < _numberofPages; i++) {
                switch (([_cameraInfos count] - 4 * i)/4 ? 4 : ([_cameraInfos count]%4 == 3 ? 3 : 0)) {
                    case 4:
                        [[self.view viewWithTag:(i * 4 + 153)] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
                        [[self.view viewWithTag:(i * 4 + 203)] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 3.f + iv_Height + iv_Height - 25.f, iv_With
                                                                                   , 25.f)];
                        [[self.view viewWithTag:(i * 4 + 253)] setFrame:CGRectMake(iv_With/2 - 20.f, iv_Height/2 - 20.f, 40.f, 40.f)];
                        [[self.view viewWithTag:(i * 4) + 353] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 3.f + iv_Height, iv_With, 25.f)];
                        //NSLog(@"view class : %@",[[self.view viewWithTag:(i * 4 + 153)] class]);
                        
                    case 3:
                        [[self.view viewWithTag:(i * 4 + 152)] setFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
                        [[self.view viewWithTag:(i * 4 + 202)] setFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 3.f + iv_Height + iv_Height - 25.f, iv_With, 25.f)];
                        [[self.view viewWithTag:(i * 4 + 252)] setFrame:CGRectMake(iv_With/2 - 20.f, iv_Height/2 - 20.f, 40, 40)];
                        [[self.view viewWithTag:(i * 4 + 352)] setFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 3.f + iv_Height, iv_With, 25.f)];
                    case 2:
                        [[self.view viewWithTag:(i * 4 + 151)] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 1.f, iv_With, iv_Height)];
                        [[self.view viewWithTag:(i * 4 + 201)] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height , 1.f + iv_Height - 25.f, iv_With, 25.f)];
                        [[self.view viewWithTag:(i * 4 + 251)] setFrame:CGRectMake(iv_With/2 - 20.f, iv_Height/2 - 20.f, 40.f, 40.f)];
                        [[self.view viewWithTag:(i * 4) + 351] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + i * _winsize.height, 1.f, iv_With, 25.f)];
                    case 1:
                        [[self.view viewWithTag:(i * 4 + 150)] setFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 1.f, iv_With, iv_Height)];
                        [[self.view viewWithTag:(i * 4 + 200)] setFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 1.f + iv_Height - 25.f, iv_With, 25.f)];
                        [[self.view viewWithTag:(i * 4 + 250)] setFrame:CGRectMake(iv_With/2 - 20.f, iv_Height/2 - 20.f, 40.f, 40.f)];
                        [[self.view viewWithTag:(i * 4 + 350)] setFrame:CGRectMake((_winsize.height - iv_With*2)/3 + i * _winsize.height, 1.f, iv_With, 25.f)];
                    default:
                        break;
                }
            }
            float iv1Height = _winsize.width - 44.f;
            float iv1Width = iv1Height * _winsize.height / _winsize.width;
            float iv1X = (self.scrollView.frame.size.width - iv1Width)/2;
            float iv1Y = (self.scrollView.frame.size.height - iv1Height)/2;
            
            float iv2Width = (_winsize.height - 4)/2;
            float iv2Height = iv2Width * 3/4/*_winsize.width / _winsize.height*/;
            float iv2_left_X = (self.scrollView.frame.size.width - iv2Width * 2)/3;
            float iv2_right_x = 2 * iv2_left_X + iv2Width;
            float iv2Y = (self.scrollView.frame.size.height - iv2Height )/2;
            switch ([_cameraInfos count]%4 ) {
                    
                case 1:
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 150)] setFrame:CGRectMake(iv1X + (_numberofPages - 1) * _winsize.height, iv1Y, iv1Width, iv1Height)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 200)] setFrame:CGRectMake(iv1X + (_numberofPages - 1) * _winsize.height, iv1Y + iv1Height - 25.f, iv1Width, 25.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 250)] setFrame:CGRectMake(iv1Width/2 - 20.f, iv1Height/2 - 20.f, 40.f, 40.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 350)] setFrame:CGRectMake(iv1X + (_numberofPages - 1) * _winsize.height, iv1Y, iv1Width, 25.f)];
                    break;
                case 2:
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 150)] setFrame:CGRectMake(iv2_left_X + (_numberofPages - 1) * _winsize.height, iv2Y, iv2Width, iv2Height)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 200)] setFrame:CGRectMake(iv2_left_X + (_numberofPages - 1) * _winsize.height, iv2Y + iv2Height - 25.f, iv2Width, 25.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 250)] setFrame:CGRectMake(iv2Width/2 - 20.f, iv2Height/2 - 20.f, 40.f, 40.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 350)] setFrame:CGRectMake(iv2_left_X + (_numberofPages - 1) * _winsize.height, iv2Y, iv2Width, 25.f)];
                    
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 151)] setFrame:CGRectMake(iv2_right_x + (_numberofPages - 1) * _winsize.height, iv2Y, iv2Width, iv2Height)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 201)] setFrame:CGRectMake(iv2_right_x + (_numberofPages - 1) * _winsize.height, iv2Y + iv2Height - 25.f, iv2Width, 25.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 251)] setFrame:CGRectMake(iv2Width/2 - 20.f, iv2Height/2 - 20.f, 40.f, 40.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 351)] setFrame:CGRectMake(iv2_right_x + (_numberofPages - 1) * _winsize.height, iv2Y, iv2Width, 25.f)];
                    break;
                case 3:
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 153)] setFrame:CGRectMake((iv_With + (_winsize.height - iv_With*2)*2/3) + (_numberofPages - 1) * _winsize.height, 3.f + iv_Height, iv_With, iv_Height)];
                    break;
                    
                default:
                    break;
            }
            /*//            }else{
             //                float iv_Height = (_winsize.width - 44.f - 4.f)/2;
             //                float iv_Width = iv_Height * _winsize.height/_winsize.width;
             //                self.scrollView.frame = CGRectMake(0.f, 44.f, _winsize.height, _winsize.width - 44.f);
             //                self.scrollView.contentOffset = CGPointMake(_currentPage * _winsize.height, 0.f);
             //                self.scrollView.contentSize = CGSizeMake(_winsize.height * _numberofPages, _winsize.width - 44.f);
             //                for (int i = 0; i < _numberofPages; i++) {
             //                    switch (([_cameraInfos count] - 4 * i)/4 ? 4 : [_cameraInfos count]%4) {
             //                        case 4:
             //                            [[self.view viewWithTag:(i * 4 + 153)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width * 2)*2/3) + i * _winsize.height, iv_Height + 3.f, iv_Width, iv_Height)];
             //                            [[self.view viewWithTag:(i * 4 + 203)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width * 2)*2/3) + i * _winsize.height, iv_Height + 3.f + iv_Height - 25.f, iv_Width, 25.f)];
             //                            [[self.view viewWithTag:(i * 4 + 253)] setFrame:CGRectMake(iv_Width/2 - 20.f, iv_Height/2 - 20.f, 40.f, 40.f)];
             //                            [[self.view  viewWithTag:(i * 4  +353)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width * 2)*2/3) + i * _winsize.height, iv_Height + 3.f, iv_Width, 25.f)];
             //                        case 3:
             //                            [[self.view viewWithTag:(i * 4 + 152)] setFrame:CGRectMake((_winsize.height - iv_Width * 2)/3 + i * _winsize.height, iv_Height + 3.f, iv_Width, iv_Height)];
             //                            [[self.view viewWithTag:(i * 4 + 202)] setFrame:CGRectMake((_winsize.height - iv_Width * 2 )/3 + i * _winsize.height, iv_Height * 2 + 3.f - 25.f, iv_Width, 25.f)];
             //                            [[self.view viewWithTag:(i * 4 + 252)] setFrame:CGRectMake(iv_Width/2 - 20.f, iv_Height/2 - 20.f, 40.f, 40.f)];
             //                            [[self.view viewWithTag:(i * 4 + 352)] setFrame:CGRectMake((_winsize.height - iv_Width * 2)/3 + i * _winsize.height, iv_Height + 3.f, iv_Width, 25.f)];
             //                        case 2:
             //                            [[self.view viewWithTag:(i * 4 + 151)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width*2)*2/3) + i * _winsize.height, 1.f, iv_Width, iv_Height)];
             //                            [[self.view viewWithTag:(i * 4 + 201)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width*2)*2/3) + i * _winsize.height , iv_Height + 1.f - 25.f, iv_Width, 25.f)];
             //                            [[self.view viewWithTag:(i * 4 + 251)] setFrame:CGRectMake(iv_Width/2 - 20.f, iv_Height/2-20.f, 40.f, 40.f)];
             //                            [[self.view viewWithTag:(i * 4 + 351)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width*2)*2/3) + i * _winsize.height, 1.f, iv_Width, 25.f)];
             //                        case 1:
             //                            [[self.view viewWithTag:(i * 4 + 150)] setFrame:CGRectMake((_winsize.height - iv_Width*2)/3 + i * _winsize.height, 1.f, iv_Width, iv_Height)];
             //                            [[self.view viewWithTag:(i * 4 + 200)] setFrame:CGRectMake((_winsize.height - iv_Width*2)/3 + i * _winsize.height, 1.f + iv_Height - 25.f, iv_Width, 25.f)];
             //                            [[self.view viewWithTag:(i * 4 + 250)] setFrame:CGRectMake(iv_Width/2 - 20.f, iv_Height/2 - 20.f, 40.f, 40.f)];
             //                            [[self.view viewWithTag:(i * 4 + 350)] setFrame:CGRectMake((_winsize.height - iv_Width*2)/3 + i * _winsize.height, 1.f, iv_Width, 25.f)];
             //                        default:
             //                            break;
             //                    }
             //                }
             //                switch ([_cameraInfos count]%4 + 1) {
             //
             //                    case 2:
             //                        [[self.view viewWithTag:((_numberofPages - 1) * 4 + 151)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width*2)*2/3) + (_numberofPages - 1) * _winsize.height, 1.f, iv_Width, iv_Height)];
             //                    case 3:
             //                        [[self.view viewWithTag:((_numberofPages - 1) * 4 + 152)] setFrame:CGRectMake((_winsize.height - iv_Width*2)/3 + (_numberofPages - 1) * _winsize.height, iv_Height + 3.f, iv_Width, iv_Height)];
             //                    case 4:
             //                        [[self.view viewWithTag:((_numberofPages - 1) * 4 + 153)] setFrame:CGRectMake((iv_Width + (_winsize.height - iv_Width*2)*2/3) + (_numberofPages - 1) * _winsize.height, iv_Height + 3.f, iv_Width, iv_Height)];
             //
             //                    default:
             //                        break;
             //                }
             //            }*/
            
            if (_imageView0 != nil) {
                _imageView0.frame = [self.view viewWithTag:(4 * _currentPage + 150)].frame;
                [[self.view viewWithTag:300 + _currentPage * 4] setFrame:CGRectMake(_imageView0.frame.size.width/2 - 20, _imageView0.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr0 != nil) {
            //                _myGlViewCtr0.view.frame = [self.view viewWithTag:(4 * _currentPage + 150)].frame;
            //            }
            if (_imageView1 != nil) {
                _imageView1.frame = [self.view viewWithTag:(4 * _currentPage) + 151].frame;
                
                [[self.view viewWithTag:(_currentPage * 4 + 301)] setFrame:CGRectMake(_imageView1.frame.size.width/2 - 20, _imageView1.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr1 != nil) {
            //                _myGlViewCtr1.view.frame = [self.view viewWithTag:(4 * _currentPage + 151)].frame;
            //            }
            if (_imageView2 != nil) {
                _imageView2.frame = [self.view viewWithTag:(4 * _currentPage + 152)].frame;
                
                [[self.view viewWithTag:(_currentPage * 4 + 302)] setFrame:CGRectMake(_imageView2.frame.size.width/2 - 20, _imageView2.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr2 != nil) {
            //                _myGlViewCtr2.view.frame = [self.view viewWithTag:(4 * _currentPage+152)].frame;
            //            }
            if (_imageView3 != nil) {
                _imageView3.frame = [self.view viewWithTag:(4 * _currentPage + 153)].frame;
                
                [[self.view viewWithTag:(_currentPage * 4 + 303)] setFrame:CGRectMake(_imageView3.frame.size.width/2 - 20, _imageView3.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr3 != nil) {
            //                _myGlViewCtr3.view.frame = [self.view viewWithTag:(4 * _currentPage + 153)].frame;
            //            }
        }];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.naBar.frame = CGRectMake(0.f, 0.f, _winsize.width, 44.f);
        float iv_width = (_winsize.width - 4.f)/2;
        self.scrollView.frame = CGRectMake(0.f, 44.f, _winsize.width, _winsize.height - 44.f - 20.f);
        self.scrollView.contentSize = CGSizeMake(_winsize.width * _numberofPages, _winsize.height - 44.f - 20.f);
        self.scrollView.contentOffset = CGPointMake(_winsize.width * _currentPage, 0);
        float iv_height = iv_width  * 3/4/*_winsize.width / _winsize.height*/;
        float up_iv_y = (self.scrollView.frame.size.height - iv_height*2)/3;
        float down_iv_y = 2 * up_iv_y + iv_height;
        float left_iv_x = (self.scrollView.frame.size.width - iv_width*2)/3;
        float right_iv_x = 2 * left_iv_x + iv_width;
        // CGRect ivRect = CGRectMake(right_iv_x + i * _winsize.width, down_iv_y, iv_width, iv_height);;
        [UIView animateWithDuration:0.5f animations:^{
            //self.timeoutLabel.frame = CGRectMake(0.f, 44.f, _winsize.width, 44.f);
            // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            for (int i = 0; i < _numberofPages; i++) {
                switch (([_cameraInfos count] - 4 * i)/4 ? 4 : ([_cameraInfos count]%4 == 3 ? 3 : 0)) {
                    case 4:
                        // ivRect =
                        
                        [[self.view viewWithTag:(i * 4 + 153)] setFrame:CGRectMake(right_iv_x + i * _winsize.width, down_iv_y, iv_width, iv_height)];
                        [[self.view viewWithTag:(i * 4 + 203)] setFrame:CGRectMake(right_iv_x + i * _winsize.width, down_iv_y + iv_height - 40.f, iv_width, 40.f)];
                        [[self.view viewWithTag:(i * 4 + 253)] setFrame:CGRectMake(iv_width/2 - 20.f, iv_height/2 - 20.f, 40.f, 40.f)];
                        [[self.view viewWithTag:(i * 4 + 353)] setFrame:CGRectMake(right_iv_x + i * _winsize.width, down_iv_y, iv_width, 25.f)];
                        // NSLog(@"view class : %@",[[self.view viewWithTag:(i * 4 + 153)] class]);
                        
                    case 3:
                        //ivRect = CGRectMake(left_iv_x + i * _winsize.width, down_iv_y, iv_width, iv_height);
                        [[self.view viewWithTag:(i * 4 + 152)] setFrame:CGRectMake(left_iv_x + i * _winsize.width, down_iv_y, iv_width, iv_height)];
                        [[self.view viewWithTag:(i * 4 + 202)] setFrame:CGRectMake(left_iv_x + i * _winsize.width, down_iv_y + iv_height - 40.f, iv_width, 40.f)];
                        [[self.view viewWithTag:(i * 4 + 252)] setFrame:CGRectMake(iv_width/2 - 20.f, iv_height/2 - 20.f, 40.f, 40.f)];
                        
                        [[self.view viewWithTag:(352 + i * 4)] setFrame:CGRectMake(left_iv_x + i * _winsize.width, down_iv_y, iv_width, 25.f)];
                    case 2:
                        [[self.view viewWithTag:(i * 4 + 151)] setFrame:CGRectMake(right_iv_x + i * _winsize.width, up_iv_y, iv_width, iv_height)];
                        [[self.view viewWithTag:(i * 4 + 201)] setFrame:CGRectMake(right_iv_x + i * _winsize.width, up_iv_y + iv_height - 40.f, iv_width, 40.f)];
                        [[self.view viewWithTag:(i * 4 + 251)] setFrame:CGRectMake(iv_width/2 - 20.f, iv_height/2 - 20.f, 40.f, 40.f)];
                        
                        [[self.view viewWithTag:(i * 4 + 351)] setFrame:CGRectMake(right_iv_x + i * _winsize.width, up_iv_y, iv_width, 25.f)];
                    case 1:
                        [[self.view viewWithTag:(i * 4 + 150)] setFrame:CGRectMake(left_iv_x + i * _winsize.width, up_iv_y, iv_width, iv_height)];
                        [[self.view viewWithTag:(i * 4) + 200] setFrame:CGRectMake(left_iv_x + i * _winsize.width, up_iv_y + iv_height - 40.f, iv_width, 40.f)];
                        [[self.view viewWithTag:(i * 4 + 250)] setFrame:CGRectMake(iv_width/2 - 20.f, iv_height/2 -20.f, 40.f, 40.f)];
                        
                        [[self.view viewWithTag:(i * 4 + 350)] setFrame:CGRectMake(left_iv_x + i * _winsize.width, up_iv_y, iv_width, 25.f)];
                    default:
                        break;
                }
            }
            float ivWidth1 = _winsize.width;
            float ivHeight1 = ivWidth1 * 3/4/*_winsize.width / _winsize.height*/;
            float iv1_x = 0.f;
            float iv1_y = (self.scrollView.frame.size.height  - ivHeight1)/2 ;
            // NSLog(@"ivWidth1  %f  ivHeight1 %f iv1_y %f",ivWidth1,ivHeight1,iv1_y);
            CGSize iv2Size = [self fitImageViewSize];
            float iv2_x = (_winsize.width - iv2Size.width)/2;
            float iv2_up_y = (self.scrollView.frame.size.height - iv2Size.height * 2)/3;
            float iv2_down_y = self.scrollView.frame.size.height - iv2_up_y - iv2Size.height;
            
            switch ([_cameraInfos count]%4) {
                    
                case 1:
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 150)] setFrame:CGRectMake(iv1_x + (_numberofPages - 1) * _winsize.width, iv1_y, ivWidth1, ivHeight1)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4) + 200] setFrame:CGRectMake(iv1_x + (_numberofPages - 1) * _winsize.width, iv1_y + ivHeight1 - 25.f, ivWidth1, 25.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 250)] setFrame:CGRectMake(ivWidth1/2 - 20.f, ivHeight1/2 -20.f, 40.f, 40.f)];
                    
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 350)] setFrame:CGRectMake(iv1_x + (_numberofPages - 1) * _winsize.width, iv1_y, ivWidth1, 25.f)];
                    NSLog(@"[self.view viewWithTag:((_numberofPages - 1) * 4 + 150)].frame  %@", NSStringFromCGRect([self.view viewWithTag:((_numberofPages - 1) * 4 + 150)].frame));
                    break;
                case 2:
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 150)] setFrame:CGRectMake(iv2_x + (_numberofPages - 1) * _winsize.width, iv2_up_y, iv2Size.width, iv2Size.height)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4) + 200] setFrame:CGRectMake(iv2_x + (_numberofPages - 1) * _winsize.width, iv2_up_y + iv2Size.height - 25.f, iv2Size.width, 25.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 250)] setFrame:CGRectMake(iv2Size.width/2 - 20.f, iv2Size.height/2 -20.f, 40.f, 40.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 350)] setFrame:CGRectMake(iv2_x + (_numberofPages - 1) * _winsize.width, iv2_up_y, iv2Size.width, 25.f)];
                    
                    
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 151)] setFrame:CGRectMake(iv2_x + (_numberofPages - 1) * _winsize.width, iv2_down_y, iv2Size.width, iv2Size.height)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4) + 201] setFrame:CGRectMake(iv2_x + (_numberofPages - 1) * _winsize.width, iv2_down_y + iv2Size.height - 25.f, iv2Size.width, 25.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 251)] setFrame:CGRectMake(iv2Size.width/2 - 20.f, iv2Size.height/2 -20.f, 40.f, 40.f)];
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 351)] setFrame:CGRectMake(iv2_x + (_numberofPages - 1) * _winsize.width, iv2_down_y, iv2Size.width, 25.f)];
                    NSLog(@"[self.view viewWithTag:((_numberofPages - 1) * 4 + 150)].frame  %@", NSStringFromCGRect([self.view viewWithTag:((_numberofPages - 1) * 4 + 150)].frame));
                    NSLog(@"[self.view viewWithTag:((_numberofPages - 1) * 4 + 151)].frame  %@", NSStringFromCGRect([self.view viewWithTag:((_numberofPages - 1) * 4 + 151)].frame));
                    break;
                case 3:
                    [[self.view viewWithTag:((_numberofPages - 1) * 4 + 153)] setFrame:CGRectMake(right_iv_x + (_numberofPages - 1) * _winsize.width, down_iv_y, iv_width, iv_height)];
                    break;
                default:
                    break;
            }
            /* }else{
             self.scrollView.frame = CGRectMake(0.f, 150.f, _winsize.width, 734.f);
             self.scrollView.contentSize = CGSizeMake(_winsize.width*_numberofPages, 734.f);
             self.scrollView.contentOffset = CGPointMake(_winsize.width * _currentPage, 0);
             for (int i = 0; i < _numberofPages; i++) {
             switch (([_cameraInfos count] - 4 * i)/4 ? 4 : [_cameraInfos count]%4) {
             case 4:
             [[self.view viewWithTag:(i * 4 + 153)] setFrame:CGRectMake(385.f + i * _winsize.width, 334.f, 382.f, 300.f)];
             [[self.view viewWithTag:(i * 4 + 203)] setFrame:CGRectMake(385.f + _winsize.width * i, 334 + 270, 382, 40)];
             [[self.view viewWithTag:(i * 4 + 253)] setFrame:CGRectMake(171.f, 130.f, 40, 40)];
             // NSLog(@"view class : %@",[[self.view viewWithTag:(i * 4 + 153)] class]);
             [[self.view viewWithTag:(i * 4 + 353)] setFrame:CGRectMake(385.f + i * _winsize.width, 334.f, 382.f, 25.f)];
             case 3:
             [[self.view viewWithTag:(i * 4 + 152)] setFrame:CGRectMake(1.f + i * _winsize.width, 334.f, 382.f, 300.f)];
             [[self.view viewWithTag:(i * 4 + 202)] setFrame:CGRectMake(1.f + i * _winsize.width, 334.f + 270.f, 382.f, 40.f)];
             [[self.view viewWithTag:(i * 4 + 252)] setFrame:CGRectMake(171.f, 130.f, 40, 40)];
             [[self.view viewWithTag:(i * 4) + 352] setFrame:CGRectMake(1.f + i * _winsize.width, 334.f, 382.f, 25.f)];
             case 2:
             [[self.view viewWithTag:(i * 4 + 151)] setFrame:CGRectMake(385.f + i * _winsize.width, 10.f, 382.f, 300.f)];
             [[self.view viewWithTag:(i * 4 + 201)] setFrame:CGRectMake(385.f + i * _winsize.width, 10.f + 270.f, 382.f, 40.f)];
             [[self.view viewWithTag:(i * 4 + 251)] setFrame:CGRectMake(171.f,130.f, 40, 40)];
             [[self.view viewWithTag:(i * 4 + 351)] setFrame:CGRectMake(385.f + i * _winsize.width, 10.f, 382.f, 25.f)];
             case 1:
             [[self.view viewWithTag:(i * 4 + 150)] setFrame:CGRectMake(1.f + i * _winsize.width, 10.f, 382.f, 300.f)];
             [[self.view viewWithTag:(i * 4) + 200] setFrame:CGRectMake(1.f + _winsize.width * i, 10.f + 270.f, 382.f, 40.f)];
             [[self.view viewWithTag:(i * 4 + 250)] setFrame:CGRectMake(171.f, 130.f, 40, 40)];
             [[self.view viewWithTag:(i * 4 + 350)] setFrame:CGRectMake(1.f + i * _winsize.width, 10.f, 382.f, 25.f)];
             default:
             break;
             }
             }
             switch ([_cameraInfos count]%4 + 1) {
             
             case 2:
             [[self.view viewWithTag:((_numberofPages - 1) * 4 + 151)] setFrame:CGRectMake(385.f + (_numberofPages - 1) * _winsize.width, 10.f, 382.f, 300.f)];
             case 3:
             [[self.view viewWithTag:((_numberofPages - 1) * 4 + 152)] setFrame:CGRectMake(1.f + (_numberofPages - 1) * _winsize.width, 334.f, 382.f, 300.f)];
             case 4:
             [[self.view viewWithTag:((_numberofPages - 1) * 4 + 153)] setFrame:CGRectMake(385.f + (_numberofPages - 1) * _winsize.width, 334.f, 382.f, 300.f)];
             
             default:
             break;
             }
             }*/
            
            if (_imageView0 != nil) {
                _imageView0.frame = [self.view viewWithTag:(4 * _currentPage + 150)].frame;
                [[self.view viewWithTag:(_currentPage * 4 + 300)] setFrame:CGRectMake(_imageView0.frame.size.width/2 - 20, _imageView0.frame.size.height/2 - 20, 40, 40)];            }
            //            if (_myGlViewCtr0 != nil) {
            //                _myGlViewCtr0.view.frame = [self.view viewWithTag:(4 * _currentPage + 150)].frame;
            //            }
            if (_imageView1 != nil) {
                _imageView1.frame = [self.view viewWithTag:(4 * _currentPage) + 151].frame;
                
                [[self.view viewWithTag:(_currentPage * 4 + 301)] setFrame:CGRectMake(_imageView1.frame.size.width/2 - 20, _imageView1.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr1 != nil) {
            //                _myGlViewCtr1.view.frame = [self.view viewWithTag:(4 * _currentPage + 151)].frame;
            //            }
            if (_imageView2 != nil) {
                _imageView2.frame = [self.view viewWithTag:(4 * _currentPage + 152)].frame;
                
                [[self.view viewWithTag:(_currentPage * 4 + 302)] setFrame:CGRectMake(_imageView2.frame.size.width/2 - 20, _imageView2.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr2 != nil) {
            //                _myGlViewCtr2.view.frame = [self.view viewWithTag:(4 * _currentPage+152)].frame;
            //            }
            if (_imageView3 != nil) {
                _imageView3.frame = [self.view viewWithTag:(4 * _currentPage + 153)].frame;
                
                [[self.view viewWithTag:(_currentPage * 4 + 303)] setFrame:CGRectMake(_imageView3.frame.size.width/2 - 20, _imageView3.frame.size.height/2 - 20, 40, 40)];
            }
            //            if (_myGlViewCtr3 != nil) {
            //                _myGlViewCtr3.view.frame = [self.view viewWithTag:(4 * _currentPage + 153)].frame;
            //            }
        }];
    }
    //    if (_imageView0 != nil) {
    //        _imageView0.frame = [self.view viewWithTag:(4 * _currentPage + 150)].frame;
    //        [[self.view viewWithTag:(_currentPage * 4 + 300)] setFrame:CGRectMake(_imageView0.frame.size.width/2 - 20, _imageView0.frame.size.height/2 - 20, 40, 40)];            }
    if (_myGlViewCtr0 != nil) {
        _myGlViewCtr0.view.frame = [self.view viewWithTag:(4 * _currentPage + 150)].frame;
    }
    //    if (_imageView1 != nil) {
    //        _imageView1.frame = [self.view viewWithTag:(4 * _currentPage) + 151].frame;
    //
    //        [[self.view viewWithTag:(_currentPage * 4 + 301)] setFrame:CGRectMake(_imageView1.frame.size.width/2 - 20, _imageView1.frame.size.height/2 - 20, 40, 40)];
    //    }
    if (_myGlViewCtr1 != nil) {
        _myGlViewCtr1.view.frame = [self.view viewWithTag:(4 * _currentPage + 151)].frame;
    }
    //    if (_imageView2 != nil) {
    //        _imageView2.frame = [self.view viewWithTag:(4 * _currentPage + 152)].frame;
    //
    //        [[self.view viewWithTag:(_currentPage * 4 + 302)] setFrame:CGRectMake(_imageView2.frame.size.width/2 - 20, _imageView2.frame.size.height/2 - 20, 40, 40)];
    //    }
    if (_myGlViewCtr2 != nil) {
        _myGlViewCtr2.view.frame = [self.view viewWithTag:(4 * _currentPage+152)].frame;
    }
    //    if (_imageView3 != nil) {
    //        _imageView3.frame = [self.view viewWithTag:(4 * _currentPage + 153)].frame;
    //
    //        [[self.view viewWithTag:(_currentPage * 4 + 303)] setFrame:CGRectMake(_imageView3.frame.size.width/2 - 20, _imageView3.frame.size.height/2 - 20, 40, 40)];
    //    }
    if (_myGlViewCtr3 != nil) {
        _myGlViewCtr3.view.frame = [self.view viewWithTag:(4 * _currentPage + 153)].frame;
    }
    
}

//旋转方向发生改变时

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //NSLog(@"will Animate Rotation   %d",toInterfaceOrientation);
}

//视图旋转完成之后自动调用

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // NSLog(@"did Rotate %d",fromInterfaceOrientation);
}
////视图旋转动画前一半发生之后自动调用
//
//-(void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    NSLog(@"did Animate First Half %d",toInterfaceOrientation);
//}

#if _IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE_6_0
// New Autorotation support.
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}
#endif

@end
