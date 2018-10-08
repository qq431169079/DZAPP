//
//  AboutViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "obj_common.h"
#import "AboutCell.h"
#import "PPPP_API.h"

#define ProductName @"VStarcam Camera"
@interface AboutViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation AboutViewController

@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"about"];
    }
    return self;
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil)];
    CGSize winsize = [UIScreen mainScreen].applicationFrame.size;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    NSLog(@"winsize  %@",NSStringFromCGSize(winsize));
    UIImage* appiconimg = [UIImage imageNamed:@"appIcon"];
    UIImageView* appiconImgView = [[UIImageView alloc] initWithImage:appiconimg];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        appiconImgView.frame = CGRectMake(winsize.width/2 - 60.0f, 64+10.0f, 120.0f, 120.0f);
        appiconImgView.layer.cornerRadius = 5.0f;
    }else{
        appiconImgView.frame = CGRectMake(winsize.width/2 - 150.f, 64+30.f, 300.f, 300.f);
        appiconImgView.layer.cornerRadius = 50.0f;
    }
    
    
    appiconImgView.layer.masksToBounds = YES;
    
    UILabel* productname;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        productname = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+130, winsize.width , 40)];
    }else{
        productname = [[UILabel alloc] initWithFrame:CGRectMake(0.f, appiconImgView.frame.origin.y + appiconImgView.frame.size.height + 10.f+64, winsize.width, 40)];
    }
    
    productname.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    productname.textAlignment = UITextAlignmentCenter;
    productname.textColor = [UIColor blackColor];
    productname.font = [UIFont fontWithName:@"System Bold" size:20];
    productname.shadowColor = [UIColor blackColor];
    productname.shadowOffset = CGSizeMake(1, 1);
    productname.layer.cornerRadius = 5.0f;
    productname.layer.masksToBounds = YES;
    productname.backgroundColor = [UIColor clearColor];
    
    UILabel* verLabel;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        verLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 64+160.f, winsize.width, 40.f)];
    }else{
        verLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, productname.frame.origin.y + productname.frame.size.height + 20.f+64, winsize.width, 40.f)];
    }
    verLabel.text = [NSString stringWithFormat:@"%@  %@",NSLocalizedStringFromTable(@"Version", @STR_LOCALIZED_FILE_NAME, nil),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    verLabel.textAlignment = UITextAlignmentCenter;
    verLabel.textColor = [UIColor blackColor];
    verLabel.font = [UIFont fontWithName:@"System Bold" size:20];
    verLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:verLabel];
    [verLabel release];
    
    UILabel* downLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        downLabel= [[UILabel alloc] initWithFrame:CGRectMake(0,winsize.height - 270, winsize.width, 40)];
    }else{
        downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, productname.frame.origin.y + productname.frame.size.height  + 100.f, winsize.width, 40.f)];
    }
    downLabel.text = NSLocalizedStringFromTable(@"OnlineCD-ROM", @STR_LOCALIZED_FILE_NAME, nil);
    downLabel.textColor = [UIColor blackColor];
    downLabel.textAlignment = UITextAlignmentCenter;
    downLabel.font = [UIFont fontWithName:@"System" size:18];
    downLabel.backgroundColor = [UIColor clearColor];
    
    UITextView* downTextView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        downTextView= [[UITextView alloc] initWithFrame:CGRectMake(0,winsize.height - 240.f, winsize.width, 40)];
    }else{
        downTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, downLabel.frame.origin.y + downLabel.frame.size.height + 10.f, winsize.width, 40.f)];
    }
    downTextView.editable = NO;
    downTextView.text = [NSString stringWithFormat:@"http://cd.ipcam.so"];
    downTextView.textAlignment = UITextAlignmentCenter;
    downTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    downTextView.backgroundColor = [UIColor clearColor];
    downTextView.font = [UIFont fontWithName:@"System" size:18];
    
    UILabel* informationLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,winsize.height - 210.f, winsize.width, 40)];
    }else{
        informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,downTextView.frame.origin.y + downTextView.frame.size.height + 30.f, winsize.width, 40)];
    }
    
    informationLabel.text = NSLocalizedStringFromTable(@"Information", @STR_LOCALIZED_FILE_NAME, nil);
    informationLabel.textColor = [UIColor blackColor];
    informationLabel.textAlignment = UITextAlignmentCenter;
    informationLabel.backgroundColor = [UIColor clearColor];
    informationLabel.font = [UIFont fontWithName:@"System" size:18];
    
    UITextView* informationText;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        informationText = [[UITextView alloc] initWithFrame:CGRectMake(0, winsize.height - 180, winsize.width, 40)];
    }else{
        informationText = [[UITextView alloc] initWithFrame:CGRectMake(0, informationLabel.frame.size.height + informationLabel.frame.origin.y + 10, winsize.width, 40)];
    }
    informationText.text = [NSString stringWithFormat:@"http://www.vstarcam.com"];
    informationText.textColor = [UIColor blackColor];
    informationText.textAlignment = UITextAlignmentCenter;
    informationText.editable = NO;
    informationText.backgroundColor = [UIColor clearColor];
    informationText.font = [UIFont fontWithName:@"System" size:18];
    informationText.dataDetectorTypes = UIDataDetectorTypeAll;
    
    UILabel* copyright = [[UILabel alloc] initWithFrame:CGRectMake(0, winsize.height - 110.0f, winsize.width, 40)];
    copyright.text = [NSString stringWithFormat:@"Copyright © 2015. All rights reserved."];
    copyright.textColor = [UIColor blackColor];
    copyright.textAlignment = UITextAlignmentCenter;
    copyright.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:copyright];
//    [self.view addSubview:informationText];
//    [self.view addSubview:informationLabel];
//    [self.view addSubview:downTextView];
//    [self.view addSubview:downLabel];
    [self.view addSubview:appiconImgView];
    [self.view addSubview:productname];
    [copyright release];
    [informationText release];
    [informationLabel release];
    [downTextView release];
    [downLabel release];
    [appiconImgView release];
    [productname release];
    
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
    
    self.navigationBar = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
 #pragma mark -
 #pragma mark TableViewDelegate
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
 {
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
 {
 return 3;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
 {
 NSString *cellIdentifier = @"AboutCell";
 AboutCell *cell =  (AboutCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
 if (cell == nil)
 {
 NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:self options:nil];
 cell = [nib objectAtIndex:0];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
 switch (anIndexPath.row) {
 case 0:
 cell.labelItem.text = NSLocalizedStringFromTable(@"Version", @STR_LOCALIZED_FILE_NAME, nil);
 cell.labelVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//@STR_VERSION_NO;
 break;
 case 1:
 {
 cell.labelItem.text = @"P2P";
 int nP2PVersion = PPPP_GetAPIVersion();
 
 NSLog(@"nP2PVersion: %d", nP2PVersion);
 NSString *P2PVersion = [NSString stringWithFormat:@"%x.%x.%x.%x",
 nP2PVersion>>24,
 (nP2PVersion & 0xffffff) >> 16,
 (nP2PVersion & 0xffff) >> 8,
 nP2PVersion & 0xff];
 cell.labelVersion.text = P2PVersion;
 }
 break;
 case 2:
 cell.labelItem.text = @"P2PAPI";
 cell.labelVersion.text = @"1.0.0.0";
 break;
 
 default:
 break;
 }
 
 return cell;
 }
 
 //- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 //{
 //
 //}
 
 - (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
 {
 
 
 }
 
 
 #pragma mark UINavigationBarDelegate
 - (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
 [self.navigationController popToRootViewControllerAnimated:YES];
 return YES;
 }
 */
@end
