//
//  HPAnimationTools.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPAnimationTools.h"

@interface __BlockNode : NSObject
@property (nonatomic, copy) void(^block)(void);
- (void)revokeBlock;
@end

@implementation __BlockNode
- (void)revokeBlock {
    if (self.block) { self.block(); }
}
@end

@interface HPAnimationTools ()<CAAnimationDelegate>
@property (nonatomic, strong) NSMutableDictionary *blockDic;
@end

@implementation HPAnimationTools

+ (instancetype)tools {
    static dispatch_once_t onceToken;
    static HPAnimationTools *tool = nil;
    dispatch_once(&onceToken, ^{
        tool = [[HPAnimationTools alloc] init];
    });
    return tool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _blockDic = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)startTarget:(UIView *)target
          animation:(HPAnimationStyle)style
         startPoint:(CGPoint)startPoint
           endPoint:(CGPoint)endPoint {
    
    [self startTarget:target animation:style startPoint:startPoint endPoint:endPoint complete:nil];
}

+ (void)startTarget:(UIView *)target
          animation:(HPAnimationStyle)style
         startPoint:(CGPoint)startPoint
           endPoint:(CGPoint)endPoint
           complete:(void(^)(void))complete {
    [[self tools] startTarget:target animation:style startPoint:startPoint endPoint:endPoint complete:complete];
}


- (void)startTarget:(UIView *)target
          animation:(HPAnimationStyle)style
         startPoint:(CGPoint)startPoint
           endPoint:(CGPoint)endPoint
           complete:(void(^)(void))complete {
    if (!target) { return; }
    NSMutableArray *animations = [NSMutableArray array];
    if (style & HPAnimationStyleQuadCurve) {
        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);//移动到起始点
        CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, startPoint.y, endPoint.x, endPoint.y);
        keyframeAnimation.path = path;
        CGPathRelease(path);
        [animations addObject:keyframeAnimation];
    }
    
    if (style & HPAnimationStyleScale) {
        //缩放动画
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @(1.0f);
        scale.byValue = @(2.0f);
        scale.toValue = @(1.0f);
        [animations addObject:scale];
    }
    
    if (style & HPAnimationStyleRotate) {
        //旋转动画
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.toValue = [NSNumber numberWithFloat:M_PI*8];
        [animations addObject:rotate];
    }
    //组动画
    if (animations.count > 0) {
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.delegate = self;
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.animations = animations.copy;
        groupAnimation.duration = 0.6f;
        [target.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
        if (complete) {
            __BlockNode *node = [__BlockNode new];
            node.block = ^{complete();};
            NSString *cacheKey = [self _cacheKeyFromAnimations:groupAnimation];
            [self.blockDic setObject:node forKey:cacheKey];
        }
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *cacheKey = [self _cacheKeyFromAnimations:anim];
    if (cacheKey) {
        __BlockNode *node = [self.blockDic objectForKey:cacheKey];
        [node revokeBlock];
    }
}

#pragma mark - Private Functions
- (NSString *)_cacheKeyFromAnimations:(CAAnimation *)group {
    if ([group isKindOfClass:CAAnimationGroup.class]) {
        NSMutableString *cacheKey = [NSMutableString string];
        CAAnimationGroup *aniGroup = (CAAnimationGroup *)group;
        [aniGroup.animations enumerateObjectsUsingBlock:^(CAAnimation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [cacheKey appendString:[NSString stringWithFormat:@"%p", obj]];
        }];
        return cacheKey.copy;
    }
    return nil;
}

@end
