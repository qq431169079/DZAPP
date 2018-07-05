//
//  HPIncreaseButton.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPIncreaseButton.h"
#import "NSString+HPUtil.h"

@interface HPIncreaseButton ()<UITextFieldDelegate>
{
    CGFloat _width;     // 控件自身的宽
    CGFloat _height;    // 控件自身的高
}
/** 快速加减定时器*/
@property (nonatomic, strong) NSTimer *timer;
/** 减按钮*/
@property (nonatomic, strong, readwrite) UIButton *decreaseBtn;
/** 加按钮*/
@property (nonatomic, strong, readwrite) UIButton *increaseBtn;
/** 数量展示/输入框*/
@property (nonatomic, strong) UITextField *textField;
@end

@implementation HPIncreaseButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        //整个控件的默认尺寸(和某宝上面的按钮同样大小)
        if (CGRectIsEmpty(frame)) {
            self.frame = CGRectMake(0, 0, 110, 30);
        };
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)increaseButtonWithFrame:(CGRect)frame {
    return [[HPIncreaseButton alloc] initWithFrame:frame];
}

#pragma mark - 设置UI子控件
- (void)setupSubviews {
    self.stepValue = 1;
    _minValue = 1;
    _maxValue = NSIntegerMax;
    _inputFieldFont = 15;
    _buttonTitleFont = 17;
    _longPressSpaceTime = 0.1f;
    
    //加,减按钮
    _increaseBtn = [self creatButton];
    _decreaseBtn = [self creatButton];
    
    //数量展示/输入框
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.font = [UIFont systemFontOfSize:_inputFieldFont];
    if (self.decimalNum) {
        _textField.text = [NSString stringWithFormat:@"%.1f",_minValue];
    }else{
        _textField.text = [NSString stringWithFormat:@"%.f",_minValue];
    }
    
    [self addSubview:_decreaseBtn];
    [self addSubview:_increaseBtn];
    [self addSubview:_textField];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3.f;
    self.backgroundColor = [UIColor whiteColor];
}

//设置加减按钮的公共方法
- (UIButton *)creatButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:_buttonTitleFont];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    return button;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _width =  self.frame.size.width;
    _height = self.frame.size.height;
    _textField.frame = CGRectMake(_height, 0, _width - 2*_height, _height);
    _increaseBtn.frame = CGRectMake(_width - _height, 0, _height, _height);
    
    if (_decreaseHide && _textField.text.floatValue < _minValue) {
        _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
    } else {
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self checkTextFieldNumberWithUpdate];
    [self buttonClickCallBackWithIncreaseStatus:NO];
}

#pragma mark - 加减按钮点击响应
/// 点击: 单击逐次加减,长按连续快速加减
- (void)touchDown:(UIButton *)sender {
    [_textField resignFirstResponder];
    
    if (sender == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_longPressSpaceTime target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_longPressSpaceTime target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

/// 手指松开
- (void)touchUp:(UIButton *)sender { [self cleanTimer]; }

/// 加运算
- (void)increase {
    [self checkTextFieldNumberWithUpdate];
    
    CGFloat number = [_textField.text floatValue] +     self.stepValue;
    
    if (number <= _maxValue) {
        // 当按钮为"减号按钮隐藏模式",且输入框值==设定最小值,减号按钮展开
        if (_decreaseHide && number==_minValue) {
            [self rotationAnimationMethod];
            [UIView animateWithDuration:0.3f animations:^{
                _decreaseBtn.alpha = 1;
                _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
            } completion:^(BOOL finished) {
                _textField.hidden = NO;
            }];
        }
        
        if (self.decimalNum) {
            _textField.text = [NSString stringWithFormat:@"%.1f",number];
        }else{
            _textField.text = [NSString stringWithFormat:@"%.f",number];
        }
        
        [self buttonClickCallBackWithIncreaseStatus:YES];
    } else {
        if (_shakeAnimation) { [self shakeAnimationMethod]; } NSLog(@"已超过最大数量%.1f",_maxValue);
    }
}

- (void)setRetract:(BOOL)retract {
    if (retract) {
        [self rotationAnimationMethod];
        [UIView animateWithDuration:0.3f animations:^{
            _decreaseBtn.alpha = 0;
            _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
        } completion:^(BOOL finished) {
            _textField.hidden = YES;
        }];
    } else {
        [self rotationAnimationMethod];
        [UIView animateWithDuration:0.3f animations:^{
            _decreaseBtn.alpha = 1;
            _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
        } completion:^(BOOL finished) {
            _textField.hidden = NO;
        }];
    }
}

/// 减运算
- (void)decrease {
    [self checkTextFieldNumberWithUpdate];
    
    CGFloat number = [_textField.text floatValue] - self.stepValue;
    
    if (number >= _minValue) {
        if (self.decimalNum) {
            _textField.text = [NSString stringWithFormat:@"%.1f",number];
        }else{
            _textField.text = [NSString stringWithFormat:@"%.f",number];
        }
        [self buttonClickCallBackWithIncreaseStatus:NO];
    } else {
        // 当按钮为"减号按钮隐藏模式",且输入框值 < 设定最小值,减号按钮隐藏
        if (_decreaseHide && number<_minValue) {
            _textField.hidden = YES;
            if (self.decimalNum) {
                _textField.text = [NSString stringWithFormat:@"%.1f",_minValue-1];
            }else{
                _textField.text = [NSString stringWithFormat:@"%.f",_minValue-1];
            }
            
            [self buttonClickCallBackWithIncreaseStatus:NO];
            [self rotationAnimationMethod];
            
            [UIView animateWithDuration:0.3f animations:^{
                _decreaseBtn.alpha = 0;
                _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
            }];
            
            return;
        }
        if (_shakeAnimation) { [self shakeAnimationMethod]; } NSLog(@"数量不能小于%.1f",_minValue);
    }
}

/// 点击响应
- (void)buttonClickCallBackWithIncreaseStatus:(BOOL)increaseStatus {
    if (self.numberChangedHandler) {
        self.numberChangedHandler(_textField.text.floatValue, increaseStatus);
    }
    if ([_delegate respondsToSelector:@selector(increaseButton: number:increaseStatus:)]) {
        [_delegate increaseButton:self number:_textField.text.floatValue increaseStatus:increaseStatus];
    }
}

/// 检查TextField中数字的合法性,并修正
- (void)checkTextFieldNumberWithUpdate {
    NSString *minValueString = nil;
    NSString *maxValueString = nil;
    if (self.decimalNum) {
        minValueString = [NSString stringWithFormat:@"%.1f",_minValue];
        maxValueString = [NSString stringWithFormat:@"%.1f",_maxValue];
    }else{
        minValueString = [NSString stringWithFormat:@"%.f",_minValue];
        maxValueString = [NSString stringWithFormat:@"%.f",_maxValue];
    }
    if ([_textField.text isNotBlank] == NO || [_textField.text floatValue] < _minValue) {
        if (self.decimalNum) {
            _textField.text = _decreaseHide ? [NSString stringWithFormat:@"%.1f",minValueString.floatValue-self.stepValue]:minValueString;
        }else{
            _textField.text = _decreaseHide ? [NSString stringWithFormat:@"%.f",minValueString.floatValue-self.stepValue]:minValueString;
        }
    }
    [_textField.text floatValue] > _maxValue ? _textField.text = maxValueString : nil;
}

/// 清除定时器
- (void)cleanTimer {
    if (_timer.isValid) { [_timer invalidate] ; _timer = nil; }
}

#pragma mark - 加减按钮的属性设置
- (void)setDecreaseHide:(BOOL)decreaseHide {
    // 当按钮为"减号按钮隐藏模式(饿了么/百度外卖/美团外卖按钮样式)"
    if (decreaseHide) {
        if (_textField.text.floatValue <= _minValue) {
            _textField.hidden = YES;
            _decreaseBtn.alpha = 0;
            
            
            if (self.decimalNum) {
                _textField.text = [NSString stringWithFormat:@"%.1f",_minValue-1];
            }else{
                _textField.text = [NSString stringWithFormat:@"%.f",_minValue-1];
            }
            
            _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
        }
        self.backgroundColor = [UIColor clearColor];
    } else {
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
    _decreaseHide = decreaseHide;
}

- (void)setEditing:(BOOL)editing{
    _editing = editing;
    _textField.enabled = editing;
}

- (void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
}

- (void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
}

- (void)setStepValue:(CGFloat)stepValue{
    _stepValue = stepValue;
}

- (void)setDecimalNum:(BOOL)decimalNum {
    _decimalNum = decimalNum;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [borderColor CGColor];
    
    _decreaseBtn.layer.borderWidth = 0.5;
    _decreaseBtn.layer.borderColor = [borderColor CGColor];
    
    _increaseBtn.layer.borderWidth = 0.5;
    _increaseBtn.layer.borderColor = [borderColor CGColor];
}

- (void)setButtonTitleFont:(CGFloat)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    _increaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:buttonTitleFont];
    _decreaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:buttonTitleFont];
}

- (void)setIncreaseTitle:(NSString *)increaseTitle {
    _increaseTitle = increaseTitle;
    [_increaseBtn setTitle:increaseTitle forState:UIControlStateNormal];
}

- (void)setDecreaseTitle:(NSString *)decreaseTitle {
    _decreaseTitle = decreaseTitle;
    [_decreaseBtn setTitle:decreaseTitle forState:UIControlStateNormal];
}

- (void)setIncreaseImage:(UIImage *)increaseImage {
    _increaseImage = increaseImage;
    [_increaseBtn setBackgroundImage:increaseImage forState:UIControlStateNormal];
}

- (void)setDecreaseImage:(UIImage *)decreaseImage {
    _decreaseImage = decreaseImage;
    [_decreaseBtn setBackgroundImage:decreaseImage forState:UIControlStateNormal];
}

#pragma mark - 输入框中的内容设置
- (CGFloat)currentNumber { return [_textField.text floatValue]; }

- (void)setCurrentNumber:(CGFloat)currentNumber {
    if (_decreaseHide && currentNumber < _minValue) {
        _textField.hidden = YES;
        _decreaseBtn.alpha = 0;
        _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
    } else {
        _textField.hidden = NO;
        _decreaseBtn.alpha = 1;
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
    
    if (self.decimalNum) {
        _textField.text = [NSString stringWithFormat:@"%.1f",currentNumber];
    }else{
        _textField.text = [NSString stringWithFormat:@"%.f",currentNumber];
    }
    
    [self checkTextFieldNumberWithUpdate];
}

- (void)setInputFieldFont:(CGFloat)inputFieldFont {
    _inputFieldFont = inputFieldFont;
    _textField.font = [UIFont systemFontOfSize:inputFieldFont];
}
#pragma mark - 核心动画
/// 抖动动画
- (void)shakeAnimationMethod {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    CGFloat positionX = self.layer.position.x;
    animation.values = @[@(positionX-10),@(positionX),@(positionX+10)];
    animation.repeatCount = 3;
    animation.duration = 0.07;
    animation.autoreverses = YES;
    [self.layer addAnimation:animation forKey:nil];
}
/// 旋转动画
- (void)rotationAnimationMethod {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = @(M_PI*2);
    rotationAnimation.duration = 0.3f;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [_decreaseBtn.layer addAnimation:rotationAnimation forKey:nil];
}
@end
