//
//  UIImageView+webImage.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "UIImageView+webImage.h"
#import <UIImageView+WebCache.h>
@implementation UIImageView (webImage)

-(void)DZ_setImageWithURL:(NSString *)urlStr placeholderImage:(UIImage *)placeholderImage{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage];
}
@end
