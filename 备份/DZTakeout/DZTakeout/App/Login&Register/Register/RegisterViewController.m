//
//  RegisterViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/7/1.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+HPUtil.h"
#import "HPTool.h"

@interface RegisterViewController () {
@private
    NSString *_mobileValue;
    NSString *_passwordValue;
    NSString *_verifyCodeValue;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController
#pragma mark - Init
- (void)setupNavigation {
    self.title = @"注册";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupData {
    self.iconImgView.image = HPGetAppIconInBundle();
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Network
- (void)requestRegisterSuccess:(void(^)(void))success {
    NSDictionary *params = @{@"userName":_mobileValue, @"password":_passwordValue};
    [DZRequests post:@"Register" parameters:params success:^(id record) {
        //[self _onNavigatedToMainPage];
        if (success) { success(); }
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}


#pragma mark - Events Response
- (IBAction)touchUpInsideSendVerifyCodeBtn:(UIButton *)sender {
    
}

- (IBAction)touchUpInsideRegisterBtn:(UIButton *)sender {
    [self requestRegisterSuccess:^{
        //注册成功进行登录
        NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   _mobileValue,@"phoneNum",
                                   _passwordValue,@"password",
                                   nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDZAutoLogin object:loginInfo];
    }];
}

- (IBAction)mobileEditingChanged:(UITextField *)sender {
    _mobileValue = sender.text.copy;
    [self _checkMobileAndPassword];
}

- (IBAction)passowordEditingChanged:(UITextField *)sender {
    _passwordValue = sender.text.copy;
    [self _checkMobileAndPassword];
}

- (IBAction)verifyCodeEditingChanged:(UITextField *)sender {
    _passwordValue = sender.text.copy;
}

#pragma mark - Private Functions
- (BOOL)_checkMobileAndPassword {
    BOOL validMobile = HPCheckValue(_mobileValue, HPCheckTypePhoneNumber);
    BOOL validPassword = [_passwordValue isValid];
    self.sendVerifyCodeBtn.enabled = (validMobile && validPassword) ;
    return (validMobile && validPassword);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
