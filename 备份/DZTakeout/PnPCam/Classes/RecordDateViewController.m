//
//  RecordDateViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordDateViewController.h"
#import "obj_common.h"
#import "RecordListViewController.h"
#import "PicDirCell.h"
#import "defineutility.h"
#import "APICommon.h"

@interface RecordDateViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation RecordDateViewController

@synthesize m_pRecPathMgt;
@synthesize strDID;
@synthesize strName;
@synthesize navigationBar;
@synthesize imagePlay;
@synthesize imageDefault;
@synthesize tableView;
@synthesize RecReloadDelegate;
@synthesize m_PpppchannelMgt;
@synthesize camListMgt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"RecordDateViewController viewDidLoad....");
    recDataArray = nil;
    recDataArray = [m_pRecPathMgt GetTotalDataArray:strDID] ;

    
    //UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    //[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar.delegate = self;
    //self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    //back.leftBarButtonItem.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
   // UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strName];
    self.navigationItem.title = strName;
    UIImage* recordImg = [UIImage imageNamed:@"Camera"];
    UIImage* newrecordImg = [self fitImage:recordImg tofitHeight:35];
    UIButton* recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.backgroundColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    recordBtn.layer.cornerRadius = 4.0f;
    recordBtn.layer.masksToBounds = YES;
    
    recordBtn.frame = CGRectMake(0, 0, newrecordImg.size.width, newrecordImg.size.height);
    [recordBtn setImage:newrecordImg forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(Record:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithCustomView:recordBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    //UIBarButtonItem* rightitem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStylePlain target:self action:@selector(Record:)];
    //item.rightBarButtonItem = rightitem;
   // NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
    
    //[item release];
    //[back release];
    
    self.imagePlay = [UIImage imageNamed:@"play_video.png"];
    self.imageDefault = [UIImage imageNamed:@"videobk.png"];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale;
    if (imagesize.height > height) {
        scale = imagesize.height / height;
    }
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


-(void)Record:(id)sender
{
    AlbumTableViewController* recordTableVew = [[AlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    recordTableVew.cameraListMgt = self.camListMgt;
    recordTableVew.delegate = self;
    recordTableVew.mark = @"record";
    FPPopoverController* fppView = [[FPPopoverController alloc] initWithViewController:recordTableVew];
    fppView.delegate = self;
    int count = [self.camListMgt GetCount];
    fppView.contentSize = CGSizeMake(190, 45*(count + 1.55));
    [fppView presentPopoverFromView:sender];
    [recordTableVew release];
    self.fppopoverCtr = [fppView retain];
    [fppView release];
}
#pragma  mark -
#pragma mark AlbumTableViewControllerDelegate
- (void)reloadData:(NSString*)strUID{
    if (self.fppopoverCtr != nil) {
        [self.fppopoverCtr dismissPopoverAnimated:YES];
    }
    self.strDID = strUID;
    recDataArray = nil;
    recDataArray = [m_pRecPathMgt GetTotalDataArray:strDID] ;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark FPPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController{
    if (popoverController != nil) {
        [popoverController release];
        popoverController = nil;
    }
}

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    self.fppopoverCtr = nil;
    self.m_pRecPathMgt = nil;
    self.strDID = nil;
    self.navigationBar = nil;
    self.strName = nil;
    self.imagePlay = nil;
    self.imageDefault = nil;
    self.tableView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection11111");
    int i = 0;
    if (recDataArray == nil || [recDataArray count] == 0) {
        return 0;
    }else{
        for (NSDictionary* dic in recDataArray){
            NSString* strDate = [[dic allKeys] objectAtIndex:0];
            int nRecCount = [m_pRecPathMgt GetTotalNumByIDAndDate:strDID Date:strDate];
            
            if (nRecCount == 0) {
                i++;
            }
        }
        return ([recDataArray count] - i);
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath11111");  
    
    NSDictionary *datePicDic = [recDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    NSString *cellIdentifier = @"RecordDateListCell";       
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    int nRecCount = [m_pRecPathMgt GetTotalNumByIDAndDate:strDID Date:strDate];
    if (nRecCount == 0) {
        return nil;
    }
    cell.labelName.text = [NSString stringWithFormat:@"%@(%d)", strDate, nRecCount];
    
    NSString *strFileName = [m_pRecPathMgt GetFirstPathByIDAndDate:strDID Date:strDate];
    UIImage *image = [APICommon GetImageByName:strDID filename:strFileName];
    if (image != nil) {
        cell.imageView.image = image;
        //play image
        int halfWidth = cell.imageView.frame.size.width / 2;
        int halfHeight = cell.imageView.frame.size.height / 2;
        
        int halfX = cell.imageView.frame.origin.x + halfWidth;
        int halfY = cell.imageView.frame.origin.y + halfHeight;
        
        int imageX = halfX - 20;
        int imageY = halfY - 20;
        
        //play image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, 40, 40)];
        imageView.image = self.imagePlay;
        imageView.alpha = 0.6f;
        [cell addSubview:imageView];
        [imageView release];
    }else {
        cell.imageView.image = self.imageDefault;
    }
    
    float cellHeight = cell.frame.size.height;
    float cellWidth = cell.frame.size.width;
    
    //NSLog(@"dddd cellHeight: %f, cellWidth: %f", cellHeight, cellWidth);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 2, cellWidth, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    [cellBgView addSubview:label];
    [label release];
    
    cell.backgroundView = cellBgView;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 60;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *datePicDic = [recDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    RecordListViewController *recListViewController = [[RecordListViewController alloc] init];
    recListViewController.strDID = strDID;
    recListViewController.strDate = strDate;
    recListViewController.m_pRecPathMgt = m_pRecPathMgt;
    recListViewController.RecReloadDelegate = self;
    [self.navigationController pushViewController:recListViewController animated:YES];
    [recListViewController release];
    
}

#pragma mark -
#pragma mark uinavigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

#pragma mark -
#pragma mark performOnMainThread
- (void) ReloadTableViewData
{
    [self.tableView reloadData];
    [RecReloadDelegate NotifyReloadData];
}


#pragma mark -
#pragma mark NotifyReloadDelegate

- (void) NotifyReloadData
{
    [self performSelectorOnMainThread:@selector(ReloadTableViewData) withObject:nil waitUntilDone:NO];
}

@end
