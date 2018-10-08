
//  CameraViewController.m   com.WildcardTest.VsC
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"

//#import <QuartzCore/QuartzCore.h>
#import "PPPPDefine.h"
//#import "mytoast.h"
#import "obj_common.h"
#include "MyAudioSession.h"

//#import "H264Decoder.h"

#import "EditCameraProtocol.h"
//#import "CameraListMgt.h"
#import "PPPPChannelManagement.h"
#import "PPPPStatusProtocol.h"
//#import "SnapshotProtocol.h"

//#import "RecPathManagement.h"

//#import "PlayViewController.h"
@interface CameraViewController()<EditCameraProtocol, PPPPStatusProtocol>{
    
    BOOL bEditMode;
    
    NSCondition *ppppChannelMgntCondition;
    
    IBOutlet UITableView *cameraList;
    IBOutlet UINavigationBar *navigationBar;
    
    IBOutlet UIButton *btnAddCamera;
    
    int cellRow;
    
//    PopupListComponent* _actionPop;
//
//    FPPopoverController* _fppviewctr;
}

//@property (nonatomic, retain) UITableView *cameraList;
//@property (nonatomic, retain) UINavigationBar *navigationBar;

//@property (nonatomic, retain) UIButton *btnAddCamera;
//@property (nonatomic, strong) CameraListMgt *cameraListMgt;
@property (nonatomic, strong) NSMutableDictionary *cameraDict;
@property (nonatomic, assign) CPPPPChannelManagement *pPPPPChannelMgt;
@property (nonatomic, strong) NSIndexPath* indPath;
//@property (nonatomic, strong) PlayViewController* playViewController;
//@property (nonatomic, assign) int setCamIndex;

//@property (nonatomic, retain) CustomTableAlert* customTalert;
@end
@implementation CameraViewController

//@synthesize cameraList;
//@synthesize navigationBar;
//@synthesize actionPop = _actionPop;
//@synthesize btnAddCamera;
//@synthesize cameraListMgt;
//@synthesize m_pPicPathMgt;
//@synthesize PicNotifyEventDelegate;
//@synthesize RecordNotifyEventDelegate;
//@synthesize m_pRecPathMgt;
//@synthesize pPPPPChannelMgt;
//synthesize indPath;

#define spliteBtn @"SpliteButton"
#pragma mark -
#pragma mark button presss handle

#define warnBtnTag  55555
#define warnBtnAlertTag  66666

#define CAMERA_DEFAULT_PWD @"888888"



- (void) StartPlayView: (NSInteger)index
{
//    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
//    if (cameraDic == nil) {
//        return;
//    }
    
//    NSString *strDID = [self.cameraDict objectForKey:@STR_DID];
//    NSString *strName = [self.cameraDict objectForKey:@STR_NAME];
//    NSNumber *nPPPPMode = [self.cameraDict objectForKey:@STR_PPPP_MODE];
//    //pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[strDID UTF8String], 0, 0);
//
//
////    IpCameraClientAppDelegate *IPCamDelegate =  (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate] ;
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        _playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_iPad" bundle:nil];
//    }else{
//          _playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
//    }
//   _playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
//    _playViewController.strDID = strDID;
//    _playViewController.cameraName = strName;
//    _playViewController.m_nP2PMode = [nPPPPMode intValue];
//    _playViewController.b_split = NO;
//    _playViewController.view.frame = self.view.frame;
//    [self.view addSubview:_playViewController.view];

}


#define ADD_CAMERA_RED 200
#define ADD_CAMERA_GREED 200
#define ADD_CAMERA_BLUE 200

#define ADD_CAMERA_NORMAL_RED 230
#define ADD_CAMERA_NORMAL_GREEN 230
#define ADD_CAMERA_NORMAL_BLUE 230

#define TalkMark @"IsTalking"//用于记录上次是监听还是对讲
#define AudioMark @"IsAudioing"

- (IBAction)btnAddCameraTouchDown:(id)sender
{
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_RED/255.0f green:ADD_CAMERA_GREED/255.0f blue:ADD_CAMERA_BLUE/255.0f alpha:1.0];
}

- (IBAction)btnAddCameraTouchUp:(id)sender
{
//    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
//
//    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
//    cameraEditViewController.editCameraDelegate = self;
//    cameraEditViewController.bAddCamera = YES;
//    [self.navigationController pushViewController:cameraEditViewController animated:YES];
//
   // [cameraListMgt AddCamera:@"aaaaa" DID:@"bbbbb" User:@"dsfsfs" Pwd:@"" Snapshot:nil];
}

- (void) btnEdit:(id)sender
{
    //NSLog(@"btnEdit");
    
//    if (!bEditMode) {
//        [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    }else {
//        [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    }
    
//    if (!bEditMode) {
//        //将tableview放大
//        CGRect tableviewFrame = self.cameraList.frame;
//        tableviewFrame.origin.y -= 45;
//        tableviewFrame.size.height += 45;
//
//        self.cameraList.frame = tableviewFrame;
//
//    }
//    else {
//        CGRect tableviewFrame = self.cameraList.frame;
//        tableviewFrame.origin.y += 45;
//        tableviewFrame.size.height -= 45;
//
//        self.cameraList.frame = tableviewFrame;
//    }
    
    bEditMode = ! bEditMode;
    //[self setNavigationBarItem:bEditMode];
   
//    [cameraList reloadData];
}


#pragma mark -
#pragma mark TableViewDelegate

//删除设备的处理
- (NSString*)PathForDocumentStrDID:(NSString*)strDID{
    NSString* documentPath = nil;
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    documentPath = [path objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:strDID];
}



#pragma mark UIActionSheetDelegate Method
- (void) NotifyReloadData{
    
}

#pragma mark SettingViewControllerDelegate
- (void) deletecam:(int) camIndex{

}

- (void) rebootCam:(int) camIndex{

    
    if (self.cameraDict == nil) {
        return;
    }
    NSString* status = [self.cameraDict objectForKey:@STR_PPPP_STATUS];

    
}


#pragma mark -
#pragma mark CamerasetViewControllerDelegate

#pragma mark -
#pragma mark system

- (void) refresh: (id) sender
{
    [self UpdateCameraSnapshot];
}

- (void) UpdateCameraSnapshot
{
//    int count = [cameraListMgt GetCount];
    if (self.cameraDict == nil) {
        [self hideLoadingIndicator];
        return;
    }

        NSNumber *nPPPPStatus = [self.cameraDict objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            return;
        }
    
        NSString *did = [self.cameraDict objectForKey:@STR_DID];
        self.pPPPPChannelMgt->Snapshot([did UTF8String]);
//    }
    
    [self showLoadingIndicator];
    [self performSelector:@selector(hideLoadingIndicator) withObject:nil afterDelay:10.0];
    
}

- (void)showLoadingIndicator
{
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     ;
    indicator.frame = CGRectMake(0, 0, 24, 24);
    [indicator startAnimating];
    UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];
    [self.navigationItem setLeftBarButtonItem:progress animated:YES];
}


- (void)hideLoadingIndicator
{
    UIActivityIndicatorView *indicator =
    (UIActivityIndicatorView *)self.navigationItem.leftBarButtonItem;
    if ([indicator isKindOfClass:[UIActivityIndicatorView class]])
    {
        [indicator stopAnimating];
    }
    UIBarButtonItem *refreshButton =
    [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
      target:self
      action:@selector(refresh:)]
     ;
    [self.navigationItem setLeftBarButtonItem:refreshButton animated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    //UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) StartPPPP:(id) param
{
    //usleep(100000);
    sleep(1);
    
//    int count = [cameraListMgt GetCount];
//
//    int i;
//    for (i = 0; i < count; i++) {
//        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
//    if (self.cameraDict) {
//        NSString *strDID = [self.cameraDict objectForKey:@STR_DID];
//        NSString *strUser = [self.cameraDict objectForKey:@STR_USER];
//        NSString *strPwd = [self.cameraDict objectForKey:@STR_PWD];
//        NSNumber *nPPPPStatus = [self.cameraDict objectForKey:@STR_PPPP_STATUS];
//        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
//            return;
//        }
//        
//        usleep(100000);
//        
//        NSString *uid = [NSString stringWithUTF8String:[strDID UTF8String]];
//        if ([[uid uppercaseString] rangeOfString:@"VSTA"].location != NSNotFound) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"EFGFFBBOKAIEGHJAEDHJFEEOHMNGDCNJCDFKAKHLEBJHKEKMCAFCDLLLHAOCJPPMBHMNOMCJKGJEBGGHJHIOMFBDNPKNFEGCEGCBGCALMFOHBCGMFK",0);
//        }else if ([[uid uppercaseString] rangeOfString:@"VSTG"].location != NSNotFound) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"EEGDFHBOKCIGGFJPECHIFNEBGJNLHOMIHEFJBADPAGJELNKJDKANCBPJGHLAIALAADMDKPDGOENEBECCIK:vstarcam2018",0);
//        }else if ([[uid uppercaseString] rangeOfString:@"VSTE"].location != NSNotFound) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"EEGDFHBAKKIOGNJHEGHMFEEDGLNOHJMPHAFPBEDLADILKEKPDLBDDNPOHKKCIFKJBNNNKLCPPPNDBFDL",0);
//        }else if ([[uid uppercaseString] rangeOfString:@"VSTB"].location != NSNotFound ) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
//        }else if ([[uid uppercaseString] rangeOfString:@"VSTC"].location != NSNotFound ) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
//        }else if ([[uid uppercaseString] rangeOfString:@"VSTD"].location != NSNotFound ) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$",1);
//        }else if ([[uid uppercaseString] rangeOfString:@"VSTF"].location != NSNotFound ) {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"HZLXEJIALKHYATPCHULNSVLMEELSHWIHPFIBAOHXIDICSQEHENEKPAARSTELERPDLNEPLKEILPHUHXHZEJEEEHEGEM-$$",1);
//        }
//        else
//        {
//            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"",0);
//        }
//    }
    
    
    
//    }
}

- (void) StopPPPP
{
//    [ppppChannelMgntCondition lock];
//    if (pPPPPChannelMgt == NULL) {
//        [ppppChannelMgntCondition unlock];
//        return;
//    }
//    pPPPPChannelMgt->StopAll();
//    [ppppChannelMgntCondition unlock];
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        ppppChannelMgntCondition = [[NSCondition alloc] init];
        //self.view.backgroundColor = [UIColor blackColor];
        self.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ipc30.png"];
    }
        
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.cameraDict = [NSMutableDictionary dictionary];
//
//    self.pPPPPChannelMgt = new CPPPPChannelManagement();
//    st_PPPP_NetInfo1 netInfo;
//    XQP2P_NetworkDetect(&netInfo, 0);
//    PPPP_Initialize((CHAR*)"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL"
//                    );
//
//    XQP2P_Initialize((CHAR *)"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$", 0);
//    bEditMode = NO;
//
//
////    [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//
//    pPPPPChannelMgt->pCameraViewController = self;
//
//
//    [self StartPPPPThread];
//
//    InitAudioSession();
//
//    [self EditP2PCameraInfo:YES Name:@"测试相机" DID:@"VSTF166008EFRHA" User:@"admin" Pwd:@"18126180537" OldDID:nil];
    
}
//
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
//    NSLog(@"aaaa");
//    return YES;
//}
//
//-(void)pushrec:(id)sender{
//
//}
//
//-(void)About:(id)sender{
//
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [cameraList reloadData];
//
//    self.navigationItem.rightBarButtonItem.enabled = YES;
//}
//
//- (void) StartPPPPThread
//{
//
//    [ppppChannelMgntCondition lock];
//    if (pPPPPChannelMgt == NULL) {
//        [ppppChannelMgntCondition unlock];
//        return;
//    }
//    [NSThread detachNewThreadSelector:@selector(StartPPPP:) toTarget:self withObject:nil];
//    [ppppChannelMgntCondition unlock];
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//
//    SAFE_DELETE(pPPPPChannelMgt);
//}
//
//
//#pragma mark -
//#pragma mark EditCameraProtocol
//
//- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid
//{
//    NSLog(@"P2P代理函数");
//    NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@", bAdd, name, did, user, pwd, olddid);
//
//    NSNumber *authority=[NSNumber numberWithBool:NO];
//    NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
//    NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
//
//    [self.cameraDict setObject:name forKey:@STR_NAME];
//    [self.cameraDict setObject:did forKey:@STR_DID];
//    [self.cameraDict setObject:user forKey:@STR_USER];
//    [self.cameraDict setObject:pwd forKey:@STR_PWD];
//    [self.cameraDict setObject:nPPPPStatus forKey:@STR_PPPP_STATUS];
//    [self.cameraDict setObject:nPPPPMode forKey:@STR_PPPP_MODE];
//    [self.cameraDict setObject:authority forKey:@STR_AUTHORITY];
//
////    if (bAdd == YES) {
////        bRet = [cameraListMgt AddCamera:name DID:did User:user Pwd:pwd Snapshot:nil];
////    }else {
////        bRet = [cameraListMgt EditCamera:olddid Name:name DID:did User:user Pwd:pwd];
////    }
////
////    if (bRet == YES) {
//
////        if (bAdd) {//添加成功，增加P2P连接
//            NSString *uid = [NSString stringWithUTF8String:[did UTF8String]];
//            if ([[uid uppercaseString] rangeOfString:@"VSTA"].location != NSNotFound) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EFGFFBBOKAIEGHJAEDHJFEEOHMNGDCNJCDFKAKHLEBJHKEKMCAFCDLLLHAOCJPPMBHMNOMCJKGJEBGGHJHIOMFBDNPKNFEGCEGCBGCALMFOHBCGMFK",0);
//            }else if ([[uid uppercaseString] rangeOfString:@"VSTG"].location != NSNotFound) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EEGDFHBOKCIGGFJPECHIFNEBGJNLHOMIHEFJBADPAGJELNKJDKANCBPJGHLAIALAADMDKPDGOENEBECCIK:vstarcam2018",0);
//            }else if ([[uid uppercaseString] rangeOfString:@"VSTE"].location != NSNotFound) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EEGDFHBAKKIOGNJHEGHMFEEDGLNOHJMPHAFPBEDLADILKEKPDLBDDNPOHKKCIFKJBNNNKLCPPPNDBFDL",0);
//            }else if ([[uid uppercaseString] rangeOfString:@"VSTB"].location != NSNotFound ) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
//            }else if ([[uid uppercaseString] rangeOfString:@"VSTC"].location != NSNotFound ) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
//            }else if ([[uid uppercaseString] rangeOfString:@"VSTD"].location != NSNotFound ) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$",1);
//            }else if ([[uid uppercaseString] rangeOfString:@"VSTF"].location != NSNotFound ) {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"HZLXEJIALKHYATPCHULNSVLMEELSHWIHPFIBAOHXIDICSQEHENEKPAARSTELERPDLNEPLKEILPHUHXHZEJEEEHEGEM-$$",1);
//            }
//            else
//            {
//                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"",0);
//            }
//
//
//        if (bEditMode && [olddid caseInsensitiveCompare:did] != NSOrderedSame) {
////            [m_pPicPathMgt RemovePicPathByID:olddid];
//        }
//
//        //添加或修改设备成功，重新加载设备列表
////        [cameraList reloadData];
//
//
//
////    }
//
////    NSLog(@"bRet: %d", bRet);
//
//    return YES;
//}
//
//#pragma mark -
//#pragma mark  PPPPStatusProtocol
//- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
//{
//    NSLog(@"PPPPStatus ..... strDID: %@, statusType: %ld, status: %ld", strDID, (long)statusType, (long)status);
//    if ([[self.cameraDict allKeys]containsObject:@STR_DID]) {
//        NSString *did = self.cameraDict[@STR_DID];
//        if (([did caseInsensitiveCompare:strDID] == NSOrderedSame)) {
//           NSNumber *PPPPMode = [[NSNumber alloc] initWithInt:(int)status];
//            [self.cameraDict setObject:PPPPMode forKey:@STR_PPPP_MODE];
//            //刷新状态
//            [self performSelectorOnMainThread:@selector(ReloadRowCameraData) withObject:nil waitUntilDone:NO];
//        }
//    }
//
//    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {
//        if ([[self.cameraDict allKeys]containsObject:@STR_DID]) {
//            NSString *did = self.cameraDict[@STR_DID];
//            if (([did caseInsensitiveCompare:strDID] == NSOrderedSame)) {
//                NSNumber *PPPPMode = [[NSNumber alloc] initWithInt:(int)status];
//                [self.cameraDict setObject:PPPPMode forKey:@STR_PPPP_MODE];
//                //刷新状态
//                [self performSelectorOnMainThread:@selector(ReloadRowCameraData) withObject:nil waitUntilDone:NO];
//            }
//        }
//
//        return;
//    }
//
//    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
//        if ([[self.cameraDict allKeys]containsObject:@STR_DID]) {
//            NSString *did = self.cameraDict[@STR_DID];
//            if (([did caseInsensitiveCompare:strDID] == NSOrderedSame)) {
//                NSNumber *PPPPStatus = [[NSNumber alloc] initWithInt:(int)status];
//                [self.cameraDict setObject:PPPPStatus forKey:@STR_PPPP_STATUS];
//                //刷新状态
//                [self performSelectorOnMainThread:@selector(ReloadRowCameraData) withObject:nil waitUntilDone:NO];
//            }
//        }
//
//        //如果是ID号无效，则停止该设备的P2P
//        if (status == PPPP_STATUS_INVALID_ID
//            || status == PPPP_STATUS_CONNECT_TIMEOUT
//            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
//            || status == PPPP_STATUS_CONNECT_FAILED
//            || status == PPPP_STATUS_INVALID_USER_PWD) {
//            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
//        }
//
//        return;
//    }
//}
//
//#pragma mark -
//#pragma mark PerformInMainThread
//
//-(void)ReloadRowCameraData{
//
//    NSNumber *nPPPPStatus = [self.cameraDict objectForKey:@STR_PPPP_STATUS];
//    int PPPPStatus = [nPPPPStatus intValue];
//
//    NSString *strPPPPStatus = nil;
//    switch (PPPPStatus) {
//        case PPPP_STATUS_UNKNOWN:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_CONNECTING:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_INITIALING:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_CONNECT_FAILED:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_DISCONNECT:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_INVALID_ID:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_ON_LINE:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
//            [self StartPlayView:0];
//            break;
//        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
//            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_CONNECT_TIMEOUT:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_INVALID_USER_PWD:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        default:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//    }
//    NSLog(@"_________%@",strPPPPStatus);
//}
//
//
//- (void) StopPPPPByDID:(NSString*)did
//{
//    pPPPPChannelMgt->Stop([did UTF8String]);
//}
//
//- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // End the context
//    UIGraphicsEndImageContext();
//
//    NSData *dataImg = UIImageJPEGRepresentation(newImage, 0.0001);
//    UIImage *imgOK = [UIImage imageWithData:dataImg];
//
//    // Return the new image.
//    return imgOK;
//}
//
//- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
//{
//
//    //创建文件管理器
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //获取路径
//    //参数NSDocumentDirectory要获取那种路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
//
//    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
//    //NSLog(@"strPath: %@", strPath);
//
//    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
//
//    //[fileManager createDirectoryAtPath:strPath attributes:nil];
//
//
//    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
//    //NSLog(@"strPath: %@", strPath);
//
//    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
//    [dataImage writeToFile:strPath atomically:YES ];
//
//
//
//}

#pragma mark -
#pragma mark SnapshotNotify

@end
