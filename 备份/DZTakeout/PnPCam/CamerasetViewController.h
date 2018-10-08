//
//  CamerasetViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-1-18.
//
//

#import <UIKit/UIKit.h>
#import "obj_common.h"
#import "FPPopoverController.h"
#import "CameraListMgt.h"
#import "PPPPDefine.h"
#import "mytoast.h"
#import "SettingViewController.h"
#import "PPPPChannelManagement.h"
#import "PicPathManagement.h"
#import "RecPathManagement.h"
#import "NotifyEventProtocol.h"
#import "PictrueDateViewController.h"
#import "RecordDateViewController.h"
#import "RemoteRecordFileListViewController.h"
@protocol CamerasetViewControllerDelegate <NSObject>

- (void)pushtoView:(UIViewController*)ViewCtr;
- (void)deleteCamera;

@end

@interface CamerasetViewController : UITableViewController
@property (nonatomic, retain) FPPopoverController* fppopoverCtr;
@property (nonatomic, retain) CameraListMgt* cameraListMgt;
@property (nonatomic, assign) CPPPPChannelManagement* m_nPPPPChannelMgt;
@property (nonatomic, assign) id<CamerasetViewControllerDelegate>delegate;
@property (nonatomic, assign) int selectRow;

@property (nonatomic, retain) PictrueDateViewController* picDataViewCtr;
@property (nonatomic, retain) PicPathManagement* picPathMgt;
@property (nonatomic, retain) RecPathManagement* m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol>PicNotifyEventDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol>RecordNotifyEventDelegate;
@end
