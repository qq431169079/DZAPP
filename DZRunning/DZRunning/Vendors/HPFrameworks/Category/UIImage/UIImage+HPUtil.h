//
//  UIImage+HPUtil.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,    //从上到小
    GradientTypeLeftToRight = 1,    //从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};


@interface UIImage (HPUtil)

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor*)color size:(CGSize)size;

/**
 返回指定大小，颜色，渐变模式的渐变色图片
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray<UIColor *>*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

@end
