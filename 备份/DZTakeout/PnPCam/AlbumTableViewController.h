//
//  AlbumTableViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-1-23.
//
//

#import <UIKit/UIKit.h>
#import "CameraListMgt.h"
#import "obj_common.h"
@protocol AlbumTableViewControllerDelegate <NSObject>
- (void)reloadData:(NSString*)strUID;
@end
@interface AlbumTableViewController : UITableViewController
@property (nonatomic, retain) CameraListMgt* cameraListMgt;
@property (nonatomic, retain) NSString* m_strDID;
@property (nonatomic, assign) id<AlbumTableViewControllerDelegate>delegate;
@property (nonatomic, retain) NSString* mark;
@end
