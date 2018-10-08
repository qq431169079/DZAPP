//
//  SettingViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "WifiSettingViewController.h"
#import "CameraViewController.h"
#import "UserPwdSetViewController.h"
#import "AlarmController.h"
#import "DateTimeController.h"
#import "FtpSettingViewController.h"
#import "MailSettingViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "CameraInfoCell.h"
#import "cellSelectBtnCell.h"
#import "PlayViewModeCell.h"
#import "cmdhead.h"
#import "RecordScheduleSettingViewController.h"
#import "SystemUpgradeViewController.h"
#import "MotionPushPlanViewController.h"
#define TalkMark @"IsTalking"//用于记录上次是监听还是对讲
#define AudioMark @"IsAudioing"


@interface SettingViewController ()
@property (nonatomic, assign) BOOL isReboot;
@property (nonatomic, assign) BOOL isEdited;
@property (nonatomic, retain) UISwipeGestureRecognizer* swipGes;
@property (nonatomic, assign) BOOL isDisplayRow;
@property (nonatomic, assign) int m_PlayMode;
@end

@implementation SettingViewController

@synthesize m_pPPPPChannelMgt;
@synthesize m_strDID;
@synthesize navigationBar;
@synthesize cameraDic;
@synthesize cameraListMgt;
@synthesize editCamerDelegate;
@synthesize m_strPWD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.SetCamIndex = 10000;
    }
    return self;
}


- (void)didEnterBackground
{
    //NSLog(@"didEnterBackground");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)willEnterForeground
{
    //NSLog(@"willEnterForeground");
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *strTitle = NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil);
    
    self.navigationItem.title = strTitle;
    _isEdited = NO;
    self.isDisplayRow = NO;
    //把self添加到NSNotificationCenter的观察者中
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    _swipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responesSwipGes:)];
    _swipGes.direction = UISwipeGestureRecognizerDirectionRight ;
    [self.view addGestureRecognizer:_swipGes];
    
    self.m_strPWD = [cameraDic objectForKey:@STR_PWD];
    
    m_pPPPPChannelMgt->SetSettingViewControllerParamsDelegate((char* )[self.m_strDID UTF8String], self);
    self.m_pPPPPChannelMgt->GetCGI((char*) [self.m_strDID UTF8String], CGI_IEGET_CAM_PARAMS);
}

- (void) responesSwipGes:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isReboot = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.m_pPPPPChannelMgt->SetCameraSDCardStatusDelegate((char* )[self.m_strDID UTF8String], nil);
    if (!_isReboot && _isEdited) {
        [self.editCamerDelegate EditP2PCameraInfo:NO Name:self.camNameTF.text DID:[cameraDic objectForKey:@STR_DID] User:[cameraDic objectForKey:@STR_USER] Pwd:self.camPwdTF.text OldDID:[cameraDic objectForKey:@STR_DID]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.view removeGestureRecognizer:_swipGes];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc
{
    [_swipGes release],_swipGes = nil;
    cameraDic = nil;
    m_strDID = nil;
    self.navigationBar = nil;
    self.m_pPPPPChannelMgt = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 5;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        if (self.isDisplayRow) {
            return 8;
        }else{
            return 7;
        }
        
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    if (anIndexPath.section == 0) {
 
        NSString* cellIdentifier = @"EditCellIden";
        CameraInfoCell *cell =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSInteger row = anIndexPath.row;
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (row) {
            case 0:
                cell.keyLable.text = NSLocalizedStringFromTable(@"CameraID", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraID", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                // cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                cell.textField.text = [cameraDic objectForKey:@STR_DID];
                cell.textField.textColor = [UIColor darkGrayColor];
                cell.textField.enabled = NO;
                
                break;
            case 1:
                cell.keyLable.text = NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraName", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                //cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                cell.textField.text = [cameraDic objectForKey:@STR_NAME];
                cell.textField.enabled = YES;
                self.camNameTF = cell.textField;
                break;
            case 2:
                cell.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                // cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                cell.textField.secureTextEntry = YES;
                cell.textField.text = [cameraDic objectForKey:@STR_PWD];
                cell.textField.enabled = YES;
                self.camPwdTF = cell.textField;
                break;
            default:
                break;
                
        }
        cell.textField.delegate = self;
        cell.textField.tag = row;
        
        return cell;
        
    }else if (anIndexPath.section == 1){
        if (anIndexPath.row == 7) {
            NSString* Fcell = @"FCell";
            PlayViewModeCell* PlayCell = [aTableView dequeueReusableCellWithIdentifier:Fcell];
            if (PlayCell == nil) {
                PlayCell = [[[NSBundle mainBundle] loadNibNamed:@"PlayViewModeCell" owner:self options:nil] lastObject];
            }
            PlayCell.backgroundColor = [UIColor colorWithRed:43.f/255.f green:43.f/255.f blue:43.f/255.f alpha:1.0f];//[UIColor colorWithWhite:0.f alpha:0.6f];
            if (_m_PlayMode == 0) {
                [PlayCell.fiftyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [PlayCell.sixtyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if (_m_PlayMode == 1){
                [PlayCell.sixtyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [PlayCell.fiftyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if (_m_PlayMode == 2){
                //室外模式(暂时不用)
            }
            [PlayCell.sixtyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
            [PlayCell.fiftyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
            [PlayCell.fiftyBtn addTarget:self action:@selector(setPlayMode:) forControlEvents:UIControlEventTouchUpInside];
            [PlayCell.sixtyBtn addTarget:self action:@selector(setPlayMode:) forControlEvents:UIControlEventTouchUpInside];
            return PlayCell;
        }
        
        NSString *cellIdentifier = @"SettingCell";
        UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell autorelease];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (anIndexPath.row) {
                
            case 0:
                cell.textLabel.text = NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 1:
                cell.textLabel.text = NSLocalizedStringFromTable(@"PwdSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 2:
                cell.textLabel.text = NSLocalizedStringFromTable(@"ClockSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 3:
                cell.textLabel.text = NSLocalizedStringFromTable(@"AlarmSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 4:
                cell.textLabel.text = NSLocalizedStringFromTable(@"SDSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 5:
                cell.textLabel.text = @"移动侦测报警通知计划";
                break;
            case 6:
                cell.textLabel.text = NSLocalizedStringFromTable(@"PlayViewMode", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 7: //ftp setting
                cell.textLabel.text = NSLocalizedStringFromTable(@"FTPSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 8: //mail setting
                cell.textLabel.text = NSLocalizedStringFromTable(@"MailSetting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            default:
                break;
        }
        return cell;
	}else if (anIndexPath.section == 2){
        static NSString* systemupgrade = @"systemCell";
        UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:systemupgrade];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemupgrade] autorelease];
        }
        cell.textLabel.text = NSLocalizedStringFromTable(@"FirmwareUpgrade", @STR_LOCALIZED_FILE_NAME, nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (anIndexPath.section == 3){
        static NSString* celliden = @"btnCell";
        cellSelectBtnCell* cell = (cellSelectBtnCell*)[aTableView dequeueReusableCellWithIdentifier:celliden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cellSelectBtnCell" owner:self options:nil] lastObject];
        }
        cell.btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.btn setTitle:NSLocalizedStringFromTable(@"RebootCamera", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        [cell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        cell.btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.btn setBackgroundImage:[[UIImage imageNamed:@"RedBtn"] stretchableImageWithLeftCapWidth:18.5f topCapHeight:0.f] forState:UIControlStateNormal];
        [cell.btn setBackgroundImage:[[UIImage imageNamed:@"RedBtnHighlight"] stretchableImageWithLeftCapWidth:18.5f topCapHeight:0.f] forState:UIControlStateHighlighted];
        cell.btn.layer.cornerRadius = 5.f;
        cell.btn.layer.masksToBounds = YES;
        [cell.btn addTarget:self action:@selector(RebootSelectedCam:) forControlEvents:UIControlEventTouchUpInside];
        UIView* view = [[[UIView alloc] init] autorelease];
        [cell setBackgroundView:view];
        [view setBackgroundColor:[UIColor clearColor]];
        return cell;
    }else{
        static NSString* celliden = @"btnCell";
        cellSelectBtnCell* cell = (cellSelectBtnCell*)[aTableView dequeueReusableCellWithIdentifier:celliden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cellSelectBtnCell" owner:self options:nil] lastObject];
        }
        cell.btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.btn setTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil)] forState:UIControlStateNormal];
        [cell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        cell.btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.btn setBackgroundImage:[[UIImage imageNamed:@"RedBtn"] stretchableImageWithLeftCapWidth:18.5f topCapHeight:0.f] forState:UIControlStateNormal];
        [cell.btn setBackgroundImage:[[UIImage imageNamed:@"RedBtnHighlight"] stretchableImageWithLeftCapWidth:18.5f topCapHeight:0.f] forState:UIControlStateHighlighted];
        cell.btn.layer.cornerRadius = 5.f;
        cell.btn.layer.masksToBounds = YES;
        [cell.btn addTarget:self action:@selector(DeleteSelectedCam:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* view = [[[UIView alloc] init] autorelease];
        [cell setBackgroundView:view];
        [view setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
	
}

#pragma mark -
- (void) RebootSelectedCam:(id) sender{
    
    if (self.delegate != nil) {
        _isReboot = YES;
        [_delegate rebootCam:self.SetCamIndex];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) DeleteSelectedCam:(id) sender{
    
    if (self.delegate != nil) {
        [_delegate deletecam:self.SetCamIndex];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"EditCamera", @STR_LOCALIZED_FILE_NAME, nil);
    }else if (section == 1){
        return NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil);
    }else{
        return nil;
    }
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSString* status = [[cameraListMgt GetCameraAtIndex:self.SetCamIndex] objectForKey:@STR_PPPP_STATUS];
    if (anIndexPath.section == 0) {
        
    }else if(anIndexPath.section == 1){
        
        if ([status intValue] != PPPP_STATUS_ON_LINE) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        
        switch (anIndexPath.row) {
            case 0: //WIFI
            {
                WifiSettingViewController *wifiSettingView = [[WifiSettingViewController alloc] init];
                wifiSettingView.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
                wifiSettingView.m_strDID = m_strDID;
                [self.navigationController pushViewController:wifiSettingView animated:YES];
                [wifiSettingView release];
            }
                break;
            case 1: //密码设置
            {
                UserPwdSetViewController *UserPwdSettingView = [[UserPwdSetViewController alloc] init];
                UserPwdSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
                UserPwdSettingView.cameraListMgt = cameraListMgt;
                UserPwdSettingView.m_strDID = m_strDID;
                UserPwdSettingView.cameraName = [self.cameraDic objectForKey:@"name"];
                [self.navigationController pushViewController:UserPwdSettingView animated:YES];
                [UserPwdSettingView release];
            }
                break;
            case 2: //时间
            {
                DateTimeController *DateTimeSettingView = [[DateTimeController alloc] init];
                DateTimeSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
                DateTimeSettingView.m_strDID = m_strDID;
                [self.navigationController pushViewController:DateTimeSettingView animated:YES];
                [DateTimeSettingView release];
            }
                break;
            case 3: //报警设置
            {
                AlarmController *AlarmSettingView = [[AlarmController alloc] init];
                AlarmSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
                AlarmSettingView.m_strDID = m_strDID;
                [self.navigationController pushViewController:AlarmSettingView animated:YES];
                [AlarmSettingView release];
            }
                break;
            case 4:
            {
                RecordScheduleSettingViewController* sdcardSet = [[RecordScheduleSettingViewController alloc] initWithNibName:@"RecordScheduleSettingViewController" bundle:nil];
                sdcardSet.m_PPPPChannelMgt = self.m_pPPPPChannelMgt;
                sdcardSet.m_strDID = self.m_strDID;
                sdcardSet.navigationItem.title = NSLocalizedStringFromTable(@"SDSetting", @STR_LOCALIZED_FILE_NAME, nil);
                [self.navigationController pushViewController:sdcardSet animated:YES];
                [sdcardSet release];
                /* SDCardSettingViewController* sd = [[SDCardSettingViewController alloc] initWithNibName:@"SDCardSettingViewController" bundle:nil];
                 sd.m_PPPPChannelMgt = self.m_pPPPPChannelMgt;
                 sd.m_strDID = self.m_strDID;
                 [self.navigationController pushViewController:sd animated:YES];
                 [sd release];*/
            }
                break;
                case 5://移动侦测报警计划设置
            {
                MotionPushPlanViewController *motionPushPlan = [[MotionPushPlanViewController alloc] init];
                motionPushPlan.m_PPPPChannelMgt = self.m_pPPPPChannelMgt;
                motionPushPlan.m_strDID = self.m_strDID;
                motionPushPlan.navigationItem.title = @"移动侦测报警计划";
                [self.navigationController pushViewController:motionPushPlan animated:YES];
                [motionPushPlan release];
            }
                break;
            case 6:
            {
                NSMutableArray* array = [[NSMutableArray alloc] init];
                NSIndexPath* path = [NSIndexPath indexPathForRow:6 inSection:1];
                [array addObject:path];
                [aTableView beginUpdates];
                if (!self.isDisplayRow) {
                    self.isDisplayRow = !self.isDisplayRow;
                    [aTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
                }else{
                    self.isDisplayRow = !self.isDisplayRow;
                    [aTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
                }
                [aTableView endUpdates];
                [array release],array = nil;
                
                
            }
                break;
            case 7: //ftp setting
            {
                FtpSettingViewController *ftpSettingView = [[FtpSettingViewController alloc] init];
                ftpSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
                ftpSettingView.m_strDID = m_strDID;
                [self.navigationController pushViewController:ftpSettingView animated:YES];
                [ftpSettingView release];
            }
                break;
            case 8://mail setting
            {
                MailSettingViewController *mailSettingView = [[MailSettingViewController alloc] init];
                mailSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
                mailSettingView.m_strDID = m_strDID;
                [self.navigationController pushViewController:mailSettingView animated:YES];
                [mailSettingView release];
            }
                break;
                
            default:
                break;
        }
    }else if (anIndexPath.section == 2){
        if ([status intValue] != PPPP_STATUS_ON_LINE) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        
        SystemUpgradeViewController* sysUpgrade = [[SystemUpgradeViewController alloc] initWithNibName:@"SystemUpgradeViewController" bundle:nil];
        sysUpgrade.navigationItem.title = NSLocalizedStringFromTable(@"FirmwareUpgrade", @STR_LOCALIZED_FILE_NAME, nil);
        sysUpgrade.m_pPPPPChannelMgt = self.m_pPPPPChannelMgt;
        sysUpgrade.str_uid = self.m_strDID;
        sysUpgrade.str_pwd = self.m_strPWD;
        [self.navigationController pushViewController:sysUpgrade animated:YES];
        [sysUpgrade release],sysUpgrade = nil;
    }

}

#pragma mark setPlayMode
- (void) setPlayMode:(UIButton*) senderBtn{
    if (senderBtn.tag == 50) {
        [senderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [(UIButton* )[self.view viewWithTag:60] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        m_pPPPPChannelMgt->CameraControl((char* )[self.m_strDID UTF8String], 3, 0);
        _m_PlayMode = 0;
    }else if (senderBtn.tag == 60){
        [senderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [(UIButton* )[self.view viewWithTag:50] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        m_pPPPPChannelMgt->CameraControl((char* )[self.m_strDID UTF8String], 3, 1);
        _m_PlayMode = 1;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        self.camNameTF = textField;
    }else if (textField.tag == 2){
        self.camPwdTF = textField;
    }
    _isEdited = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark ParamNotifyProtocol

- (void) ParamNotify: (int) paramType params:(void*) params{
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM pCameraParam = (PSTRU_CAMERA_PARAM)params;
        _m_PlayMode = pCameraParam->mode;
    }
}

@end
