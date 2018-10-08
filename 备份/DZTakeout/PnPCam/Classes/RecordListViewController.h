//
//  RecordListViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecPathManagement.h"
#import "NotifyEventProtocol.h"

@interface RecordListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NotifyEventProtocol, UINavigationBarDelegate>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *m_tableView;
    
    NSMutableArray *picPathArray;
    
    NSString *strDate;
    NSString *strDID;
    RecPathManagement *m_pRecPathMgt;
    
    UIImage *imageDefault;
    UIImage *imagePlay;
    UIImage *imageTag;
    
    BOOL m_bEditMode;
    
    char m_pSelectedStatus[1024];
    int m_nTotalNum;
    
    UIToolbar *m_toolBar;
    
    id<NotifyEventProtocol> RecReloadDelegate;
    
}

@property (nonatomic, retain) UITableView *m_tableView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strDate;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, retain) UIImage *imageDefault;
@property (nonatomic, retain) UIImage *imagePlay;
@property (nonatomic, retain) UIImage *imageTag;
@property (nonatomic, assign) id<NotifyEventProtocol> RecReloadDelegate;


@end
