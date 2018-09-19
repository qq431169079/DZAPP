//
//  DZSegmentNavBar.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/15.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZSegmentNavBar : UIView

@property (nonatomic, copy) NSArray<NSString *> *segmentTitles;

@property (nonatomic, copy) void(^returnBackHandler) (UIButton *sender);
@property (nonatomic, copy) void(^onSelectedIndexHandler) (NSInteger selectedIndex);
- (void)setSelectedIndex:(NSInteger)selectedIndex;
-(void)hiddenBackBtn:(BOOL)hidden;
@end
