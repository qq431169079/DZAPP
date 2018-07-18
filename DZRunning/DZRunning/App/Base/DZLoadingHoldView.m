//
//  DZLoadingHoldView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/11.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZLoadingHoldView.h"
@interface DZLoadingHoldView()
@property (weak, nonatomic) IBOutlet UIImageView *loadingView;

@end
@implementation DZLoadingHoldView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addLoadingAnimation];
}

-(void)addLoadingAnimation{
    self.loadingView.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"loading1"],
                                        [UIImage imageNamed:@"loading2"],
                                        nil];
    self.loadingView.animationRepeatCount = CGFLOAT_MAX;
    self.loadingView.animationDuration = 0.5;
    [self.loadingView startAnimating];
}
@end
