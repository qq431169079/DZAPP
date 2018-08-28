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
@property (weak, nonatomic) IBOutlet UILabel *notiLab;

@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;
@end
@implementation DZLoadingHoldView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addGestureRecognizer];
}

-(void)addGestureRecognizer{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reRequest)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.enabled = NO;
}

-(void)reRequest{
    if (self.reResultBlock) {
        self.reResultBlock();
    }
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

-(void)setImageWithRequestResult:(DZRequestResult)requestResult{
    self.tapGestureRecognizer.enabled = NO;
    self.notiLab.text = nil;
    [self.loadingView stopAnimating];
    switch (requestResult) {
        case DZRequestLoading:
        {
            [self addLoadingAnimation];
            self.notiLab.text = @"看看能找到什么";
        }

            break;
            case DZRequestSuccess:{
            self.hidden = YES;
            [self removeFromSuperview];
        }
            break;
        case DZRequestFailure:{
            if (self.reResultBlock) {
                self.tapGestureRecognizer.enabled = YES;
            }
            self.loadingView.image = [UIImage imageNamed:@"DZ_Loading_failer"];
            self.notiLab.text = @"数据加载失败";
        }
            break;
        case DZRequestEmpty:{
            self.loadingView.image = [UIImage imageNamed:@"DZ_Loading_empty"];
            self.notiLab.text = @"空白页";
        }
            break;
        case DZRequestEmptyMessage:{
            self.loadingView.image = [UIImage imageNamed:@"DZ_Message_empty"];
            self.notiLab.text = @"无消息";
        }
            break;
        default:
            break;
    }
}
@end
