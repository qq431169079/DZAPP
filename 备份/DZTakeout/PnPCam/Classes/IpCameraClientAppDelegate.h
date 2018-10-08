//
//  IpCameraClientAppDelegate.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "PlayViewController.h"
#import "CameraViewController.h"
#import "CameraListMgt.h"
#import "PicPathManagement.h"
#import "RecPathManagement.h"
#import "PlaybackViewController.h"
#import "PictureViewController.h"
#import "RecordViewController.h"
#import "PPPPChannelManagement.h"
#import "RemotePlaybackViewController.h"
#import "Split-screenViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "MyNavigationController.h"
@class LoginViewController;
@interface IpCameraClientAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSXMLParserDelegate> {
    
    IBOutlet UIWindow *window;    
    MyNavigationController *navigationController;
    StartViewController *startViewController;    
    PlayViewController *playViewController;
    CameraViewController *cameraViewController;
    PlaybackViewController *playbackViewController;
    PictureViewController *picViewController;
    RecordViewController *recViewController;
    RemotePlaybackViewController *remotePlaybackViewController;
    
    CameraListMgt *m_pCameraListMgt;
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    
    CPPPPChannelManagement *m_pPPPPChannelMgt ;
    NSString* DownVer;
    
    Split_screenViewController* spliteScreenVc;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MyNavigationController *navigationController;
@property (nonatomic, retain) StartViewController *startViewController;
@property (nonatomic, retain) PlayViewController *playViewController;
@property (nonatomic, retain) PlaybackViewController *playbackViewController;
@property (nonatomic, retain) RemotePlaybackViewController *remotePlaybackViewController;
@property (nonatomic, retain) NSMutableData* downLoadData;
@property (nonatomic, retain) NSString* DownVer;
@property (nonatomic, retain) NSString* DownUpdataContents;
@property (nonatomic, retain) NSString* UpdaUrl;
@property (nonatomic, retain) NSMutableString* DowntmpStr;
@property (nonatomic, retain) CameraViewController* cameraViewController;
@property (nonatomic, retain) LoginViewController* loginVc;
- (void) switchPlayView: (PlayViewController *)playViewController;
- (void) switchPlaybackView: (PlaybackViewController*)_playbackViewController;
- (void) switchRemotePlaybackView: (RemotePlaybackViewController*)_remotePlaybackViewController;
- (void) switchBack;
- (void) switchSpliteScreen:(Split_screenViewController*)_split;
+(BOOL)is43Version;

@end

