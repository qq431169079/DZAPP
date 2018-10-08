//
//  PictureListViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicPathManagement.h"
#import "NotifyEventProtocol.h"
#import "CameraListMgt.h"
@interface PictureListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NotifyEventProtocol, UINavigationBarDelegate>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *m_tableView;
    
    NSMutableArray *picPathArray;
    
    NSString *strDate;
    NSString *strDID;
    PicPathManagement *m_pPicPathMgt;
    id<NotifyEventProtocol> NotifyReloadDataDelegate;
}
@property (nonatomic, retain) CameraListMgt* cameraListMgt;
@property (nonatomic, retain) UITableView *m_tableView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) NSString* strName;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strDate;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic,assign) id<NotifyEventProtocol> NotifyReloadDataDelegate;
@property (nonatomic, retain) UIToolbar* myToolBar;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, retain) UIImage* tagImg;
@property (nonatomic, retain) NSMutableArray* selectImgTagArr;
@end
