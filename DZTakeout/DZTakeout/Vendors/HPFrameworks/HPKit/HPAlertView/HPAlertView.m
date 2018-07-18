//
//  HPAlertView.m
//  MyPractice
//
//  Created by huangpan on 16/7/18.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPAlertView.h"
#import "UIView+HPUtil.h"
#import "Pop.h"

@interface HPAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messLabel;
@property (nonatomic, strong) NSMutableArray *btnsArray;
@property (nonatomic, copy) void (^clickBlock)(NSUInteger index);
@property (nonatomic, copy) void (^hiddenBlock)(void);
@end

@implementation HPAlertView
#pragma mark - Life cycle
- (void)dealloc {
    _delegate = nil;
    _clickBlock = nil;
    [self removeNotifications];
}

#pragma mark - Init
- (void)initParameters {
    [super initParameters];
    //
    _expectedIndex = -1;
    _titleHeight = 3.0f;
    _titleVerticalGap = 8.0f;
    _titleBottomToMessGap = 20.0f;
    _messHeight = 65.0f;
    _messBottomToButtonGap = 20.0f;
    _btnHeight = 50.0f;
    _maxHorizontalBtns = 2;
    _edgeInsets = UIEdgeInsetsZero;
    _textHorizontalIndention = 28.0f;
    _firstLineIndent = NO;
    _btnsArray = [NSMutableArray array];
    
    [self initTitleLabel];
    [self initMessLabel];
    [self setUpNotifications];
    
}

- (void)initTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_edgeInsets.left + self.cancelButton.width, _edgeInsets.top, self.contentView.bounds.size.width - _edgeInsets.left - _edgeInsets.right - 2 * self.cancelButton.width, _titleHeight)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];//[XYTheme fontWithSize:18.0f];
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)initMessLabel {
    _messLabel = [[UILabel alloc] initWithFrame:CGRectMake(_edgeInsets.left, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + _titleBottomToMessGap, self.contentView.size.width - _edgeInsets.left - _edgeInsets.right, _messHeight)];
    _messLabel.textAlignment = NSTextAlignmentCenter;
    _messLabel.textColor = [UIColor darkGrayColor];
    _messLabel.font = [UIFont systemFontOfSize:17.0f];//[XYTheme fontWithSize:16.0f];
    _messLabel.numberOfLines = 0;
    _messLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _messLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
}

- (void) relayoutViews {
    CGFloat titleLabelHeight = ceil([self calculateStringSize:self.titleLabel.text width:self.contentView.bounds.size.width - _edgeInsets.left - _edgeInsets.right - 2 * self.cancelButton.frame.size.width font:self.titleLabel.font].height);
    titleLabelHeight = titleLabelHeight <= _titleHeight ? _titleHeight : titleLabelHeight;
    if ( titleLabelHeight > _titleHeight ) {
        titleLabelHeight = titleLabelHeight + 2 * _titleVerticalGap;
    }
    _titleLabel.frame = CGRectMake(_edgeInsets.left, _edgeInsets.top, self.contentView.bounds.size.width - _edgeInsets.left - _edgeInsets.right, titleLabelHeight);
    [self.contentView addSubview:self.titleLabel];
    [self.contentView bringSubviewToFront:self.cancelButton];
    
    CGFloat messLabelHeight = [self calculateStringSize:self.messLabel.text width:self.contentView.size.width - _edgeInsets.left - _edgeInsets.right - 2 * _textHorizontalIndention font:self.messLabel.font].height + 1.0f;
    messLabelHeight = messLabelHeight <= _messHeight ? _messHeight : messLabelHeight;
    
    self.messLabel.frame = CGRectMake(_edgeInsets.left + _textHorizontalIndention, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + _titleBottomToMessGap, self.contentView.size.width - _edgeInsets.left - _edgeInsets.right - 2 * _textHorizontalIndention, messLabelHeight);
    [self.contentView addSubview:self.messLabel];
    
    CGFloat bottomOffset = self.messLabel.frame.origin.y + self.messLabel.frame.size.height;
    bottomOffset = self.btnsArray.count > 0 ? bottomOffset + self.messBottomToButtonGap : bottomOffset;
    if ( self.btnsArray.count > 0 && self.btnsArray.count > _maxHorizontalBtns ) {
        CGFloat btnWidth = self.contentView.size.width - _edgeInsets.left - _edgeInsets.right;
        for ( UIButton * button in self.btnsArray ) {
            button.frame = CGRectMake(_edgeInsets.left, bottomOffset, btnWidth, _btnHeight);
            bottomOffset = bottomOffset + _btnHeight - 0.5f;
            [self.contentView addSubview:button];
        }
    } else if ( self.btnsArray.count > 0 && self.btnsArray.count <= _maxHorizontalBtns ) {
        CGFloat btnWidth = (self.contentSize.width - _edgeInsets.left - _edgeInsets.right) / self.btnsArray.count;
        CGFloat xOffset = _edgeInsets.left;
        for ( UIButton * button in self.btnsArray ) {
            button.frame = CGRectMake(xOffset, bottomOffset, (xOffset == _edgeInsets.left) ? btnWidth : btnWidth + 0.5f, _btnHeight);
            [self.contentView addSubview:button];
            xOffset = xOffset + btnWidth - 0.5f;
        }
        bottomOffset = bottomOffset + _btnHeight;
    }
    bottomOffset = bottomOffset + _edgeInsets.bottom;
    
    self.contentView.frame = CGRectMake((self.frame.size.width - self.contentSize.width) * 0.5f, (self.frame.size.height - bottomOffset) * 0.5f, self.contentSize.width, bottomOffset);
    self.cancelButton.frame = CGRectMake(self.contentView.bounds.size.width - 32.0f, 0.0f, 32.0f, 32.0f);
    [self.contentView addSubview:self.cancelButton];
}

#pragma mark - Public API

- (void) setMaxHorizontalBtns:(NSInteger)maxHorizontalBtns {
    _maxHorizontalBtns = maxHorizontalBtns <= 0 ? 1 : _maxHorizontalBtns;
}

- (UIButton *) itemButtonWithTitle : (NSString *) title index : (NSInteger) index {
    UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn setTitleColor:self.expectedIndex == index ? NAV_FGC : [UIColor whiteColor]
                  forState:UIControlStateNormal];
    [itemBtn setTitleColor:COLOR_HEX(0x848484) forState:UIControlStateHighlighted];
    itemBtn.tag = index;
    //Layer
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    itemBtn.layer.borderWidth = 0.5f;
    itemBtn.layer.borderColor = NAV_FGC.CGColor;
    itemBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if ( _delegate && [_delegate respondsToSelector:@selector(alertView:didCreateButton:atIndex:isExpected:)] ) {
        itemBtn = [_delegate alertView:self.identifier didCreateButton:itemBtn atIndex:index isExpected:index == _expectedIndex];
    }
    //
    [itemBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [itemBtn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    [itemBtn addTarget:self action:@selector(touchUpOutSide:) forControlEvents:UIControlEventTouchDragOutside];
    return itemBtn;
}

#pragma mark - Event Handle
- (void)touchDown:(UIButton *)sender {
    sender.backgroundColor = COLOR_HEX(0xe7e7e7);
}

- (void)touchUp:(UIButton *)sender {
    sender.backgroundColor = [UIColor whiteColor];
    if ( _delegate && [_delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:)] ) {
        [_delegate alertView:self.identifier didClickButtonAtIndex:sender.tag];
    }
    if ( self.clickBlock ) {
        self.clickBlock(sender.tag);
    }
    [self hide];
}


- (void) touchUpOutSide : (UIButton *) sender {
    sender.backgroundColor = [UIColor whiteColor];
}

- (void) didClickCancelBtnAction {
    if ( _delegate && [_delegate respondsToSelector:@selector(coverViewDidClickCancelButtonWithIdentifier:)] ) {
        [_delegate coverViewDidClickCancelButtonWithIdentifier:self.identifier];
    }
}

- (BOOL)preparedWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex buttonsTitle:(NSString *)btn1, ... NS_REQUIRES_NIL_TERMINATION {
    [self.contentView removeAllSubviews];
    [_btnsArray removeAllObjects];
    
    self.titleLabel.text = title;
    self.messLabel.text = _firstLineIndent ? mess : [NSString stringWithFormat:@"  %@",mess ? : @""];
    self.expectedIndex = expectedIndex;
    
    va_list arguments;
    id eachObject;
    if (btn1) {
        NSInteger index = 0;
        [_btnsArray addObject:[self itemButtonWithTitle:btn1 index:index]];
        va_start(arguments, btn1);
        while ( (eachObject = va_arg(arguments, id)) ) {
            index ++;
            [_btnsArray addObject:[self itemButtonWithTitle:eachObject index:index]];
        }
        va_end(arguments);
    }
    [self relayoutViews];
    return YES;
}

- (BOOL)preparedWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex buttonsTitleArray:(NSArray *)btnTitlesArray {
    [self.contentView removeAllSubviews];
    [_btnsArray removeAllObjects];
    
    self.titleLabel.text = title;
    self.messLabel.text = _firstLineIndent ? mess : [NSString stringWithFormat:@"  %@", mess ? : @""];
    self.expectedIndex = expectedIndex;
    NSInteger index = 0;
    for (NSString *title in btnTitlesArray) {
        [_btnsArray addObject:[self itemButtonWithTitle:title index:index]];
        index ++;
    }
    [self relayoutViews];
    return YES;
}

- (void)showInView:(UIView *)view withBlock:(void (^)(NSUInteger))clickBlock {
    [self showInView:view];
    self.clickBlock = clickBlock;
}

- (void)hide {
    [UIView animateWithDuration:0.15f animations:^{
        self.contentView.layer.transform = CATransform3DMakeRotation(-0.1f, 0, 0, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundImageView.alpha = 0.2f;
            self.contentView.center = CGPointMake(self.contentView.centerX, self.height + self.contentView.height * 0.5f);
        } completion:^(BOOL finished) {
            self.contentView.layer.transform = CATransform3DIdentity;
            self.contentView.center = CGPointMake(self.contentView.center.x, self.bounds.size.height * 0.5f);
            self.backgroundImageView.alpha = 1.0f;
            [self removeFromSuperview];
            if ( self.hiddenBlock ) self.hiddenBlock();
        }];
    }];
}

#pragma mark - Notifications
- (void) setUpNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void) removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) handleKeyboardWillShow : (NSNotification *) notif {
    CGRect rect = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = [self convertRect:rect toView:nil].size;
    NSTimeInterval time = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self keyboardWillShowWithSize:size
                          duration:time];
}

- (void) handleKeyboardWillHide : (NSNotification *) notif {
    CGRect rect = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = [self convertRect:rect toView:nil].size;
    NSTimeInterval time = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self keyboardWillHideWithSize:size
                          duration:time];
}

- (void) keyboardWillShowWithSize : (CGSize) size
                         duration : (NSTimeInterval) time {
    CGFloat newCenterY = SCREEN_HEIGHT * 0.5f - size.height * 0.5f;
    POPSpringAnimation * anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.contentView.centerX, newCenterY)];
    [self.contentView pop_addAnimation:anim forKey:@"MOVING"];
    
}

- (void) keyboardWillHideWithSize : (CGSize) size
                         duration : (NSTimeInterval) time {
    CGFloat newCenterY = SCREEN_HEIGHT * 0.5f;
    POPSpringAnimation * anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.contentView.centerX, newCenterY)];
    [self.contentView pop_addAnimation:anim forKey:@"MOVING"];
}

#pragma mark - 类方法
+ (void)showAlertViewWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex actionBlock:(void (^)(NSUInteger))actionBlock butttonsTitle:(id)btn1, ...NS_REQUIRES_NIL_TERMINATION  {
    NSMutableArray *btnsArray = [NSMutableArray array];
    va_list arguments;
    id eachObject;
    if (btn1) {
        NSInteger index = 0;
        [btnsArray addObject:btn1];
        va_start(arguments, btn1);
        while ( (eachObject = va_arg(arguments, id)) ) {
            index ++;
            [btnsArray addObject:eachObject];
        }
        va_end(arguments);
    }
    [self showAlertViewWithTitle:title mess:mess expectedIndex:expectedIndex buttonsTitle:btnsArray actionBlock:actionBlock];
}

+ (void)showAlertWithMess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex actionBlock:(void (^)(NSUInteger))actionBlock buttonsTitle:(id)btn1, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *btnsArray = [NSMutableArray array];
    va_list arguments;
    id eachObject;
    if ( btn1 ) {
        NSInteger index = 0;
        [btnsArray addObject:btn1];
        va_start(arguments, btn1);
        while ( (eachObject = va_arg(arguments, id)) ) {
            index ++;
            [btnsArray addObject:eachObject];
        }
        va_end(arguments);
    }
    [self showAlertViewWithTitle:nil mess:mess expectedIndex:expectedIndex buttonsTitle:btnsArray actionBlock:actionBlock];
}

+ (void)showAlertViewWithTitle:(NSString *)title mess:(NSString *)mess expectedIndex:(NSInteger)expectedIndex buttonsTitle:(NSArray *)titlesArray actionBlock:(void (^)(NSUInteger))actionBlock {
    static dispatch_semaphore_t semaphore = nil;
    if (semaphore == nil) semaphore = dispatch_semaphore_create(1);
    void (^hiddenBlock)(void) = ^() {
        dispatch_semaphore_signal(semaphore);
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            HPAlertView * alertView = [HPAlertView viewWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
            alertView.hiddenBlock = hiddenBlock;
            alertView.cancelButton.hidden = YES;
            alertView.titleLabel.backgroundColor = NAV_FGC;
            alertView.titleLabel.textColor = [UIColor whiteColor];
            alertView.messLabel.textColor = COLOR_HEX(0x333333);
            alertView.contentView.backgroundColor = COLOR_HEX(0xffffff);
            alertView.firstLineIndent = YES;
            [alertView preparedWithTitle:title mess:mess expectedIndex:expectedIndex buttonsTitleArray:titlesArray];
            [alertView showInView:[UIApplication sharedApplication].keyWindow withBlock:actionBlock];
        });
    });
}

#pragma mark - Helper
- (CGSize) calculateStringSize : (NSString *) inputString width : (CGFloat) width font : (UIFont *) font {
    if ( inputString && inputString.length > 0 ) {
        return [inputString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName : font}
                                         context:nil].size;
    } else {
        return CGSizeZero;
    }
}
@end
