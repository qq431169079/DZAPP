//
//  LoginViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/7/1.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "DZResetPWDViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "NSString+HPUtil.h"
#import "HPTool.h"

@interface LoginViewController () {
    @private
    NSString *_mobileValue;
    NSString *_passwordValue;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController
#pragma mark - Init
- (void)setupNavigation {
    self.title = @"登录";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupData {
    self.iconImgView.image = HPGetAppIconInBundle();
    self.registerBtn.layer.cornerRadius = 22;
    self.registerBtn.layer.borderColor = COLOR_HEX(0xf5f5f5).CGColor;
    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.clipsToBounds = YES;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoagin:) name:kDZAutoLogin object:nil];
}
#pragma mark - Network
- (void)requestLoginSuccess:(void(^)(NSDictionary *record))success {
    NSDictionary *params = @{@"userName":_mobileValue, @"password":_passwordValue};
    [DZRequests post:@"Login" parameters:params success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            if (success) {
                success(recordDict);
            }
        }
//        if (success) { success(); }
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

- (void)requestLoginWithToken:(NSString *)token success:(void(^)(NSDictionary *record))success {
    NSDictionary *params = @{@"token":token};
    [DZRequests post:@"loginWithToken" parameters:params success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            if ([[recordDict allKeys]containsObject:@"list"]) {
                NSArray *userList = recordDict[@"list"];
                if ([userList isKindOfClass:[NSArray class]] && userList.count>0) {
                    NSDictionary *userDict = [userList firstObject];
                    if ([userDict isKindOfClass:[NSDictionary class]]) {
                        if (success) {
                            success(userDict);
                        }
                    }
                }

            }
        }
        
        
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

#pragma mark - Events Response
- (IBAction)touchUpInsideLoginBtn:(UIButton *)sender {
    @weakify(self);
    [self requestLoginSuccess:^(NSDictionary *record) {
        if ([[record allKeys] containsObject:@"token"]) {
            [__weak_self__ requestLoginWithToken:record[@"token"] success:^(NSDictionary *record) {
                [__weak_self__ loginSuccess:record];

            }];
        }
    }];
}

- (IBAction)touchUpInsideRegisterBtn:(UIButton *)sender {
    [self addNotification];
    RegisterViewController *vc = [RegisterViewController controller];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mobileEditingChanged:(UITextField *)sender {
    _mobileValue = sender.text.copy;
    [self _checkMobileAndPassword];
}

- (IBAction)passowordEditingChanged:(UITextField *)sender {
    _passwordValue = sender.text.copy;
    [self _checkMobileAndPassword];
}
- (IBAction)resetPassword:(id)sender {
    DZResetPWDViewController *vc = [DZResetPWDViewController controller];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 其他
//注册后登录
-(void)autoLoagin:(NSNotification *)info{
    if (info.object) {
        NSDictionary *loginDict = (NSDictionary *)info.object;
        _mobileValue = loginDict[@"phoneNum"];
        _passwordValue = loginDict[@"password"]; 
        [self touchUpInsideLoginBtn:nil];
    }
    NSLog(@"");
}

#pragma mark - Private Functions
-(void)loginSuccess:(NSDictionary *)record{
    [UserHelper setUpWithRecord:record];
    [self _onNavigatedToMainPage];
}

- (void)_checkMobileAndPassword {
    BOOL validMobile = HPCheckValue(_mobileValue, HPCheckTypePhoneNumber);
    BOOL validPassword = [_passwordValue isValid];
    self.loginBtn.enabled = (validMobile && validPassword) ;
}

- (void)_onNavigatedToMainPage {
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    RootViewController *rootController = [[RootViewController alloc] init];
    [mainWindow setRootViewController:rootController];
    [mainWindow makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
