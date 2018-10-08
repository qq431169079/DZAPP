//
//  HPAnimationTools.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, HPAnimationStyle) {
    HPAnimationStyleScale = 1 << 0,
    HPAnimationStyleRotate = 1 << 1,
    HPAnimationStyleQuadCurve = 1 << 2,
};

@interface HPAnimationTools : NSObject

+ (instancetype)tools;

+ (void)startTarget:(UIView *)target
          animation:(HPAnimationStyle)style
         startPoint:(CGPoint)startPoint
           endPoint:(CGPoint)endPoint;

+ (void)startTarget:(UIView *)target
          animation:(HPAnimationStyle)style
         startPoint:(CGPoint)startPoint
           endPoint:(CGPoint)endPoint
           complete:(void(^)(void))complete;

@end
