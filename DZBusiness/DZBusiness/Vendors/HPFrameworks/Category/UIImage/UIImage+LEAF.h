//
//  UIImage+LEAF.h
//  testProj
//
//  Created by 陈梦杉 on 15/1/9.
//  Copyright (c) 2015年 陈梦杉. All rights reserved.
//

#import <UIKit/UIKit.h>

//---------------------------------------------
//  添加了很多图片处理方法
//---------------------------------------------
//  注意：需要Accelerate.framework支持
//
@interface UIImage (LEAF)

/**
 *  创建一张与本图大小一样的遮罩图
 *
 *  @param maskColor 遮罩图底色
 *
 *  @return 遮罩图
 */
- (UIImage *) imageMaskedWithColor : (UIColor *) maskColor;

/**
 *  中心拉伸图片到尺寸，十字行一个像素位被拉伸，边缘将出现一个像素位的空隙除锯齿
 *
 *  @param size 新size
 *
 *  @return 拉伸图
 */
- (UIImage *) crossScaleToSize : (CGSize) size;

/**
 *  切片拉伸图片到尺寸，边缘将出现一个像素位的空隙除锯齿
 *
 *  @param size 新size
 *
 *  @return 拉伸图
 */
- (UIImage *) scaleToSize : (CGSize) size capInsets : (UIEdgeInsets) capInsets;

/**
 *  拉伸图片到尺寸，边缘将出现一个像素位空隙消除锯齿
 *
 *  @param size 新size
 *
 *  @return 拉伸图
 */
- (UIImage *) scaleToSize : (CGSize) size;

/**
 *  毛玻璃效果，模糊图片
 *
 *  @param blur 模糊等级，0～1浮点数
 *
 *  @return 模糊图片
 */
- (UIImage *) blurImageWithBlurLevel : (CGFloat) blur;

/**
 *  毛玻璃效果，模糊图片
 *
 *  @param boxSize 色值模糊矩阵
 *
 *  @return 模糊图片
 */
- (UIImage *) blurImageWithBlurBoxSize : (CGSize) boxSize;

/**
 *  截取图片
 *
 *  @param rect 截取范围
 *
 *  @return 截取图片
 */
- (UIImage *) catImageFromRect : (CGRect) rect;

/**
 *  截取某个视图界面
 *
 *  @param view 被截取的视图
 *  @param rect 范围
 *
 *  @return 截取图片
 */
+ (UIImage *) imageFromView : (UIView *) view catRect : (CGRect) rect;

/**
 *  截取某个视图界面
 *
 *  @param view   被截取的视图
 *  @param rect   范围
 *  @param opaque 是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES
 *  @param scale  屏幕密度,截取密度
 *
 *  @return 截取图片
 */
+ (UIImage *) imageFromView : (UIView *) view catRect : (CGRect) rect opaque : (BOOL) opaque scale : (CGFloat) scale;

/**
 *  均衡色道图片
 *
 *  @return 均衡图
 */
- (UIImage *) equalizationImage;
/**
 *  色值通道图
 *
 *  @return 通道图
 */
- (UIImage *) edgeDetectionImage;
/**
 *  浮雕图
 *
 *  @return 浮雕图
 */
- (UIImage *) embossImage;
/**
 *  锐化图
 *
 *  @return 锐化图
 */
- (UIImage *) sharpenImage;
/**
 *  非锐化图
 *
 *  @return 非锐化图
 */
- (UIImage *) unSharepenImage;
/**
 *  旋转图
 *
 *  @param radius 角度
 *
 *  @return 旋转图
 */
- (UIImage *) rotateImageByRadius : (CGFloat) radius;
/**
 *  旋转图
 *
 *  @param radius   角度
 *  @param isExpand 是否拓展大小｜或者截取
 *
 *  @return 旋转图
 */
- (UIImage *) rotateImageByRadius : (CGFloat) radius isExpand : (BOOL) isExpand;
/**
 *  膨胀图
 *
 *  @return 膨胀图
 */
- (UIImage *) dilateImage;
/**
 *  多次迭代膨胀图
 *
 *  @param iterations 迭代次数
 *
 *  @return 多次迭代膨胀图
 */
- (UIImage *) dilateWithIterations : (int) iterations;
/**
 *  侵蚀图
 *
 *  @return 侵蚀图
 */
- (UIImage *) erodeImage;
/**
 *  多次迭代侵蚀图
 *
 *  @param iterations 迭代次数
 *
 *  @return 多次迭代侵蚀图
 */
- (UIImage *) erodeWithIterations : (int) iterations;
/**
 *  多次迭代渐变图
 *
 *  @param iterations 迭代次数
 *
 *  @return 多次迭代渐变图
 */
- (UIImage *) gradientWithIterations : (int) iterations;
/**
 *  高色值通道多次迭代图
 *
 *  @param iterations 迭代次数
 *
 *  @return 高色值通道多次迭代图
 */
- (UIImage *) tophatWithIterations : (int) iterations;
/**
 *  低色值通道多次迭代图
 *
 *  @param iterations 迭代次数
 *
 *  @return 低色值通道多次迭代图
 */
- (UIImage *) blackhatWithIterations : (int) iterations;
/**
 *  遮罩视图
 *
 *  @param overlayImage 遮罩
 *  @param blendMode    模式
 *  @param alpha        透明度
 *
 *  @return 遮罩视图
 */
- (UIImage *) imageBlendedWithImage : (UIImage *) overlayImage blendMode : (CGBlendMode) blendMode alpha : (CGFloat) alpha;
/**
 *  毛玻璃效果，白色色调
 *
 *  @return 图
 */
- (UIImage *) blurLightEffect;
/**
 *  毛玻璃效果，黑色色调
 *
 *  @return 图
 */
- (UIImage *) blurDarkEffect;
/**
 *  毛玻璃效果,自定义色调
 *
 *  @param tintColor 色调
 *
 *  @return 图
 */
- (UIImage *) blurTintEffectWithColor:(UIColor *)tintColor;
/**
 *  毛玻璃效果
 *
 *  @param blurRadius            滤镜大小
 *  @param tintColor             色调
 *  @param saturationDeltaFactor 饱和三角因子,1为正常值
 *  @param maskImage             遮罩图
 *
 *  @return 图
 */
- (UIImage *) blurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/**
 *  创建一张底色图
 *
 *  @param color 底色
 *
 *  @return 图
 */
+ (UIImage *) imageWithColor : (UIColor *) color;

/**
 *  创建一张固定大小的底色图
 *
 *  @param color 底色
 *  @param size  大小
 *
 *  @return 图
 */
+ (UIImage *) imageWithColor : (UIColor *) color size : (CGSize) size;

@end
