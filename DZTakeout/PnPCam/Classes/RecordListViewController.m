//
//  RecordListViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordListViewController.h"
#import "obj_common.h"
#import "PicListCell.h"
#import "PlaybackViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "APICommon.h"
#import "RecListCell_iPad.h"
@interface RecordListViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation RecordListViewController

@synthesize navigationBar;
@synthesize strDate;
@synthesize m_pRecPathMgt;
@synthesize strDID;
@synthesize m_tableView;
@synthesize imageDefault;
@synthesize imagePlay;
@synthesize imageTag;
@synthesize RecReloadDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnEdit: (id) sender
{
    m_bEditMode = !m_bEditMode;
    [self initNavigationBar];
    [self ShowEditButton];
}

- (void) btnSelectAll: (id) sender
{
    //NSLog(@"btnSelectAll...");
    
    BOOL bReloadData = NO;
    
    int i;
    for (i = 0; i < m_nTotalNum; i++) {
        if (m_pSelectedStatus[i] == 0) {
            bReloadData = YES;
        }
        m_pSelectedStatus[i] = 1;
    }
    
    if (bReloadData == YES) {
        [self.m_tableView reloadData];
    }
    
}

- (void) btnSelectReverse: (id) sender
{
    int i;
    for (i = 0; i < m_nTotalNum; i++) {
        if(m_pSelectedStatus[i] == 1){
            m_pSelectedStatus[i] = 0;
        }else {
            m_pSelectedStatus[i] = 1;
        }
    }
    
    [self.m_tableView reloadData];
}

- (void) btnDelete: (id) sender
{
    BOOL bReloadData = NO;
    int i;
    for (i = 0; i < m_nTotalNum; i++) {
        if (m_pSelectedStatus[i] == 1) {
            bReloadData = YES;
            [m_pRecPathMgt RemovePath:strDID Date:strDate Path:[picPathArray objectAtIndex:i]];
        }
    }
    
    if (bReloadData == YES) {
        memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
        
        [self reloadPathArray];
        [self.m_tableView reloadData];
        
        [RecReloadDelegate NotifyReloadData];
    }
    
    
}

- (void) ShowEditButton
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    
    if (m_bEditMode) {
        int toolBarX = 0;
        int toolBarY = screenFrame.size.height - 44 - 44;
        int toolBarWidth = screenFrame.size.width ;
        int toolBarHeight = 44 ;
        m_toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(toolBarX, toolBarY, toolBarWidth, toolBarHeight)];
        m_toolBar.barStyle = UIBarStyleBlackOpaque ;
        m_toolBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
        UIBarButtonItem *btnSelectAll = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"selected", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnSelectAll:)];
        UIBarButtonItem *btnSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnSelectReverse = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Invert", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnSelectReverse:)];
        UIBarButtonItem *btnSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnDelete:)];
        NSArray *itemArray = [NSArray arrayWithObjects:btnSpace1 ,btnSelectAll, btnSelectReverse, btnDelete, btnSpace2, nil];
        [m_toolBar setItems:itemArray];
//        [btnSelectAll release];
//        [btnSelectReverse release];
//        [btnDelete release];
//        [btnSpace1 release];
//        [btnSpace2 release];
        [self.view addSubview:m_toolBar];

        CGRect rectTableView = self.m_tableView.frame;
        rectTableView.size.height -= 44 ;
        self.m_tableView.frame = rectTableView ;
            
    }else {
        CGRect rectTableView = self.m_tableView.frame;
        rectTableView.size.height += 44 ;
        self.m_tableView.frame = rectTableView ;
        [m_toolBar removeFromSuperview];
//        [m_toolBar release];
        m_toolBar = nil;
        
        int i;
        BOOL bReloadData = NO;
        for (i = 0; i < m_nTotalNum; i++) {
            if (m_pSelectedStatus[i] == 1) {
                bReloadData = YES;
            }
            m_pSelectedStatus[i] = 0;
        }
        if (bReloadData == YES) {
            [self.m_tableView reloadData];
        }
        
    }
}

- (void) initNavigationBar
{
    if (!m_bEditMode) {
        //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strDate];
        self.navigationItem.title = strDate;
        //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        self.navigationItem.rightBarButtonItem = rightButton;
       // item.rightBarButtonItem = rightButton;
//        [rightButton release];
        
       // NSArray *array = [NSArray arrayWithObjects:back, item, nil];
        //[self.navigationBar setItems:array];
       // [item release];
       // [back release];
        
    }else {
        //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strDate];
        self.navigationItem.title = strDate;
       // UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleDone target:self action:@selector(btnEdit:)];
        //item.rightBarButtonItem = rightButton;
        self.navigationItem.rightBarButtonItem = rightButton;
//        [rightButton release];
        
        //NSArray *array = [NSArray arrayWithObjects:back, item, nil];
       // [self.navigationBar setItems:array];
        //[item release];
        //[back release];
    }
    
}
- (void) reloadPathArray
{
    [picPathArray removeAllObjects];
    
    NSMutableArray *tempArray = [m_pRecPathMgt GetTotalPathArray:strDID date:strDate];
    for (NSString *strPath in tempArray) {
        [picPathArray addObject:strPath];
    } 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    m_bEditMode = NO;
    //m_pSelectedStatus = NULL;
    memset(m_pSelectedStatus, 0, sizeof(m_pSelectedStatus));
    m_nTotalNum = 0;
    m_toolBar = nil;
    
    picPathArray = nil;
    picPathArray = [[NSMutableArray alloc] init];
       
    [self reloadPathArray];
   
   // navigationBar.delegate = self;
   // navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    [self initNavigationBar];
    
    self.wantsFullScreenLayout = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.navigationBar.translucent = YES;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    /*CGRect navigationBarFrame = self.navigationBar.frame;
    navigationBarFrame.origin.y += 20;
    self.navigationBar.frame = navigationBarFrame;
    //self.navigationBar.alpha = 0.5f;
    
    CGRect tableViewFrame ;
    tableViewFrame.size.height = 480 - 20;
    tableViewFrame.size.width = 320;
    tableViewFrame.origin.x = 0;
    tableViewFrame.origin.y = 0;
    
    m_tableView.frame = tableViewFrame;
        
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 44 + 20 + 5)];
    m_tableView.tableHeaderView = headerView;
    [headerView release];
    */
    self.imageDefault = [UIImage imageNamed:@"videodefault.png"];
    self.imagePlay = [UIImage imageNamed:@"play_video.png"];
    self.imageTag = [UIImage imageNamed:@"del_hook.png"];
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
//    [_swipeGes release],_swipeGes = nil;
    
    self.navigationBar = nil;
    self.m_pRecPathMgt = nil;
    self.strDID = nil;
    self.strDate = nil;
    self.m_tableView = nil;
    self.imageDefault = nil;
    self.imagePlay = nil;
    self.imageTag = nil;
    if (picPathArray != nil) {
//        [picPathArray release];
        picPathArray = nil;
    }
//    [super dealloc];
}

- (void) singleTapHandle: (UITapGestureRecognizer*)sender
{
    UIImageView *imageView = (UIImageView*)[sender view];
    int tag = imageView.tag;
    
    //NSLog(@"singleTapHandle tag:%d", tag);
    
    if (!m_bEditMode) {
        PlaybackViewController *playbackViewController = [[PlaybackViewController alloc] init];
        playbackViewController.m_nSelectIndex = tag;
        playbackViewController.m_pRecPathMgt = m_pRecPathMgt;
        playbackViewController.strDID = strDID;
        playbackViewController.strDate = strDate;
        IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
        [IPCamDelegate switchPlaybackView:playbackViewController];
//        [playbackViewController release];
        return ;
    }
    
    if (tag >= m_nTotalNum) {
        return;
    }
    
    if (m_pSelectedStatus[tag] == 1) {
        NSArray *viewArray = [imageView subviews];
        if ([viewArray count] < 1) {
            m_pSelectedStatus[tag] = 0;
            return ;
        }
        
        UIView *viewTag = [viewArray objectAtIndex:0];
        [viewTag removeFromSuperview];
        
        m_pSelectedStatus[tag] = 0;
    }else {
        [self AddTag:imageView];
        
        m_pSelectedStatus[tag] = 1;
    }
    
    
}

- (void) AddTag: (UIView*) view
{
    int imageX = view.frame.size.width - 5 - 30;
    int imageY = 5;
    
    UIImageView *imageViewTag = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, 30, 30)];
    imageViewTag.image = self.imageTag;
    [view addSubview:imageViewTag];
//    [imageViewTag release];
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"PictureListViewController numberOfRowsInSection");
//    
//    m_nTotalNum = 30;
//    return 10;
//  
    
    int  count = [picPathArray count];
    m_nTotalNum = count;
    
    if (count == 0) {
        return 0;
    }
    
    return (count % 3) > 0 ? (count / 3) + 1 : count / 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  

    NSString *cellIdentifier = @"RecListCell";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    PicListCell *cell =  (PicListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    int nTotalCount = [picPathArray count];
    
    //imageView1
    int AtIndex = anIndexPath.row * 3 ;
    NSString *strPath = [picPathArray objectAtIndex:AtIndex];
    int length = [strPath length];
    NSString* datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
    UIImage *image = [APICommon GetImageByName:strDID filename:strPath];
    if (image != nil) {
        cell.imageView1.image = image; 
    }else {
        cell.imageView1.image = self.imageDefault;
    }
    //play image
    
    CGRect rectImageView = CGRectInset(cell.imageView1.frame, 18, 18);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectImageView];
    imageView.image = self.imagePlay;
    imageView.alpha = 0.6f;
    [cell addSubview:imageView];
//    [imageView release];
    cell.imageView1.tag = AtIndex;
    cell.dateLabel1.text = datename;
    cell.imageView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView1 addGestureRecognizer:singleTap];
//    [singleTap release];
    if (m_pSelectedStatus[AtIndex] == 1)
    {
        [self AddTag:cell.imageView1];
    }

    //imageView2
    AtIndex += 1;
    if (AtIndex >= nTotalCount) {
        return cell;
    }
    
    strPath = [picPathArray objectAtIndex:AtIndex];
    if (strPath == nil) {
        return cell;
    }
    length = [strPath length];
    datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];

    image = [APICommon GetImageByName:strDID filename:strPath];
    if (image != nil) {
        cell.imageView2.image = image;
        //play image
        CGRect rectImageView = CGRectInset(cell.imageView2.frame, 18, 18);
        //NSLog(@"x: %f, y: %f, width: %f, height: %f", rectImageView.origin.x, rectImageView.origin.y , rectImageView.size.width, rectImageView.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectImageView];
        imageView.image = self.imagePlay;
        imageView.alpha = 0.6f;
        [cell addSubview:imageView];
//        [imageView release];
    }else {
        cell.imageView2.image = self.imageDefault;
    }
    cell.imageView2.tag = AtIndex;
    cell.dateLabel2.text = datename;
    cell.imageView2.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView2 addGestureRecognizer:singleTap];
//    [singleTap release];
    if (m_pSelectedStatus[AtIndex] == 1)
    {
        [self AddTag:cell.imageView2];
    }
    
    //imageView3
    AtIndex += 1;
    if (AtIndex >= nTotalCount) {
        return cell;
    }
    strPath = [picPathArray objectAtIndex:AtIndex];
    if (strPath == nil) {
        return cell;
    }
    length = [strPath length];
    datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
    image = [APICommon GetImageByName:strDID filename:strPath];
    if (image != nil) {
        cell.imageView3.image = image;
        //play image
        CGRect rectImageView = CGRectInset(cell.imageView3.frame, 18, 18);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectImageView];
        imageView.image = self.imagePlay;
        imageView.alpha = 0.6f;
        [cell addSubview:imageView];
//        [imageView release];
    }else {
        cell.imageView3.image = self.imageDefault;
    }
    cell.imageView3.tag = AtIndex;
    cell.dateLabel3.text = datename;
    cell.imageView3.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView3 addGestureRecognizer:singleTap];
//    [singleTap release];
    if (m_pSelectedStatus[AtIndex] == 1)
    {
        [self AddTag:cell.imageView3];
    }

    return cell;
    }else{
        RecListCell_iPad *cell =  (RecListCell_iPad*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecListCell_iPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int nTotalCount = [picPathArray count];
        //NSLog(@"imagePlay %@",NSStringFromCGSize(self.imagePlay.size));
        //imageView1
        int AtIndex = anIndexPath.row * 3 ;
        NSString *strPath = [picPathArray objectAtIndex:AtIndex];
        int length = [strPath length];
        NSString* datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
        //NSLog(@"strpaht  %@",strPath);
        UIImage *image = [APICommon GetImageByName:strDID filename:strPath];
        if (image != nil) {
            cell.imageView1.image = image;
        }else {
            cell.imageView1.image = self.imageDefault;
        }
        cell.dateLabel1.text = datename;
        //play image
        //CGRect rectImageView = CGRectInset(cell.imageView1.frame, 18, 18);
        CGRect rectImageView = CGRectMake(80, 40, self.imagePlay.size.width, self.imagePlay.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectImageView];
        imageView.image = self.imagePlay;
        //imageView.contentStretch = CGRectMake(1.0f, 1.0f, 0.5f, 0.5f) ;
        imageView.alpha = 0.6f;
        //imageView.frame.origin = cell.imageView1.center;
        //NSLog(@"x: %f y:  %f w:  %f h:  %f",imageView.center.x,imageView.center.y,cell.imageView1.center.x ,cell.imageView1.center.y);
        [cell addSubview:imageView];
//        [imageView release];
        cell.imageView1.tag = AtIndex;
        
        cell.imageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView1 addGestureRecognizer:singleTap];
//        [singleTap release];
        if (m_pSelectedStatus[AtIndex] == 1)
        {
            [self AddTag:cell.imageView1];
        }
        
        //imageView2
        AtIndex += 1;
        if (AtIndex >= nTotalCount) {
            return cell;
        }
        
        strPath = [picPathArray objectAtIndex:AtIndex];
        if (strPath == nil) {
            return cell;
        }
        length = [strPath length];
        datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
        cell.dateLabel2.text = datename;
        image = [APICommon GetImageByName:strDID filename:strPath];
        if (image != nil) {
            cell.imageView2.image = image;
            //play image
            CGRect rectImageView = CGRectMake(cell.imageView2.frame.origin.x + 80 + 16,40, self.imagePlay.size.width, self.imagePlay.size.height);
            //NSLog(@"x: %f, y: %f, width: %f, height: %f", rectImageView.origin.x, rectImageView.origin.y , rectImageView.size.width, rectImageView.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectImageView];
            imageView.image = self.imagePlay;
            imageView.alpha = 0.6f;
            [cell addSubview:imageView];
//            [imageView release];
        }else {
            cell.imageView2.image = self.imageDefault;
        }
        cell.imageView2.tag = AtIndex;
        
        cell.imageView2.userInteractionEnabled = YES;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView2 addGestureRecognizer:singleTap];
//        [singleTap release];
        if (m_pSelectedStatus[AtIndex] == 1)
        {
            [self AddTag:cell.imageView2];
        }
        
        //imageView3
        AtIndex += 1;
        if (AtIndex >= nTotalCount) {
            return cell;
        }
        strPath = [picPathArray objectAtIndex:AtIndex];
        if (strPath == nil) {
            return cell;
        }
        length = [strPath length];
        datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
        cell.dateLabel3.text  =datename;
        image = [APICommon GetImageByName:strDID filename:strPath];
        if (image != nil) {
            cell.imageView3.image = image;
            //play image
            CGRect rectImageView = CGRectMake(cell.imageView3.frame.origin.x + 80 + 16, 40,self.imagePlay.size.width, self.imagePlay.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectImageView];
            imageView.image = self.imagePlay;
            imageView.alpha = 0.6f;
            [cell addSubview:imageView];
//            [imageView release];
        }else {
            cell.imageView3.image = self.imageDefault;
        }
        cell.imageView3.tag = AtIndex;
        
        cell.imageView3.userInteractionEnabled = YES;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView3 addGestureRecognizer:singleTap];
//        [singleTap release];
        if (m_pSelectedStatus[AtIndex] == 1)
        {
            [self AddTag:cell.imageView3];
        }
        
        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 215;
    }
    return 125;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    
    
}


#pragma mark -
#pragma mark performInMainThread

- (void)reloadTableViewData
{
    [m_tableView reloadData];
}

#pragma mark -
#pragma mark NotifyReloadData

- (void) NotifyReloadData
{
    [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark navigationBardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    return NO;
}

- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale;
    scale = imagesize.height / height;
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


@end
