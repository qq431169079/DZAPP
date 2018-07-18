//
//  HPCoverView.h
//  MyPractice
//
//  Created by huangpan on 16/7/15.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** --------------------------------------------------
 *  遮罩视图，提供一个contentSize
 ** --------------------------------------------------
 */

@interface HPCoverView : UIView

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIButton *cancelButton;

+ (instancetype)viewWithFrame:(CGRect)frame;
- (void)initParameters;

- (void)didClickCancelButtonAction;
- (void)showInView:(UIView *)view;
- (void)hide;
@end
