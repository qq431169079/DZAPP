//
//  DZFakeSearchNavBar.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/13.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZFakeSearchNavBar : UIView

// 默认为YES，如果为NO，UISearchBar不能成为第一响应者
@property (nonatomic, assign) BOOL searchBarEnable;
// 只有在searchBarEnable=NO的时候使用
@property (nonatomic, copy) void(^onClickSearchBarHandler) (void);

@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, copy) void(^returnBackHandler) (UIButton *sender);
@property (nonatomic, weak) id<UISearchBarDelegate> delegate;

- (BOOL)searchBecomeFirstResponder;
- (BOOL)searchResignFirstResponder;

@end
