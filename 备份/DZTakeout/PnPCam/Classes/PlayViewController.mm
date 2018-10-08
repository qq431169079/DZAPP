//
//  PlayViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayViewController.h"
#include "IpCameraClientAppDelegate.h"

#import "obj_common.h"
#import "PPPPDefine.h"
#import "mytoast.h"
#import "cmdhead.h"
#import "moto.h"
#import "CustomToast.h"
#import <sys/time.h>
#import "APICommon.h"
#import "DemoTableController.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIScrollView (UITouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController].view isEqual:[self.nextResponder nextResponder]]) {
        [[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController] PlayViewtouchesBegan:touches withEvent:event];
    }
    [[[self nextResponder] nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController].view isEqual:[self.nextResponder nextResponder]]) {
        [[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController] PlayViewtouchesMoved:touches withEvent:event];
    }
    
    [[[self nextResponder] nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController].view isEqual:[self.nextResponder nextResponder]]) {
        [[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController] PlayViewtouchesEnded:touches withEvent:event];
    }
    
    
    [[[self nextResponder] nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController].view isEqual:[self.nextResponder nextResponder]]) {
        [[(IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate playViewController] PlayViewtouchesCancelled:touches withEvent:event];
    }
    [[[self nextResponder] nextResponder] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

@end

@interface PlayViewController ()
@property (nonatomic, assign) BOOL is_animationUp;
@property (nonatomic, assign) BOOL is_animationDown;
@property (nonatomic, assign) BOOL is_animationLeft;
@property (nonatomic, assign) BOOL is_animationRight;
@property (nonatomic, assign) double FocalLength;
@property (nonatomic, retain) CustomToolBar* menuToolBar;
@end

@implementation PlayViewController
@synthesize m_pPPPPChannelMgt;
@synthesize imgView;
@synthesize cameraName;
@synthesize strDID;
@synthesize progressView;
@synthesize LblProgress;
@synthesize playToolBar;
@synthesize btnItemResolution;
@synthesize btnTitle;
@synthesize timeoutLabel;
@synthesize m_nP2PMode;
@synthesize toolBarTop;
@synthesize btnUpDown;
@synthesize btnLeftDown;
@synthesize btnUpDownMirror;
@synthesize btnLeftRightMirror;
@synthesize btnTalkControl;
@synthesize btnAudioControl;
@synthesize btnSetContrast;
@synthesize btnSetBrightness;
@synthesize btnStop;
@synthesize imgVGA;
@synthesize img720P;
@synthesize imgQVGA;
//@synthesize btnSwitchDisplayMode;
@synthesize imgNormal;
@synthesize imgEnlarge;
@synthesize imgFullScreen;
@synthesize imageSnapshot;
@synthesize m_pPicPathMgt;
@synthesize btnRecord;
@synthesize imageUp;
@synthesize imageDown;
@synthesize imageLeft;
@synthesize imageRight;
@synthesize m_pRecPathMgt;
@synthesize PicNotifyDelegate;
@synthesize RecNotifyDelegate;
@synthesize btnSnapshot;
@synthesize resolutionPopup = _resolutionPopup;
@synthesize listitems = _listitems;
@synthesize resolutionbutton = _resolutionbutton;
@synthesize menuPopup = _menuPopup;
@synthesize cameramarkimgView = _cameramarkimgView;
#define spliteBtn @"SpliteButton"
#define TalkMark @"IsTalking"
#define AudioMark @"IsAudioing"
#pragma mark -
#pragma mark others

- (void) StartAudio
{
    m_pPPPPChannelMgt->StartPPPPAudio([strDID UTF8String]);
}

- (void) StopAudio
{
    m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
}

- (void) StartTalk
{
    m_pPPPPChannelMgt->StartPPPPTalk([strDID UTF8String]);
}

- (void) StopTalk
{
    m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
}

- (IBAction)btnStop:(id)sender
{
    UIImage *image = nil;
    if(m_videoFormat != 0 && m_videoFormat != 2) //MJPEG && H264
    {
        //return;
    }else if (m_videoFormat == 0) {//MJPEG
        if (imageSnapshot == nil || m_pPicPathMgt == nil) {
            //return;
        }else{
            image = imageSnapshot;
        }
        
        
    }else{//H264
        [m_YUVDataLock lock];
        if (m_YUVDataLock == NULL) {
            [m_YUVDataLock unlock];
            //return;
        }else{
            //yuv->image
            image = [APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight];
        }
        [m_YUVDataLock unlock];
    }
    if (image != nil){
        [self saveSnapshot:image DID:strDID];
        [self.m_PCameraListMgt UpdateCamereaImage:self.strDID Image:image];
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationPortrait == orientation || UIInterfaceOrientationPortraitUpsideDown == orientation) {
        bManualStop = YES;
        [self StopPlay: 0];
    }else{
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
        }
        bManualStop = YES;
        [self StopPlay: 0];
    }
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) _strDID
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:_strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    
    [pool release];
    
    
}


- (IBAction)btnAudioControl:(id)sender
{
    if (m_bAudioStarted) {
        [self StopAudio];
        [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
        //btnAudioControl.style = UIBarButtonItemStyleBordered;
        //btnAudioControl.image = [UIImage imageNamed:@"ptz_audio_off"];
        //[btnAudioControl setBackgroundImage:[UIImage imageNamed:@"ptz_audio_off"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    }else {
        if (m_bTalkStarted) {
            [self StopTalk];
            m_bTalkStarted = !m_bTalkStarted;
            [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
            //btnTalkControl.style = UIBarButtonItemStyleBordered;
            //btnTalkControl.image = [UIImage imageNamed:@"microphone_off"];
            //[btnAudioControl setBackgroundImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        }
        [self StartAudio];
        [_audioBtn setImage:_audioImgOn forState:UIControlStateNormal];
        //btnAudioControl.style = UIBarButtonItemStyleDone;
        //btnAudioControl.image = [UIImage imageNamed:@"audio"];
    }
    
    m_bAudioStarted = !m_bAudioStarted;
    
    /*if (m_bAudioStarted) {
     btnTalkControl.enabled = NO;
     }else {
     btnTalkControl.enabled = YES;
     }*/
}

- (IBAction)btnTalkControl:(id)sender
{
    if (m_bTalkStarted) {
        [self StopTalk];
        [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
        //btnTalkControl.style = UIBarButtonItemStyleBordered;
        //btnTalkControl.image = [UIImage imageNamed:@"microphone_off"];
        //[btnTalkControl setBackgroundImage:[UIImage imageNamed:@"microphone_off"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    }else {
        if (m_bAudioStarted) {
            [self StopAudio];
            m_bAudioStarted = !m_bAudioStarted;
            [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
            //btnAudioControl.style = UIBarButtonItemStyleBordered;
            //btnAudioControl.image = [UIImage imageNamed:@"ptz_audio_off"];
            //[btnTalkControl setBackgroundImage:[UIImage imageNamed:@"micro_on"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        }
        [self StartTalk];
        [_talkBtn setImage:_talkImgOn forState:UIControlStateNormal];
        //btnTalkControl.style = UIBarButtonItemStyleDone;
        //btnTalkControl.image = [UIImage imageNamed:@"micro_on"];
    }
    m_bTalkStarted = !m_bTalkStarted;
    
    /*if (m_bTalkStarted) {
     btnAudioControl.enabled = NO;
     }else {
     btnAudioControl.enabled = YES;
     }*/
}

/*- (IBAction) btnItemDefaultVideoParamsPressed:(id)sender
 {
 sliderBrightness.value = 1;
 sliderContrast.value = 128;
 m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 1, 1);
 m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 2, 128);
 
 [CustomToast showWithText:NSLocalizedStringFromTable(@"DefaultVideoParams", @STR_LOCALIZED_FILE_NAME, nil)
 superView:self.view
 bLandScap:YES];
 }*/

- (IBAction) btnUpDown:(id)sender
{
    if (m_bPtzIsUpDown) {
        m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_DOWN_STOP);
        btnUpDown.style = UIBarButtonItemStyleBordered;
        [_upDownBtn setImage:_arrowUpDownImg forState:UIControlStateNormal];
    }else {
        m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_DOWN);
        btnUpDown.style = UIBarButtonItemStyleDone;
        [_upDownBtn setImage:_arrowUpDownImgOn forState:UIControlStateNormal];
    }
    m_bPtzIsUpDown = !m_bPtzIsUpDown;
    
}

- (NSString*) GetRecordFileName
{
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString* camuid = [NSString stringWithString:strDID];
    
    if ([camuid length] != 15) {
        NSArray* strarr = [strDID componentsSeparatedByString:@"-"];
        camuid = [strarr componentsJoinedByString:@""];
        if ([camuid length] < 15){
            camuid = [NSString stringWithFormat:@"%@ppppppppppppppp",camuid];
        }
        
        if ([camuid length] > 15) {
            camuid = [camuid substringToIndex:15];
        }
    }
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@_%@.rec",camuid, self.currentAcc, strDateTime];
    
    
    [formatter release];
    
    return strFileName;
    
}

- (NSString*) GetRecordPath: (NSString*)strFileName
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    
    return strPath;
    
    
}

- (void) stopRecord
{
    [m_RecordLock lock];
    bCameramark = NO;
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    [_recordBtn setImage:_recordImgOff forState:UIControlStateNormal];
    //btnRecord.image = [UIImage imageNamed:@"record"];
    SAFE_DELETE(m_pCustomRecorder);
    [RecNotifyDelegate NotifyReloadData];
    [m_RecordLock  unlock];
}

- (IBAction) btnRecord:(id)sender
{
    if (m_videoFormat == -1) {
        return ;
    }
    
    [m_RecordLock lock];
    if (m_pCustomRecorder == NULL) {
        m_pCustomRecorder = new CCustomAVRecorder();
        NSString *strFileName = [self GetRecordFileName];
        NSString *strPath = [self GetRecordPath: strFileName];
        if(m_pCustomRecorder->StartRecord((char*)[strPath UTF8String], m_videoFormat, (char*)[cameraName UTF8String]))
        {
            //btnRecord.image = [UIImage imageNamed:@"ptz_takevideo_pressed"];
            [_recordBtn setImage:_recordImgOn forState:UIControlStateNormal];
            UIImage* markimg = [UIImage imageNamed:@"CameraMark"];
            UIImage* newmarkimg = [self fitImage:markimg tofitHeight:30];
            //_cameramarkimgView.frame = CGRectMake(self.imgView.frame.size.width - 50, self.imgView.frame.origin.y, newmarkimg.size.width, newmarkimg.size.height);
            [self.cameramarkimgView setFrame:CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height  - newmarkimg.size.height - 5.f, newmarkimg.size.width,newmarkimg.size.height)];
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
                self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.toolBarTop.frame.size.height - newmarkimg.size.height - 5.f, newmarkimg.size.width, newmarkimg.size.height);
            }
            
            //            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //                _cameramarkimgView.frame = CGRectMake(self.imgView.frame.size.width - 50, self.imgView.frame.origin.y + self.toolBarTop.frame.size.height, newmarkimg.size.width, newmarkimg.size.height);
            //            }
            _cameramarkimgView.image = newmarkimg;
            [self.view bringSubviewToFront:_cameramarkimgView];
            //[self ];
            if (!bCameramark) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cameraanimation:) userInfo:nil repeats:YES];
            }
            _cameramarkimgView.hidden = NO;
            NSDate* date = [NSDate date];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString* strDate = [formatter stringFromDate:date];
            [m_pRecPathMgt InsertPath:strDID Date:strDate Path:strFileName];
            [formatter release];
            bCameramark = YES;
        }
        
        btnRecord.style = UIBarButtonItemStyleDone;
        
    }else {
        NSLog(@"timer  %@",timer);
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
        _cameramarkimgView.hidden = YES;
        //btnRecord.image = [UIImage imageNamed:@"record"];
        [_recordBtn setImage:_recordImgOff forState:UIControlStateNormal];
        bCameramark = NO;
        SAFE_DELETE(m_pCustomRecorder);
        [RecNotifyDelegate NotifyReloadData];
        btnRecord.style = UIBarButtonItemStyleBordered;
    }
    [m_RecordLock unlock];
    
}

- (void)cameraanimation:(id)sender{
    //_cameramarkimgView.alpha = 1.0;
    if (_cameramarkimgView.alpha == 1.0f) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _cameramarkimgView.alpha = 0.f;
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _cameramarkimgView.alpha = 1.0f;
        [UIView commitAnimations];
    }
    
    
}

- (IBAction) btnLeftRight:(id)sender
{
    if (m_bPtzIsLeftRight) {
        m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
        btnLeftRight.style = UIBarButtonItemStyleBordered;
        [_leftRightBtn setImage:_arrowLeftRightImg forState:UIControlStateNormal];
    }else {
        m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RIGHT);
        btnLeftRight.style = UIBarButtonItemStyleDone;
        [_leftRightBtn setImage:_arrowLeftRightImgOn forState:UIControlStateNormal];
    }
    m_bPtzIsLeftRight = !m_bPtzIsLeftRight;
}

- (IBAction) btnUpDownMirror:(id)sender
{
    int value;
    
    if (m_bUpDownMirror) {
        btnUpDownMirror.style = UIBarButtonItemStyleBordered;
        
        if (m_bLeftRightMirror) {
            value = 2;
        }else {
            value = 0;
        }
    }else {
        btnUpDownMirror.style = UIBarButtonItemStyleDone;
        if (m_bLeftRightMirror) {
            value = 3;
        }else {
            value = 1;
        }
    }
    
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
    
    m_bUpDownMirror = !m_bUpDownMirror;
}

- (IBAction) btnLeftRightMirror:(id)sender
{
    int value;
    
    if (m_bLeftRightMirror) {
        btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
        
        if (m_bUpDownMirror) {
            value = 1;
        }else {
            value = 0;
        }
    }else {
        
        btnLeftRightMirror.style = UIBarButtonItemStyleDone;
        
        if (m_bUpDownMirror) {
            value = 3;
        }else {
            value = 2;
        }
    }
    
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
    
    m_bLeftRightMirror = !m_bLeftRightMirror;
}

- (void) showContrastSlider: (BOOL) bShow
{
    [labelContrast setHidden:!bShow];
    [sliderContrast setHidden:!bShow];
    
    if (bShow) {
        btnSetContrast.style = UIBarButtonItemStyleDone;
    }else {
        btnSetContrast.style = UIBarButtonItemStyleBordered;
    }
}

- (void) showBrightnessSlider: (BOOL) bShow
{
    [labelBrightness setHidden:!bShow];
    [sliderBrightness setHidden:!bShow];
    
    if (bShow) {
        btnSetBrightness.style = UIBarButtonItemStyleDone;
    }else {
        btnSetBrightness.style = UIBarButtonItemStyleBordered;
    }
}

- (IBAction) btnSetContrast:(id)sender
{
    if (m_bContrastShow) {
        [self showContrastSlider:NO];
    }else {
        [self showContrastSlider:YES];
    }
    m_bContrastShow = !m_bContrastShow;
}

- (IBAction) btnSetBrightness:(id)sender
{
    if (m_bBrightnessShow) {
        [self showBrightnessSlider:NO];
    }else {
        [self showBrightnessSlider:YES];
    }
    m_bBrightnessShow = !m_bBrightnessShow;
}

- (void) setResolutionSize:(NSInteger) resolution
{
    
    switch (resolution) {
        case 0:
            m_nVideoWidth = 640;
            m_nVideoHeight = 480;
            break;
        case 1:
            m_nVideoWidth = 320;
            m_nVideoHeight = 240;
            break;
        case 3:
            m_nVideoWidth = 1280;
            m_nVideoHeight = 720;
            break;
            
        default:
            break;
    }
    
    [self setDisplayMode];
}



- (IBAction) btnItemResolutionPressed:(id)sender
{
    if (bGetVideoParams == NO || m_bGetStreamCodecType == NO) {
        return ;
    }
    if (_resolutionPopup) {
        [_resolutionPopup hide];
    }
    if (_listitems) {
        [_listitems release];
        _listitems = nil;
    }
    PopupListComponent* resolutionPopupView = [[PopupListComponent alloc] init];
    resolutionPopupView.allowedArrowDirections = UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp;
    if (m_StreamCodecType == STREAM_CODEC_TYPE_JPEG) {
        PopupListComponentItem* item0 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"highdefinition", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:10 showCaption:YES];
        PopupListComponentItem* item1 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"commondefinition", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:11 showCaption:YES];
        
        
        _listitems = [[NSArray alloc] initWithObjects:item0 ,item1 ,nil];//[NSArray arrayWithObjects: item1, item2, nil];
        
        resolutionPopupView.textColor = [UIColor whiteColor];
        resolutionPopupView.textPaddingHorizontal = 5.0f;
        resolutionPopupView.textPaddingVertical = 2.0f;
        
        resolutionPopupView.alignment = UIControlContentHorizontalAlignmentCenter;
        [resolutionPopupView useSystemDefaultFontNonBold];
        
        [resolutionPopupView showAnchoredTo:sender inView:self.view withItems:_listitems withDelegate:self];
        [item0 release];
        [item1 release];
        item0 = nil;
        item1 = nil;
    }else{
        PopupListComponentItem* item2 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"MotionLevelHighest", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:12 showCaption:YES];
        PopupListComponentItem* item3 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"MotionLevelHigh", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:13 showCaption:YES];
        PopupListComponentItem* item4 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"MotionLevelMiddle", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:14 showCaption:YES];
        PopupListComponentItem* item5 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"MotionLevelLow", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:15 showCaption:YES];
        PopupListComponentItem* item6 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"MotionLevelLowest", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:16 showCaption:YES];
        PopupListComponentItem* item7 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"MotionLevelmobile", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:17 showCaption:YES];
        _listitems = [[NSArray alloc] initWithObjects:item2, item3, item4, item5, item6, item7, nil];
        resolutionPopupView.textColor = [UIColor whiteColor];
        resolutionPopupView.textPaddingHorizontal = 5.0f;
        resolutionPopupView.textPaddingVertical = 2.0f;
        [resolutionPopupView showAnchoredTo:sender inView:self.view withItems:_listitems withDelegate:self];
        [item2 release];
        [item3 release];
        [item4 release];
        [item5 release];
        [item6 release];
        [item7 release];
        item2 = nil;
        item3 = nil;
        item4 = nil;
        item5 = nil;
        item6 = nil;
        item7 = nil;
    }
    
    int itemId = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@itemId",strDID]] intValue];
    UIView* view = [self.view viewWithTag:itemId];
    if ([view isMemberOfClass:[UIButton class]]) {
        [(UIButton*)view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    self.resolutionPopup = [resolutionPopupView retain];
    [resolutionPopupView release];
    /*int resolution = 0;
     
     if (m_StreamCodecType == STREAM_CODEC_TYPE_JPEG) {
     if (nResolution == 0) {
     resolution = 1;
     
     }else {
     resolution = 0;
     }
     }else {
     switch (nResolution) {
     case 0:
     resolution = 1;
     break;
     case 1:
     resolution = 3;
     break;
     case 3:
     resolution = 2;
     break;
     default:
     return;
     }
     }
     // NSLog(@"resolution %d",resolution);
     [self setResolutionSize:resolution];
     
     nResolution = resolution;
     [self updateVideoResolution];
     
     m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, resolution);
     */
    //nUpdataImageCount = 0;
    [self performSelector:@selector(getCameraParams) withObject:nil afterDelay:3.0];
    //NSLog(@"imgView  %@",NSStringFromCGRect(imgView.frame));
}

#pragma mark-
#pragma mark CustomToolBarItemDelegate
- (void) TouchToItem:(CustomToolBarItem*) item{
    int itemId = item.itemId;
    switch (itemId) {
        case 11:
            if (m_bContrastShow) {
                [self showContrastSlider:NO];
            }else {
                [self showContrastSlider:YES];
            }
            [_menuToolBar dismissToolBar];
            m_bContrastShow = !m_bContrastShow;
            break;
        case 12:
            if (m_bBrightnessShow) {
                [self showBrightnessSlider:NO];
            }else {
                [self showBrightnessSlider:YES];
            }
            [_menuToolBar dismissToolBar];
            m_bBrightnessShow = !m_bBrightnessShow;
            break;
        case 13:
        {
            m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 18, 1);
        }
            break;
        case 14:
        {
            m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 17, 1);
        }
            break;
        case 15:
        {
            int value;
            
            if (m_bUpDownMirror) {
                btnUpDownMirror.style = UIBarButtonItemStyleBordered;
                
                if (m_bLeftRightMirror) {
                    value = 2;
                }else {
                    value = 0;
                }
            }else {
                btnUpDownMirror.style = UIBarButtonItemStyleDone;
                if (m_bLeftRightMirror) {
                    value = 3;
                }else {
                    value = 1;
                }
            }
            [_menuToolBar dismissToolBar];
            m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
            
            m_bUpDownMirror = !m_bUpDownMirror;
        }
            break;
        case 16:
        {
            int value;
            
            if (m_bLeftRightMirror) {
                btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
                
                if (m_bUpDownMirror) {
                    value = 1;
                }else {
                    value = 0;
                }
            }else {
                
                btnLeftRightMirror.style = UIBarButtonItemStyleDone;
                
                if (m_bUpDownMirror) {
                    value = 3;
                }else {
                    value = 2;
                }
            }
            [_menuToolBar dismissToolBar];
            m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
            
            m_bLeftRightMirror = !m_bLeftRightMirror;
        }
            break;
        case 17:
        {
            [_menuToolBar dismissToolBar];
            m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 14, 1);
        }
            break;
        case 18:
        {
            [_menuToolBar dismissToolBar];
            m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 14, 0);
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark PopupListComponentDelegate

- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId{
    
    if (itemId >= 10 && itemId <= 17) {
        int itemid =[(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@itemId",strDID]] intValue];
        if (itemid != itemId ) {
            UIView* view = [self.view viewWithTag:itemid];
            if ([view isMemberOfClass:[UIButton class]]) {
                [(UIButton*)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }
        [(UIButton*)[self.view viewWithTag:itemId] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setInteger:itemId forKey:[NSString stringWithFormat:@"%@itemId",strDID]];
        //item = itemId;
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSInteger resolutionValue = 0;
        switch (itemId) {
            case 10:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 0);
                break;
            case 11:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
                break;
            case 12:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 16, 0);
                resolutionValue = 0;
                break;
            case 13:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 16, 1);
                resolutionValue = 1;
                break;
            case 14:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 16, 2);
                resolutionValue = 2;
                break;
            case 15:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 16, 3);
                resolutionValue = 3;
                break;
            case 16:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 16, 4);
                resolutionValue = 4;
                break;
            case 17:
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 16, 5);
                resolutionValue = 5;
                break;
            default:
                break;
        }
        [[NSUserDefaults standardUserDefaults] setInteger:resolutionValue forKey:[NSString stringWithFormat:@"%@_ResolutionValue",strDID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if (itemId >= 18 && itemId <= 21){
        /*int itemid = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@menu",strDID]] intValue];
         if (itemId != itemid) {
         UIView* view = [self.view viewWithTag:itemid];
         if ([view isMemberOfClass:[UIButton class]]) {
         [(UIButton*)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         }
         }
         [(UIButton*)[self.view viewWithTag:itemId] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         [[NSUserDefaults standardUserDefaults] setInteger:itemId forKey:[NSString stringWithFormat:@"%@menu",strDID]];*/
        switch (itemId) {
            case 18:
                if (m_bContrastShow) {
                    [self showContrastSlider:NO];
                }else {
                    [self showContrastSlider:YES];
                }
                m_bContrastShow = !m_bContrastShow;
                break;
            case 19:
                if (m_bBrightnessShow) {
                    [self showBrightnessSlider:NO];
                }else {
                    [self showBrightnessSlider:YES];
                }
                m_bBrightnessShow = !m_bBrightnessShow;
                break;
            case 20:
            {
                m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 18, 1);
                //m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 14, 0 );
            }
                break;
            case 21:
            {
                m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 17, 1);
                //m_pPPPPChannelMgt->CameraControl((char* )[strDID UTF8String], 14, 1);
            }
                break;
            case 22:
            {
                int value;
                
                if (m_bUpDownMirror) {
                    btnUpDownMirror.style = UIBarButtonItemStyleBordered;
                    
                    if (m_bLeftRightMirror) {
                        value = 2;
                    }else {
                        value = 0;
                    }
                }else {
                    btnUpDownMirror.style = UIBarButtonItemStyleDone;
                    if (m_bLeftRightMirror) {
                        value = 3;
                    }else {
                        value = 1;
                    }
                }
                
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
                
                m_bUpDownMirror = !m_bUpDownMirror;
            }
                break;
            case 23:
            {
                int value;
                
                if (m_bLeftRightMirror) {
                    btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
                    
                    if (m_bUpDownMirror) {
                        value = 1;
                    }else {
                        value = 0;
                    }
                }else {
                    
                    btnLeftRightMirror.style = UIBarButtonItemStyleDone;
                    
                    if (m_bUpDownMirror) {
                        value = 3;
                    }else {
                        value = 2;
                    }
                }
                
                m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
                
                m_bLeftRightMirror = !m_bLeftRightMirror;
            }
                break;
            default:
                break;
        }
    }
    [sender hide];
}

- (void) popupListcompoentDidCancel:(PopupListComponent *)sender{
    if (_resolutionPopup != nil) {
        [_resolutionPopup release];
    }
    _resolutionPopup = nil;
    NSLog(@"popupList  component did cancel");
}

/*- (IBAction) btnSwitchDisplayMode:(id)sender
 {
 switch (m_nDisplayMode) {
 case 0:
 m_nDisplayMode = 1;
 break;
 case 1:
 m_nDisplayMode = 2;
 break;
 case 2:
 m_nDisplayMode = 0;
 break;
 default:
 m_nDisplayMode = 0;
 break;
 }
 NSLog(@"m_nDisplayMode  %d",m_nDisplayMode);
 [self setDisplayMode];
 }*/

- (IBAction)rotationView:(id)sender{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    /*CGRect frame = [UIScreen mainScreen].applicationFrame;
     self.view.center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
     if (orientation == UIInterfaceOrientationLandscapeLeft) {
     self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5);
     } else if (orientation == UIInterfaceOrientationLandscapeRight) {
     self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
     } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
     self.view.transform = CGAffineTransformMakeRotation(-M_PI);
     } else {
     self.view.transform = CGAffineTransformIdentity;
     }
     [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
     CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:duration];
     
     //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
     
     [UIView commitAnimations];
     orientation = [UIApplication sharedApplication].statusBarOrientation;
     [self shouldAutorotateToInterfaceOrientation:orientation];*/
    
    if (UIInterfaceOrientationPortrait == orientation || UIInterfaceOrientationPortraitUpsideDown == orientation) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                           withObject:(id)UIInterfaceOrientationLandscapeRight];
        }
        
    }else{
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                           withObject:(id)UIInterfaceOrientationPortrait];
        }
        
    }
    
}


- (void) image: (UIImage*)image didFinishSavingWithError: (NSError*) error contextInfo: (void*)contextInfo
{
    //NSLog(@"save result");
    
    if (error != nil) {
        //show error message
        NSLog(@"take picture failed");
    }else {
        //show message image successfully saved
        //NSLog(@"save success");
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
                            superView:self.view
                            bLandScap:YES];
        }else{
            [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
                            superView:self.view
                            bLandScap:NO];
        }
        
    }
    
}

- (IBAction) btnSnapshot:(id)sender
{
    UIImage *image = nil;
    if(m_videoFormat != 0 && m_videoFormat != 2) //MJPEG && H264
    {
        return;
    }
    
    if (m_videoFormat == 0) {//MJPEG
        if (imageSnapshot == nil || m_pPicPathMgt == nil) {
            return;
        }
        
        image = imageSnapshot;
    }else{//H264
        [m_YUVDataLock lock];
        if (m_YUVDataLock == NULL) {
            [m_YUVDataLock unlock];
            return;
        }
        
        //yuv->image
        image = [APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight];
        
        [m_YUVDataLock unlock];
        //        self.m_pPPPPChannelMgt->RefreshSnapshot([self.strDID UTF8String]);
        //        image = _snapShotImage;
    }
    
    
    //------save image--------
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [formatter stringFromDate:date];
    
    NSString* camuid = [NSString stringWithString:strDID];
    
    if ([camuid length] != 15) {
        NSArray* strarr = [strDID componentsSeparatedByString:@"-"];
        camuid = [strarr componentsJoinedByString:@""];
        if ([camuid length] < 15){
            camuid = [NSString stringWithFormat:@"%@ppppppppppppppp",camuid];
        }
        
        if ([camuid length] > 15) {
            camuid = [camuid substringToIndex:15];
        }
    }
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@_%@.jpg",camuid, self.currentAcc, strDateTime];
    
    
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    //NSLog(@"strPath: %@", strPath);
    
    //NSData *dataImage = UIImageJPEGRepresentation(imageSnapshot, 1.0);
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    if([dataImage writeToFile:strPath atomically:YES ])
    {
        [m_pPicPathMgt InsertPicPath:strDID PicDate:strDate PicPath:strFileName];
    }
    
    [pool release];
    
    [formatter release];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    //        [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
    //                        superView:self.view
    //                        bLandScap:YES];
    //
    //    }else{
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
    }else{
        [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:NO];
    }
    //}
    
    [PicNotifyDelegate NotifyReloadData];
    
}

- (void) showOSD
{
    [OSDLabel setHidden:NO];
    if (bPlaying == YES) {
        [TimeStampLabel setHidden:NO];
    }
}

- (void) showPtzImage: (BOOL) bShow
{
    [imageUp setHidden:!bShow];
    [imageDown setHidden:!bShow];
    [imageLeft setHidden:!bShow];
    [imageRight setHidden:!bShow];
}

- (void) animationStop
{
    //NSLog(@"animation stop");
    if (!m_bToolBarShow) {
        [self showOSD];
        
        //[self showPtzImage:m_bToolBarShow];
    }
}

- (void) ShowToolBar: (BOOL) bShow
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        //开始动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationStop)];
        
        //设定动画持续时间
        [UIView setAnimationDuration:0.4];
    }
    //动画的内容
    CGRect frame = toolBarTop.frame;
    
    if (bShow == YES) {
        frame.origin.y += frame.size.height;
    }else {
        frame.origin.y -= frame.size.height;
    }
    [toolBarTop setFrame:frame];
    
    CGRect frame2 = playToolBar.frame;
    
    
    
    CGRect frame3 = timeoutLabel.frame;
    
    NSLog(@"timeoutLabel x %f  y %f",frame3.origin.x,frame3.origin.y);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if (bShow == YES) {
            frame3.origin.y += frame2.size.height;
        }else {
            frame3.origin.y -= frame2.size.height;
        }
        [timeoutLabel setFrame:frame3];
    }
    
    
    
    NSLog(@"frame3.x %f , y  %f",timeoutLabel.frame.origin.x,timeoutLabel.frame.origin.y);
    //[self.view addSubview:timeoutLabel];
    if (bShow == YES) {
        frame2.origin.y -= frame2.size.height;
    }else {
        frame2.origin.y += frame2.size.height;
    }
    [playToolBar setFrame:frame2];
    
    
    //动画结束
    [UIView commitAnimations];
}

//停止播放，并返回到设备列表界面
- (void) StopPlay:(int)bForce
{
    [[NSUserDefaults standardUserDefaults] setBool:m_bTalkStarted forKey:[NSString stringWithFormat:@"%@_%@_%@",self.currentAcc,strDID,TalkMark]];
    
    [[NSUserDefaults standardUserDefaults] setBool:m_bAudioStarted forKey:[NSString stringWithFormat:@"%@_%@_%@",self.currentAcc,strDID,AudioMark]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"StopPlay....");
    if ([self->timeStampTimer isValid]) {
        [self->timeStampTimer invalidate];
        self->timeStampTimer = nil;
    }
    if (m_pPPPPChannelMgt != NULL) {
        m_pPPPPChannelMgt->StopPPPPLivestream([strDID UTF8String]);
        m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
        m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
    }
    
    if (timeoutTimer != nil) {
        [timeoutTimer invalidate];
        timeoutTimer = nil;
    }
    
    [self stopRecord];
    
    
    IpCameraClientAppDelegate *IPCAMDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.b_split == YES && bForce == 0) {
        btnStop.enabled = NO;
        Split_screenViewController* splitvc = [[Split_screenViewController alloc] init];
        [IPCAMDelegate switchSpliteScreen:splitvc];
        [splitvc release];
    }else{
        [IPCAMDelegate switchBack];
    }
    
    
    if (bForce != 1 && bManualStop == NO) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }else if (bForce == 1){
        [mytoast showWithText:NSLocalizedStringFromTable(@"RelayModeEnd",@STR_LOCALIZED_FILE_NAME, nil)];
    }
    
}

- (void) hideProgress:(id)param
{
    [self.progressView setHidden:YES];
    [self.LblProgress setHidden:YES];
    OSDLabel.hidden = NO;
    TimeStampLabel.hidden = NO;
    if (NO == [OSDLabel isHidden]) {
        [TimeStampLabel setHidden:NO];
    }
    
    //关闭转发180s限制
    if (m_nP2PMode == PPPP_MODE_RELAY  ) {
        //timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        //[timeoutLabel  setHidden:NO];
        //NSLog(@"m_nP2PMode  %d",m_nP2PMode);
        
    }
    
    [self getCameraParams];
}

- (void)enableButton
{
    [self.btnRecord setEnabled:YES];
    [self.btnSnapshot setEnabled:YES];
}


//handler the start timer
- (void)handleTimer:(NSTimer *)timer
{
    //NSLog(@"handleTimer");
    if(m_nTimeoutSec <= 0){
        //[timeoutTimer invalidate];
        //[self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
        [self StopPlay:1];
        return;
    }
    
    //[self performSelectorOnMainThread:@selector(updateTimeout:) withObject:nil waitUntilDone:NO];
    m_nTimeoutSec = m_nTimeoutSec - 1;
    NSString *strTimeout = [NSString stringWithFormat:@"%@ %d %@", NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),m_nTimeoutSec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
    timeoutLabel.text = strTimeout;
    
    
    //timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) //userInfo:nil repeats:NO];
    
}

- (void) updateTimeout:(id)data{
    NSString *strTimeout = [NSString stringWithFormat:@"%@ %d %@", NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),m_nTimeoutSec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
    timeoutLabel.text = strTimeout;
    m_nTimeoutSec = m_nTimeoutSec - 1;
    //NSLog(@"m_nTimeoutSec: %d", m_nTimeoutSec);
}

- (void) updateImage:(id)data
{
    //NSLog(@"updateImage");
    UIImage *img = (UIImage*)data;
    
    self.imageSnapshot = img;
    if (tableCtr != nil &&  tableCtr.butonTap ) {
        if (tableCtr.img != nil) {
            [tableCtr.img release];
            tableCtr.img = nil;
        }
        tableCtr.img = [self.imageSnapshot retain];
    }
    
    
    
    imgView.image = img;
    [img release];
    
    //show timestamp
    //[self updateTimestamp];
    
}

- (void) updateTimestamp
{
    //show timestamp
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str = [formatter stringFromDate:date];
    TimeStampLabel.text = str;
    [formatter release];
}

- (void) getCameraParams
{    NSLog(@"getCameraPar");
    m_pPPPPChannelMgt->GetCGI([strDID UTF8String], CGI_IEGET_CAM_PARAMS);
}

- (void) updateVideoResolution
{
    //NSLog(@"updateVideoResolution nResolution: %d", nResolution);
    switch (nResolution) {
        case 0:
            //btnItemResolution.title = @"640*480";
            btnItemResolution.image = imgVGA;
            break;
        case 1:
            //btnItemResolution.title = @"320*240";
            btnItemResolution.image = imgQVGA;
            break;
        case 2:
            //btnItemResolution.title = @"160*120";
            break;
        case 3:
            //btnItemResolution.title = @"1280*720";
            btnItemResolution.image = img720P;
            break;
        case 4:
            //btnItemResolution.title = @"640*360";
            break;
        case 5:
            //btnItemResolution.title = @"1280*960";
            break;
        default:
            break;
    }
}

- (void) UpdateVieoDisplay
{
    [self updateVideoResolution];
    
    //NSLog(@"m_nFlip: %d", m_nFlip);
    
    switch (m_nFlip) {
        case 0: // normal
            m_bUpDownMirror = NO;
            m_bLeftRightMirror = NO;
            btnUpDownMirror.style = UIBarButtonItemStyleBordered;
            btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
            break;
        case 1: //up down mirror
            m_bUpDownMirror = YES;
            m_bLeftRightMirror = NO;
            btnUpDownMirror.style = UIBarButtonItemStyleDone;
            btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
            break;
        case 2: // left right mirror
            m_bUpDownMirror = NO;
            m_bLeftRightMirror = YES;
            btnUpDownMirror.style = UIBarButtonItemStyleBordered;
            btnLeftRightMirror.style = UIBarButtonItemStyleDone;
            break;
        case 3: //all mirror
            m_bUpDownMirror = YES;
            m_bLeftRightMirror = YES;
            btnUpDownMirror.style = UIBarButtonItemStyleDone;
            btnLeftRightMirror.style = UIBarButtonItemStyleDone;
            break;
        default:
            break;
    }
    
    sliderContrast.value = m_Contrast;
    sliderBrightness.value = m_Brightness;
}


- (void) ptzImageTouched: (UITapGestureRecognizer*)sender
{
    UIImageView *imageView = (UIImageView*)[sender view];
    
    // NSLog(@"ptzImageTouched... tag: %d", imageView.tag);
    int command = 0;
    switch (imageView.tag) {
        case 0: //up
            command = CMD_PTZ_UP;
            /*self.imageUp.hidden = NO;
             self.imageUp.alpha = 1.f;
             [UIView animateWithDuration:0.5f animations:^{
             self.imageUp.alpha = 0.2f;
             } completion:^(BOOL finsh){
             self.imageUp.hidden = YES;
             }];*/
            break;
        case 1: //down
            command = CMD_PTZ_DOWN;
            /*self.imageDown.hidden = NO;
             self.imageUp.alpha = 1.f;
             [UIView animateWithDuration:0.5f animations:^{
             self.imageDown.alpha = 0.2f;
             } completion:^(BOOL finsh){
             self.imageDown.hidden = YES;
             }];*/
            break;
        case 2: //left
            command = CMD_PTZ_LEFT;
            /*self.imageLeft.hidden = NO;
             self.imageUp.alpha = 1.f;
             [UIView animateWithDuration:0.5f animations:^{
             self.imageLeft.alpha = 0.2f;
             } completion:^(BOOL finsh){
             self.imageLeft.hidden = YES;
             }];*/
            break;
        case 3: //right
            command = CMD_PTZ_RIGHT;
            /*self.imageRight.hidden = NO;
             self.imageUp.alpha = 1.f;
             [UIView animateWithDuration:0.5f animations:^{
             self.imageRight.alpha = 0.2f;
             } completion:^(BOOL finsh){
             self.imageRight.hidden = YES;
             }];*/
            break;
            
        default:
            return;
    }
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
}

- (void) playViewTouch: (id) param
{
    //NSLog(@"touch....");
    m_bToolBarShow = !m_bToolBarShow;
    [self ShowToolBar:m_bToolBarShow];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect osdFrame = OSDLabel.frame;
    CGRect timestamp = TimeStampLabel.frame;
    if (m_bToolBarShow) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            timestamp.origin = CGPointMake(TimeStampLabel.frame.origin.x, TimeStampLabel.frame.origin.y - toolBarTop.frame.size.height);
            TimeStampLabel.frame = timestamp;
            
            osdFrame.origin = CGPointMake(5, self.subDisplayScrollView.frame.origin.y + toolBarTop.frame.size.height );
            OSDLabel.frame = osdFrame;
            
            self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.toolBarTop.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        }
        
        
        
        
        //[OSDLabel setHidden:YES];
        //[TimeStampLabel setHidden:YES];
        //[self showPtzImage:YES];
    }else {
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
            timestamp.origin = CGPointMake(TimeStampLabel.frame.origin.x, TimeStampLabel.frame.origin.y + toolBarTop.frame.size.height );
            TimeStampLabel.frame = timestamp;
            
            osdFrame.origin = CGPointMake(5,self.subDisplayScrollView.frame.origin.y );
            
            OSDLabel.frame = osdFrame;
            
            self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        }
        
        
        //[OSDLabel setHidden:NO];
        //[TimeStampLabel setHidden:NO];
        m_bContrastShow = NO;
        m_bBrightnessShow = NO;
        [self showBrightnessSlider:NO];
        [self showContrastSlider:NO];
        
    }
    [_menuToolBar dismissToolBar];
    //    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
    //        CGRect cameraFrame = _cameramarkimgView.frame;
    //        cameraFrame.origin = CGPointMake(imgView.frame.size.width - 50.0f, TimeStampLabel.frame.origin.y + TimeStampLabel.frame.size.height + 5.f);
    //        _cameramarkimgView.frame = cameraFrame;
    //    }
}

#pragma mark -
#pragma mark TouchEvent
- (void)PlayViewtouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    beginPoint = [[touches anyObject] locationInView:self.disPlayScrollView];
}

- (void)PlayViewtouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesMoved");
}

- (void)PlayViewtouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    if (bPlaying == NO)
    {
        return;
    }
    
    CGPoint currPoint = [[touches anyObject] locationInView:self.disPlayScrollView];
    const int EVENT_PTZ = 1;
    int curr_event = EVENT_PTZ;
    
    int x1 = beginPoint.x;
    int y1 = beginPoint.y;
    int x2 = currPoint.x;
    int y2 = currPoint.y;
    
    int view_width = self.disPlayScrollView.frame.size.width;
    int _width1 = 0;
    int _width2 = view_width  ;
    
    if(x1 >= _width1 && x1 <= _width2)
    {
        curr_event = EVENT_PTZ;
    }
    else
    {
        return;
    }
    
    const int MIN_X_LEN = 60;
    const int MIN_Y_LEN = 60;
    
    int len = (x1 > x2) ? (x1 - x2) : (x2 - x1) ;
    BOOL b_x_ok = (len >= MIN_X_LEN ) ? YES : NO ;
    len = (y1 > y2) ? (y1 - y2) : (y2 - y1) ;
    BOOL b_y_ok = (len > MIN_Y_LEN) ? YES : NO;
    
    BOOL bUp = NO;
    BOOL bDown = NO;
    BOOL bLeft = NO;
    BOOL bRight = NO;
    
    bDown = (y1 > y2) ? NO : YES;
    bUp = !bDown;
    bRight = (x1 > x2) ? NO : YES;
    bLeft = !bRight;
    
    int command = 0;
    
    switch (curr_event)
    {
        case EVENT_PTZ:
        {
            
            if (b_x_ok == YES)
            {
                if (bLeft == NO)
                {
                    NSLog(@"left");
                    command = CMD_PTZ_LEFT;
                    //command = CMD_PTZ_RIGHT;
                    if (self.imageLeft.hidden && !_is_animationLeft) {
                        self.imageLeft.hidden = NO;
                        _is_animationLeft = YES;
                        [UIView animateWithDuration:0.2f animations:^{
                            self.imageLeft.alpha = 0.2f;
                        } completion:^(BOOL finsh){
                            self.imageLeft.alpha = 1.f;
                            self.imageLeft.hidden = YES;
                            _is_animationLeft = NO;
                        }];
                    }
                    
                }
                else
                {
                    NSLog(@"right");
                    command = CMD_PTZ_RIGHT;
                    //command = CMD_PTZ_LEFT;
                    if (self.imageRight.hidden && !_is_animationRight) {
                        self.imageRight.hidden = NO;
                        _is_animationRight = YES;
                        [UIView animateWithDuration:0.2f animations:^{
                            self.imageRight.alpha = 0.2f;
                        } completion:^(BOOL finsh){
                            self.imageRight.alpha = 1.f;
                            self.imageRight.hidden = YES;
                            _is_animationRight = NO;
                        }];
                    }
                }
                
                m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
                m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command + 1);
                
            }
            
            if (b_y_ok == YES)
            {
                
                if (bUp == NO)
                {
                    NSLog(@"up");
                    command = CMD_PTZ_UP;
                    //command = CMD_PTZ_DOWN;
                    if (self.imageUp.hidden && !_is_animationUp) {
                        self.imageUp.hidden = NO;
                        _is_animationUp = YES;
                        [UIView animateWithDuration:0.2f animations:^{
                            self.imageUp.alpha = 0.2f;
                        } completion:^(BOOL finsh){
                            self.imageUp.alpha = 1.f;
                            self.imageUp.hidden = YES;
                            _is_animationUp = NO;
                        }];
                    }
                }
                else
                {
                    NSLog(@"down");
                    command = CMD_PTZ_DOWN;
                    //command = CMD_PTZ_UP;
                    if (self.imageDown.hidden && !_is_animationDown) {
                        self.imageDown.hidden = NO;
                        _is_animationDown = YES;
                        [UIView animateWithDuration:0.2f animations:^{
                            self.imageDown.alpha = 0.2f;
                        } completion:^(BOOL finsh){
                            self.imageDown.alpha = 1.f;
                            self.imageDown.hidden = YES;
                            _is_animationDown = NO;
                        }];
                    }
                }
                
                m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
                m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command + 1);
            }
        }
            break;
            
        default:
            return ;
    }
    
}

- (void)PlayViewtouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}


#pragma  mark PreSet

- (IBAction) Preset:(id)sender{
    
    /*resetimage = nil;
     if (resetimage != nil) {
     [resetimage release];
     resetimage = nil;
     }
     
     if(m_videoFormat != 0 && m_videoFormat != 2) //MJPEG && H264
     {
     return;
     }
     
     if (m_videoFormat == 0) {//MJPEG
     if (imageSnapshot == nil || m_pPicPathMgt == nil) {
     return;
     }
     
     resetimage = [imageSnapshot retain];
     }else{//H264
     [m_YUVDataLock lock];
     if (m_YUVDataLock == NULL) {
     [m_YUVDataLock unlock];
     return;
     }
     
     //yuv->image
     // resetimage = [[APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight] retain];
     
     [m_YUVDataLock unlock];
     }
     */
    if (bPlaying == NO) {
        return;
    }
    tableCtr = [[DemoTableController alloc] initWithStyle:UITableViewStylePlain];
    tableCtr.cppppchannelMgt = self.m_pPPPPChannelMgt;
    tableCtr.strDID = self.strDID;
    
    fppoverCtr =[[FPPopoverController alloc] initWithViewController:tableCtr];
    tableCtr.fppopoverCtr = fppoverCtr;
    fppoverCtr.delegate = self;
    [tableCtr release];
    fppoverCtr.tint  =FPPopoverDefaultTint;
    /* if (tableCtr.img != nil) {
     [tableCtr.img release];
     tableCtr.img = nil;
     }
     tableCtr.img = resetimage;*/
    fppoverCtr.arrowDirection = FPPopoverArrowDirectionAny;
    
    
    UIInterfaceOrientation interorientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if (interorientation == UIInterfaceOrientationLandscapeLeft || interorientation == UIInterfaceOrientationLandscapeRight) {
        fppoverCtr.contentSize = CGSizeMake(210, 290);
    }else{
        fppoverCtr.contentSize = CGSizeMake(210, 290);
    }
    //    }else{
    //        fppoverCtr.contentSize = CGSizeMake(234, 495);
    //    }
    
    //[fppoverCtr presentPopoverFromView:self.resetButton];
    [fppoverCtr presentPopoverFromView:self.resetButton];
    //[tableCtr release];
    //[fppoverCtr release];
}

#pragma mark FPPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController{
    if (popoverController != nil) {
        [popoverController release];
    }
    
    
    popoverController = nil;
    //tableCtr = nil;
}
#pragma mark -
#pragma mark system
- (BOOL)shouldAutorotate{
    NSLog(@"iphone   orientation");
    // Return YES for supported orientations.
    self.subDisplayScrollView.zoomScale = 1.0f;
    if (_resolutionPopup) {
        [_resolutionPopup hide];
    }
    
    UIInterfaceOrientation  interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat sliderBrightx;
    CGFloat progressY;
    CGFloat progressX;
    CGSize screen = [UIScreen mainScreen].bounds.size;
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        sliderBrightx = winsize.size.width;
        progressX = screen.width;
        progressY = screen.height;
        // NSLog(@"winsize   height  %f",winsize.size.height);
    }else{
        sliderBrightx = [[UIScreen mainScreen] bounds].size.height;
        progressX = screen.height;
        progressY = screen.width;
        // NSLog(@"sliderBridhtx %f",sliderBrightx);
    }
    
    CGRect progressViewFrame = self.progressView.frame;
    progressViewFrame.origin = CGPointMake(progressX/2, progressY/2);
    self.progressView.frame = progressViewFrame;
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    //        return YES;//(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //    }else{
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.subDisplayScrollView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        self.subDisplayScrollView.contentSize = CGSizeMake(m_nScreenWidth, m_nScreenHeight);
        imgView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        imageBg.frame = imgView.frame;
        self.disPlayScrollView.frame = imgView.frame;
        // NSLog(@"imageBg.frame  %@",NSStringFromCGRect(imageBg.frame));
        myGLViewController.view.frame = imgView.frame;
        if (fppoverCtr != nil) {
            fppoverCtr.contentSize = CGSizeMake(210, 290);
        }
        
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        if (m_bToolBarShow) {
            [toolBarTop setFrame:CGRectMake(0, 0, m_nScreenWidth, toolBarTop.frame.size.height)];
            [timeoutLabel setFrame: CGRectMake(self.subDisplayScrollView.frame.size.width - timeoutLabel.frame.size.width, self.subDisplayScrollView.frame.origin.y + toolBarTop.frame.size.height, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];//CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, winsize.size.width - timeoutLabel.frame.size.height - toolBarTop.frame.size.height, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
            [TimeStampLabel setFrame:CGRectMake(self.subDisplayScrollView.frame.size.width - labelsize.width , self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - toolBarTop.frame.size.height - labelsize.height, labelsize.width, labelsize.height)];
            
            [OSDLabel setFrame:CGRectMake(OSDLabel.frame.origin.x, self.subDisplayScrollView.frame.origin.y + toolBarTop.frame.size.height, OSDLabel.frame.size.width, OSDLabel.frame.size.height)];
            
            self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.toolBarTop.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        }else{
            [toolBarTop setFrame:CGRectMake(0, -toolBarTop.frame.size.height, m_nScreenWidth, toolBarTop.frame.size.height)];
            [timeoutLabel setFrame: CGRectMake(self.subDisplayScrollView.frame.size.width - timeoutLabel.frame.size.width, self.subDisplayScrollView.frame.origin.y, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];//CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, winsize.size.width - timeoutLabel.frame.size.height , timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
            [TimeStampLabel setFrame:CGRectMake(self.subDisplayScrollView.frame.size.width - labelsize.width , self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - labelsize.height, labelsize.width, labelsize.height)];
            
            [OSDLabel setFrame:CGRectMake(OSDLabel.frame.origin.x, self.subDisplayScrollView.frame.origin.y, OSDLabel.frame.size.width, OSDLabel.frame.size.height)];
            
            self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        }
        //[TimeStampLabel setFrame: CGRectMake(sliderBrightx - 10 - labelsize.width, TimeStampLabel.frame.origin.y, labelsize.width, labelsize.height)];
        
        //        CGRect cameraFrame = _cameramarkimgView.frame;
        //        cameraFrame.origin = CGPointMake(imgView.frame.size.width - 50.0f, TimeStampLabel.frame.origin.y + TimeStampLabel.frame.size.height + 5.f);
        //        _cameramarkimgView.frame = cameraFrame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [labelContrast setFrame:CGRectMake(20, 210, 60, 320)];
            [sliderContrast setFrame:CGRectMake(20, 210, 60, 320)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 100, 210, 60, 320)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx- 100, 210, 60, 320)];
        }else{
            [labelContrast setFrame:CGRectMake(20, 80 , 60, 160)];
            [sliderContrast setFrame:CGRectMake(20, 80, 60, 160)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 80, 80, 60, 160)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx - 80, 80, 60, 160)];
        }
    }else{
        
        if (fppoverCtr != nil) {
            fppoverCtr.contentSize = CGSizeMake(210, 290);
        }
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        imageBg.frame = [[UIScreen mainScreen] bounds];
        self.disPlayScrollView.frame = [UIScreen mainScreen].bounds;
        //imgView.frame = CGRectMake(0, 256, 768, 546);
        self.subDisplayScrollView.frame = CGRectMake(0, m_nScreenWidth/2-m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4/2, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        self.subDisplayScrollView.contentSize = CGSizeMake(m_nScreenHeight, m_nScreenHeight*3/4);
        NSLog(@"self.subDisplayScrollView.contentSize  %@",NSStringFromCGSize(self.subDisplayScrollView.contentSize));
        imgView.frame = CGRectMake(0, 0, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        myGLViewController.view.frame = imgView.frame;
        // NSLog(@"imgView.frame  %d  %d   %d",m_nScreenWidth/2-m_nScreenHeight*m_nScreenHeight/m_nScreenWidth/2,m_nScreenHeight,m_nScreenHeight*m_nScreenHeight/m_nScreenWidth);
        //        CGRect cameraFrame = _cameramarkimgView.frame;
        //        cameraFrame.origin = CGPointMake(imgView.frame.size.width - 50.0f, imgView.frame.origin.y);
        //        _cameramarkimgView.frame = cameraFrame;
        self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        
        if (m_bToolBarShow) {
            [toolBarTop setFrame:CGRectMake(0, 0, m_nScreenHeight, toolBarTop.frame.size.height)];
            //            [timeoutLabel setFrame:CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, [[UIScreen mainScreen] bounds].size.height - timeoutLabel.frame.size.height - toolBarTop.frame.size.height, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
        }else{
            
            [toolBarTop setFrame:CGRectMake(0, -toolBarTop.frame.size.height, m_nScreenHeight, toolBarTop.frame.size.height)];
            //            [timeoutLabel setFrame:CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, [[UIScreen mainScreen] bounds].size.height - timeoutLabel.frame.size.height , timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
        }
        // NSLog(@"timelabel %@",NSStringFromCGRect(timeoutLabel.frame));
        [timeoutLabel setFrame:CGRectMake(self.subDisplayScrollView.frame.size.width - timeoutLabel.frame.size.width, self.subDisplayScrollView.frame.origin.y , timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
        [OSDLabel setFrame:CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y, OSDLabel.frame.size.width, OSDLabel.frame.size.height)];
        [TimeStampLabel setFrame: CGRectMake(self.subDisplayScrollView.frame.size.width - labelsize.width , self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - labelsize.height, labelsize.width, labelsize.height)];//CGRectMake(sliderBrightx - 10 - labelsize.width, TimeStampLabel.frame.origin.y, labelsize.width, labelsize.height)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [labelContrast setFrame:CGRectMake(20, 280, 60, 320)];
            [sliderContrast setFrame:CGRectMake(20, 280, 60, 320)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 100, 280, 60, 320)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx - 100, 280, 60, 320)];
        }else{
            [labelContrast setFrame:CGRectMake(20, 141, 60, 200)];
            [sliderContrast setFrame:CGRectMake(20, 141, 60, 200)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 100, 141, 60, 200)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx - 100, 141, 60, 200)];
        }
    }
    return YES;
    // }
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    self.subDisplayScrollView.zoomScale = 1.f;
    if (_resolutionPopup) {
        [_resolutionPopup hide];
    }
    
    
    CGFloat sliderBrightx;
    CGFloat progressY;
    CGFloat progressX;
    CGSize screen = [UIScreen mainScreen].bounds.size;
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        sliderBrightx = winsize.size.width;
        progressX = screen.width;
        progressY = screen.height;
        // NSLog(@"winsize   height  %f",winsize.size.height);
    }else{
        sliderBrightx = [[UIScreen mainScreen] bounds].size.height;
        progressX = screen.height;
        progressY = screen.width;
        // NSLog(@"sliderBridhtx %f",sliderBrightx);
    }
    
    CGRect progressViewFrame = self.progressView.frame;
    progressViewFrame.origin = CGPointMake(progressX/2, progressY/2);
    self.progressView.frame = progressViewFrame;
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    //        return YES;//(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //    }else{
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.subDisplayScrollView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        self.subDisplayScrollView.contentSize = CGSizeMake(m_nScreenWidth, m_nScreenHeight);
        imgView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        imageBg.frame = imgView.frame;
        self.disPlayScrollView.frame = imgView.frame;
        // NSLog(@"imageBg.frame  %@",NSStringFromCGRect(imageBg.frame));
        myGLViewController.view.frame = imgView.frame;
        if (fppoverCtr != nil) {
            fppoverCtr.contentSize = CGSizeMake(210, 290);
        }
        
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        if (m_bToolBarShow) {
            [toolBarTop setFrame:CGRectMake(0, 0, m_nScreenWidth, toolBarTop.frame.size.height)];
            [timeoutLabel setFrame: CGRectMake(self.imgView.frame.size.width - timeoutLabel.frame.size.width, self.imgView.frame.origin.y + toolBarTop.frame.size.height, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];//CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, winsize.size.width - timeoutLabel.frame.size.height - toolBarTop.frame.size.height, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
            [TimeStampLabel setFrame:CGRectMake(self.imgView.frame.size.width - labelsize.width , self.imgView.frame.origin.y + self.imgView.frame.size.height - toolBarTop.frame.size.height - labelsize.height, labelsize.width, labelsize.height)];
            
            [OSDLabel setFrame:CGRectMake(OSDLabel.frame.origin.x, self.imgView.frame.origin.y + toolBarTop.frame.size.height, OSDLabel.frame.size.width, OSDLabel.frame.size.height)];
            
            self.cameramarkimgView.frame = CGRectMake(5.f, self.imgView.frame.origin.y + self.imgView.frame.size.height - self.toolBarTop.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        }else{
            [toolBarTop setFrame:CGRectMake(0, -toolBarTop.frame.size.height, m_nScreenWidth, toolBarTop.frame.size.height)];
            [timeoutLabel setFrame: CGRectMake(self.imgView.frame.size.width - timeoutLabel.frame.size.width, self.imgView.frame.origin.y, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];//CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, winsize.size.width - timeoutLabel.frame.size.height , timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
            [TimeStampLabel setFrame:CGRectMake(self.imgView.frame.size.width - labelsize.width , self.imgView.frame.origin.y + self.imgView.frame.size.height - labelsize.height, labelsize.width, labelsize.height)];
            
            [OSDLabel setFrame:CGRectMake(OSDLabel.frame.origin.x, self.imgView.frame.origin.y, OSDLabel.frame.size.width, OSDLabel.frame.size.height)];
            
            self.cameramarkimgView.frame = CGRectMake(5.f, self.imgView.frame.origin.y + self.imgView.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        }
        //[TimeStampLabel setFrame: CGRectMake(sliderBrightx - 10 - labelsize.width, TimeStampLabel.frame.origin.y, labelsize.width, labelsize.height)];
        
        //        CGRect cameraFrame = _cameramarkimgView.frame;
        //        cameraFrame.origin = CGPointMake(imgView.frame.size.width - 50.0f, TimeStampLabel.frame.origin.y + TimeStampLabel.frame.size.height + 5.f);
        //        _cameramarkimgView.frame = cameraFrame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [labelContrast setFrame:CGRectMake(20, 210, 60, 320)];
            [sliderContrast setFrame:CGRectMake(20, 210, 60, 320)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 100, 210, 60, 320)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx- 100, 210, 60, 320)];
        }else{
            [labelContrast setFrame:CGRectMake(20, 80 , 60, 160)];
            [sliderContrast setFrame:CGRectMake(20, 80, 60, 160)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 80, 80, 60, 160)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx - 80, 80, 60, 160)];
        }
        
        
        
        
    }else{
        
        if (fppoverCtr != nil) {
            fppoverCtr.contentSize = CGSizeMake(210, 290);
        }
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        imageBg.frame = [[UIScreen mainScreen] bounds];
        self.disPlayScrollView.frame = [UIScreen mainScreen].bounds;
        //imgView.frame = CGRectMake(0, 256, 768, 546);
        self.subDisplayScrollView.frame = CGRectMake(0, m_nScreenWidth/2-m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4/2, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        self.subDisplayScrollView.contentSize = CGSizeMake(m_nScreenHeight, m_nScreenHeight*3/4);
        imgView.frame = CGRectMake(0, 0, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        myGLViewController.view.frame = imgView.frame;
        // NSLog(@"imgView.frame  %d  %d   %d",m_nScreenWidth/2-m_nScreenHeight*m_nScreenHeight/m_nScreenWidth/2,m_nScreenHeight,m_nScreenHeight*m_nScreenHeight/m_nScreenWidth);
        //        CGRect cameraFrame = _cameramarkimgView.frame;
        //        cameraFrame.origin = CGPointMake(imgView.frame.size.width - 50.0f, imgView.frame.origin.y);
        //        _cameramarkimgView.frame = cameraFrame;
        self.cameramarkimgView.frame = CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - self.cameramarkimgView.frame.size.height - 5.f, self.cameramarkimgView.frame.size.width, self.cameramarkimgView.frame.size.height);
        
        if (m_bToolBarShow) {
            [toolBarTop setFrame:CGRectMake(0, 0, m_nScreenHeight, toolBarTop.frame.size.height)];
            //            [timeoutLabel setFrame:CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, [[UIScreen mainScreen] bounds].size.height - timeoutLabel.frame.size.height - toolBarTop.frame.size.height, timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
        }else{
            
            [toolBarTop setFrame:CGRectMake(0, -toolBarTop.frame.size.height, m_nScreenHeight, toolBarTop.frame.size.height)];
            //            [timeoutLabel setFrame:CGRectMake(sliderBrightx - timeoutLabel.frame.size.width, [[UIScreen mainScreen] bounds].size.height - timeoutLabel.frame.size.height , timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
        }
        // NSLog(@"timelabel %@",NSStringFromCGRect(timeoutLabel.frame));
        [timeoutLabel setFrame:CGRectMake(self.subDisplayScrollView.frame.size.width - timeoutLabel.frame.size.width, self.subDisplayScrollView.frame.origin.y , timeoutLabel.frame.size.width, timeoutLabel.frame.size.height)];
        [OSDLabel setFrame:CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y, OSDLabel.frame.size.width, OSDLabel.frame.size.height)];
        [TimeStampLabel setFrame: CGRectMake(self.subDisplayScrollView.frame.size.width - labelsize.width , self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - labelsize.height, labelsize.width, labelsize.height)];//CGRectMake(sliderBrightx - 10 - labelsize.width, TimeStampLabel.frame.origin.y, labelsize.width, labelsize.height)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [labelContrast setFrame:CGRectMake(20, 280, 60, 320)];
            [sliderContrast setFrame:CGRectMake(20, 280, 60, 320)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 100, 280, 60, 320)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx - 100, 280, 60, 320)];
        }else{
            [labelContrast setFrame:CGRectMake(20, 141, 60, 200)];
            [sliderContrast setFrame:CGRectMake(20, 141, 60, 200)];
            
            [labelBrightness setFrame:CGRectMake(sliderBrightx - 100, 141, 60, 200)];
            [sliderBrightness setFrame:CGRectMake(sliderBrightx - 100, 141, 60, 200)];
        }
    }
    return YES;
    // }
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) updateContrast: (id) sender
{
    float f = sliderContrast.value;
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 2, f);
}

- (void) updateBrightness: (id) sender
{
    float f = sliderBrightness.value;
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 1, f);
}

/*- (void) setDisplayModeImage
 {
 switch (m_nDisplayMode) {
 case 0: //normal
 btnSwitchDisplayMode.image = imgEnlarge;
 break;
 case 1: //enlarge
 btnSwitchDisplayMode.image = imgFullScreen;
 break;
 case 2: //full screen
 btnSwitchDisplayMode.image = imgNormal;
 break;
 
 default:
 break;
 }
 }*/

- (void) setDisplayMode
{
    if (m_nVideoWidth == 0 || m_nVideoHeight == 0)
    {
        return;
    }
    
    
    /*int nDisplayWidth = 0;
     int nDisplayHeight = 0;
     
     
     switch (m_nDisplayMode)
     {
     case 0:
     {
     if (m_nVideoWidth > m_nScreenWidth || m_nVideoHeight > m_nScreenHeight) {
     nDisplayHeight = m_nScreenHeight;
     nDisplayWidth = m_nVideoWidth * m_nScreenHeight / m_nVideoHeight ;
     if (nDisplayWidth > m_nScreenWidth) {
     nDisplayWidth = m_nScreenWidth;
     nDisplayHeight = m_nVideoHeight * m_nScreenWidth / m_nVideoWidth;
     }
     }else {
     nDisplayWidth = m_nVideoWidth;
     nDisplayHeight = m_nVideoHeight;
     }
     }
     break;
     case 1:
     {
     nDisplayWidth = m_nScreenWidth;
     nDisplayHeight = m_nScreenHeight;
     
     
     }
     break;
     case 2:
     {
     nDisplayHeight =m_nScreenHeight;
     nDisplayWidth = m_nVideoWidth * m_nScreenHeight / m_nVideoHeight ;
     if (nDisplayWidth > m_nScreenWidth) {
     nDisplayWidth = m_nScreenWidth;
     nDisplayHeight = m_nVideoHeight * m_nScreenWidth / m_nVideoWidth;
     }
     }
     break;
     default:
     break;
     }
     
     //NSLog(@"nDisplayWidth: %d, nDisplayHeight: %d", nDisplayWidth, nDisplayHeight);
     
     int nCenterX = m_nScreenWidth / 2;
     int nCenterY = m_nScreenHeight / 2;
     
     //NSLog(@"nCenterX:%d, nCenterY: %d", nCenterX, nCenterY);
     
     int halfWidth = nDisplayWidth / 2;
     int halfHeight = nDisplayHeight / 2;
     
     int nDisplayX = nCenterX - halfWidth;
     int nDisplayY = nCenterY - halfHeight;
     
     */
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation] ;
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    //        imgView.frame = CGRectMake(0, 134, 320, 214);
    //        myGLViewController.view.frame = imgView.frame;
    //    }else{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.subDisplayScrollView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        imgView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        myGLViewController.view.frame = imgView.frame;
    }else{
        self.subDisplayScrollView.frame = CGRectMake(0, m_nScreenWidth/2-m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4/2, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        imgView.frame = CGRectMake(0, 0, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        myGLViewController.view.frame = imgView.frame;//[[UIScreen mainScreen] bounds];
    }
    //  }
    //[self setDisplayModeImage];
    
}

- (void) CreateGLView
{
    myGLViewController = [[MyGLViewController alloc] init];
    if ([[UIApplication sharedApplication] statusBarOrientation]== UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation]== UIInterfaceOrientationLandscapeRight) {
        myGLViewController.view.frame = imgView.frame;//CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
    }else{
        myGLViewController.view.frame = imgView.frame;//CGRectMake(0, 224, 768, 576);
    }
    
    [self.subDisplayScrollView addSubview:myGLViewController.view];
    [self.view bringSubviewToFront:timeoutLabel];
    [self.view bringSubviewToFront:OSDLabel];
    [self.view bringSubviewToFront:TimeStampLabel];
    [self.view bringSubviewToFront:toolBarTop];
    [self.view bringSubviewToFront:playToolBar];
    [self.view bringSubviewToFront:labelContrast];
    [self.view bringSubviewToFront:sliderContrast];
    [self.view bringSubviewToFront:sliderBrightness];
    [self.view bringSubviewToFront:labelBrightness];
    
    [myGLViewController.view addSubview:self.imageDown];
    [myGLViewController.view addSubview:self.imageUp];
    [myGLViewController.view addSubview:self.imageLeft];
    [myGLViewController.view addSubview:self.imageRight];
    
    [self.view bringSubviewToFront:self.imageDown];
    [self.view bringSubviewToFront:self.imageLeft];
    [self.view bringSubviewToFront:self.imageRight];
    [self.view bringSubviewToFront:self.imageUp];
    
}

#pragma mark -
#pragma mark UIScooleViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (myGLViewController != nil) {
        return myGLViewController.view;
    }
    return imgView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSNotificationCenter* notigication = [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationchange:) name:UIKeyboardDidHideNotification object:<#(id)#>];
    self.subDisplayScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.subDisplayScrollView addSubview:self.imgView];
    self.subDisplayScrollView.delegate = self;
    self.subDisplayScrollView.minimumZoomScale = 1.f;
    self.subDisplayScrollView.maximumZoomScale = 5.f;
    self.subDisplayScrollView.showsHorizontalScrollIndicator = NO;
    self.subDisplayScrollView.showsVerticalScrollIndicator = NO;
    self.subDisplayScrollView.scrollEnabled = NO;
    
    self.disPlayScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.disPlayScrollView addSubview:self.subDisplayScrollView];
    self.disPlayScrollView.delegate = nil;
    self.disPlayScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.disPlayScrollView];
    
    [self.view bringSubviewToFront:self.toolBarTop];
    [self.view bringSubviewToFront:self.playToolBar];
    [self.view bringSubviewToFront:self.progressView];
    btnStop.title = NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil);
    
    m_videoFormat = -1;
    nUpdataImageCount = 0;
    m_bTalkStarted = NO;
    m_bAudioStarted = NO;
    m_bPtzIsUpDown = NO;
    m_bPtzIsLeftRight = NO;
    bCameramark = NO;
    m_nDisplayMode = 0;
    m_nVideoWidth = 0;
    m_nVideoHeight = 0;
    m_pCustomRecorder = NULL;
    m_pYUVData = NULL;
    m_nWidth = 0;
    m_nHeight = 0;
    m_YUVDataLock = [[NSCondition alloc] init];
    m_RecordLock = [[NSCondition alloc] init];
    
    [self showPtzImage:NO];
    [self.btnRecord setEnabled:NO];
    [self.btnSnapshot setEnabled:NO];
    _cameramarkimgView = [[UIImageView alloc] init];
    [self.view addSubview:_cameramarkimgView];
    CGRect getFrame = [[UIScreen mainScreen]bounds];
    m_nScreenHeight = getFrame.size.width;
    m_nScreenWidth = getFrame.size.height;
    //m_nScreenHeight = getFrame.size.height;
    //m_nScreenWidth = getFrame.size.width;
    //NSLog(@"screen width: %d height: %d", m_nScreenWidth, m_nScreenHeight);
    
    //create yuv displayController
    myGLViewController = nil;
    
    
    
    
    imageUp.tag = 0;
    imageDown.tag = 1;
    imageLeft.tag = 2;
    imageRight.tag = 3;
    imageUp.userInteractionEnabled = YES;
    UITapGestureRecognizer *ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageUp addGestureRecognizer:ptzImageGR];
    [ptzImageGR release];
    
    imageDown.userInteractionEnabled = YES;
    ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageDown addGestureRecognizer:ptzImageGR];
    [ptzImageGR release];
    
    imageLeft.userInteractionEnabled = YES;
    ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageLeft addGestureRecognizer:ptzImageGR];
    [ptzImageGR release];
    
    imageRight.userInteractionEnabled = YES;
    ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageRight addGestureRecognizer:ptzImageGR];
    [ptzImageGR release];
    
    
    //self.FocalLengthStepper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    imageBg = [[UIImageView alloc] init];
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.subDisplayScrollView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        imgView.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
        imageBg.frame = imgView.frame;
        myGLViewController.view.frame = imgView.frame;
        [UIApplication sharedApplication].statusBarHidden = YES;
    }else{
        [UIApplication sharedApplication].statusBarHidden = YES;
        imageBg.frame = [[UIScreen mainScreen] bounds];
        self.subDisplayScrollView.frame = CGRectMake(0, m_nScreenWidth/2-m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4/2, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        imgView.frame = CGRectMake(0.f, 0.f, m_nScreenHeight, m_nScreenHeight*/*m_nScreenHeight/m_nScreenWidth*/3/4);
        myGLViewController.view.frame = imgView.frame;
    }
    imageBg.backgroundColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:0.5];
    imageBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTouch:)];
    [tapGes1 setNumberOfTapsRequired:1];
    [imageBg addGestureRecognizer:tapGes1];
    self.disPlayScrollView.userInteractionEnabled = YES;
    [self.disPlayScrollView addGestureRecognizer:tapGes1];
    [tapGes1 release];
    [self.view addSubview:imageBg];
    [self.view sendSubviewToBack:imageBg];
    //[imageBg release];
    
    
    self.imgVGA = [UIImage imageNamed:@"resolution_vga_pressed"];
    self.imgQVGA = [UIImage imageNamed:@"resolution_qvga"];
    self.img720P = [UIImage imageNamed:@"resolution_720p_pressed"];
    
    
    self.imgNormal = [UIImage imageNamed:@"ptz_playmode_standard"];
    self.imgEnlarge = [UIImage imageNamed:@"ptz_playmode_enlarge"];
    self.imgFullScreen = [UIImage imageNamed:@"ptz_playmode_fullscreen"];
    //==========================================================
    labelContrast  = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 30, 170)];
    UIColor *labelColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    labelContrast.backgroundColor = labelColor;
    labelContrast.layer.masksToBounds = YES;
    labelContrast.layer.cornerRadius = 5.0;
    [self.view addSubview:labelContrast];
    [labelContrast setHidden:YES];
    
    sliderContrast = [[UISlider alloc] init];
    [sliderContrast setMaximumValue:255.0];
    [sliderContrast setMinimumValue:1.0];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-1.57079633);
    sliderContrast.transform = rotation;
    [sliderContrast setFrame:CGRectMake(20, 70, 30, 160)];
    [self.view addSubview:sliderContrast];
    [sliderContrast setHidden:YES];
    [sliderContrast addTarget:self action:@selector(updateContrast:) forControlEvents:UIControlEventTouchUpInside];
    
    m_bContrastShow = NO;
    //==========================================================
    _recordImgOn = [[self fitImage:[UIImage imageNamed:@"ptz_takevideo_pressed"] tofitHeight:35] retain];
    _recordImgOff = [[self fitImage:[UIImage imageNamed:@"record"] tofitHeight:35] retain];
    _audioImgOn = [[self fitImage:[UIImage imageNamed:@"audio"] tofitHeight:35] retain];
    _audioImgOff = [[self fitImage:[UIImage imageNamed:@"ptz_audio_off"] tofitHeight:35] retain];
    _talkImgOn = [[self fitImage:[UIImage imageNamed:@"micro_on"] tofitHeight:35] retain];
    _talkImgOff = [[self fitImage:[UIImage imageNamed:@"microphone_off"] tofitHeight:35] retain];
    CGRect recordBtn = _recordBtn.frame;
    recordBtn.size = _recordImgOff.size;
    //_recordBtn.frame = recordBtn;
    CGRect audioBtn = _audioBtn.frame;
    audioBtn.size = _audioImgOff.size;
    //_audioBtn.frame = audioBtn;
    CGRect talkBtn = _talkBtn.frame;
    talkBtn.size = _talkImgOff.size;
    //_talkBtn.frame = talkBtn;
    
    __block UIImage* resetbg  = [UIImage imageNamed:@"ptz_resolution_preset"];
    __block UIImage* menubg = [UIImage imageNamed:@"menu"];
    __block UIImage* rotationImg = [UIImage imageNamed:@"rotation"];
    __block UIImage* updownImg = [UIImage imageNamed:@"ArrowUpDown"];
    __block UIImage* leftrightImg = [UIImage imageNamed:@"ArrowRightLeft"];
    __block UIImage* snapshotBackImg = [UIImage imageNamed:@"SnapShotImg"];
    __block UIImage* resolutionImg = [UIImage imageNamed:@"resolution"];
    __block UIImage* updownImgOn = [UIImage imageNamed:@"ArrowUpDownOn"];
    __block UIImage* leftrightImgOn = [UIImage imageNamed:@"ArrowRightLeftOn"];
    __block UIImage* muscreenImg = [UIImage imageNamed:@"muscreen"];
    _arrowUpDownImg = [[self fitImage:updownImg tofitHeight:30] retain];
    CGRect updownBtnFrame = _upDownBtn.frame;
    updownBtnFrame.size = _arrowUpDownImg.size;
    //_upDownBtn.frame = updownBtnFrame;
    
    _arrowLeftRightImg = [[self fitImage:leftrightImg tofitHeight:30] retain];
    CGRect leftrightBtnFrame = _leftRightBtn.frame;
    leftrightBtnFrame.size = _arrowLeftRightImg.size;
    //_leftRightBtn.frame = leftrightBtnFrame;
    
    _arrowUpDownImgOn = [[self fitImage:updownImgOn tofitHeight:30] retain];
    _arrowLeftRightImgOn = [[self fitImage:leftrightImgOn tofitHeight:30] retain];
    
    
    dispatch_queue_t queue = dispatch_queue_create((const char*)[@"resolution" UTF8String], nil);
    dispatch_async(queue, ^{
        
        UIImage* newresetbg = [self fitImage:resetbg tofitHeight:30];
        CGRect resolutionframe = _resetButton.frame;
        resolutionframe.size = newresetbg.size;
        //_resetButton.frame = resolutionframe;
        
        
        UIImage* newmenubg = [self fitImage:menubg tofitHeight:30];
        CGRect menuframe = [_menuButton frame];
        menuframe.size = newmenubg.size;
        //_menuButton.frame = menuframe;
        
        UIImage* newSnapShotImg = [self fitImage:snapshotBackImg tofitHeight:35];
        CGRect snapshotBtnFrame = _snapshotBtn.frame;
        snapshotBtnFrame.size = newSnapShotImg.size;
        //_snapshotBtn.frame = snapshotBtnFrame;
        
        UIImage* newresolutionImg = [self fitImage:resolutionImg tofitHeight:30];
        CGRect resolutionBtnFrame = _resolutionBtn.frame;
        resolutionBtnFrame.size = newresolutionImg.size;
        //_resolutionBtn.frame = resolutionBtnFrame;
        
        UIImage* newrotationImg = [self fitImage:rotationImg tofitHeight:30];
        CGRect rotationBtnFrame =[_rotationBtn frame];
        rotationBtnFrame.size = newrotationImg.size;
        //_rotationBtn.frame = rotationBtnFrame;
        
        UIImage* newmuscreenImg = [self fitImage:muscreenImg tofitHeight:35];
        CGRect muscreenFrame = [_muscreenBtn frame];
        muscreenFrame.size = newmuscreenImg.size;
        //_muscreenBtn.frame = muscreenFrame;
        
        //        UIImage* stopImgNormal = [self fitImage:[UIImage imageNamed:@"bar_button_back_normal"] tofitHeight:30.f];
        //        UIImage* stopImgSelected = [self fitImage:[UIImage imageNamed:@"bar_button_back_selected"] tofitHeight:30.f];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_recordBtn setImage:_recordImgOff forState:UIControlStateNormal];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_%@",self.currentAcc,strDID,TalkMark]]) {
                [self StartTalk];
                [_talkBtn setImage:_talkImgOn forState:UIControlStateNormal];
                m_bTalkStarted = YES;
            }else{
                [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
            }
            if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_%@",self.currentAcc,strDID,AudioMark]]) {
                [self StartAudio];
                [_audioBtn setImage:_audioImgOn forState:UIControlStateNormal];
                m_bAudioStarted = YES;
            }else{
                [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
            }
            
            [_upDownBtn setImage:_arrowUpDownImg forState:UIControlStateNormal];
            [_leftRightBtn setImage:_arrowLeftRightImg forState:UIControlStateNormal];
            
            [_resetButton setImage:newresetbg forState:UIControlStateNormal];
            [_menuButton setImage:newmenubg forState:UIControlStateNormal];
            [_rotationBtn setImage:newrotationImg forState:UIControlStateNormal];
            [_snapshotBtn setImage:newSnapShotImg forState:UIControlStateNormal];
            [_resolutionBtn setImage:newresolutionImg forState:UIControlStateNormal];
            [_muscreenBtn setImage:newmuscreenImg forState:UIControlStateNormal];
            //            [_ButtonStop setBackgroundImage:stopImgNormal forState:UIControlStateNormal];
            //            [_ButtonStop setBackgroundImage:stopImgSelected forState:UIControlStateSelected];
        });
    });
    //    [_ButtonStop setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    //==========================================================
    winsize = [[UIScreen mainScreen] bounds];
    
    //NSLog(@"winsize  %@",NSStringFromCGRect(winsize));
    // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        winsize.size.height = winsize.size.width;
        //NSLog(@"winsize   height  %f",winsize.size.height);
    }else{
        winsize.size.height = [[UIScreen mainScreen] bounds].size.height;
    }
    //}
    labelBrightness  = [[UILabel alloc] initWithFrame:CGRectMake(winsize.size.height - 50, 70, 30, 170)];
    labelBrightness.backgroundColor = labelColor;
    labelContrast.layer.masksToBounds = YES;
    labelBrightness.layer.cornerRadius = 5.0;
    [self.view addSubview:labelBrightness];
    [labelBrightness setHidden:YES];
    
    sliderBrightness = [[UISlider alloc] init];
    [sliderBrightness setMaximumValue:255.0];
    [sliderBrightness setMinimumValue:1.0];
    sliderBrightness.transform = rotation;
    [sliderBrightness setFrame:CGRectMake(winsize.size.height - 50, 70, 30, 170)];
    [self.view addSubview:sliderBrightness];
    [sliderBrightness setHidden:YES];
    [sliderBrightness addTarget:self action:@selector(updateBrightness:) forControlEvents:UIControlEventTouchUpInside];
    
    m_bBrightnessShow = NO;
    //==========================================================
    
    //NSLog(@"label %@   slider  %@",NSStringFromCGRect(labelBrightness.frame),NSStringFromCGRect(sliderBrightness.frame));
    /* iPad */
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [labelContrast setFrame:CGRectMake(20, 210, 60, 320)];
        [sliderContrast setFrame:CGRectMake(20, 210, 60, 320)];
        [labelBrightness setFrame:CGRectMake(winsize.size.height - 100, 210, 60, 320)];
        [sliderBrightness setFrame:CGRectMake(winsize.size.height - 100, 210, 60, 320)];
    }
    
    m_bToolBarShow = YES;
    
    self.btnTitle.title = cameraName;
    
    //    toolBarTop.tintColor = [UIColor colorWithRed:COLOR_BASE_RED/255.0f green:COLOR_BASE_GREEN/255.0f blue:COLOR_BASE_BLUE/255.0f alpha:0.1f];
    //    toolBarTop.alpha = 0.6f;
    //    playToolBar.tintColor = [UIColor colorWithRed:COLOR_BASE_RED/255.0f green:COLOR_BASE_GREEN/255.0f blue:COLOR_BASE_BLUE/255.0f alpha:0.1f];
    //    playToolBar.alpha = 0.6f;
    toolBarTop.barStyle = UIBarStyleBlackTranslucent;
    playToolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBarTop.translucent = YES;
    playToolBar.translucent = YES;
    /*if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
     
     //iOS 5
     UIImage *toolBarIMG = [UIImage imageNamed: @"barbk.png"];
     if ([toolBarTop respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
     [toolBarTop setBackgroundImage:toolBarIMG forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
     }
     if ([playToolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
     [playToolBar setBackgroundImage:toolBarIMG forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
     }
     
     } else {
     
     //iOS 4
     [toolBarTop insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barbk.png"]] autorelease] atIndex:0];
     [playToolBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barbk.png"]] autorelease] atIndex:0];
     } */
    
    //    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTouch:)];
    //    [tapGes setNumberOfTapsRequired:1];
    //    [self.imgView addGestureRecognizer:tapGes];
    //    [tapGes release];
    
    UIColor *osdColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3f];
    
    ///////////////////////////////////////////////////////////////////
    OSDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [OSDLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    CGSize size = CGSizeMake(170,100);
    OSDLabel.lineBreakMode = UILineBreakModeWordWrap;
    NSString *s = cameraName;
    labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [OSDLabel setFrame: CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y, labelsize.width, 30.f)];
    }else{
        [OSDLabel setFrame: CGRectMake(5.f, self.subDisplayScrollView.frame.origin.y, labelsize.width, 40.f)];
    }
    //CGRectMake(10, self.playToolBar.frame.size.height + 10, labelsize.width, labelsize.height)];
    OSDLabel.text = cameraName;
    OSDLabel.font = font;
    OSDLabel.layer.masksToBounds = YES;
    OSDLabel.layer.cornerRadius = 2.0;
    OSDLabel.backgroundColor = osdColor;
    OSDLabel.hidden = YES;
    [self.view addSubview:OSDLabel];
    ///[OSDLabel setHidden:YES];
    ///////////////////////////////////////////////////////////////////
    NSLog(@"playViewController   ViewDIDload7");
    ///////////////////////////////////////////////////////////////////
    // CGRect winsize = [[UIScreen mainScreen] bounds];
    TimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [TimeStampLabel setNumberOfLines:0];
    //font = [UIFont fontWithName:@"Arial" size:18];
    //size = CGSizeMake(170,100);
    TimeStampLabel.lineBreakMode = UILineBreakModeWordWrap;
    s = @"2012-07-04 08:05:30";
    labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [TimeStampLabel setFrame: CGRectMake(self.subDisplayScrollView.frame.size.width - labelsize.width, self.subDisplayScrollView.frame.origin.y + self.subDisplayScrollView.frame.size.height - labelsize.height , labelsize.width, labelsize.height)];//CGRectMake(winsize.size.height - 10 - labelsize.width, self.playToolBar.frame.size.height + 10, labelsize.width, labelsize.height)];
    NSDate* date = [NSDate date];
    TimeStampLabel.text = [NSString stringWithFormat:@"%@",date];
    TimeStampLabel.font = font;
    TimeStampLabel.layer.masksToBounds = YES;
    TimeStampLabel.layer.cornerRadius = 2.0;
    TimeStampLabel.textColor = [UIColor whiteColor];
    TimeStampLabel.backgroundColor = osdColor;
    TimeStampLabel.hidden = YES;
    [self.view addSubview:TimeStampLabel];
    self->timeStampTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateTimestamp) userInfo:nil repeats:YES];
    ///////////////////////////////////////////////////////////////////
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.timeoutLabel.frame = CGRectMake(self.subDisplayScrollView.frame.size.width - self.timeoutLabel.frame.size.width, self.subDisplayScrollView.frame.origin.y , self.timeoutLabel.frame.size.width, 30.f);
    }else{
        self.timeoutLabel.frame = CGRectMake(self.subDisplayScrollView.frame.size.width - self.timeoutLabel.frame.size.width, self.subDisplayScrollView.frame.origin.y , self.timeoutLabel.frame.size.width, 40.f);
    }
    
    [timeoutLabel setHidden:YES];
    timeoutLabel.backgroundColor = osdColor;
    timeoutLabel.layer.masksToBounds = YES;
    timeoutLabel.layer.cornerRadius = 2.0f;
    m_nTimeoutSec = 180;
    timeoutTimer = nil;
    NSString *strTimeout = [NSString stringWithFormat:@"%@ %d %@", NSLocalizedStringFromTable(@"RelayModeTimeout", @STR_LOCALIZED_FILE_NAME, nil),m_nTimeoutSec,NSLocalizedStringFromTable(@"StrSeconds", @STR_LOCALIZED_FILE_NAME, nil)];
    timeoutLabel.text = strTimeout;
    [self.view bringSubviewToFront:timeoutLabel];
    //imgView.userInteractionEnabled = YES;
    bGetVideoParams = NO;
    bManualStop = NO;
    m_bGetStreamCodecType = NO;
    
    self.LblProgress.text = NSLocalizedStringFromTable(@"Connecting", @STR_LOCALIZED_FILE_NAME,nil);
    
    [self.progressView setHidden:NO];
    [self.progressView startAnimating];
    
    if (m_pPPPPChannelMgt != NULL ) {
        //如果请求视频失败，则退出播放
        NSInteger substream = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_ResolutionValue",strDID]];
        NSLog(@"substream %ld", (long)substream);
        if( m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10,(int)substream, self) == 0 ){
            [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
            return;
        }else{
        }
        
        [self getCameraParams];
    }else{
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"AAA" message:@"BB" delegate:self cancelButtonTitle:@"CAncel" otherButtonTitles: nil];
        //        [alert show];
        //        [alert release];
    }
    [self performSelector:@selector(playViewTouch:) withObject:nil afterDelay:3.f];
    
    
    self.resetButton.layer.masksToBounds = YES;
    self.resetButton.layer.cornerRadius = 4.0f;
    //self.resetButton.layer.borderWidth = 1.0f;
    //self.resetButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.resolutionbutton.layer.masksToBounds = YES;
    self.resolutionbutton.layer.cornerRadius = 4.0f;
    self.resolutionbutton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.resolutionbutton.layer.borderWidth = 1.0f;
    self.resolutionbutton.backgroundColor = [UIColor grayColor];
    
    CGRect ptzImgFrame = CGRectZero;
    ptzImgFrame = self.imageLeft.frame;
    ptzImgFrame.origin.x = 20.f;
    ptzImgFrame.origin.y = self.imgView.frame.size.height/2 - self.imageLeft.frame.size.height/2;
    self.imageLeft.frame = ptzImgFrame;
    
    ptzImgFrame = self.imageRight.frame;
    ptzImgFrame.origin.x = self.imgView.frame.size.width - 20.f - self.imageRight.frame.size.width;
    ptzImgFrame.origin.y = self.imageLeft.frame.origin.y;
    self.imageRight.frame = ptzImgFrame;
    
    ptzImgFrame = self.imageUp.frame;
    ptzImgFrame.origin.x = self.imgView.frame.size.width/2 - self.imageUp.frame.size.width/2;
    ptzImgFrame.origin.y = 50.f;/*50 = toolBar.frame.size.height + 间隔(6)*/
    self.imageUp.frame = ptzImgFrame;
    
    ptzImgFrame = self.imageDown.frame;
    ptzImgFrame.origin.x = self.imageUp.frame.origin.x;
    ptzImgFrame.origin.y = self.imgView.frame.size.height - self.imageDown.frame.size.height - 50.f;
    self.imageDown.frame = ptzImgFrame;
    
    [self.imgView addSubview:self.imageDown];
    [self.imgView addSubview:self.imageUp];
    [self.imgView addSubview:self.imageLeft];
    [self.imgView addSubview:self.imageRight];
    
    [self.view bringSubviewToFront:self.imageDown];
    [self.view bringSubviewToFront:self.imageLeft];
    [self.view bringSubviewToFront:self.imageRight];
    [self.view bringSubviewToFront:self.imageUp];
    
    
    self.imageLeft.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageDown.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.imageUp.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    _is_animationDown = NO;
    _is_animationLeft = NO;
    _is_animationRight = NO;
    _is_animationUp = NO;
    
    CustomToolBarItem* item1 = [[[CustomToolBarItem alloc] initwithItemId:11 andTitle:NSLocalizedStringFromTable(@"Contrast", @STR_LOCALIZED_FILE_NAME, nil) andDelegate:self] autorelease];
    CustomToolBarItem* item2 = [[[CustomToolBarItem alloc] initwithItemId:12 andTitle:NSLocalizedStringFromTable(@"Brightness", @STR_LOCALIZED_FILE_NAME, nil) andDelegate:self] autorelease];
    CustomToolBarItem* item3 = [[[CustomToolBarItem alloc] initwithItemId:13 andTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"FocalLength", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Zoom", @STR_LOCALIZED_FILE_NAME, nil)] andDelegate:self] autorelease];
    CustomToolBarItem* item4 = [[[CustomToolBarItem alloc] initwithItemId:14 andTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"FocalLength", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"ZoomOut", @STR_LOCALIZED_FILE_NAME, nil)] andDelegate:self] autorelease];
    CustomToolBarItem* item5 = [[[CustomToolBarItem alloc] initwithItemId:15 andTitle:NSLocalizedStringFromTable(@"Vertical", @STR_LOCALIZED_FILE_NAME, nil) andDelegate:self] autorelease];
    CustomToolBarItem* item6 = [[[CustomToolBarItem alloc] initwithItemId:16 andTitle:NSLocalizedStringFromTable(@"Horizontal", @STR_LOCALIZED_FILE_NAME, nil) andDelegate:self] autorelease];
    CustomToolBarItem* item7 = [[[CustomToolBarItem alloc] initwithItemId:17 andTitle:[NSString stringWithFormat:@"IR(%@)",NSLocalizedStringFromTable(@"On", @STR_LOCALIZED_FILE_NAME, nil)] andDelegate:self] autorelease];
    CustomToolBarItem* item8 = [[[CustomToolBarItem alloc] initwithItemId:18 andTitle:[NSString stringWithFormat:@"IR(%@)",NSLocalizedStringFromTable(@"Off", @STR_LOCALIZED_FILE_NAME, nil)] andDelegate:self] autorelease];
    
    NSArray* items = [NSArray arrayWithObjects:item1, item2, item3, item4, item5, item6, item7, item8, nil];
    _menuToolBar = [[CustomToolBar alloc] initFrom:[self.view viewWithTag:550] andRowItems:4 andItems:items andRowHeight:44.f andWidth:imgView.frame.size.width];
    [self.view addSubview:_menuToolBar];
}


- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale;
    
    scale = imagesize.height / height;
    
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //NSLog(@"PlayViewController ViewDidUnload");
    
}


- (void)dealloc {
    NSLog(@"PlayViewController dealloc");
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    
    if (_cameramarkimgView != nil) {
        [_cameramarkimgView release];
        _cameramarkimgView = nil;
    }
    
    if (OSDLabel != nil) {
        [OSDLabel release];
        OSDLabel = nil;
    }
    if (TimeStampLabel != nil) {
        [TimeStampLabel release];
        TimeStampLabel = nil;
    }
    if (imageBg != nil) {
        [imageBg release];
        imageBg = nil;
    }
    if (_listitems != nil) {
        [_listitems release];
        _listitems = nil;
    }
    if (_recordImgOn) {
        [_recordImgOn release];
        _recordImgOn = nil;
    }
    if (_recordImgOff) {
        [_recordImgOff release];
        _recordImgOff = nil;
    }
    if (_audioImgOn) {
        [_audioImgOn release];
        _audioImgOn = nil;
    }
    if (_audioImgOff) {
        [_audioImgOff release];
        _audioImgOff = nil;
    }
    if (_talkImgOn) {
        [_talkImgOn release];
        _talkImgOn = nil;
    }
    if (_talkImgOff) {
        [_talkImgOff  release];
        _talkImgOff = nil;
    }
    
    if (_arrowLeftRightImg) {
        [_arrowLeftRightImg release];
        _arrowLeftRightImg = nil;
    }
    if (_arrowLeftRightImgOn) {
        [_arrowLeftRightImgOn release];
        _arrowLeftRightImgOn = nil;
    }
    if (_arrowUpDownImg) {
        [_arrowUpDownImg release];
        _arrowUpDownImg = nil;
    }
    if (_arrowUpDownImgOn) {
        [_arrowUpDownImgOn release];
        _arrowUpDownImgOn = nil;
    }
    [_menuToolBar release],_menuToolBar = nil;
    self.recordBtn = nil;
    self.audioBtn = nil;
    self.talkBtn = nil;
    self.rotationBtn = nil;
    self.rotationItem = nil;
    self.resolutionPopup = nil;
    tableCtr = nil;
    fppoverCtr = nil;
    self.resolutionbutton  = nil;
    self.btnStop = nil;
    self.imgView = nil;
    self.cameraName = nil;
    self.strDID = nil;
    self.playToolBar = nil;
    self.btnItemResolution = nil;
    self.btnTitle = nil;
    self.toolBarTop = nil;
    self.btnUpDown = nil;
    self.btnLeftDown = nil;
    self.btnUpDownMirror = nil;
    self.btnLeftRightMirror = nil;
    self.btnTalkControl = nil;
    self.btnAudioControl = nil;
    [sliderContrast release];
    [labelContrast release];
    self.btnSetContrast = nil;
    self.btnSetBrightness = nil;
    [sliderBrightness release];
    [labelBrightness release];
    self.imgVGA = nil;
    self.imgQVGA = nil;
    self.img720P = nil;
    //self.btnSwitchDisplayMode = nil;
    self.imgEnlarge = nil;
    self.imgFullScreen = nil;
    self.imgNormal = nil;
    self.imageSnapshot = nil;
    //self.m_pPicPathMgt = nil;
    self.btnRecord = nil;
    if (m_RecordLock != nil) {
        [m_RecordLock release];
        m_RecordLock = nil;
        
    }
    self.imageLeft = nil;
    self.imageUp = nil;
    self.imageDown = nil;
    self.imageRight = nil;
    //self.m_pRecPathMgt = nil;
    self.PicNotifyDelegate = nil;
    if (myGLViewController != nil) {
        [myGLViewController release];
        myGLViewController = nil;
    }
    if (m_YUVDataLock != nil) {
        [m_YUVDataLock release];
        m_YUVDataLock = nil;
    }
    SAFE_DELETE(m_pYUVData);
    [super dealloc];
    
}

#pragma mark -

- (IBAction) menu:(id)sender{
    /*if (_menuPopup) {
     [_menuPopup hide];
     }
     _menuPopup = [[PopupListComponent alloc]init];
     PopupListComponentItem* item18 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"Contrast", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:18 showCaption:YES];
     PopupListComponentItem* item19 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"Brightness", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:19 showCaption:YES];
     PopupListComponentItem* item20 = [[PopupListComponentItem alloc] initWithCaption:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"FocalLength", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Zoom", @STR_LOCALIZED_FILE_NAME, nil)] image:nil itemId:20 showCaption:YES];
     PopupListComponentItem* item21 = [[PopupListComponentItem alloc] initWithCaption:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"FocalLength", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"ZoomOut", @STR_LOCALIZED_FILE_NAME, nil)] image:nil itemId:21 showCaption:YES];
     PopupListComponentItem* item22 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"Vertical", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:22 showCaption:YES];
     PopupListComponentItem* item23 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"Horizontal", @STR_LOCALIZED_FILE_NAME, nil) image:nil itemId:23 showCaption:YES];
     NSArray* listItems = [NSArray arrayWithObjects:item18, item19, item20, item21,item22, item23, nil];
     _menuPopup.textColor = [UIColor whiteColor];
     _menuPopup.textPaddingHorizontal = 5.0f;
     _menuPopup.textPaddingVertical = 2.0f;
     [_menuPopup showAnchoredTo:sender inView:self.view withItems:listItems withDelegate:self];
     [item18 release];
     item18 = nil;
     [item19 release];
     item19 = nil;
     [item20 release];
     item20 = nil;
     [item21 release];
     item21 = nil;*/
    if (_menuToolBar.show) {
        [self.view bringSubviewToFront:_menuToolBar];
        [_menuToolBar showToolBar];
    }else{
        [_menuToolBar dismissToolBar];
    }
}

- (IBAction)SplitScreen:(id)sender{
    _muscreenBtn.enabled = NO;
    _muscreenItem.enabled = NO;
    if (m_pPPPPChannelMgt != NULL) {
        m_pPPPPChannelMgt->StopPPPPLivestream([strDID UTF8String]);
        m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
        m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
    }
    
    if (timeoutTimer != nil) {
        [timeoutTimer invalidate];
        timeoutTimer = nil;
    }
    
    [self stopRecord];
    
    
    IpCameraClientAppDelegate *IPCAMDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    Split_screenViewController* split = [[Split_screenViewController alloc] init];
    [IPCAMDelegate switchSpliteScreen:split];
    [split release];
}

#pragma mark -
#pragma mark PPPPStatusDelegate
- (void) PPPPStatus:(NSString *)astrDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    //NSLog(@"PlayViewController strDID: %@, statusType: %d, status: %d", astrDID, statusType, status);
    //处理PPP的事件通知
    
    if (bManualStop == YES) {
        return;
    }
    
    //这个一般情况下是不会发生的
    if ([astrDID isEqualToString:strDID] == NO) {
        return;
    }
    
    //如果是PPP断开，则停止播放
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS && status == PPPP_STATUS_DISCONNECT) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
    }
    
}

#pragma mark -
#pragma mark ParamNotify

- (void) ParamNotify:(int)paramType params:(void *)params
{
    //NSLog(@"PlayViewController ParamNotify");
    
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM pCameraParam = (PSTRU_CAMERA_PARAM)params;
        m_Contrast = pCameraParam->contrast;
        m_Brightness = pCameraParam->bright;
        nResolution = pCameraParam->resolution;
        m_nFlip = pCameraParam->flip;
        bGetVideoParams = YES;
        [self performSelectorOnMainThread:@selector(UpdateVieoDisplay) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (paramType == STREAM_CODEC_TYPE) {
        //NSLog(@"STREAM_CODEC_TYPE notify");
        m_StreamCodecType = *((int*)params);
        m_bGetStreamCodecType = YES;
        //[self performSelectorOnMainThread:@selector(DisplayVideoCodec) withObject:nil waitUntilDone:NO];
    }
    
}

#pragma mark -
#pragma mark ImageNotify

- (void) H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger) timestamp
{
    if (m_videoFormat == -1) {
        m_videoFormat = 2;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    
    //NSLog(@"H264Data... length: %d, type: %d", length, type);
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        //NSLog(@"unTimestamp: %d", unTimestamp);
        m_pCustomRecorder->SendOneFrame((char*)h264Frame, length, unTimestamp, type);
        [pool release];
    }
    [m_RecordLock unlock];
}

- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp
{
    //NSLog(@"YUVNotify.... length: %d, timestamp: %d, width: %d, height: %d", length, timestamp, width, height);
    //NSLog(@"GL UPData Image");
    if ([IpCameraClientAppDelegate is43Version]) {//4.3.3版本
        UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
        if (bPlaying==NO) {
            bPlaying = YES;
            [self updateResolution:image];
            
            [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
            
        }
        
        [self performSelectorOnMainThread:@selector(updateTimestamp) withObject:nil waitUntilDone:NO];
        if (image != nil) {
            [image retain];
            [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
        }
        
        [m_YUVDataLock lock];
        SAFE_DELETE(m_pYUVData);
        int yuvlength = width * height * 3 / 2;
        m_pYUVData = new Byte[yuvlength];
        memcpy(m_pYUVData, yuv, yuvlength);
        m_nWidth = width;
        m_nHeight = height;
        [m_YUVDataLock unlock];
        
        return;
    }
    
    if (bPlaying == NO)
    {
        
        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:YES];
        [self updataResolution:width height:height];
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        
        bPlaying = YES;
        //        if (![[NSUserDefaults standardUserDefaults] boolForKey:spliteBtn]) {
        //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:spliteBtn];
        //        }
    }
    
    //[self performSelectorOnMainThread:@selector(updateTimestamp) withObject:nil waitUntilDone:NO];
    
    [myGLViewController WriteYUVFrame:yuv Len:length width:width height:height];
    
    [m_YUVDataLock lock];
    SAFE_DELETE(m_pYUVData);
    int yuvlength = width * height * 3 / 2;
    m_pYUVData = new Byte[yuvlength];
    memcpy(m_pYUVData, yuv, yuvlength);
    m_nWidth = width;
    m_nHeight = height;
    
    if (tableCtr != nil && tableCtr.butonTap ) {
        if (m_YUVDataLock == NULL) {
            [m_YUVDataLock unlock];
            return;
        }
        
        if (tableCtr.img != nil) {
            [tableCtr.img release];
            tableCtr.img = nil;
        }
        
        //yuv->image
        if (m_videoFormat == 2) {
            tableCtr.img = [[APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight] retain];
        }
        
        
        
        
    }
    [m_YUVDataLock unlock];
}

- (void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp
{
    // NSLog(@"ImageNotify......%d", timestamp);
    
    if (m_videoFormat == -1) {
        m_videoFormat = 0;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    
    if (bPlaying == NO)
    {
        bPlaying = YES;
        [self updateResolution:image];
        
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        //        if (![[NSUserDefaults standardUserDefaults] boolForKey:spliteBtn]) {
        //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:spliteBtn];
        //        }
    }
    
    if (image != nil) {
        [image retain];
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    }
    
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        //NSLog(@"unTimestamp: %d", unTimestamp);
        m_pCustomRecorder->SendOneFrame((char*)[data bytes], [data length], unTimestamp, 0);
        [pool release];
    }
    [m_RecordLock unlock];
    
    //NSLog(@"image size %@",NSStringFromCGSize(image.size));
    
}

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp szdid:(NSString*)szdid{
    
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp szdid:(NSString*)szdid{
    
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp szdid:(NSString*)szdid{
    
}

- (void) updataResolution: (int) width height:(int)height
{
    m_nVideoWidth = width;
    m_nVideoHeight = height;
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 0;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 1;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }
    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
    
}

- (void) updateResolution:(UIImage*)image
{
    //NSLog(@"updateResolution");
    m_nVideoWidth = image.size.width;
    m_nVideoHeight = image.size.height;
    
    //NSLog(@"m_nVideoWidth: %d, m_nVideoHeight: %d", m_nVideoWidth, m_nVideoHeight);
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 1;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 0;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }
    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
}

@end
