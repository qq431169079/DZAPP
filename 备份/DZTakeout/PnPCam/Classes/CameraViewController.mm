
//  CameraViewController.m   com.WildcardTest.VsC
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraEditViewController.h"
#import "CameraListCell.h"
#import "IpCameraClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PPPPDefine.h"
#import "mytoast.h"
#include "MyAudioSession.h"
#import "SettingViewController.h"
#import "AddCameraCell.h"
#import "CameraEditViewController.h"
#import "H264Decoder.h"
#import "CustomTableAlert.h"
#import "UserPwdSetViewController.h"
@interface CameraViewController()
@property (nonatomic, retain) CustomTableAlert* customTalert;
@end
@implementation CameraViewController

@synthesize cameraList;
@synthesize navigationBar;
@synthesize actionPop = _actionPop;
@synthesize btnAddCamera;
@synthesize cameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize PicNotifyEventDelegate;
@synthesize RecordNotifyEventDelegate;
@synthesize m_pRecPathMgt;
@synthesize pPPPPChannelMgt;
@synthesize indPath;

#define spliteBtn @"SpliteButton"
#pragma mark -
#pragma mark button presss handle

#define warnBtnTag  55555
#define warnBtnAlertTag  66666

#define CAMERA_DEFAULT_PWD @"888888"



- (void) StartPlayView: (NSInteger)index
{    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    NSString *strName = [cameraDic objectForKey:@STR_NAME];
    NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    //pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[strDID UTF8String], 0, 0);
    
    
    IpCameraClientAppDelegate *IPCamDelegate =  (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate] ;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_iPad" bundle:nil];
    }else{
          _playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
    }
   _playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    _playViewController.strDID = strDID;
    _playViewController.cameraName = strName;
    _playViewController.m_nP2PMode = [nPPPPMode intValue];
    _playViewController.b_split = NO;
    [IPCamDelegate switchPlayView:_playViewController];
    
   // [playViewController release];

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
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
    
    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
    cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES]; 
    [cameraEditViewController release];
    
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
   
    [cameraList reloadData];
}

- (void) setNavigationBarItem: (BOOL) abEditMode
{
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil)];  
    NSString *strText;    
    UIBarButtonItem *btnEdit;
    UIBarButtonItem* left;
    if (!abEditMode) {
        strText = NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil);
        btnEdit = [[UIBarButtonItem alloc] initWithTitle:strText  style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        //btnEdit.tintColor = [UIColor colorWithRed:COLOR_BASE_RED/255 green:COLOR_BASE_GREEN/255 blue:COLOR_BASE_BLUE/255 alpha:0.5];
        
        btnEdit.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddCamera:)];
        left.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        left.width = 50.0f;
//        naviItem.rightBarButtonItem = right;
//        [right release];
    }else {
        strText = NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil);
        btnEdit = [[UIBarButtonItem alloc] initWithTitle:strText  style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        
        btnEdit.tintColor = [UIColor colorWithRed:BTN_DONE_RED/255.0f green:BTN_DONE_GREEN/255.0f blue:BTN_DONE_BLUE/255.0f alpha:1.0];
        
        left = nil;
    }
    
    

    //naviItem.rightBarButtonItem = left;
    //naviItem.rightBarButtonItem = btnEdit;
    [btnEdit release];
    [left release];
    NSArray *array = [NSArray arrayWithObjects:naviItem, nil];
    [self.navigationBar setItems:array];
    [naviItem release];

}

-(void)AddCamera:(id)sender
{
    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
    cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES];
    [cameraEditViewController release];
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    //NSLog(@"commitEditingStyle");
    //indPath = indexPath;
   // NSLog(@"indexPath %d",indPath.row);
    int index = indexPath.row ;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    
    NSFileManager* fileMng = [NSFileManager   defaultManager];
    NSString* imagepath = [self PathForDocumentStrDID:strDID];
    if ([fileMng fileExistsAtPath:imagepath]) {
        if ([fileMng removeItemAtPath:imagepath error:nil]) {
            NSLog(@"remove success");
        }
    }
    
    
    if(YES == [cameraListMgt RemoveCameraAtIndex:index ]){
        if ([cameraListMgt GetCount] > 0) {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //停止P2P
        pPPPPChannelMgt->Stop([strDID UTF8String]);
        
        [m_pPicPathMgt RemovePicPathByID:strDID];
        [m_pRecPathMgt RemovePathByID:strDID];
        
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        if ([cameraListMgt GetCount] == 0) {
            [self btnEdit:nil];
        }
        
    }    
} 

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //if (indexPath.row == [cameraListMgt GetCount]) {
        return UITableViewCellEditingStyleNone;
    //}
  
    
   // return UITableViewCellEditingStyleDelete;
    
    
    
} 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    self.indPath = anIndexPath;
    cellRow = anIndexPath.row ;
}


#pragma mark UIActionSheetDelegate Method
- (void) NotifyReloadData{
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    return  NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil); 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
      
    int count = [cameraListMgt GetCount];
    

   
    return count + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    
    NSInteger index = anIndexPath.row ;    
    
    //-----------------------------------------------------------------------------------
        
    //index = 0显示添加摄像机
    if (index == [cameraListMgt GetCount]) {
        NSString *cellIdentifier = @"AddCameraCell";       
        //当状态为显示当前的设备列表信息时
        AddCameraCell *cell =  (AddCameraCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddCameraCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.labelAddCamera.text = NSLocalizedStringFromTable(@"TouchAddCamera", @STR_LOCALIZED_FILE_NAME, nil);
        
        float cellHeight = cell.frame.size.height;
       // float cellWidth = cell.frame.size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, winsize.width, cellHeight - 1)];
        label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
        
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, winsize.width, cellHeight - 1)];
        [cellBgView addSubview:label];
        [label release];
        
        cell.backgroundView = cellBgView;
        
        return cell;
    }
    
    //index -= 1;
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    UIImage *img = [cameraDic objectForKey:@STR_IMG];    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    //NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    NSString *pwd=[cameraDic objectForKey:@STR_PWD];
    
    
    NSLog(@"摄像机信息%@",cameraDic);
    

    NSString *cellIdentifier = @"CameraListCell";       
    //当状态为显示当前的设备列表信息时
    CameraListCell *cell =  (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.button.tag = index;
    //cell.button.titleLabel.text = NSLocalizedStringFromTable(@"Menu", @STR_LOCALIZED_FILE_NAME, nil);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGSize winsize = [[UIScreen mainScreen] bounds].size;
        CGRect aFrame = cell.button.frame;
        aFrame.origin = CGPointMake(winsize.width - aFrame.size.width - 20, aFrame.origin.y);
        cell.button.frame = aFrame;
    }
    [cell.button setTitle:NSLocalizedStringFromTable(@"Menu", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(cameraset:) forControlEvents:UIControlEventTouchUpInside];
    
    //MZY  显示危险按钮
    cell.warnBtn.tag = anIndexPath.row + warnBtnTag ;
    [cell.warnBtn addTarget:self action:@selector(clickWarn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.warnBtn setHidden:YES];
    if ([nPPPPStatus integerValue] == PPPP_STATUS_ON_LINE && [pwd isEqualToString:CAMERA_DEFAULT_PWD]) {
        [cell.warnBtn setHidden:NO];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    int PPPPStatus = [nPPPPStatus intValue];
    //int PPPPMode = [nPPPPMode intValue];
    //NSLog(@"name: %@, index: %d, PPPPStatus: %d, PPPPMode: %d", name, index, PPPPStatus, PPPPMode);
        
    if (img != nil) {
        cell.imageCamera.image = img;
    }
        
    cell.NameLable.text = name;
    cell.PPPPIDLable.text = did; 
           
    NSString *strPPPPStatus = nil;
    switch (PPPPStatus) {
        case PPPP_STATUS_UNKNOWN:    
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;    
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
        break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    cell.PPPPStatusLable.text = strPPPPStatus;
    
         
   	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    
    
    if (indexpath.row == [cameraListMgt GetCount]) {
        return 44;
    }
    
    return 74;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    indPath = anIndexPath;
       
    if (anIndexPath.row == [cameraListMgt GetCount]) {
        CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] initWithNibName:@"CameraEditView" bundle:nil];
        cameraEditViewController.editCameraDelegate = self;
        cameraEditViewController.bAddCamera = YES;
        [self.navigationController pushViewController:cameraEditViewController animated:YES]; 
        [cameraEditViewController release];
        return;
    }
    
    NSInteger index = anIndexPath.row;
    //index -= 1;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];        
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
        return;
    }
    
    if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
        return;

//        NSString *strDID = [cameraDic objectForKey:@STR_DID];
//        NSString *strUser = [cameraDic objectForKey:@STR_USER];
//        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];    
//        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        //[mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
            }
    
    
    [self StartPlayView:index];

}
/*-(void)cameraset:(id)sender{
    if (_actionPop) {
        [_actionPop hide];
    }
    
    cellRow = ((UIButton*)sender).tag;
    
    PopupListComponent *popupList = [[PopupListComponent alloc] init];
    NSArray* listItems = nil;
    PopupListComponentItem* item1 = [[PopupListComponentItem alloc] initWithCaption:NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil) image:[UIImage imageNamed:@"ic_setting_camera"] itemId:0 showCaption:YES];
    PopupListComponentItem* item2 = [[PopupListComponentItem alloc] initWithCaption:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Picture", @STR_LOCALIZED_FILE_NAME, nil)] image:[UIImage imageNamed:@"ic_menu_album_inverse"] itemId:1 showCaption:YES];
    PopupListComponentItem* item3 = [[PopupListComponentItem alloc] initWithCaption:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)] image:[UIImage imageNamed:@"ic_menu_checkvideo"] itemId:2 showCaption:YES];
    PopupListComponentItem* item4 = [[PopupListComponentItem alloc] initWithCaption:[NSString stringWithFormat:@" TF%@",NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)] image:[UIImage imageNamed:@"remotetfcard"] itemId:3 showCaption:YES];
    PopupListComponentItem* item5 = [[PopupListComponentItem alloc] initWithCaption:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil)] image:[UIImage imageNamed:@"ic_delete_camera"] itemId:4 showCaption:YES];
    
    listItems = [NSArray arrayWithObjects:item1, item2, item3, item4, item5, nil];
    // Optional: override any default properties you want to change:
    popupList.textColor = [UIColor redColor];
    popupList.imagePaddingHorizontal = 5;
    popupList.imagePaddingVertical = 2;  // Images are taller than text, so this will be determining factor!
    popupList.textPaddingHorizontal = 5;
    popupList.alignment = UIControlContentHorizontalAlignmentLeft;
    [popupList useSystemDefaultFontNonBold];  // Instead of bold font, which is component default.
    
    // Optional: store any object you want to have access to in the delegeate callback(s):
    popupList.userInfo = @"Value to hold on to";
    
    [popupList showAnchoredTo:sender inView:self.view withItems:listItems withDelegate:self];
    
    //UIView* popview =[self.view viewWithTag:200];
    //if ([popview isMemberOfClass:[UIView class]]) {
       // NSLog(@"popview  %@",NSStringFromCGRect([popview frame]));
    //}
    
    _actionPop = popupList;
    [item1 release];
    [item2 release];
    [item3 release];
    [item4 release];
    [item5 release];
}

#pragma mark PopupListComponentDelegate
- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId{
    
    [_actionPop hide];
    
    NSDictionary* cameradic = [cameraListMgt GetCameraAtIndex:cellRow];
    if (cameradic == nil) {
        return;
    }
    
    NSString* strUID = (NSString*)[cameradic objectForKey:@STR_DID];
    NSNumber* status = [cameradic objectForKey:@STR_PPPP_STATUS];
    NSString* strName = [cameradic objectForKey:@STR_NAME];
    
    switch (itemId) {
        case 0:{//设置
            if ([status intValue] != PPPP_STATUS_ON_LINE) {
                [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
                return;
            }
            
            SettingViewController* settingViewCtr = [[SettingViewController alloc] init];
            settingViewCtr.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
            settingViewCtr.m_strDID = strUID;
            settingViewCtr.cameraDic = cameradic;
            settingViewCtr.cameraListMgt = self.cameraListMgt;
            settingViewCtr.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:settingViewCtr animated:YES];
            [settingViewCtr release];
        }
            
            break;
        case 1:{//图片
           
            PictrueDateViewController* picDateViewCtr = [[PictrueDateViewController alloc] init];
            picDateViewCtr.m_pPicPathMgt = self.m_pPicPathMgt;
            picDateViewCtr.strDID = strUID;
            picDateViewCtr.strName = strName;
            picDateViewCtr.NotifyReloadDataDelegate = PicNotifyEventDelegate;
            picDateViewCtr.cameraListMgt = self.cameraListMgt;
            picDateViewCtr.picMgt = self.m_pPicPathMgt;
            picDateViewCtr.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController pushViewController:picDateViewCtr animated:YES];
            [picDateViewCtr release];
        }
            break;
        case 2:{//本地录像
            
            RecordDateViewController* recDateViewCtr = [[RecordDateViewController alloc] init];
            recDateViewCtr.m_pRecPathMgt = self.m_pRecPathMgt;
            recDateViewCtr.RecReloadDelegate = self.RecordNotifyEventDelegate;
            recDateViewCtr.strDID = strUID;
            recDateViewCtr.strName = strName;
            recDateViewCtr.m_PpppchannelMgt = pPPPPChannelMgt;
            recDateViewCtr.camListMgt = cameraListMgt;
            recDateViewCtr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController pushViewController:recDateViewCtr animated:YES];
            [recDateViewCtr release];

                    }
            break;
        case 3:{//远程录像
                        
            if ([status intValue] != PPPP_STATUS_ON_LINE) {
                [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
                return;
            }
            
            RemoteRecordFileListViewController* remoteRec = [[RemoteRecordFileListViewController alloc] init];
            remoteRec.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
            remoteRec.m_strDID = strUID;
            remoteRec.m_strName = strName;
            remoteRec.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
            remoteRec.cameraListMgt = cameraListMgt;
            remoteRec.recPathMgt = m_pRecPathMgt;
            
            [self.navigationController pushViewController:remoteRec animated:YES];
            [remoteRec release];

            
        }
            break;
        case 4:{//删除
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Whetherdelete", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
            [alert show];
            [alert release];
            
                        
        }
            break;
            
        default:
            break;
    }
    
    _actionPop = nil;
}
- (void) popupListcompoentDidCancel:(PopupListComponent *)sender{
    
}*/

-(void)cameraset:(id)sender{
    cellRow = [(UIButton*)sender tag];
    
    /*CamerasetViewController* cameraSetViewCtr = [[CamerasetViewController alloc] init];
    cameraSetViewCtr.cameraListMgt = cameraListMgt;
    cameraSetViewCtr.m_nPPPPChannelMgt = self.pPPPPChannelMgt;
    
    cameraSetViewCtr.PicNotifyEventDelegate = self.PicNotifyEventDelegate;
    cameraSetViewCtr.picPathMgt = self.m_pPicPathMgt;
    cameraSetViewCtr.selectRow = [(UIButton*)sender tag];
    cameraSetViewCtr.delegate = self;
    cameraSetViewCtr.RecordNotifyEventDelegate = RecordNotifyEventDelegate;
    cameraSetViewCtr.m_pRecPathMgt = m_pRecPathMgt;
    _fppviewctr= [[FPPopoverController alloc] initWithViewController:cameraSetViewCtr];
    cameraSetViewCtr.fppopoverCtr = _fppviewctr;
    [cameraSetViewCtr release];
    _fppviewctr.delegate = self;
    _fppviewctr.contentSize = CGSizeMake(200, 290);
    _fppviewctr.tint = FPPopoverDefaultTint;
    _fppviewctr.arrowDirection = FPPopoverArrowDirectionVertical;
    //[_fppviewctr presentPopoverFromView:sender inView:self.view];
    [_fppviewctr presentPopoverFromView:sender];*/
    _customTalert = [[CustomTableAlert alloc] initWithTitle:nil cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) numberOfRows:^NSInteger{
        return 4;
    }tablecell:^UITableViewCell*(CustomTableAlert* table, NSIndexPath* indexPath){
        /*static NSString* idenstr = @"iden";
        UITableViewCell* cell = [table.contentTable dequeueReusableCellWithIdentifier:idenstr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenstr];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"section  %d,row  %d",indexPath.section,indexPath.row];
        return cell;*/
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [table.contentTable dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"ic_setting_camera"];
                cell.textLabel.text = NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"ic_menu_album_inverse"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil)];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"ic_menu_checkvideo"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"LocalRec", @STR_LOCALIZED_FILE_NAME, nil)];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"remotetfcard"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"TFRecord", @STR_LOCALIZED_FILE_NAME, nil)];
                break;
//            case 4:
//                cell.imageView.image = [UIImage imageNamed:@"ic_delete_camera"];
//                cell.textLabel.text = NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil);
            default:
                break;
        }
        
        
        
        return cell;

    }];
    [_customTalert configureTableViewSelectionRowBlock:^(NSIndexPath* indexPath){
        //[tableView deselectRowAtIndexPath:indexPath animated:NO];
        //[_fppopoverCtr dismissPopoverAnimated:YES];
        
        NSDictionary* cameraDic = [cameraListMgt GetCameraAtIndex:[(UIButton*)sender tag]];
        if (cameraDic == nil) {
            return;
        }
        
        NSString* strDID = [cameraDic objectForKey:@STR_DID];
        NSString* strName = [cameraDic objectForKey:@STR_NAME];
        NSString* status = [cameraDic objectForKey:@STR_PPPP_STATUS];
        
        switch (indexPath.row) {
            case 0:
            {
                SettingViewController* settingViewCtr = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                settingViewCtr.cameraListMgt = cameraListMgt;
                settingViewCtr.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
                settingViewCtr.hidesBottomBarWhenPushed = YES;
                settingViewCtr.delegate = self;
                settingViewCtr.editCamerDelegate = self;
                settingViewCtr.SetCamIndex = [(UIButton*)sender tag];
                settingViewCtr.m_strDID = strDID;
                settingViewCtr.cameraDic = cameraDic;
                [self.navigationController pushViewController:settingViewCtr animated:YES];
                [settingViewCtr release];
                settingViewCtr = nil;
            }
                break;
            case 1:
            {
                PictrueDateViewController* picDataViewCtr = [[PictrueDateViewController alloc] init];
                picDataViewCtr.cameraListMgt = cameraListMgt;
                picDataViewCtr.m_pPicPathMgt = self.m_pPicPathMgt;
                picDataViewCtr.picMgt = self.m_pPicPathMgt;
                picDataViewCtr.NotifyReloadDataDelegate = self.PicNotifyEventDelegate;
                picDataViewCtr.strDID = strDID;
                picDataViewCtr.strName = strName;
                [self pushtoView:picDataViewCtr];
                [picDataViewCtr release];
                picDataViewCtr = nil;
            }
                break;
            case 2:
            {
                RecordDateViewController* recDateViewCtr = [[RecordDateViewController alloc] init];
                recDateViewCtr.m_pRecPathMgt = self.m_pRecPathMgt;
                recDateViewCtr.RecReloadDelegate = self.RecordNotifyEventDelegate;
                recDateViewCtr.strDID = strDID;
                recDateViewCtr.strName = strName;
                recDateViewCtr.m_PpppchannelMgt = self.pPPPPChannelMgt;
                recDateViewCtr.camListMgt = self.cameraListMgt;
                recDateViewCtr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self pushtoView:recDateViewCtr];
                [recDateViewCtr release];
                recDateViewCtr = nil;
            }
                break;
            case 3:
            {
                if ([status intValue] != PPPP_STATUS_ON_LINE) {
                    [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
                    return;
                }
                RemoteRecordFileListViewController* remoterecFileListViewCtr = [[RemoteRecordFileListViewController alloc] init];
                remoterecFileListViewCtr.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
                remoterecFileListViewCtr.m_strDID = strDID;
                remoterecFileListViewCtr.m_strName = strName;
                remoterecFileListViewCtr.cameraListMgt = self.cameraListMgt;
                remoterecFileListViewCtr.recPathMgt = self.m_pRecPathMgt;
                [self pushtoView:remoterecFileListViewCtr];
                [remoterecFileListViewCtr release];
                remoterecFileListViewCtr = nil;
            }
                break;
//            case 4:
//            {
//                [self deleteCamera];
//            }
               // break;
            default:
                break;
        }

    }Completion:^{
        ;
    }];
    self.customTalert.height = 296;
    
    
    [_customTalert show];

}

#pragma mark SettingViewControllerDelegate
- (void) deletecam:(int) camIndex{
    self.setCamIndex = camIndex;
    [self deleteCamera];
}

- (void) rebootCam:(int) camIndex{
    self.setCamIndex = camIndex;
    NSDictionary* camdic = [cameraListMgt GetCameraAtIndex:self.setCamIndex];
    
    if (camdic == nil) {
        return;
    }
    NSString* status = [camdic objectForKey:@STR_PPPP_STATUS];
    if ([status intValue] != PPPP_STATUS_ON_LINE) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
    }else{
        UIAlertView* rebootAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"RebootCam", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil),[camdic objectForKey:@STR_NAME]] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        rebootAlert.tag = 11;
        [rebootAlert show];
        [rebootAlert release];
    }
    
}


#pragma mark -
#pragma mark CamerasetViewControllerDelegate
- (void)pushtoView:(UIViewController*)ViewCtr{
    [self.navigationController pushViewController:ViewCtr animated:YES];
}
- (void)deleteCamera{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Whetherdelete", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil),[[cameraListMgt GetCameraAtIndex:self.setCamIndex] objectForKey:@STR_NAME]] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alert.tag = 10;
    [alert show];
    [alert release];
    
}

- (void)clickWarn:(UIButton *)btn {
    NSLog(@"危险Index:%ld",(long)btn.tag);
    self.setCamIndex = short(btn.tag - warnBtnTag);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"Warn_AlertMessage", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alert.tag = warnBtnAlertTag;
    [alert show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.setCamIndex < 0 || self.setCamIndex >= [cameraListMgt GetCount]) {
        return;
    }
    
    NSDictionary* camdic = [cameraListMgt GetCameraAtIndex:self.setCamIndex];
    if (camdic == nil) {
        return;
    }
    NSString* strUID = (NSString*)[camdic objectForKey:@STR_DID];
    if (strUID == nil) {
        return;
    }
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            if (YES == [cameraListMgt RemoveCamerea:strUID]) {
            }
            pPPPPChannelMgt->Stop([strUID UTF8String]);
            [m_pPicPathMgt RemovePicPathByID:strUID];
            [m_pRecPathMgt RemovePathByID:strUID];
            [PicNotifyEventDelegate NotifyReloadData];
            [RecordNotifyEventDelegate NotifyReloadData];
            [self.cameraList reloadData];
            
            
            NSFileManager* fileMng = [NSFileManager   defaultManager];
            /*for (int i = 50; i < 55; i++) {
             NSString* imagePath = [[self PathForDocumentStrDID:strUID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",i]];
             if ([fileMng fileExistsAtPath:[self PathForDocumentStrDID:strUID]]) {
             if ([fileMng removeItemAtPath:imagePath error:nil])
             NSLog(@"remove   success");
             }
             
             }*/
            NSString* imagepath = [self PathForDocumentStrDID:strUID];
            if ([fileMng fileExistsAtPath:imagepath]) {
                if ([fileMng removeItemAtPath:imagepath error:nil]) {
                    NSLog(@"remove success");
                    
                    
                }
                
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@itemId",strUID]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",strUID,TalkMark]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",strUID,AudioMark]];
            
        }

    }else if (alertView.tag == 11){
        if (buttonIndex == 1) {
            // self.is_Editing = NO;
            pPPPPChannelMgt->PPPPSetSystemParams((char*)[strUID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);;
        }

    }else if (alertView.tag == warnBtnAlertTag){
        if (buttonIndex == 1) {
            NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:self.setCamIndex];

            UserPwdSetViewController *UserPwdSettingView = [[UserPwdSetViewController alloc] init];

            UserPwdSettingView.m_strDID = [cameraDic objectForKey:@STR_DID];
            UserPwdSettingView.m_pChannelMgt = pPPPPChannelMgt;
            UserPwdSettingView.cameraListMgt = cameraListMgt;
            UserPwdSettingView.cameraName = [cameraDic objectForKey:@STR_NAME];
            
            [self.navigationController pushViewController:UserPwdSettingView animated:YES];
        }
        
    }
    self.setCamIndex = 100000;
}



#pragma mark -
#pragma mark system

- (void) refresh: (id) sender
{
    [self UpdateCameraSnapshot];
}

- (void) UpdateCameraSnapshot
{   
    int count = [cameraListMgt GetCount];    
    if (count == 0) {
        [self hideLoadingIndicator];
        return;
    }   
    
    //NSLog(@"UpdateCameraSnapshot...count: %d", count);
    int i;
    for (i = 0; i < count; i++)
    {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        if (cameraDic == nil) {
            return ;
        }        
            
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];    
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            continue;
        }
        
        NSString *did = [cameraDic objectForKey:@STR_DID];
        pPPPPChannelMgt->Snapshot([did UTF8String]);        
    }    
    
    [self showLoadingIndicator];    
    [self performSelector:@selector(hideLoadingIndicator) withObject:nil afterDelay:10.0];
    
}

- (void)showLoadingIndicator
{
	UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
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
    [[[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
      target:self
      action:@selector(refresh:)]
     autorelease];
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
    
    int count = [cameraListMgt GetCount];
    
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];        
        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
            continue;
        }
        
        usleep(100000);
        
        NSString *uid = [NSString stringWithUTF8String:[strDID UTF8String]];
        if ([[uid uppercaseString] rangeOfString:@"VSTA"].location != NSNotFound) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"EFGFFBBOKAIEGHJAEDHJFEEOHMNGDCNJCDFKAKHLEBJHKEKMCAFCDLLLHAOCJPPMBHMNOMCJKGJEBGGHJHIOMFBDNPKNFEGCEGCBGCALMFOHBCGMFK",0);
        }else if ([[uid uppercaseString] rangeOfString:@"VSTG"].location != NSNotFound) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"EEGDFHBOKCIGGFJPECHIFNEBGJNLHOMIHEFJBADPAGJELNKJDKANCBPJGHLAIALAADMDKPDGOENEBECCIK:vstarcam2018",0);
        }else if ([[uid uppercaseString] rangeOfString:@"VSTE"].location != NSNotFound) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"EEGDFHBAKKIOGNJHEGHMFEEDGLNOHJMPHAFPBEDLADILKEKPDLBDDNPOHKKCIFKJBNNNKLCPPPNDBFDL",0);
        }else if ([[uid uppercaseString] rangeOfString:@"VSTB"].location != NSNotFound ) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
        }else if ([[uid uppercaseString] rangeOfString:@"VSTC"].location != NSNotFound ) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
        }else if ([[uid uppercaseString] rangeOfString:@"VSTD"].location != NSNotFound ) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$",1);
        }else if ([[uid uppercaseString] rangeOfString:@"VSTF"].location != NSNotFound ) {
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"HZLXEJIALKHYATPCHULNSVLMEELSHWIHPFIBAOHXIDICSQEHENEKPAARSTELERPDLNEPLKEILPHUHXHZEJEEEHEGEM-$$",1);
        }
        else
        {
             pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String],@"",0);
        }
       
    }
}

- (void) StopPPPP
{
    [ppppChannelMgntCondition lock];
    if (pPPPPChannelMgt == NULL) {
        [ppppChannelMgntCondition unlock];
        return;
    }
    pPPPPChannelMgt->StopAll();
    [ppppChannelMgntCondition unlock];
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
    
    
    bEditMode = NO;
    //[self.tabBarController.tabBar exchangeSubviewAtIndex:<#(NSInteger)#> withSubviewAtIndex:<#(NSInteger)#>];
    //NSLog(@"self.view   %@",[self.view.window subviews]);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
   // self.tabBarController.tabBar.hidden = YES;
   // NSLog(@"sys  %@",);
   // UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil)];
    self.navigationItem.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
    /*UIImage* backGroundImg = [UIImage imageNamed:@"record30.png"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 50);
    //btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(pushrec:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:backGroundImg forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(28, -backGroundImg.size.width, 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-18, 0, 0, -btn.bounds.size.width + 43)];
   
    
    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    */
    //UIImage* aboutBackGround = [UIImage imageNamed:@"about.png"];
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //rightbtn.backgroundColor = [UIColor redColor];
    leftBtn.frame = CGRectMake(0, 0, 40, 30);
    [leftBtn addTarget:self action:@selector(About:) forControlEvents:UIControlEventTouchUpInside];
    //[rightbtn setImage:aboutBackGround forState:UIControlStateNormal];
    //[rightbtn setTitle:NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    //[rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(28, -aboutBackGround.size.width + 40, 0, 0)];
    //[rightbtn setImageEdgeInsets:UIEdgeInsetsMake(-16, 40, 0, 10)];
    
    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    self.navigationItem.leftBarButtonItem= leftBar;
    //item.leftBarButtonItem = leftBar;
    //item.rightBarButtonItem = rightBar;
    
    //NSArray* itemarr = [NSArray arrayWithObjects:item,nil];
    //[self.navigationBar setItems:itemarr animated:YES];
    //[/item release];
    //[leftBar release];
    [leftBar release];

   // if (![[NSUserDefaults standardUserDefaults] boolForKey:spliteBtn]) {
        //UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Splite", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(splite:)];
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"muscreen"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(splite:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn release];
    //}else{
   //     self.navigationItem.rightBarButtonItem = nil;
   // }
       // [self setNavigationBarItem:bEditMode];

    [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.cameraList setSeparatorColor:[UIColor clearColor]];
    
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
  
    //[ppppChannelMgntCondition lock];
    //pPPPPChannelMgt = new CPPPPChannelManagement();
    pPPPPChannelMgt->pCameraViewController = self;
    //[ppppChannelMgntCondition unlock];
    
    [self StartPPPPThread];
    
    InitAudioSession();
    
    //[self.view bringSubviewToFront:cameraList];
    
}


- (void)splite:(id)sender{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    CH264Decoder *pH264Decoder=new CH264Decoder();
    delete pH264Decoder;
    pH264Decoder = NULL;//暂时解决多画面找不到解码器问题，以后需要进一步修改解码库。
    
    Split_screenViewController* splitvc = [[Split_screenViewController alloc] init];
    
    IpCameraClientAppDelegate *IPCAMDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [IPCAMDelegate switchSpliteScreen:splitvc];
    [splitvc release];
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    NSLog(@"aaaa");
    return YES;
}

-(void)pushrec:(id)sender{
    RecordViewController* recViewController = [[RecordViewController alloc] init];
    recViewController.m_pCameraListMgt = cameraListMgt;
    recViewController.m_pRecPathMgt = m_pRecPathMgt;
    recViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    [self.navigationController pushViewController:recViewController animated:YES];
    [recViewController release];

}

-(void)About:(id)sender{
    AboutViewController* aboutViewCtr = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewCtr animated:YES];
    [aboutViewCtr release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [cameraList reloadData];
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:spliteBtn] && self.navigationItem.rightBarButtonItem == nil) {
//        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Splite", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(splite:)];
//        self.navigationItem.rightBarButtonItem = rightItem;
//        [rightItem release];
//    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) StartPPPPThread
{
    //NSLog(@"StartPPPPThread");
    [ppppChannelMgntCondition lock];
    if (pPPPPChannelMgt == NULL) {
        [ppppChannelMgntCondition unlock];
        return;
    }    
    [NSThread detachNewThreadSelector:@selector(StartPPPP:) toTarget:self withObject:nil];   
    [ppppChannelMgntCondition unlock];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    //[cameraListMgt release];
    //cameraListMgt = nil;
    SAFE_DELETE(pPPPPChannelMgt);    
}

- (void)dealloc {
    self.cameraList = nil;
    //[cameraListMgt release];
    //cameraListMgt = nil;
    SAFE_DELETE(pPPPPChannelMgt);
    [ppppChannelMgntCondition release];
    [_playViewController release];
    _playViewController = nil;
    self.navigationBar = nil;
    self.cameraListMgt = nil;
    self.PicNotifyEventDelegate = nil;
    self.RecordNotifyEventDelegate = nil;
    self.m_pPicPathMgt = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark EditCameraProtocol

- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid
{
    NSLog(@"P2P代理函数");
    NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@", bAdd, name, did, user, pwd, olddid);
    
    BOOL bRet;
    
    if (bAdd == YES) {
        bRet = [cameraListMgt AddCamera:name DID:did User:user Pwd:pwd Snapshot:nil];
    }else {
        bRet = [cameraListMgt EditCamera:olddid Name:name DID:did User:user Pwd:pwd];
    }
    
    if (bRet == YES) {

        if (bAdd) {//添加成功，增加P2P连接
            NSString *uid = [NSString stringWithUTF8String:[did UTF8String]];
            if ([[uid uppercaseString] rangeOfString:@"VSTA"].location != NSNotFound) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EFGFFBBOKAIEGHJAEDHJFEEOHMNGDCNJCDFKAKHLEBJHKEKMCAFCDLLLHAOCJPPMBHMNOMCJKGJEBGGHJHIOMFBDNPKNFEGCEGCBGCALMFOHBCGMFK",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTG"].location != NSNotFound) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EEGDFHBOKCIGGFJPECHIFNEBGJNLHOMIHEFJBADPAGJELNKJDKANCBPJGHLAIALAADMDKPDGOENEBECCIK:vstarcam2018",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTE"].location != NSNotFound) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EEGDFHBAKKIOGNJHEGHMFEEDGLNOHJMPHAFPBEDLADILKEKPDLBDDNPOHKKCIFKJBNNNKLCPPPNDBFDL",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTB"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTC"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTD"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$",1);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTF"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"HZLXEJIALKHYATPCHULNSVLMEELSHWIHPFIBAOHXIDICSQEHENEKPAARSTELERPDLNEPLKEILPHUHXHZEJEEEHEGEM-$$",1);
            }
            else
            {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"",0);
            }
        }else {//修改成功，重新启动P2P连接
            pPPPPChannelMgt->Stop([did UTF8String]);
            NSString *uid = [NSString stringWithUTF8String:[did UTF8String]];
            if ([[uid uppercaseString] rangeOfString:@"VSTA"].location != NSNotFound) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EFGFFBBOKAIEGHJAEDHJFEEOHMNGDCNJCDFKAKHLEBJHKEKMCAFCDLLLHAOCJPPMBHMNOMCJKGJEBGGHJHIOMFBDNPKNFEGCEGCBGCALMFOHBCGMFK",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTG"].location != NSNotFound) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EEGDFHBOKCIGGFJPECHIFNEBGJNLHOMIHEFJBADPAGJELNKJDKANCBPJGHLAIALAADMDKPDGOENEBECCIK:vstarcam2018",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTE"].location != NSNotFound) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"EEGDFHBAKKIOGNJHEGHMFEEDGLNOHJMPHAFPBEDLADILKEKPDLBDDNPOHKKCIFKJBNNNKLCPPPNDBFDL",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTB"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTC"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL",0);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTD"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$",1);
            }else if ([[uid uppercaseString] rangeOfString:@"VSTF"].location != NSNotFound ) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"HZLXEJIALKHYATPCHULNSVLMEELSHWIHPFIBAOHXIDICSQEHENEKPAARSTELERPDLNEPLKEILPHUHXHZEJEEEHEGEM-$$",1);
            }
            else
            {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String],@"",0);
            }
            [self btnEdit:nil];
        }
        
        if (bEditMode && [olddid caseInsensitiveCompare:did] != NSOrderedSame) {
            [m_pPicPathMgt RemovePicPathByID:olddid];
        }
        
        //添加或修改设备成功，重新加载设备列表
        [cameraList reloadData];
        
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        
    }
    
    NSLog(@"bRet: %d", bRet);
    
    return bRet;
}

#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    NSLog(@"PPPPStatus ..... strDID: %@, statusType: %d, status: %d", strDID, statusType, status);
    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {        
        NSInteger index = [cameraListMgt UpdatePPPPMode:strDID mode:status];
        if ( index >= 0){          
         //   [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
            int Camindex = [cameraListMgt GetIndexFromDID:strDID];
            [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:Camindex] waitUntilDone:NO];
        }
        return;
    }
    NSLog(@"status  %d",status);
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        NSInteger index = [cameraListMgt UpdatePPPPStatus:strDID status:status];
        
        if ( index >= 0){
            int Camindex = [cameraListMgt GetIndexFromDID:strDID];
            [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:Camindex] waitUntilDone:NO];
            //[self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        }
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID 
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED
            || status == PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
        }
        [RecordNotifyEventDelegate NotifyReloadData];
        
        return;        
    }    
}

#pragma mark -
#pragma mark PerformInMainThread

- (void) ReloadCameraTableView
{
    [cameraList reloadData];  
}

- (void) ReloadRowDataAtIndex: (NSNumber*) indexNumber
{
    NSLog(@"indexNumber  %@",indexNumber);
    NSInteger index = [indexNumber intValue];
    if (index == [cameraListMgt GetCount]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [cameraList cellForRowAtIndexPath:indexPath];
    if (cell != nil) {              
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [cameraList reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
} 

- (void) StopPPPPByDID:(NSString*)did
{
    pPPPPChannelMgt->Stop([did UTF8String]);
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 0.0001);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    
    [pool release];
 
    
}

#pragma mark -
#pragma mark SnapshotNotify

- (void) SnapshotNotify:(NSString *)strDID data:(char *)data length:(int)length
{   
    //NSLog(@"CameraViewController SnapshotNotify... strDID: %@, length: %d", strDID, length);
    if (length < 20) {
        return;
    }
    
    //显示图片
    NSData *image = [[NSData alloc] initWithBytes:data length:length];
    if (image == nil) {
        //NSLog(@"SnapshotNotify image == nil");
        [image release];
        return;
    }
    
    UIImage *img = [[UIImage alloc] initWithData:image];

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];

    int Camindex = [cameraListMgt GetIndexFromDID:strDID];
    
    NSInteger index = [cameraListMgt UpdateCamereaImage:strDID  Image:imgScale] ;
    if (index >= 0) {
        [self saveSnapshot:imgScale DID:strDID];
        [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:Camindex] waitUntilDone:NO];
    }  
    
    [pool release];
    
    [img release];        
    [image release];
    
}


@end
