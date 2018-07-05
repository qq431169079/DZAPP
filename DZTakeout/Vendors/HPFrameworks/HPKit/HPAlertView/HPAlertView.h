//
//  HPAlertView.h
//  MyPractice
//
//  Created by huangpan on 16/7/18.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPCoverView.h"

@protocol HPAlertViewDelegate <NSObject>

@optional
/**
 *  用户点击了按钮
 *
 *  @param alertViewIdentifier identifier
 *  @param index               按钮序号
 */
- (void)alertView:(NSString *)alertViewIdentifier didClickButtonAtIndex:(NSInteger)index;
/**
 *  用户点击了退出
 *
 *  @param identifier identifier
 */
- (void)coverViewDidClickCancelButtonWithIdentifier:(NSString *)identifier;
/**
 *  返回button，不需要设置按钮title，可以更改
 *
 *  @param alertViewIdentifier identifier
 *  @param button              当前生成的按钮
 *  @param index               按钮序号
 */
- (UIButton *)alertView:(NSString *)alertViewIdentifier didCreateButton:(UIButton *)button atIndex:(NSInteger)index isExpected:(BOOL)isExpected;
@end

/** --------------------------------------------------------
 *  弹窗
 ** --------------------------------------------------------
 */
@interface HPAlertView : HPCoverView

@property (nonatomic, weak) id<HPAlertViewDelegate> delegate;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleVerticalGap;
@property (nonatomic, assign) CGFloat titleBottomToMessGap;
@property (nonatomic, assign) CGFloat messHeight;
@property (nonatomic, assign) CGFloat messBottomToButtonGap;
@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, assign) NSInteger maxHorizontalBtns; // 一行显示多少个button
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) BOOL firstLineIndent; // 首行缩进
@property (nonatomic, assign) CGFloat textHorizontalIndention;// 文字显示范围
@property (nonatomic, assign) NSInteger expectedIndex;// 期待被选中的按钮需要，-1表示没有期待

- (UILabel *)titleLabel;
- (UILabel *)messLabel;

- (BOOL)preparedWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex buttonsTitle:(NSString *)btn1, ...NS_REQUIRES_NIL_TERMINATION;

- (BOOL)preparedWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex buttonsTitleArray:(NSArray *)btnTitlesArray;

- (void)showInView:(UIView *)view withBlock:(void (^)(NSUInteger index))clickBlock;


#pragma mark - 类方法
+ (void)showAlertViewWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex actionBlock:(void (^)(NSUInteger index))actionBlock butttonsTitle:btn1, ...NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertViewWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex buttonsTitle:(NSArray *)titlesArray actionBlock:(void (^)(NSUInteger index))actionBlock;

+ (void)showAlertWithMess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex actionBlock:(void (^)(NSUInteger index))actionBlock buttonsTitle:btn1, ... NS_REQUIRES_NIL_TERMINATION;
@end
