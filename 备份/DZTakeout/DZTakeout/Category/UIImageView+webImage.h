//
//  UIImageView+webImage.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (webImage)
-(void)DZ_setImageWithURL:(NSString *)urlStr placeholderImage:(UIImage *)placeholderImage;
@end
