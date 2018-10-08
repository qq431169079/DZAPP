//
//  CameraSearchViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDVS.h"
#import "SearchListMgt.h"
#import "SearchCameraResultProtocol.h"
#import "CameraViewController.h"
#import "SearchAddCameraInfoProtocol.h"

@interface CameraSearchViewController : UIViewController<SearchCameraResultProtocol,
UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>{
    IBOutlet UITableView *SearchListView;
    IBOutlet UINavigationBar *navigationBar;
    
    SearchListMgt *searchListMgt;
    CSearchDVS *m_pSearchDVS;
    NSTimer *searchTimer;
    
    BOOL bSearchFinished;
    
    CameraViewController *cameraViewController;
    
    id<SearchAddCameraInfoProtocol> SearchAddCameraDelegate;
}

@property (nonatomic,assign) CameraViewController *cameraViewController;
@property (nonatomic, retain) IBOutlet UITableView *SearchListView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, assign) id<SearchAddCameraInfoProtocol> SearchAddCameraDelegate;

@end
