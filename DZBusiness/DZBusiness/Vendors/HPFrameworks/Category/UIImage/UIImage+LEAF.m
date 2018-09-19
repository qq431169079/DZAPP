//
//  UIImage+LEAF.m
//  testProj
//
//  Created by 陈梦杉 on 15/1/9.
//  Copyright (c) 2015年 陈梦杉. All rights reserved.
//

#import "UIImage+LEAF.h"
#import <Accelerate/Accelerate.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif

static int16_t edgedetect_kernel[9] = {
    -1, -1, -1,
    -1, 8, -1,
    -1, -1, -1
};

static int16_t emboss_kernel[9] = {
    -2, 0, 0,
    0, 1, 0,
    0, 0, 2
};

static int16_t sharpen_kernel[9] = {
    -1, -1, -1,
    -1, 9, -1,
    -1, -1, -1
};

static int16_t unsharpen_kernel[9] = {
    -1, -1, -1,
    -1, 17, -1,
    -1, -1, -1
};

static uint8_t backgroundColorBlack[4] = {0,0,0,0};

static unsigned char morphological_kernel[9] = {
    1, 1, 1,
    1, 1, 1,
    1, 1, 1,
};

@implementation UIImage (LEAF)

- (UIImage *) imageMaskedWithColor : (UIColor *) maskColor {
    NSParameterAssert(maskColor != nil);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *) crossScaleToSize : (CGSize) size {
    return [[self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height * 0.5f - 0.5f, self.size.width * 0.5f - 0.5f, self.size.height * 0.5f - 0.5f, self.size.width * 0.5f - 0.5f) resizingMode:UIImageResizingModeStretch] scaleToSize:size];
}

- (UIImage *) scaleToSize : (CGSize) size capInsets : (UIEdgeInsets) capInsets {
    return [[self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] scaleToSize:size];
}

- (UIImage *) scaleToSize : (CGSize) size {
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(1.0f, 1.0f, size.width - 2.0f, size.height - 2.0f)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *) blurImageWithBlurLevel : (CGFloat) blur {
    blur = blur < 0.0f || blur > 1.0f ? 0.5f : blur;
    blur = blur * 100;
    CGSize boxSize = CGSizeMake(blur, blur);
    return [self blurImageWithBlurBoxSize:boxSize];
}

- (UIImage *) blurImageWithBlurBoxSize : (CGSize) boxSize {
    int width = ceilf(boxSize.width);
    width = width - (width % 2) + 1;
    int height = ceilf(boxSize.height);
    height = height - (height % 2) + 1;
    vImagePixelCount pixelWidth = CGImageGetWidth(self.CGImage);
    vImagePixelCount pixelHeight = CGImageGetHeight(self.CGImage);
    size_t rowBytes = CGImageGetBytesPerRow(self.CGImage);
    vImage_Buffer inBuffer, outBuffer;
    inBuffer.width = pixelWidth;
    inBuffer.height = pixelHeight;
    inBuffer.rowBytes = rowBytes;
    outBuffer.width = pixelWidth;
    outBuffer.height = pixelHeight;
    outBuffer.rowBytes = rowBytes;
    vImage_Error error;
    void * pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(self.CGImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc( rowBytes * pixelHeight );
    if ( pixelBuffer == NULL ) {
        NSLog(@">>ERROR : <blurImageWithBlurBoxSize> NO pixelBuffer !");
        CFRelease(inBitmapData);
        return nil;
    }
    outBuffer.data = pixelBuffer;
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, height, width, NULL, kvImageEdgeExtend);
    if ( error ) {
        CFRelease(inBitmapData);
        NSLog(@">>ERROR : <blurImageWithBlurBoxSize> error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, bitmapInfo);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage * returnImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    return returnImage;
}

- (UIImage *) catImageFromRect : (CGRect) rect {
    CGImageRef img = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage * returnImage = [UIImage imageWithCGImage:img];
    CFRelease(img);
    return returnImage;
}

+ (UIImage *) imageFromView : (UIView *) view catRect : (CGRect) rect {
    UIGraphicsBeginImageContext(view.layer.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage * returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [returnImage catImageFromRect:rect];
}

+ (UIImage *) imageFromView : (UIView *) view catRect : (CGRect) rect opaque : (BOOL) opaque scale : (CGFloat) scale {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage * returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    rect.origin.x = rect.origin.x * scale;
    rect.origin.y = rect.origin.y * scale;
    rect.size.width = rect.size.width * scale;
    rect.size.height = rect.size.height * scale;
    return [returnImage catImageFromRect:rect];
}

- (UIImage *) equalizationImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8 * data = (UInt8*)CGBitmapContextGetData(bmContext);
    if ( !data ) {
        CGContextRelease(bmContext);
        return nil;
    }
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {data, height, width, bytesPerRow};
    vImageEqualization_ARGB8888(&src, &dest, kvImageNoFlags);
    CGImageRef destImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* destImage = [UIImage imageWithCGImage:destImageRef];
    CGImageRelease(destImageRef);
    CGContextRelease(bmContext);
    return destImage;
}

- (UIImage *) edgeDetectionImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if ( !data ) {
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, edgedetect_kernel, 3, 3, 1, backgroundColorBlack, kvImageCopyInPlace);
    memcpy(data, outt, n);
    CGImageRef edgedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* edged = [UIImage imageWithCGImage:edgedImageRef];
    CGImageRelease(edgedImageRef);
    free(outt);
    CGContextRelease(bmContext);
    return edged;
}

- (UIImage *) embossImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, emboss_kernel, 3, 3, 1, NULL, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    CGImageRef embossImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* emboss = [UIImage imageWithCGImage:embossImageRef];
    CGImageRelease(embossImageRef);
    CGContextRelease(bmContext);
    return emboss;
}

- (UIImage *) sharpenImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, sharpen_kernel, 3, 3, 1, NULL, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    CGImageRef sharpenedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* sharpened = [UIImage imageWithCGImage:sharpenedImageRef];
    CGImageRelease(sharpenedImageRef);
    CGContextRelease(bmContext);
    return sharpened;
}

- (UIImage *) unSharepenImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, unsharpen_kernel, 3, 3, 9, NULL, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    CGImageRef unsharpenedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* unsharpened = [UIImage imageWithCGImage:unsharpenedImageRef];
    CGImageRelease(unsharpenedImageRef);
    CGContextRelease(bmContext);
    return unsharpened;
}

- (UIImage *) rotateImageByRadius : (CGFloat) radius {
    if (!(&vImageRotate_ARGB8888)) return nil;
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {data, height, width, bytesPerRow};
    Pixel_8888 bgColor = {0, 0, 0, 0};
    vImageRotate_ARGB8888(&src, &dest, NULL, radius, bgColor, kvImageBackgroundColorFill);
    CGImageRef rotatedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* rotated = [UIImage imageWithCGImage:rotatedImageRef];
    CGImageRelease(rotatedImageRef);
    CGContextRelease(bmContext);
    return rotated;
}

- (UIImage *) rotateImageByRadius : (CGFloat) radius isExpand : (BOOL) isExpand {
    CGSize imgSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGSize outputSize = imgSize;
    if ( isExpand ) {
        CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(radius));
        outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radius);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [self drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *) dilateImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageDilate_ARGB8888(&src, &dest, 0, 0, morphological_kernel, 3, 3, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    CGImageRef dilatedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* dilated = [UIImage imageWithCGImage:dilatedImageRef];
    CGImageRelease(dilatedImageRef);
    CGContextRelease(bmContext);
    return dilated;
}

- (UIImage *) dilateWithIterations : (int) iterations {
    UIImage *dstImage = self;
    for (int i=0; i<iterations; i++) {
        dstImage = [dstImage dilateImage];
    }
    return dstImage;
}

- (UIImage *) erodeImage {
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageErode_ARGB8888(&src, &dest, 0, 0, morphological_kernel, 3, 3, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    CGImageRef erodedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* eroded = [UIImage imageWithCGImage:erodedImageRef];
    CGImageRelease(erodedImageRef);
    CGContextRelease(bmContext);
    return eroded;
}

- (UIImage *) erodeWithIterations : (int) iterations {
    UIImage *dstImage = self;
    for (int i=0; i<iterations; i++) {
        dstImage = [dstImage erodeImage];
    }
    return dstImage;
}

- (UIImage *) gradientWithIterations : (int) iterations {
    UIImage *dilated = [self dilateWithIterations:iterations];
    UIImage *eroded = [self erodeWithIterations:iterations];
    UIImage *dstImage = [dilated imageBlendedWithImage:eroded blendMode:kCGBlendModeDifference alpha:1.0];
    return dstImage;
}

- (UIImage *) tophatWithIterations : (int) iterations {
    UIImage *dilated = [self dilateWithIterations:iterations];
    UIImage *dstImage = [self imageBlendedWithImage:dilated blendMode:kCGBlendModeDifference alpha:1.0];
    return dstImage;
}

- (UIImage *) blackhatWithIterations : (int) iterations {
    UIImage *eroded = [self erodeWithIterations:iterations];
    UIImage *dstImage = [eroded imageBlendedWithImage:self blendMode:kCGBlendModeDifference alpha:1.0];
    return dstImage;
}

- (UIImage *) imageBlendedWithImage : (UIImage *) overlayImage blendMode : (CGBlendMode) blendMode alpha : (CGFloat) alpha {
    UIGraphicsBeginImageContext(self.size);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:rect];
    [overlayImage drawAtPoint:CGPointMake(0, 0) blendMode:blendMode alpha:alpha];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blendedImage;
}

- (UIImage *) blurLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self blurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *) blurDarkEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self blurWithRadius:15 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *) blurTintEffectWithColor:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self blurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}

- (UIImage *) blurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    // check pre-conditions
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            } else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // set up output context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    // draw base image
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    // draw effect image
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // add in color tint
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // output image is ready
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

+ (UIImage *) imageWithColor : (UIColor *) color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) imageWithColor : (UIColor *) color size : (CGSize) size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
