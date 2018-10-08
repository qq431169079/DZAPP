//
//  RecordDateViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecPathManagement.h"
#import "NotifyEventProtocol.h"
#import "PPPPChannelManagement.h"
#import "CameraListMgt.h"
#import "RecordViewController.h"
#import "FPPopoverController.h"
#import "AlbumTableViewController.h"
@interface RecordDateViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, NotifyEventProtocol,UINavigationBarDelegate,AlbumTableViewControllerDelegate,FPPopoverControllerDelegate>{
//    RecPathManagement *m_pRecPathMgt;
    NSString *strDID;
    NSString *strName;
    
    NSMutableArray *recDataArray;
    
    IBOutlet UINavigationBar *navigationBar;
    
    UIImage *imagePlay;
    UIImage *imageDefault;
    
    IBOutlet UITableView *tableView;
    
//    id<NotifyEventProtocol> RecReloadDelegate;
    
    CPPPPChannelManagement* m_PpppchannelMgt;
    CameraListMgt* camListMgt;
}
@property (nonatomic, retain) FPPopoverController* fppopoverCtr;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIImage *imagePlay;
@property (nonatomic, retain) UIImage *imageDefault;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<NotifyEventProtocol> RecReloadDelegate;
@property (nonatomic, assign) CPPPPChannelManagement* m_PpppchannelMgt;
@property (nonatomic, retain) CameraListMgt* camListMgt;
- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height;
@end
