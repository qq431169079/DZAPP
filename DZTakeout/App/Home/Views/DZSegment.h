//
//  DZSegment.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZSegment : UIView

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, copy) void(^onSelectedIndexHandler) (NSInteger index);
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)items;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setSelectedIndex:(NSInteger)selectedIndex;
@end
