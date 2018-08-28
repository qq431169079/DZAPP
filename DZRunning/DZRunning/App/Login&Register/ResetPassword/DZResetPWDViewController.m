//
//  HMDRecoveredPWDViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "DZResetPWDViewController.h"
#import "DZPredicate.h"
@interface DZResetPWDViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;//账号输入
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;//密码输入
@property (weak, nonatomic) IBOutlet UITextField *makesurePWDTextField;//密码输入二次确认
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;//验证码
//@property (nonatomic,strong) HMDRegisterDao *registerDao;
@property (weak, nonatomic) IBOutlet UIButton *dynamicCodeBtn;
/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *makesureBtn;
@property (nonatomic,strong) NSString *sms;                 //验证码
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdTopConstraint;

@end

@implementation DZResetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

    [self endTimer];
}
#pragma mark - 初始化
-(void)setupUI{
    if (self.resetPWD) {
        self.title = @"修改密码";
//        self.pwdTopConstraint.priority = 200;
    }else{
        self.title = @"忘记密码";
//        [self setupFirstNavBar];
    }

}
#pragma mark - 点击
//获取验证码
- (IBAction)getVerificationCode:(id)sender {
    //判断手机号码位数
    NSString *phoneNum = self.phoneNumTextField.text;
    if ([DZPredicate checkTelNumber:phoneNum]) {
        [self requestResetPWDCode];
        [self startTimer];
    }else{
        occasionalHint(@"请输入正确的手机号");
    }
    
}
- (IBAction)changepwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = sender.selected;
}
- (IBAction)changeMakesurepwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.makesurePWDTextField.secureTextEntry = sender.selected;
}
//确定

- (IBAction)recoverPWD:(id)sender {
    //先判断
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *pwd = self.pwdTextField.text;
    if (self.resetPWD) {
        //修改密码
        if (![pwd isEqualToString:self.makesurePWDTextField.text]){
            occasionalHint(@"两次输入的密码不一致");
        } else{
            [self requestResetPWD];
        }
    }else{
        //忘记密码
        if (![DZPredicate checkTelNumber:phoneNum]) {
            occasionalHint(@"请输入正确的手机号");
        }else if (![DZPredicate checkPassword:pwd]){
            occasionalHint(@"密码必须为6-18位数字或字母");
        }else if (self.verificationCodeTextField.text.length <1){
            occasionalHint(@"验证码错误");
        }else if (![pwd isEqualToString:self.makesurePWDTextField.text]){
            occasionalHint(@"两次输入的密码不一致");
        } else{
            [self requestResetPWD];
        }
    }
}

#pragma mark - 网络
-(void)requestResetPWD{
    DZWeakSelf(self)
        //本地处理验证码
        NSString *sms = self.verificationCodeTextField.text;
        if ([sms isEqualToString:self.sms]) {
            NSDictionary *params = @{@"userName":self.phoneNumTextField.text, @"password":self.pwdTextField.text};
            [DZRequests post:@"resetPWD" parameters:params success:^(id record) {
                if ([record isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *recordDict = (NSDictionary *)record;
                    if ([[recordDict allKeys] containsObject:@"message"]) {
                        occasionalHint(recordDict[@"message"]);
                    }
                    if ([[recordDict allKeys]containsObject:@"success"]) {
                        //退出
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            } failure:^(HPRequestsError type, NSError *error) {
                occasionalHint(error.localizedDescription);
            }];
        }else{
            occasionalHint(@"验证码错误");
        }

}

-(void)requestResetPWDCode{
    DZWeakSelf(self)
        self.sms = nil;
        NSDictionary *params = @{@"userName":self.phoneNumTextField.text};
        [DZRequests post:@"resetPWDCode" parameters:params success:^(id record) {
            if ([record isKindOfClass:[NSDictionary class]]) {
                NSDictionary *recordDict = (NSDictionary *)record;
                if ([[recordDict allKeys] containsObject:@"message"] && [[recordDict allKeys] containsObject:@"sms"]) {
                    occasionalHint(recordDict[@"message"]);
                    NSString *sms = recordDict[@"sms"];
                    self.sms = sms;
                    NSLog(@"%@",sms);
                }

            }
        } failure:^(HPRequestsError type, NSError *error) {
            occasionalHint(error.localizedDescription);
            [weakSelf endTimer];
        }];

}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 其他
-(void)startTimer{
    self.dynamicCodeBtn.enabled = NO;
    [self.dynamicCodeBtn setTitle:@"59s后重新获取" forState:UIControlStateDisabled];
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(countDown:) userInfo:[NSDate date] repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//倒计时
-(void)countDown:(NSTimer *)timer{
    NSDate *curDate = timer.fireDate;
    NSDate *startDate = timer.userInfo;
    NSTimeInterval timeInterval = [curDate timeIntervalSinceDate:startDate];
    NSInteger showTime = 60-timeInterval;
    if (showTime<=0) {
        [self endTimer];
        
    }else{
        NSString *showString = [NSString stringWithFormat:@"%lds后重新获取",showTime];
        [self.dynamicCodeBtn setTitle:showString forState:UIControlStateDisabled];
    }
    
    
}
-(void)endTimer{
    self.dynamicCodeBtn.enabled = YES;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//#pragma mark - 懒加载
//-(HMDRegisterDao *)registerDao{
//    if (_registerDao == nil) {
//        _registerDao = [[HMDRegisterDao alloc] init];
//    }
//    return _registerDao;
//}
@end
