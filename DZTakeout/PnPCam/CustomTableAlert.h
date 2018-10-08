//
//  CustomTableAlert.h
//  AlertView
//
//  Created by yan luke on 13-3-1.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class CustomTableAlert;
typedef NSInteger (^myTableViewRows)(void);
typedef UITableViewCell* (^myTableViewCell)(CustomTableAlert* tableView,NSIndexPath* indexPath);
typedef void (^myTableViewSelectionRow)(NSIndexPath* indexPath);
typedef void (^myTableAlertCompletion)(void);

@interface CustomTableAlert : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, retain) NSString* cancelBtnTitle;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UITableView* contentTable;
@property (nonatomic, copy) myTableViewCell cellBlock;
@property (nonatomic, copy) myTableViewRows rowBlock;
@property (nonatomic, copy) myTableViewSelectionRow selectionRowBlock;
@property (nonatomic, copy) myTableAlertCompletion completionBlock;
- (id)initWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle numberOfRows:(myTableViewRows) rowsblock tablecell:(myTableViewCell)cellblock;
- (void)configureTableViewSelectionRowBlock:(myTableViewSelectionRow)selectionRow Completion:(myTableAlertCompletion)completion;
- (void)createBackGroundView;
- (void)show;
- (void)dismisstableAlert;
@end
