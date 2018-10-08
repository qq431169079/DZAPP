//
//  PictrueDateViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicPathManagement.h"
#import "NotifyEventProtocol.h"
#import "PictureViewController.h"
#import "CameraListMgt.h"
#import "PicPathManagement.h"
#import "PopupListComponent.h"
#import "FPPopoverController.h"
#import "AlbumTableViewController.h"
@interface PictrueDateViewController : UIViewController<UITableViewDelegate,NotifyEventProtocol, UITableViewDataSource, UINavigationBarDelegate,NotifyEventProtocol,UIPopoverControllerDelegate,PopupListComponentDelegate,FPPopoverControllerDelegate,AlbumTableViewControllerDelegate>{
    PicPathManagement *m_pPicPathMgt;
    NSString *strDID;
    NSString *strName;
    
    NSMutableArray *picDataArray;
    
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    
    UIImage *imageBkDefault;
    id<NotifyEventProtocol> NotifyReloadDataDelegate;

    CameraListMgt* cameraListMgt ;
    PicPathManagement* picMgt;
    
    UITableViewController* menuTableCtr;
    IBOutlet UITableView* menutableView;
    UIPopoverController* popoverCtr;
    UIBarButtonItem* rightItem;
    
    PopupListComponent* popList;
}
@property (nonatomic, retain) FPPopoverController* fPPopoverCtr;
@property (nonatomic, retain) UITableView* menutableView;
@property (nonatomic, retain) UITableViewController* menuTableCtr;
@property (nonatomic, retain) UIPopoverController* popovewCtr;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImage *imageBkDefault;
@property (nonatomic,retain) id<NotifyEventProtocol> NotifyReloadDataDelegate;
@property (nonatomic, retain) PicPathManagement* picMgt;
@property (nonatomic, retain) CameraListMgt* cameraListMgt;
@property (nonatomic, retain) PopupListComponent* popList;

- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height;

@end
