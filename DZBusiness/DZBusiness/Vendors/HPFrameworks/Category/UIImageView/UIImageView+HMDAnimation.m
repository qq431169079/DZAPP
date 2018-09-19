//
//  UIImageView+HMDAnimation.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/15.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "UIImageView+HMDAnimation.h"

@implementation UIImageView (HMDAnimation)
static NSString * const kRotationAnimationKey = @"kRotationAnimationKey";
//动画
-(void)startRotationAnimation{
    if ([[self.layer animationKeys] containsObject:kRotationAnimationKey]) {
        return;
    }else{
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.removedOnCompletion = NO;
        [self.layer addAnimation:rotationAnimation forKey:kRotationAnimationKey];
    }
    
}

-(void)stopRotationAnimaton{
    if ([[self.layer animationKeys] containsObject:kRotationAnimationKey]) {
        [self.layer removeAnimationForKey:kRotationAnimationKey];
    }
}
@end
