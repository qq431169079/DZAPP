//
//  UIButton+HPUtil.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HPUtil)

@property (nonatomic, copy) NSString *titleOfNormal;
@property (nonatomic, copy) NSString *titleOfDisabled;
@property (nonatomic, copy) NSString *titleOfSelected;
@property (nonatomic, copy) NSString *titleOfHighlighted;

@property (nonatomic, strong) UIColor *titleColorOfNormal;
@property (nonatomic, strong) UIColor *titleColorOfDisabled;
@property (nonatomic, strong) UIColor *titleColorOfSelected;
@property (nonatomic, strong) UIColor *titleColorOfHighlighted;

@property (nonatomic, strong) UIColor *backgroudColorOfNormal;
@property (nonatomic, strong) UIColor *backgroudColorOfDisabled;
@property (nonatomic, strong) UIColor *backgroudColorOfSelected;
@property (nonatomic, strong) UIColor *backgroudColorOfHighlighted;

@property (nonatomic, strong) UIImage *backgroudImageOfNormal;
@property (nonatomic, strong) UIImage *backgroudImageOfDisabled;
@property (nonatomic, strong) UIImage *backgroudImageOfSelected;
@property (nonatomic, strong) UIImage *backgroudImageOfHighlighted;

@property (nonatomic, strong) UIImage *imageOfNormal;
@property (nonatomic, strong) UIImage *imageOfDisabled;
@property (nonatomic, strong) UIImage *imageOfSelected;
@property (nonatomic, strong) UIImage *imageOfHighlighted;

@end
