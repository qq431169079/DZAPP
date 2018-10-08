//
//  Split-screenViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-2-19.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyGLViewController.h"
#import "PlayViewController.h"
#import "CameraListMgt.h"
#import "PPPPChannelManagement.h"
#import "PPPPStatusProtocol.h"
#import "ParamNotifyProtocol.h"
#import "ImageNotifyProtocol.h"
@interface Split_screenViewController : UIViewController<PPPPStatusProtocol,ParamNotifyProtocol,ImageNotifyProtocol,UIScrollViewDelegate,UINavigationBarDelegate,UIAlertViewDelegate>
@property (nonatomic, retain) CameraListMgt* cameraListMgt;
@property (nonatomic, assign) CPPPPChannelManagement* ppppChannelMgt;
@property (nonatomic, retain) NSDictionary* camdic;
@property (nonatomic, retain) NSString* str_uid;
//@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, assign) BOOL bPlaying;
@property (nonatomic, assign) BOOL bManualStop;
@property (nonatomic, retain) MyGLViewController* myGlViewCtr0;
@property (nonatomic, retain) MyGLViewController* myGlViewCtr1;
@property (nonatomic, retain) MyGLViewController* myGlViewCtr2;
@property (nonatomic, retain) MyGLViewController* myGlViewCtr3;
@property (nonatomic, retain) UIImageView* imageView0;
@property (nonatomic, retain) UIImageView* imageView1;
@property (nonatomic, retain) UIImageView* imageView2;
@property (nonatomic, retain) UIImageView* imageView3;
//@property (nonatomic, retain) NSMutableArray* tapGestures;
@property (nonatomic, retain) NSMutableArray* cameraInfos;
//@property (nonatomic, retain) NSMutableArray* imageViews;
@property (nonatomic, retain) NSMutableArray* cameraDics;
@property (nonatomic, retain) NSMutableArray* cameraNames;
//@property (nonatomic, retain) NSMutableArray* myGlViews;
//@property (nonatomic, retain) NSMutableArray* displayViews;
@property (nonatomic, retain) NSMutableDictionary* cameraInfoDic;
@property (nonatomic, retain) NSMutableDictionary* cameramodeDic;
@property (nonatomic, retain) NSMutableDictionary* cameraIsStartLive;
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) UIPageControl* pageCtr;
@property (nonatomic, assign) int mark;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int oldPage;
@property (nonatomic, assign) int numberofPages;
@property (nonatomic, retain) IBOutlet UINavigationBar* naBar;
@property (nonatomic) UIInterfaceOrientation* deviceOroentation;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, retain) UIAlertView* anAlert;
@property (assign) CGSize winsize;
@property (nonatomic, retain) UILabel* timeoutLabel;
@property (nonatomic, retain) NSTimer* timeoutTimer;
@property (assign) int timeoutSec;

@property (nonatomic, retain) NSTimer* timer0;
@property (nonatomic, retain) NSTimer* timer1;
@property (nonatomic, retain) NSTimer* timer2;
@property (nonatomic, retain) NSTimer* timer3;

@property int time0Sec;
@property int time1Sec;
@property int time2Sec;
@property int time3Sec;

@property (nonatomic, assign) BOOL isPushPlayVc;
- (void)initCameraInfo;
- (IBAction)back:(id)sender;
- (CGSize)fitImageViewSize;
@end
