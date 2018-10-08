//
//  iCloudLivePFZUIviewQR.m
//  TempScanf
//
//  Created by pengfeiV on 14-8-20.
//  Copyright (c) 2014年 VStarcam. All rights reserved.
//

#import "iCloudLivePFZUIviewQR.h"
#import "obj_common.h"
#define IOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define IOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)


@interface iCloudLivePFZUIviewQR () {
    int num;
    BOOL upOrdown;
    NSTimer * timer;
       NSString *m_UID;
}

@property (strong,nonatomic)AVCaptureDevice *               device;
@property (strong,nonatomic)AVCaptureDeviceInput *          input;
@property (strong,nonatomic)AVCaptureMetadataOutput *       output;
@property (strong,nonatomic)AVCaptureSession *              session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *    preview;
@property (nonatomic, retain) UIImageView *                 line;


@property (nonatomic)BOOL m_bLight;
@property(nonatomic,retain)NSString *myUID;
@property(nonatomic,retain)NSString *myName;

@property (nonatomic, retain) NSMutableArray *m_nsUIDImageList;

@end

@implementation iCloudLivePFZUIviewQR
@synthesize m_bLight;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
  

    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:0/255.0 green:184.0/255.0 blue:169.0/255.0 alpha:1.0]; //VSTZPF01
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                     [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1], UITextAttributeTextColor,
//                                                                     [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1], UITextAttributeTextShadowColor,
//                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
//                                                                     nil]];
    
    [self CreateUI];
    m_bLight = false;

    

}




- (void)CreateUI {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    int nT = 0;
    if (IOS7)
        nT = 40;
    else
        nT = 80;
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, bounds.size.width-100, 24)];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.backgroundColor = [UIColor clearColor];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    labelTitle.text  =   NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
  
    [self.view addSubview:labelTitle];
    
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    btnBack.frame = CGRectMake(20, 40,12, 18);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"NEWADD_BACKT.png"] forState:UIControlStateNormal];//给button添加image
    [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    UIButton *btnBackLight = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    btnBackLight.frame = CGRectMake(bounds.size.width-38, 40,13, 18);
    btnBackLight.backgroundColor = [UIColor clearColor];
    [btnBackLight setImage:[UIImage imageNamed:@"ScanfLight.png"] forState:UIControlStateNormal];//给button添加image
    [btnBackLight addTarget:self action:@selector(LightOnOff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBackLight];
    
    
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((bounds.size.width - 300)/2, 150- nT, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((bounds.size.width - 250)/2, 160- nT, 250, 10)];
    _line.image = [UIImage imageNamed:@"lineT.png"];
    _line.layer.masksToBounds = YES;
    [self.view addSubview:_line];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}

-(void)animation1
{
    int nT = 0;
    if (IOS7)
        nT =40;
    else
        nT = 80;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((bounds.size.width - 250)/2, 160+2*num - nT, 250, 10);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake((bounds.size.width - 250)/2, 160+2*num - nT, 250, 10);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

- (void)LightOnOff {
    if (_device) {
        if ([_device hasTorch] && [_device hasFlash]){
            [_device lockForConfiguration:nil];
            if (m_bLight) {
                [_device setTorchMode:AVCaptureTorchModeOff];
                [_device setFlashMode:AVCaptureFlashModeOff];
                m_bLight = NO;
            } else {
                [_device setTorchMode:AVCaptureTorchModeOn];
                [_device setFlashMode:AVCaptureFlashModeOn];
                m_bLight = YES;
            }
        }
    }
}

-(void)backAction
{
    [timer invalidate];
    
     self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated
{
   self.navigationController.navigationBarHidden = YES;
    //相机权限功能判断   zzy-0327
    if(IOS7)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus ==AVAuthorizationStatusRestricted){
            NSLog(@"Restricted");
        }
        else if(authStatus == AVAuthorizationStatusDenied){
     
            NSLog(@"Denied");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Message", @"Localizable.strings", nil) message:NSLocalizedStringFromTable(@"CameraDisabled", @"Localizable.strings", nil)  delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"Localizable.strings", nil) otherButtonTitles:nil, nil];
             [alert show];
    
            return;
        }
        else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
                        NSLog(@"Authorized");
             [self setupCamera];
            
            
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined){
            
                       [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){//点击允许访问时调用
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    [self setupCamera];
                                   }
                else {
                    NSLog(@"Not granted access to %@", mediaType);
                }
                
            }];
        }else {
            NSLog(@"Unknown authorization status");
        }
    
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    //     [super viewDidAppear:animated];
    //     [self setupCamera];
}

- (void)LightAction {
    if (_device) {
        if ([_device hasTorch] && [_device hasFlash]){
            [_device lockForConfiguration:nil];
            if (m_bLight) {
                [_device setTorchMode:AVCaptureTorchModeOff];
                [_device setFlashMode:AVCaptureFlashModeOff];
                m_bLight = NO;
            } else {
                [_device setTorchMode:AVCaptureTorchModeOn];
                [_device setFlashMode:AVCaptureFlashModeOn];
                m_bLight = YES;
            }
        }
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    int nT = 0;
    // 条码类型 AVMetadataObjectTypeQRCode  VSTC606486PYNCF
    if (IOS7) {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        nT = 40;
    }
    else
        nT = 80;
    
    // Preview
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake((bounds.size.width - 280)/2,160 - nT,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"%@",stringValue);
        
        
    }
    
    [_session stopRunning];
    
    
    if ([stringValue length] == 0) {
        return;
    }
    
    
    
        
        
        m_UID = [[NSString alloc] initWithString:stringValue];
        
        if(1)
        {
            self.myUID = stringValue;
            
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(startInputPass) userInfo:nil repeats:NO];
            
        }
    
        
    }
    
    


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self backAction];
    
}

- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

-(void)startInputPass
{
    [timer invalidate];
    
    NSMutableString *str2 = [[NSMutableString alloc]init];
    if([self.myUID rangeOfString:@"-"].location !=NSNotFound){
        
        NSArray *array = [self.myUID componentsSeparatedByString:@"-"];
        for (int i = 0; i < [array count]; i++) {
            [str2 appendString:[array objectAtIndex:i]];
        }
        
    }else{
        [str2 appendString:self.myUID];
        
    }
    
    NSLog(@"%@",str2);//这里开始接收字符串
    NSLog(@"代理：%@",self.delegate);
    [self.delegate displayData:str2];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    //UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
