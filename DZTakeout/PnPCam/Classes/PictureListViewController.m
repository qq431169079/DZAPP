//
//  PictureListViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureListViewController.h"
#import "obj_common.h"
#import "PicListCell.h"
#import "PictureShowViewController.h"
#import "APICommon.h"
#import "PicListCell_iPad.h"

@interface PictureListViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation PictureListViewController

@synthesize navigationBar;
@synthesize strDate;
@synthesize m_pPicPathMgt;
@synthesize strDID;
@synthesize m_tableView;
@synthesize NotifyReloadDataDelegate;

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
    
    //NSLog(@"Picture list viewdidload");
    self.isEdit = NO;
    self.tagImg = [UIImage imageNamed:@"del_hook"];
    
    picPathArray = nil;
    picPathArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
    picPathArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
    self.selectImgTagArr = [[NSMutableArray alloc] init];
    navigationBar.delegate = self;
    self.navigationItem.title = strDate;
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strDate];
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    
    //NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
    //[item release];
    //[back release];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.wantsFullScreenLayout = YES;
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showTooleBar:)];
    self.navigationItem.rightBarButtonItem = rightBar;

    rightBar = nil;
       /*self.navigationBar.translucent = YES;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    CGRect navigationBarFrame = self.navigationBar.frame;
    navigationBarFrame.origin.y += 20;
    self.navigationBar.frame = navigationBarFrame;
    //self.navigationBar.alpha = 0.5f;
 
    CGRect tableViewFrame ;
    tableViewFrame.size.height = 480 - 20;
    tableViewFrame.size.width = 320;
    tableViewFrame.origin.x = 0;
    tableViewFrame.origin.y = 0;
    
    m_tableView.frame = tableViewFrame;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 44 + 20 + 4)];
    m_tableView.tableHeaderView = headerView;
    [headerView release];*/
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showTooleBar:(id)sender{
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    if (self.selectImgTagArr == nil) {
        self.selectImgTagArr = [[NSMutableArray alloc] init];
    }else if ([self.selectImgTagArr count] != 0){
        [self.selectImgTagArr removeAllObjects];
    }
    if (!self.isEdit) {
        self.myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, winsize.height - 44 - 44 - 20, winsize.width, 44)];
        self.myToolBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
        UIBarButtonItem *btnSelectAll = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"selected", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnSelectAll:)];
        UIBarButtonItem *btnSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnSelectReverse = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Invert", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnSelectReverse:)];
        UIBarButtonItem *btnSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnDelete:)];
        NSArray *itemArray = [NSArray arrayWithObjects:btnSpace1 ,btnSelectAll, btnSelectReverse, btnDelete, btnSpace2, nil];
        [self.myToolBar setItems:itemArray];

        btnSelectAll = nil;

        btnDelete = nil;

        btnSelectReverse = nil;

        btnSpace1 = nil;

        btnSpace2 = nil;
        [self.view addSubview:self.myToolBar];
        [self.view bringSubviewToFront:self.myToolBar];
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
        self.navigationItem.rightBarButtonItem.title = NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil);
        self.isEdit = YES;
    }else{
        if (self.myToolBar != nil) {
            [self.myToolBar removeFromSuperview];

            self.myToolBar = nil;
        }
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
        self.navigationItem.rightBarButtonItem.title = NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil);
        self.isEdit = NO;
        [self.m_tableView reloadData];
    }
     NSMutableArray* tempArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
    NSLog(@"tempArray  %@",tempArray);
}

- (void)btnSelectReverse:(id)sender{
    if ([picPathArray count] == 0) {
        return;
    }
    if (self.selectImgTagArr == nil) {
        self.selectImgTagArr = [[NSMutableArray alloc] init];
    }else if ([self.selectImgTagArr count] != 0){
        NSMutableArray* arr = [NSMutableArray arrayWithArray:self.selectImgTagArr];
        [self.selectImgTagArr removeAllObjects];
        NSLog(@"arr  %@",arr);
        
        for (int i = 0 ; i < [picPathArray count]; i++) {
            int j = 0;
            for (NSNumber* tagnum in arr){
                BOOL exist = NO;
                j++;
                int tag = [tagnum intValue];
                if (tag == i+1) {
                    exist = YES;
                    UIView* view = [self.view viewWithTag:tag];
                    //NSLog(@"view  %@",[view class]);
                    if ([view isMemberOfClass:[UIImageView class]]){
                        for (UIView* subView in [view subviews]){
                            [subView removeFromSuperview];
                        }
                    }
            
        }
    if (exist) {
        break;
    }
                if (!exist && (j == [arr count])){
                    UIView* view = [self.view viewWithTag:i+1];
                    if ([view isMemberOfClass:[UIImageView class]]) {
                        NSLog(@"tagview  %@",[view class]);
                        UIImageView* tagImgView = [[UIImageView alloc] initWithImage:self.tagImg];
                        tagImgView.frame = CGRectMake(view.frame.size.width - self.tagImg.size.width , view.frame.origin.y  , self.tagImg.size.width, self.tagImg.size.height);
                        [view addSubview:tagImgView];

                        tagImgView = nil;
                        [self.selectImgTagArr addObject:[NSNumber numberWithInt:i + 1]];
                        
                    }

                }
            }
        }
    }else if ([self.selectImgTagArr count] == 0){
        for (int i = 0; i < [picPathArray count]; i++) {
            UIView* view = [self.view viewWithTag:i+1];
            if ([view isMemberOfClass:[UIImageView class]]) {
                
                UIImageView* tagImgView = [[UIImageView alloc] initWithImage:self.tagImg];
                tagImgView.frame = CGRectMake(view.frame.size.width - self.tagImg.size.width , view.frame.origin.y  , self.tagImg.size.width, self.tagImg.size.height);
                [view addSubview:tagImgView];

                tagImgView = nil;
                [self.selectImgTagArr addObject:[NSNumber numberWithInt:i + 1]];
                
            }
        }

    }
    NSMutableArray* tempArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
    NSLog(@"tempArray  %@",tempArray);

}

- (void)btnSelectAll:(id)sender{
    if ([picPathArray count] == 0) {
        return;
    }
    if (self.selectImgTagArr == nil) {
        self.selectImgTagArr = [[NSMutableArray alloc] init];
    }else if ([self.selectImgTagArr count] != 0){
        
        for (NSNumber* tagnumber in self.selectImgTagArr){
            UIView* view = [self.view viewWithTag:[tagnumber intValue]];
            if ([view isMemberOfClass:[UIImageView class]]){
                for (UIView* subView in [view subviews]){
                    [subView removeFromSuperview];
                }
            }
        }
        [self.selectImgTagArr removeAllObjects];
    }
    for (int i = 0; i < [picPathArray count]; i++) {
        UIView* view = [self.view viewWithTag:i+1];
        if ([view isMemberOfClass:[UIImageView class]]) {
            
            UIImageView* tagImgView = [[UIImageView alloc] initWithImage:self.tagImg];
            tagImgView.frame = CGRectMake(view.frame.size.width - self.tagImg.size.width , view.frame.origin.y  , self.tagImg.size.width, self.tagImg.size.height);
            [view addSubview:tagImgView];

            tagImgView = nil;
            [self.selectImgTagArr addObject:[NSNumber numberWithInt:i + 1]];
            
            }
        }
    
    NSMutableArray* tempArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
    NSLog(@"tempArray  %@",tempArray);

}

- (void)btnDelete:(id)sender{
    if ([picPathArray count] == 0) {
        return;
    }
    // NSLog(@"strDID  %@  strDate  %@   picPath %@",strDID,strDate,picPathArray );
    BOOL b_reloadData = NO;
    int pathCount = [picPathArray count];
    NSMutableArray* tmpPatharray = [picPathArray mutableCopy];
    for (int i = 0; i < pathCount; i++) {
        for (NSNumber* tagNum in self.selectImgTagArr){
            int tag = [tagNum intValue];
            if (tag == i+1) {
                NSLog(@"picPathArraycount = %d,tag = %d,i = %d",[picPathArray count],tag,i);
                b_reloadData = YES;
                if ([self.m_pPicPathMgt RemovePicPath:strDID PicDate:strDate PicPath:[tmpPatharray objectAtIndex:i]]){
                   
                }
                //NSLog(@"strDID  %@  strDate  %@   picPath %@",strDID,strDate,picPathArray );
            }
        }
    }
    if (b_reloadData) {
        //[picPathArray removeAllObjects];
        //NSMutableArray* tempArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
        //for (NSString *strPath in tempArray) {
           // [picPathArray addObject:strPath];
        //}
       /// NSLog(@"picPath %d   %d",[picPathArray count],[tempArray count]);
        [self.NotifyReloadDataDelegate  NotifyReloadData];
        [self reloadTableViewData];
        
    }
    if (tmpPatharray != nil) {

        tmpPatharray = nil;
    }
    
    [self.selectImgTagArr removeAllObjects];
   // NSMutableArray* tempArray = [m_pPicPathMgt GetTotalPathArray:strDID date:strDate];
    //[self reloadTableViewData];
    //NSLog(@"tempArray  %@",tempArray);
 
}

- (void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
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
    _swipeGes = nil;
    
    if (self.myToolBar != nil) {
        
        self.myToolBar = nil;
    }
    if (self.tagImg != nil) {
      
        self.tagImg = nil;
    }
    if (self.selectImgTagArr != nil) {

        self.selectImgTagArr = nil;
    }
    self.strName = nil;
    self.cameraListMgt = nil;
    self.navigationBar = nil;
    self.m_pPicPathMgt = nil;
    self.strDID = nil;
    self.strDate = nil;
    self.m_tableView = nil;
    self.NotifyReloadDataDelegate=nil;

}


- (void) singleTapHandle: (UITapGestureRecognizer*)sender
{
    UIImageView *imageView = (UIImageView*)[sender view];
    int tag = imageView.tag;
    
    //NSLog(@"singleTapHandle tag:%d", tag);
    if (!self.isEdit) {
        PictureShowViewController *picShowViewController = [[PictureShowViewController alloc] init];
        picShowViewController.strDID = strDID;
        picShowViewController.strDate = strDate;
        picShowViewController.m_pPicPathMgt = m_pPicPathMgt;
        picShowViewController.cameraListMgt = self.cameraListMgt;
        picShowViewController.strName = self.strName;
        picShowViewController.picPathArray = picPathArray;
        picShowViewController.NotifyReloadDataDelegate = self;
        picShowViewController.m_currPic = tag - 1;
        [self.navigationController pushViewController:picShowViewController animated:YES];
   
    }else{
        if ([imageView.subviews count] == 0) {
            UIImageView* tagImgView = [[UIImageView alloc] initWithImage:self.tagImg];
            tagImgView.frame = CGRectMake(imageView.frame.size.width - self.tagImg.size.width , imageView.frame.origin.y  , self.tagImg.size.width, self.tagImg.size.height);
            [imageView addSubview:tagImgView];

            tagImgView = nil;
            [self.selectImgTagArr addObject:[NSNumber numberWithInt:tag]];

        }else{
            for (UIView* view in [imageView subviews]){
                [view removeFromSuperview];
            }
            [self.selectImgTagArr removeObject:[NSNumber numberWithInt:tag]];
        }
    }
    NSLog(@"selectImgTagArr %@",self.selectImgTagArr);
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@" numberOfRowsInSection");

    int  count = [picPathArray count];
    
    if (count == 0) {
        return 0;
    }
    
    return (count % 4) > 0 ? (count / 4) + 1 : count / 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    //UITableViewCell* cell;
    NSString *cellIdentifier = @"PicListCell";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        PicListCell *cell =  (PicListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        if (cell == nil)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PicListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int nTotalCount = [picPathArray count];
    
    //imageView1
    int AtIndex = anIndexPath.row * 4 ;
    NSString *strPath = [picPathArray objectAtIndex:AtIndex];
    int length = [strPath length];
    NSString* datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
    
    UIImage *image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
    if (image != nil) {
        cell.imageView1.image = image;
    }
    
    
    cell.imageView1.tag = AtIndex + 1;
        cell.dateLabel1.text = datename;
    cell.imageView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView1 addGestureRecognizer:singleTap];

    
    
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
    image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
    if (image != nil) {
        cell.imageView2.image = image;
    }
    cell.imageView2.tag = AtIndex + 1;
        cell.dateLabel2.text = datename;
    cell.imageView2.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView2 addGestureRecognizer:singleTap];

    
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
    image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
    if (image != nil) {
        cell.imageView3.image = image;
    }
    cell.imageView3.tag = AtIndex + 1;
    
    cell.dateLabel3.text = datename;
    cell.imageView3.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView3 addGestureRecognizer:singleTap];

    
    //imageView4
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
    image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
    if (image != nil) {
        cell.imageView4.image = image;
    }
    cell.imageView4.tag = AtIndex + 1;
    cell.dateLabel4.text = datename;
    cell.imageView4.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.imageView4 addGestureRecognizer:singleTap];


    
    return cell;
    }else{
        PicListCell_iPad *cell =  (PicListCell_iPad*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PicListCell_iPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int nTotalCount = [picPathArray count];
        
        //imageView1
        int AtIndex = anIndexPath.row * 4 ;
        NSString *strPath = [picPathArray objectAtIndex:AtIndex];
        int length = [strPath length];
        NSString* datename = [strPath substringWithRange:NSMakeRange(length - 12, 8)];
        
        UIImage *image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
        //image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        if (image != nil) {
            cell.imageView1.image = image;
            //cell.imageView1.contentStretch = CGRectMake(0, 0.4, 1.0, 0.3);
        }
        cell.imageView1.tag = AtIndex + 1;
        cell.dateLabel1.text = datename;
        cell.imageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView1 addGestureRecognizer:singleTap];
        
        
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
        image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
        if (image != nil) {
            cell.imageView2.image = image;
        }
        cell.imageView2.tag = AtIndex + 1;
        cell.dateLabel2.text = datename;
        cell.imageView2.userInteractionEnabled = YES;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView2 addGestureRecognizer:singleTap];
        
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
        image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
        if (image != nil) {
            cell.imageView3.image = image;
        }
        cell.imageView3.tag = AtIndex + 1;
        cell.dateLabel3.text = datename;
        cell.imageView3.userInteractionEnabled = YES;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView3 addGestureRecognizer:singleTap];

        
        //imageView4
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
        image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
        if (image != nil) {
            cell.imageView4.image = image;
        }
        cell.imageView4.tag = AtIndex + 1;
        cell.dateLabel4.text = datename;
        cell.imageView4.userInteractionEnabled = YES;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTap.numberOfTapsRequired = 1;
        [cell.imageView4 addGestureRecognizer:singleTap];

        
        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 150;
    }
    return 100;
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
    //[self.NotifyReloadDataDelegate NotifyReloadData];
    NSLog(@"asfasfasf");
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


@end
