//
//  HPBaseViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPBaseViewController.h"
#import "UIViewController+HPUtil.h"
#import <objc/runtime.h>
#import "HPMacro.h"

void _private_hy_swizzle(Class cls, SEL originalSelector) {
    NSString *originalName = NSStringFromSelector(originalSelector);
    NSString *alternativeName = [NSString stringWithFormat:@"_private_hy_swizzled_%@", originalName];
    
    SEL alternativeSelector = NSSelectorFromString(alternativeName);
    
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method alternativeMethod = class_getInstanceMethod(cls, alternativeSelector);
    
    class_addMethod(cls,
                    originalSelector,
                    class_getMethodImplementation(cls, originalSelector),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(cls,
                    alternativeSelector,
                    class_getMethodImplementation(cls, alternativeSelector),
                    method_getTypeEncoding(alternativeMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(cls, originalSelector),
                                   class_getInstanceMethod(cls, alternativeSelector));
}

@implementation UIScrollView (AdaptSystemVersion)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _private_hy_swizzle(self, @selector(initWithFrame:));
    });
}

- (instancetype)_private_hy_swizzled_initWithFrame:(CGRect)frame {
    UIScrollView *scrollView = [self _private_hy_swizzled_initWithFrame:frame];
#ifdef __IPHONE_11_0
    if ([scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            [scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    return scrollView;
}
@end


@implementation UITableView (AdaptSystemVersion)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _private_hy_swizzle(self, @selector(initWithFrame:style:));
    });
}

- (instancetype)_private_hy_swizzled_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    UITableView *tableView = [self _private_hy_swizzled_initWithFrame:frame style:style];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    return tableView;
}
@end


@interface HPBaseViewController ()

@end

@implementation HPBaseViewController
-(void)dealloc{
    NSLog(@"%s------------------------------",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = COLOR_HEX(0xf5f5f5);
    
    [self __setupBackBarButtonItem];
    [self setupData];
    [self setupNavigation];
    [self setupSubviews];
    [self setStatusBarBackgroundColor:RGB(255, 126, 0)];
}

- (void)__setupBackBarButtonItem {
    if ((self.navigationController && self.navigationController.viewControllers.firstObject != self) || self.navigationController.presentingViewController != nil) {
        [self setLeftBarButtonItem:[self barButtonItemWithTitle:nil normalColor:nil highlightColor:nil normalImage:[UIImage imageNamed:@"nav_nav_icon_back_normal"] highlightImage:nil target:self action:@selector(__onPopBackAction)]];
    }
}

- (void)__onPopBackAction {
    [self onReturnBackComplete:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ========== General ==========

/**
 从指定名字的Storyboard文件中, 加载与类名相同的控制器实例
 */
+ (instancetype)instanceFromStoryboard:(NSString *)storyboardFileName {
    HPBaseViewController *vc = [[UIStoryboard storyboardWithName:storyboardFileName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
    NSAssert([vc isKindOfClass:[HPBaseViewController class]], @"从Storyboard加载的控制器并非HPBaseViewController的子类, 请注意检查");
    return vc;
}

// ========== All In One ==========

+ (instancetype)controller {
    return [[self alloc] init];
}

- (void)setupNavigation {
    // 统一方法： 导航初始化
}

- (void)setupSubviews {
    // 统一声明： 子视图初始化
}

- (void)setupData {
    // 统一声明： 变量初始化
}

- (void)onReturnBackComplete:(void (^)(void))complete {
    if (self.navigationController.viewControllers.firstObject == self && self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:complete];
    } else if ( self.navigationController ) {
        [self.navigationController popViewControllerAnimated:YES];
        if (complete) { complete(); }
    } else {
        [self dismissViewControllerAnimated:YES completion:complete];
    }
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
