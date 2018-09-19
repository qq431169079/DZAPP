//
//  HPCoverView.m
//  MyPractice
//
//  Created by huangpan on 16/7/15.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPCoverView.h"
#import "UIView+HPUtil.h"
#import "HPKeyboardRecord.h"

@implementation HPCoverView
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initParameters];
    }
    return self;
}

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (void)initParameters {
    _contentSize = CGSizeMake(SCREEN_WIDTH - 60.0f, 145.0f);
    [self setUpBackgroundImageView];
    self.backgroundImageView.backgroundColor =  RGBA(0.0f, 0.0f, 0.0f, 0.35f);
    [self initContentView];
    [self initCancelIcon];
}


#pragma mark - Event Handle
- (void)setUpBackgroundImageView {
    
}

- (void)initContentView {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - _contentSize.width) * 0.5f , ((self.height - _contentSize.height) * 0.5f ), _contentSize.width, _contentSize.height)];
    _contentView.layer.cornerRadius = 4.0f;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_contentView];
}

- (void)initCancelIcon {
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(self.contentView.width - 32.0f, 0.0f, 32.0f, 32.0f);
    [_cancelButton setImage:[UIImage imageNamed:@"lock_close_normal"] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"lock_close_highlight"] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cancelButton];
}

- (void)cancelAction {
    [self didClickCancelButtonAction];
    [self hide];
}


- (void)didClickCancelButtonAction {
    // 子类重写
}

- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    [self setNeedsLayout];
}

- (void)showInView:(UIView *)view {
    if (!view) return;
    self.frame = view.bounds;
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.backgroundImageView.alpha = 0.2f;
    self.contentView.center = CGPointMake(self.contentView.center.x, self.contentView.bounds.size.height);
    self.contentView.layer.transform = CATransform3DMakeRotation(-0.1f, 0, 0, 1);
    //
    CGFloat toCenterY = self.bounds.size.height * 0.5f;
    if ([[HPKeyboardRecord shareInstance] isKeyboardVisiable]) {
        toCenterY = toCenterY - [[HPKeyboardRecord shareInstance] keyboardRect].size.height * 0.5f;
    }
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundImageView.alpha = 1.0f;
        self.contentView.center = CGPointMake(self.contentView.centerX, toCenterY);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f animations:^{
            self.contentView.layer.transform = CATransform3DIdentity;
        }];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.15f animations:^{
        self.contentView.layer.transform = CATransform3DMakeRotation(-0.1f, 0, 0, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundImageView.alpha = 0.2f;
            self.contentView.center = CGPointMake(self.centerX, self.height + self.contentView.height * 0.5f);
        } completion:^(BOOL finished) {
            self.contentView.layer.transform = CATransform3DIdentity;
            self.contentView.center = CGPointMake(self.contentView.centerX, self.height * 0.5f);
            self.backgroundImageView.alpha = 1.0f;
            [self removeFromSuperview];
        }];
    }];
}

@end
