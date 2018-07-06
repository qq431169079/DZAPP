//
//  DZLoadingView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/5.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZLoadingView.h"
#import "UIImageView+HMDAnimation.h"

@interface DZLoadingView()

@end
@implementation DZLoadingView

+(instancetype)DZLoadingViewWithType:(DZLoadingViewType)loadingViewType{
    DZLoadingView *loadingView = [[DZLoadingView alloc] init];
    switch (loadingViewType) {
        case DZLoadingViewMiniType:
            {
                loadingView.loadingImageView.image = [UIImage imageNamed:@"loading_s_green"];
                loadingView.frame = CGRectMake(0, 0, 30, 30);
                loadingView.loadingImageView.frame = loadingView.bounds;
            }
            break;
            
        default:
            break;
    }
    return loadingView;
}

-(void)startLoadingAnimation{
    self.isloading = YES;
    self.hidden = NO;
    [self.loadingImageView startRotationAnimation];
}

-(void)endLoadingAnimaton{
    self.isloading = NO;
    self.hidden = YES;
    [self.loadingImageView stopRotationAnimaton];
}

-(UIImageView *)loadingImageView{
    if (_loadingImageView == nil) {
        _loadingImageView = [[UIImageView alloc] init];
        [self addSubview:_loadingImageView];
    }
    return _loadingImageView;
}
@end
