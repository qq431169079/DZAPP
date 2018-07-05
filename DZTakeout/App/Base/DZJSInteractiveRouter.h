//
//  DZJSInteractiveRouter.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/13.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface NSMutableArray (JSRouter)
- (void)addArg:(JSValue *)arg;
- (void)addArgs:(NSArray<JSValue *>*)args;
@end

@interface DZJSInteractiveRouter : NSObject

+ (__kindof UIViewController *)instanceFromDestn:(NSString *)destn;

+ (__kindof UIViewController *)instanceFromDestn:(NSString *)destn param:(NSString *)param;

+ (__kindof UIViewController *)instanceFromDestn:(NSString *)destn params:(NSArray<NSString *> *)params;

+ (BOOL)nav:(UINavigationController *)nav needsPush:(UIViewController *)destn animated:(BOOL)animated;
@end
