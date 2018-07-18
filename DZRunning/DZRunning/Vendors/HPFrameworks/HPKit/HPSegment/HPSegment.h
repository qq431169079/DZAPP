//
//  HPSegment.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HPSegmentType) {
    HPSegmentTypeFixedWidth         =   1,  /*固定段宽*/
    HPSegmentTypeDynamicWidth       =   2,  /*动态段宽*/
};

@interface HPSegment : UIView

@property (nonatomic, assign) HPSegmentType type;
@property (nonatomic, strong) UIFont * normalFont;
@property (nonatomic, strong) UIFont * selectedFont;
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectedColor;
//LESegmentTypeFixedWidth下下面属性有效
@property (nonatomic, assign) CGFloat itemFixedWidth;
//LESegmentTypeDynamicWidth下下面属性有效
@property (nonatomic, assign) CGFloat horizontalGap;
@property (nonatomic, assign) UIEdgeInsets itemLineInsets;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) void(^segmentDidChangeSelectedValue)(NSUInteger selectedIndex);

- (void)setItems:(NSArray<NSString *> *)items oneWidth:(CGFloat) width;
- (void)setItems:(NSArray<NSString *> *)items;

- (void)addRedPointAtIndex:(NSUInteger)index;
- (void)removeRedPointAtIndex:(NSUInteger)index;
- (BOOL)hadRedPointAtIndex:(NSUInteger)index;

@end
