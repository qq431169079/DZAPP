//
//  DZSeatSelectionView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/7.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSeatSelectionView.h"
#import "JXAlertview.h"
#import "CustomDayDatePicker.h"
#import "FoodsOrderViewController.h"
@interface DZSeatSelectionView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *companyIconImageView;//店铺图标
@property (weak, nonatomic) IBOutlet UILabel *depositLab;//押金金额
@property (weak, nonatomic) IBOutlet UILabel *seatInfoLab;//选中的座位信息
@property (weak, nonatomic) IBOutlet UILabel *personNumLab; //顾客数
@property (assign, nonatomic) NSInteger personNum; //顾客数
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;//电话
@property (weak, nonatomic) IBOutlet UIView *phoneNumBGView;

@property (weak, nonatomic) IBOutlet UIView *timeChoiceView;//预约时间
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet CustomDayDatePicker *datePickView;
@property (weak, nonatomic) IBOutlet UIView *mainView;      //白色背景界面
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *minuteLab;

@property (assign, nonatomic) NSInteger maxMeals;           //最大人数
@property (assign, nonatomic) NSInteger minMeals;           //最少人数
@property (strong, nonatomic) NSString *price;                //价格

@property (nonatomic, copy) void(^keyboardShowBlock)(CGRect keyboardFrameEnd);
@property (nonatomic, copy) void(^keyboardHideBlock)(void);
@end
@implementation DZSeatSelectionView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupBaseUI];
        [self setNotificationCenter];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupBaseUI];
    [self setNotificationCenter];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setupBaseUI{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeCurView:)];
    [self.closeView addGestureRecognizer:tapGestureRecognizer];
    
    self.personNum = 1;
    UITapGestureRecognizer *mainViewtapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewTapGR:)];
    [self.mainView addGestureRecognizer:mainViewtapGR];
    
    UITapGestureRecognizer *changeTimetapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTimetapGR:)];
    [self.timeChoiceView addGestureRecognizer:changeTimetapGR];
    DZWeakSelf(self)
    self.datePickView.didSelectFinishBlock = ^(int day, int hour, int minute) {
        [weakSelf setupChoiceTimeWithDay:day
                                    hour:hour
                                  minute:minute];
    };
    

    self.keyboardHideBlock = ^{
        weakSelf.phoneNumBGView.transform = CGAffineTransformIdentity;
        [weakSelf.phoneNumTextField resignFirstResponder];
    };
    self.keyboardShowBlock = ^(CGRect keyboardFrameEnd){
        CGRect textFieldRect = weakSelf.phoneNumBGView.frame;
        CGRect mainViewRect = [weakSelf.phoneNumBGView.superview convertRect:textFieldRect toView:weakSelf];
        CGFloat offsetY = keyboardFrameEnd.origin.y - CGRectGetMaxY(mainViewRect);
        weakSelf.phoneNumBGView.transform = CGAffineTransformTranslate(weakSelf.phoneNumBGView.transform, 0, offsetY);
    };
}

//通知
-(void)setNotificationCenter{
    // 添加通知监听见键盘弹出/退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - UI

-(void)reloadUIWithSeatInfo:(NSDictionary *)infoDict{
    //5分钟后
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5*60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //时间
    [formatter setDateFormat:@"dd"];
    int day = [[formatter stringFromDate:date] intValue];
    [formatter setDateFormat:@"HH"];
    int hour = [[formatter stringFromDate:date] intValue];
    [formatter setDateFormat:@"mm"];
    int minute = [[formatter stringFromDate:date] intValue];
    
    [self setupChoiceTimeWithDay:day hour:hour minute:minute];
    NSArray *infoDictAllKeys = [infoDict allKeys];
    if ([infoDictAllKeys containsObject:@"price"]) {
        self.price = infoDict[@"price"];
        self.depositLab.text = [NSString stringWithFormat:@"¥%@",self.price];
    }
    if ([infoDictAllKeys containsObject:@"logo"]) {
        [self.companyIconImageView DZ_setImageWithURL:infoDict[@"logo"] placeholderImage:nil];
    }
    if ([infoDictAllKeys containsObject:@"seat"]&&[infoDictAllKeys containsObject:@"name"]) {
        NSString *seatInfo = [NSString stringWithFormat:@"已选:%@%@.",infoDict[@"seat"],infoDict[@"name"]];
        self.seatInfoLab.text = seatInfo;
    }
    if ([infoDictAllKeys containsObject:@"meals"]) {
        NSString *meals = infoDict[@"meals"];
        NSArray *mealsInfo = [meals componentsSeparatedByString:@"~"];
        self.minMeals = [[mealsInfo firstObject] integerValue];
        self.maxMeals = [[mealsInfo lastObject] integerValue];
        self.personNum = self.minMeals;
        self.personNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.personNum];
    }

    self.phoneNumTextField.text = [UserHelper userItem].phone;
}
-(void)setupChoiceTimeWithDay:(int)day hour:(int)hour minute:(int)minute{
    self.dayLab.text = [NSString stringWithFormat:@"%02d",day];
    self.hourLab.text = [NSString stringWithFormat:@"%02d",hour];
    self.minuteLab.text = [NSString stringWithFormat:@"%02d",minute];
}
#pragma mark - 点击
-(void)closeCurView:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self closeBtnClick:nil];
}

-(void)mainViewTapGR:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (self.datePickView.hidden == NO) {
        self.datePickView.hidden = YES;
    }
}
-(void)changeTimetapGR:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (self.datePickView.isHidden) {
        self.datePickView.hidden = NO;
    }
}
//减顾客数
- (IBAction)subtractBtnClick:(id)sender {
    self.personNum--;
    if (self.personNum<self.minMeals) {
        self.personNum = self.minMeals;
    }
    self.personNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.personNum];
}
//加顾客数
- (IBAction)addBtnClick:(id)sender {
    self.personNum++;
    if (self.personNum > self.maxMeals) {
        self.personNum = self.maxMeals;
    }
    self.personNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.personNum];
}
//直接点菜
- (IBAction)orderDishesBtnClick:(id)sender {
    //判断手机位数
    NSString *phoneNum = self.phoneNumTextField.text;
    if (HPCheckValue(phoneNum, HPCheckTypePhoneNumber)) {
        if (self.orderDishesBlock) {
            NSString *endTime = [NSString stringWithFormat:@"%@-%@-%@",self.dayLab.text,self.hourLab.text,self.minuteLab.text];
            
            self.orderDishesBlock(endTime,self.personNumLab.text,phoneNum);
        }
    }else{
        occasionalHint(@"请输入正确的手机号");
    }

}
//支付押金
- (IBAction)securityBtnClick:(id)sender {
    //判断手机位数
    NSString *phoneNum = self.phoneNumTextField.text;
    if (HPCheckValue(phoneNum, HPCheckTypePhoneNumber)) {
        if (self.paySecurityBlock) {
            NSString *endTime = [NSString stringWithFormat:@"%@-%@-%@",self.dayLab.text,self.hourLab.text,self.minuteLab.text];
            
            self.paySecurityBlock(endTime,self.personNumLab.text,phoneNum);
        }
    }else{
        occasionalHint(@"请输入正确的手机号");
    }
}
//关闭
- (IBAction)closeBtnClick:(id)sender {
    self.hidden = YES;
}
#pragma mark 通知
-(void)keyboardWillShow:(NSNotification *)info{
    NSDictionary* userInfo = [info userInfo];
    CGRect keyboardFrameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘高度
    
    if (self.keyboardShowBlock) {
        self.keyboardShowBlock(keyboardFrameEnd);
    }
}

-(void)keyboardWillHide:(NSNotification *)info{
    if (self.keyboardHideBlock) {
        self.keyboardHideBlock();
    }
    
}
@end
