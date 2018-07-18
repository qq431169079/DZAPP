//
//  DZMenuScrollView.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZMenuScrollView;

@protocol DZMenuModelProtocol <NSObject>
@required
@property (nonatomic, copy) NSString *name;
@end

@protocol DZMenuScrollViewDelegate <NSObject>
@required
- (CGFloat)menu:(DZMenuScrollView *)menu heightForIndex:(NSInteger)index;

@optional
- (void)menu:(DZMenuScrollView *)menu onSelectIndex:(NSInteger)index;

@end

@interface DZMenuScrollView : UIScrollView

@property(nonatomic, copy) NSArray<id<DZMenuModelProtocol>> *menuModels;

@property (nonatomic, weak)id<DZMenuScrollViewDelegate>menuDelegate;

- (void)setSelectedMenuAtIndex:(NSInteger)index;
- (void)changedBadge:(NSInteger)badge atIndex:(NSUInteger)index;
-(void)clearAllBage;
@end
