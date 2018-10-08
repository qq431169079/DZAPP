//
//  RemoteRecordFileListViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-14.
//
//

#import "RemoteRecordFileListViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "RemotePlaybackViewController.h"
#import "IpCameraClientAppDelegate.h"

#define STR_RECORD_FILE_NAME "STR_RECORD_FILE_NAME"
#define STR_RECORD_FILE_SIZE "STR_RECORD_FILE_SIZE"
#define STR_DATE @"STR_DATE"
#define STR_TIME @"STR_TIME"
#define STR_TYPE @"STR_TYPE"
#define STR_GROUP_NAME @"STR_GROUP"
#define STR_ISCELLTAP @"STR_ISCELLTAP"
@interface RemoteRecordFileListViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation RemoteRecordFileListViewController
@synthesize navigationBar;
@synthesize tableView;
@synthesize m_pPPPPChannelMgt;
@synthesize m_strDID;
@synthesize m_strName;
@synthesize cameraListMgt;
@synthesize recPathMgt;
@synthesize recViewCtr;
@synthesize m_RecordDate = _m_RecordDate;
@synthesize m_RecordTypeparameter = _m_RecordTypeparameter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) refresh:(id)param
{
    // [m_RecordFileList removeAllObjects];
    //[self.m_RecordDate removeAllObjects];
    // [self.m_RecordTypeparameter removeAllObjects];
    //  [self.m_RecordCopy removeAllObjects];
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self ReloadTableView];
    //for (int i = 0; i < 5000; i++) {
    int index = ++_pageindex;
    m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String], index,  500);
    
    //}
    
    m_bFinished = NO;
    
}

- (void)handleTimer:(id)param
{
    [self StopTimer];
    [self hideLoadingIndicator];
    m_bFinished = YES;
    //[self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

- (void) StopTimer
{
    [m_timerLock lock];
    if (m_timer != nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
    [m_timerLock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dateStr = [[NSString alloc] init];
    //UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    //[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    UIBarButtonItem* leftbar = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStylePlain target:self action:@selector(popView:)];
    leftbar.enabled = NO;
    self.navigationItem.leftBarButtonItem = leftbar;
//    [leftbar release];
    
    _pageindex = 0;
    _recordCount = 0;
    //NSLog(@"WifiSettingViewController viewDidLoad");
    m_timerLock = [[NSCondition alloc] init];
    
    m_bFinished = NO;
    m_RecordFileList = [[NSMutableArray alloc] init];
    self.m_RecordDate = [[NSMutableArray alloc] init];
    self.m_RecordTypeparameter = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    m_pPPPPChannelMgt->SetSDCardSearchDelegate((char*)[m_strDID UTF8String], self);
    m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String], 0, 500);
    
}

- (void) handleSwipeGes{
    if (self.navigationItem.leftBarButtonItem.enabled) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)popView:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) viewDidUnload
{
    
    [super viewDidUnload];
    
    if (m_RecordFileList != nil) {
//        [m_RecordFileList release];
        m_RecordFileList = nil;
    }
    
    m_pPPPPChannelMgt->SetSDCardSearchDelegate((char*)[m_strDID UTF8String], nil);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self StopTimer];
}

- (void)showLoadingIndicator
{
    NSString *strTitle = m_strName;
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    // UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    self.navigationItem.title = strTitle;
    //创建一个右边按钮
    
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     ;
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = progress;
    //item.rightBarButtonItem = progress;
    
    //NSArray *array = [NSArray arrayWithObjects:back,item, nil];
    //[self.navigationBar setItems:array];
	
    //[item release];
    //[back release];
}

/*-(void)pushrec:(id)sender{
 recViewCtr = [[RecordViewController alloc] init];
 recViewCtr.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
 recViewCtr.m_pCameraListMgt = cameraListMgt;
 recViewCtr.m_pRecPathMgt = recPathMgt;
 [self.navigationController pushViewController:recViewCtr animated:YES];
 [recViewCtr release];
 }*/

- (void)hideLoadingIndicator
{
    NSString *strTitle = m_strName;
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    self.navigationItem.title = strTitle;
    if (_recordCount == 0) {
        CGSize winsize = [UIScreen mainScreen].applicationFrame.size;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, winsize.height/2 - 20.f, winsize.width, 40.f)];
        label.textAlignment = NSTextAlignmentCenter;
        //        label.shadowColor = [UIColor blackColor];
        //        label.shadowOffset = CGSizeMake(1, -1);
        label.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:17];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedStringFromTable(@"Noevents", @STR_LOCALIZED_FILE_NAME, nil);
        
        
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, winsize.width, winsize.height - 44.f)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [view addSubview:label];
        [self.view addSubview:view];

    }
	/*UIBarButtonItem *actionButton =
     [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
     target:self
     action:@selector(refresh:)];*/
    //    UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"GetMore", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    //item.rightBarButtonItem = actionButton;
    
    // NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
	
    //[actionButton release];
    //[item release];
    //[back release];
    
}

/*-(void)action:(id)sender{
 UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"Refresh", @STR_LOCALIZED_FILE_NAME, nil), NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil), nil];
 [action showInView:self.view];
 [action release];
 }
 
 #pragma  mark UIActionSheetDelegate
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 switch (buttonIndex) {
 case 0:
 [self performSelector:@selector(refresh:) withObject:nil withObject:nil];
 break;
 case 1:
 //[self performSelector:@selector(pushrec:) withObject:nil withObject:nil];
 //[self performSelectorOnMainThread:@selector(pushrec:) withObject:nil waitUntilDone:YES];
 {
 recViewCtr = [[RecordViewController alloc] init];
 recViewCtr.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
 recViewCtr.m_pCameraListMgt = cameraListMgt;
 recViewCtr.m_pRecPathMgt = recPathMgt;
 [self.navigationController pushViewController:recViewCtr animated:YES];
 [recViewCtr release];
 }
 break;
 
 default:
 break;
 }
 }
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    _swipeGes = nil;
    
    m_pPPPPChannelMgt->SetSDCardSearchDelegate((char*)[m_strDID UTF8String], nil);
    self.navigationBar = nil;
    self.tableView = nil;
    self.m_strDID = nil;
    self.m_strName = nil;
    if (m_RecordFileList != nil) {

        m_RecordFileList = nil;
    }
    if (self.m_RecordDate != nil) {

        self.m_RecordDate = nil;
    }
    if (self.m_RecordTypeparameter != nil) {

        self.m_RecordTypeparameter = nil;
    }
    self.dateStr = nil;
    self.cameraListMgt = nil;
    self.recViewCtr = nil;
    self.recPathMgt = nil;

}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (_recordCount == 0) {
        return [self.m_RecordDate count];
    }else{
        return [self.m_RecordDate count] + 1;
    }
}

- (UITableViewCell *) tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    
    /*NSString *cellIdentifier = @"RemoteRecordFileListCell";
     UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
     
     if (cell == nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
     
     //cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     NSDictionary *fileDic = [self.m_RecordDate objectAtIndex:anIndexPath.row];
     cell.textLabel.text = [fileDic objectForKey:STR_DATE];
     
     return cell;*/
    if (anIndexPath.row == [self.m_RecordDate count]) {
        static NSString* celliden = @"isLabelcell";
        UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:celliden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celliden];
        }
        
        //UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, cell.frame.size.width, cell.frame.size.height - 1)];
        cell.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        if ( _recordCount > [self.m_RecordTypeparameter count]) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Clickhereformoreevents", @STR_LOCALIZED_FILE_NAME, nil);
        }else{
            cell.textLabel.text = NSLocalizedStringFromTable(@"Eventacquisitioniscomplete", @STR_LOCALIZED_FILE_NAME, nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    NSDictionary* recordDic = [self.m_RecordDate objectAtIndex:anIndexPath.row];
    if (recordDic == nil) {
        return nil;
    }
    if ([(NSString*)[recordDic objectForKey:STR_GROUP_NAME] isEqualToString:@"YES"]) {
        static NSString* iden = @"groupcell";
        RemoteRecordGroupCell* cell = [aTableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"RemoteRecordGroupCell" owner:nil options:nil];
            cell = [nib lastObject];
        }
        UIImage* iconimage;
        if ([(NSString*)[recordDic objectForKey:STR_ISCELLTAP] isEqualToString:@"NO"]) {
            iconimage  = [UIImage imageNamed:@"arrowRight"];
        }else{
            iconimage  = [UIImage imageNamed:@"arrowDown"];
        }
        
        UIImage* newiconImg = [self fitImage:iconimage tofitHeight:30];
        CGRect newFrame = cell.iconImg.frame;
        newFrame.size = newiconImg.size;
        cell.iconImg.frame = newFrame;
        cell.iconImg.image = newiconImg;
        cell.dateLabel.text = [recordDic objectForKey:STR_DATE];
        
        return cell;
    }else{
        static NSString* iden = @"cell";
        RemoteRecordCell* cell = [aTableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"RemoteRecordCell" owner:nil options:nil];
            cell = [nib lastObject];
        }
        UIImage* iconimg;
        NSString* type = [recordDic objectForKey:STR_TYPE] ;
        if ([type isEqualToString:@"10"]) {
            iconimg = [UIImage imageNamed:@"ic_menu_event"];
            cell.typeLabel.text = NSLocalizedStringFromTable(@"MotionDetection", @STR_LOCALIZED_FILE_NAME, nil);
        }else if ([type isEqualToString:@"01"] || [type isEqualToString:@"11"]){
            iconimg = [UIImage imageNamed:@"Externalinput"];
            cell.typeLabel.text = NSLocalizedStringFromTable(@"ExternalInput", @STR_LOCALIZED_FILE_NAME, nil);
        }else{
            iconimg = [UIImage imageNamed:@"Timingvideo"];
            cell.typeLabel.text = NSLocalizedStringFromTable(@"TimerRecording", @STR_LOCALIZED_FILE_NAME, nil);
        }
        UIImage* newiconImg = [self fitImage:iconimg tofitHeight:40];
        CGRect newFrame = cell.iconImg.frame;
        newFrame.size = newiconImg.size;
        cell.iconImg.frame = newFrame;
        cell.iconImg.image = newiconImg;
        //NSLog(@"%@",NSStringFromCGSize(newiconImg.size));
        cell.dateLabel.text = [recordDic objectForKey:STR_TIME];
        return cell;
    }
}

- (void)refreshData:(NSIndexPath*)anIndexPath{
    NSMutableArray* tmpArray = [NSMutableArray arrayWithArray:self.m_RecordDate];//self.m_RecordDate;
    NSLog(@"tmpArrayCount  %d",[tmpArray count]);
    int i = anIndexPath.row;
    int j = anIndexPath.row + 1;
    int m = 0;
    NSDictionary* dateDic = [self.m_RecordDate objectAtIndex:i];
    for (NSDictionary* dic in self.m_RecordTypeparameter){
        if ([(NSString*)[dateDic objectForKey:STR_DATE] isEqualToString:(NSString*)[dic objectForKey:STR_DATE]]) {
            i++;
            if ([(NSString*)[dateDic objectForKey:STR_ISCELLTAP] isEqualToString:@"NO"]) {
                [tmpArray insertObject:dic atIndex:i];
            }else{
                m++;
                if ([self.m_RecordDate count] - anIndexPath.row > m) {
                    [tmpArray removeObjectAtIndex:j];
                }
                
            }
            
        }
    }
    //[tmpArray removeObjectAtIndex:1];
    if (self.m_RecordDate != nil) {

        self.m_RecordDate = nil;
    }
    //NSLog(@"tmpArray  %d",[tmpArray count]);
    self.m_RecordDate = tmpArray;
    [self ReloadTableView];
    
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (indexpath.row == [self.m_RecordDate count]) {
        return 44;
    }
    
    if ([(NSString*)[(NSDictionary*)[self.m_RecordDate objectAtIndex:indexpath.row] objectForKey:STR_GROUP_NAME] isEqualToString:@"YES"]){
        return 44;
    }else{
        return 54;
    }
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:NO];
    if (anIndexPath.row == [self.m_RecordDate count]) {
        if (_recordCount > [self.m_RecordTypeparameter count]) {
            [self showLoadingIndicator];
            m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
            [self ReloadTableView];
            //for (int i = 0; i < 5000; i++) {
            self.navigationItem.leftBarButtonItem.enabled = NO;
            int index = ++_pageindex;
            m_pPPPPChannelMgt->PPPPGetSDCardRecordFileList((char*)[m_strDID UTF8String], index,  500);
            
            //}
            
            m_bFinished = NO;
        }
        return;
    }
    
    NSMutableDictionary* recordDic = [self.m_RecordDate objectAtIndex:anIndexPath.row];
    if ([(NSString*)[recordDic objectForKey:STR_GROUP_NAME] isEqualToString:@"YES"]) {
        //RemoteRecordGroupCell* remotecell = (RemoteRecordGroupCell*)[aTableView cellForRowAtIndexPath:anIndexPath];
        if ([(NSString*)[recordDic objectForKey:STR_ISCELLTAP] isEqualToString:@"NO"]) {
            [self refreshData:anIndexPath];
            [recordDic setObject:@"YES" forKey:STR_ISCELLTAP];
        }else{
            //            if (self.m_RecordDate != nil) {
            //                [self.m_RecordDate release];
            //                self.m_RecordDate = nil;
            //            }
            
            [self refreshData:anIndexPath];
            [recordDic setObject:@"NO" forKey:STR_ISCELLTAP];
        }
    }else{
        NSString *strFileName = [recordDic objectForKey:@STR_RECORD_FILE_NAME];
        int record_Size = [[recordDic objectForKey:@STR_RECORD_FILE_SIZE] intValue];
        RemotePlaybackViewController *remotePlaybackViewController = [[RemotePlaybackViewController alloc] init];
        
        remotePlaybackViewController.m_strName = m_strName;
        remotePlaybackViewController.m_strFileName = strFileName;
        remotePlaybackViewController.m_pPPPPMgnt = m_pPPPPChannelMgt;
        remotePlaybackViewController.strDID = m_strDID;
        remotePlaybackViewController.record_Size = record_Size;
        IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
        [IPCamDelegate switchRemotePlaybackView:remotePlaybackViewController];
 }
    
    /*NSDictionary *fileDic = [m_RecordFileList objectAtIndex:anIndexPath.row];
     NSString *strFileName = [fileDic objectForKey:@STR_RECORD_FILE_NAME];
     RemotePlaybackViewController *remotePlaybackViewController = [[RemotePlaybackViewController alloc] init];
     
     remotePlaybackViewController.m_strName = m_strName;
     remotePlaybackViewController.m_strFileName = strFileName;
     remotePlaybackViewController.m_pPPPPMgnt = m_pPPPPChannelMgt;
     remotePlaybackViewController.strDID = m_strDID;
     
     IpCameraClientAppDelegate *IPCamDelegate = [[UIApplication sharedApplication] delegate];
     [IPCamDelegate switchRemotePlaybackView:remotePlaybackViewController];
     [remotePlaybackViewController release];*/
    
}

#pragma mark -
#pragma mark performOnMainThread

- (void) ReloadTableView
{
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark -
#pragma mark sdcardfilelistresult
- (void) SDCardRecordFileSearchResult: (NSString *) did filename: (NSString *) strFileName fileSize: (NSInteger) fileSize recodeCount: (NSInteger) recordcount pageindex: (NSInteger) pageIndex pageSize: (NSInteger) pageSize bEnd: (BOOL) bEnd{
    // NSLog(@"fileName  %@  bEnd  %d  recordCount %d",strFileName,bEnd,recordcount);
    _recordCount = recordcount;
    [self performSelectorOnMainThread:@selector(StopTimer) withObject:nil waitUntilDone:YES];
    
    if (m_bFinished == YES) {
        return;
    }
    
    NSDictionary *fileDic = [NSDictionary dictionaryWithObjectsAndKeys:strFileName, @STR_RECORD_FILE_NAME, [NSString stringWithFormat:@"%d", fileSize], @STR_RECORD_FILE_SIZE, nil];
    
    [m_RecordFileList addObject:fileDic];
    
    NSString* dateYear = [strFileName substringWithRange:NSMakeRange(0, 4)];
    NSString* dateMonth = [strFileName substringWithRange:NSMakeRange(4, 2)];
    NSString* dateDay = [strFileName substringWithRange:NSMakeRange(6, 2)];
    NSString* datemark = [NSString stringWithFormat:@"%@-%@-%@",dateYear,dateMonth,dateDay];
    NSString* recordfileSize = [NSString stringWithFormat:@"%ld", (long)fileSize];
    if (![self.dateStr isEqualToString:datemark]){
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:datemark, STR_DATE, [NSString stringWithFormat:@"%@",@"YES"], STR_GROUP_NAME, [NSString stringWithFormat:@"%@",@"NO"], STR_ISCELLTAP, recordfileSize, @STR_RECORD_FILE_SIZE, nil]];
        [_m_RecordDate addObject:dic];
        self.dateStr = datemark;
    }
    
    
    NSString* dateHour = [strFileName substringWithRange:NSMakeRange(8, 2)];
    NSString* dateMinute = [strFileName substringWithRange:NSMakeRange(10, 2)];
    NSString* dateSec = [strFileName substringWithRange:NSMakeRange(12, 2)];
    NSString* type = [strFileName substringWithRange:NSMakeRange(15, 3)];
    // NSLog(@"Year %@  Month %@ Day %@ Hour %@ Minute %@ Sec %@ type %@",dateYear,dateMonth,dateDay,dateHour,dateMinute,dateSec,type);
    NSDictionary* datetype = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@-%@",dateYear,dateMonth,dateDay], STR_DATE, [NSString stringWithFormat:@"%@:%@:%@",dateHour,dateMinute,dateSec], STR_TIME, [NSString stringWithString:type], STR_TYPE,strFileName, @STR_RECORD_FILE_NAME, [NSString stringWithFormat:@"%@",@"NO"], STR_GROUP_NAME, recordfileSize, @STR_RECORD_FILE_SIZE,nil];
    
    [self.m_RecordTypeparameter addObject:datetype];
    
    
    if (bEnd == 1) {
        //        if ([self.m_RecordCopy count] != 0) {
        //            [self.m_RecordCopy release];
        //            self.m_RecordCopy = nil;
        //        }
        //       // self.dateStr = @"";
        //        self.m_RecordCopy = [self.m_RecordDate copy];
        NSLog(@"self.m_RecordCount  %d   self.m_RecordTypeparameter  %d",[self.m_RecordDate count],[self.m_RecordTypeparameter count]);
        [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
    }
    
}

/*- (void) SDCardRecordFileSearchResult:(NSString *)strFileName fileSize:(NSInteger)fileSize bEnd:(BOOL)bEnd
 {
 // NSLog(@"strFileName: %@, fileSize: %d, bEnd: %d", strFileName, fileSize, bEnd);
 
 [self performSelectorOnMainThread:@selector(StopTimer) withObject:nil waitUntilDone:YES];
 
 if (m_bFinished == YES) {
 return;
 }
 
 NSDictionary *fileDic = [NSDictionary dictionaryWithObjectsAndKeys:strFileName, @STR_RECORD_FILE_NAME, [NSString stringWithFormat:@"%d", fileSize], @STR_RECORD_FILE_SIZE, nil];
 
 [m_RecordFileList addObject:fileDic];
 
 NSString* dateYear = [strFileName substringWithRange:NSMakeRange(0, 4)];
 NSString* dateMonth = [strFileName substringWithRange:NSMakeRange(4, 2)];
 NSString* dateDay = [strFileName substringWithRange:NSMakeRange(6, 2)];
 NSString* datemark = [NSString stringWithFormat:@"%@-%@-%@",dateYear,dateMonth,dateDay];
 if (![self.dateStr isEqualToString:datemark]){
 NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:datemark, STR_DATE, [NSString stringWithFormat:@"%@",@"YES"], STR_GROUP_NAME, [NSString stringWithFormat:@"%@",@"NO"], STR_ISCELLTAP,nil]];
 [_m_RecordDate addObject:dic];
 self.dateStr = datemark;
 }
 
 
 NSString* dateHour = [strFileName substringWithRange:NSMakeRange(8, 2)];
 NSString* dateMinute = [strFileName substringWithRange:NSMakeRange(10, 2)];
 NSString* dateSec = [strFileName substringWithRange:NSMakeRange(12, 2)];
 NSString* type = [strFileName substringWithRange:NSMakeRange(15, 3)];
 // NSLog(@"Year %@  Month %@ Day %@ Hour %@ Minute %@ Sec %@ type %@",dateYear,dateMonth,dateDay,dateHour,dateMinute,dateSec,type);
 NSDictionary* datetype = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@-%@",dateYear,dateMonth,dateDay], STR_DATE, [NSString stringWithFormat:@"%@:%@:%@",dateHour,dateMinute,dateSec], STR_TIME, [NSString stringWithString:type], STR_TYPE,strFileName, @STR_RECORD_FILE_NAME, [NSString stringWithFormat:@"%@",@"NO"], STR_GROUP_NAME,nil];
 
 [self.m_RecordTypeparameter addObject:datetype];
 
 NSLog(@"self.m_RecordCount  %d",[self.m_RecordDate count]);
 if (bEnd == 1) {
 
 if ([self.m_RecordCopy count] != 0) {
 [self.m_RecordCopy release];
 self.m_RecordCopy = nil;
 }
 //self.dateStr = @"";
 self.m_RecordCopy = [self.m_RecordDate copy];
 
 [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:YES];
 [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:YES];
 }
 }*/

- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale;
    //if (imagesize.height > height) {
    scale = imagesize.height / height;
    //}
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


@end
