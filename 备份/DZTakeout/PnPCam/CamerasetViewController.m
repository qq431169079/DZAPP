//
//  CamerasetViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-1-18.
//
//

#import "CamerasetViewController.h"

@interface CamerasetViewController ()

@end

@implementation CamerasetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

/*NSLocalizedStringFromTable(@"Picture", @STR_LOCALIZED_FILE_NAME, nil), [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Remote", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)], [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)],NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil)*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Picture", @STR_LOCALIZED_FILE_NAME, nil)];
            break;
            case 2:
            cell.imageView.image = [UIImage imageNamed:@"ic_menu_checkvideo"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)];
            break;
            case 3:
            cell.imageView.image = [UIImage imageNamed:@"remotetfcard"];
            cell.textLabel.text = [NSString stringWithFormat:@"TF%@",NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)];
            break;
            case 4:
            cell.imageView.image = [UIImage imageNamed:@"ic_delete_camera"];
            cell.textLabel.text = NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil);
        default:
            break;
    }
    
   
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_fppopoverCtr dismissPopoverAnimated:YES];

    NSDictionary* cameraDic = [_cameraListMgt GetCameraAtIndex:_selectRow];
    if (cameraDic == nil) {
        return;
    }
    
    NSString* strDID = [cameraDic objectForKey:@STR_DID];
    NSString* strName = [cameraDic objectForKey:@STR_NAME];
    NSString* status = [cameraDic objectForKey:@STR_PPPP_STATUS];
    
    NSLog(@"tableView   delegate");
    switch (indexPath.row) {
        case 0:
        {
            SettingViewController* settingViewCtr = [[SettingViewController alloc] init];
            settingViewCtr.cameraListMgt = _cameraListMgt;
            settingViewCtr.m_pPPPPChannelMgt = _m_nPPPPChannelMgt;
            settingViewCtr.m_strDID = strDID;
            settingViewCtr.cameraDic = cameraDic;
            [_delegate pushtoView:settingViewCtr];
            [settingViewCtr release];
            settingViewCtr = nil;
        }
            break;
            case 1:
        {
            PictrueDateViewController* picDataViewCtr = [[PictrueDateViewController alloc] init];
            picDataViewCtr.cameraListMgt = _cameraListMgt;
            picDataViewCtr.m_pPicPathMgt = _picPathMgt;
            picDataViewCtr.picMgt = _picPathMgt;
            picDataViewCtr.NotifyReloadDataDelegate = _PicNotifyEventDelegate;
            picDataViewCtr.strDID = strDID;
            picDataViewCtr.strName = strName;
            [_delegate pushtoView:picDataViewCtr];
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
            recDateViewCtr.m_PpppchannelMgt = _m_nPPPPChannelMgt;
            recDateViewCtr.camListMgt = _cameraListMgt;
            recDateViewCtr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [_delegate pushtoView:recDateViewCtr];
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
            remoterecFileListViewCtr.m_pPPPPChannelMgt = self.m_nPPPPChannelMgt;
            remoterecFileListViewCtr.m_strDID = strDID;
            remoterecFileListViewCtr.m_strName = strName;
            remoterecFileListViewCtr.cameraListMgt = _cameraListMgt;
            remoterecFileListViewCtr.recPathMgt = _m_pRecPathMgt;
            [_delegate pushtoView:remoterecFileListViewCtr];
            [remoterecFileListViewCtr release];
            remoterecFileListViewCtr = nil;
        }
            break;
            case 4:
        {
            [_delegate deleteCamera];
        }
            break;
        default:
            break;
    }
}
- (void)dealloc{
    [super dealloc];
    _fppopoverCtr = nil;
    _cameraListMgt = nil;
    _m_nPPPPChannelMgt = nil;
    _delegate = nil;
    _picDataViewCtr = nil;
    _picPathMgt = nil;
    _m_pRecPathMgt = nil;
    _PicNotifyEventDelegate = nil;
    _RecordNotifyEventDelegate = nil;
}

@end
