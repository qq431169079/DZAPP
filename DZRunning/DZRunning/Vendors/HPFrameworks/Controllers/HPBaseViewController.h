//
//  HPBaseViewController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBaseViewController : UIViewController

// ========== General ==========

/**
 从指定名字的Storyboard文件中, 加载与类名相同的控制器实例
 */
+ (instancetype)instanceFromStoryboard:(NSString *)storyboardFileName;


// ========== All In One ==========

/**
 统一规定： 使用该方法替换【alloc】 init】实例化操作
 */
+ (instancetype)controller;

/**
 统一规定: 在该方法中配置Navigation的相关操作
 */
- (void)setupNavigation;

/**
 统一规定: 在该方法中为控制器加载子视图
 */
- (void)setupSubviews;

/**
 统一规定: 在该方法中实例化变量(属性)
 */
- (void)setupData;

/**
 返回上级页面
 */
- (void)onReturnBackComplete:(void(^)(void))complete;

@end
