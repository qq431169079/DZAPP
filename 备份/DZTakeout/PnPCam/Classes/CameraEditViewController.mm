    //
//  CameraEditViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraEditViewController.h"
#import "CameraViewController.h"
#import "CameraInfoCell.h"
#import "mytoast.h"
//#import <UniversalResultParser.h>
//#import <ParsedResult.h>
#import <Actions/ResultAction.h>
//#import "ArchiveController.h"
//#import "Database.h"
//#import "ScanViewController.h"
//#import "BarcodesAppDelegate.h"
#import "CameraSearchViewController.h"
//#import "QRCodeReader.h"
#import "iCloudLivePFZUIviewQR.h"

static const double PageViewControllerTextAnimationDuration = 0.33;

@interface CameraEditViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation CameraEditViewController

@synthesize bAddCamera;
@synthesize editCameraDelegate;
@synthesize strCameraName;
@synthesize strCameraID;
@synthesize strOldDID;
@synthesize strUser;
@synthesize strPwd;
@synthesize currentTextField;
@synthesize tableView;
@synthesize navigationBar;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
        self.strOldDID = @"";
        self.strUser = @STR_DEFAULT_USER_NAME;
        self.strPwd = @"";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

#pragma mark -
#pragma mark system

-(id)init
{
    self = [super init];
    if (self != nil) {
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
        self.strOldDID = @"";
        self.strUser = @STR_DEFAULT_USER_NAME;
        self.strPwd = @"";
    }
    
    return self ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    [super viewDidLoad];       
    
    NSString *strTitle;
    if (bAddCamera == YES) {
        strTitle = NSLocalizedStringFromTable(@"AddCamera", @STR_LOCALIZED_FILE_NAME, nil);
    }else {
        strTitle = NSLocalizedStringFromTable(@"EditCamera", @STR_LOCALIZED_FILE_NAME, nil);
    }   
    self.winsize = [UIScreen mainScreen].applicationFrame.size;
    
    self.navigationItem.title = strTitle;
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)      
                                style:UIBarButtonItemStyleBordered     
                               target:self     
                               action:@selector(btnFinished:)];
    
 //   rightButton.tintColor = [UIColor colorWithRed:BTN_DONE_RED/255.0f green:BTN_DONE_GREEN/255.0f blue:BTN_DONE_BLUE/255.0f alpha:0.5];
    
    //item.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
    if (bAddCamera == NO) {
        self.strOldDID = self.strCameraID;
    }
    
    self.tableView.allowsSelection = NO;
      
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    self.editCameraDelegate = nil;
    self.strCameraName = nil;
    self.strCameraID = nil;
    self.strOldDID = nil;
    self.strUser = nil;
    self.strPwd = nil;
    self.currentTextField = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    ///if (NO == bAddCamera) {
    return 1;
    //}
//return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //if (section == 0) {
        return 3;
    //}else {
       // return 1;
    //}
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = [NSString stringWithFormat:@"CameraInfoCell%d%d", anIndexPath.section, anIndexPath.row];//= @"CameraInfoCell1";	
    
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
     NSInteger row = anIndexPath.row;
    
    if (row != 1) {
       
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        
        //disable selected cell
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CameraInfoCell * cell = (CameraInfoCell*)cell1;

        
       
        CGRect newFrame = cell.textField.frame;
        newFrame.size = CGSizeMake(self.winsize.width - 180, newFrame.size.height);
        cell.textField.frame = newFrame;
        
        switch (row) {
            case 0: 
                cell.keyLable.text = NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraName", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                cell.textField.text = self.strCameraName;            
                break;
//            case 2:
//                cell.keyLable.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
//                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);            
//                cell.textField.text = self.strUser;            
//                break;
            case 2:
                cell.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                cell.textField.secureTextEntry = YES;
                cell.textField.text = self.strPwd;
               
                break;
                default:
                break;
            
        }
        
        
        cell.textField.delegate = self;
        cell.textField.tag = row; 
    }else  if (row == 1){// lan search
        if (cell1 == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CustomAddCameraCell" owner:nil options:nil];
            
            cell1 = [nib lastObject];
            
        }     
        UIImage* btnbackground = [UIImage imageNamed:@"BtnBackGround"];
        btnbackground = [btnbackground stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage* btnbackgroundselect = [UIImage imageNamed:@"BtnBackGroundSelect"];
        btnbackgroundselect = [btnbackgroundselect stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        CustomAddCameraCell* Customcell = (CustomAddCameraCell*)cell1;
    
        CGRect newFrame = Customcell.textField.frame;
        newFrame.size = CGSizeMake(self.winsize.width - 180, newFrame.size.height);
        Customcell.textField.frame = newFrame;
        
        Customcell.keyLabel.text = NSLocalizedStringFromTable(@"CameraID", @STR_LOCALIZED_FILE_NAME, nil);
        Customcell.keyLabel.font = [UIFont fontWithName:@"System Bold" size:17.f];
        Customcell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraID", @STR_LOCALIZED_FILE_NAME, nil);
        Customcell.textField.text = self.strCameraID;
        Customcell.textField.delegate = self;
        Customcell.textField.tag = row;

        [Customcell.seachButton setTitle:NSLocalizedStringFromTable(@"Search", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        NSString* seachButtonText = NSLocalizedStringFromTable(@"Search", @STR_LOCALIZED_FILE_NAME, nil);
        CGSize fontSize = [seachButtonText sizeWithFont:Customcell.seachButton.titleLabel.font constrainedToSize:Customcell.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        fontSize = CGSizeMake(fontSize.width + 20, fontSize.height + 10);
         CGRect newframe =  Customcell.seachButton.frame;
        newframe.size = fontSize;
        newframe.origin = CGPointMake(newframe.origin.x , newframe.origin.y + 10);
        Customcell.seachButton.frame = newframe;
        
        //Customcell.seachButton.layer.masksToBounds = YES;
        //Customcell.seachButton.layer.cornerRadius = 4.0;
        Customcell.seachButton.titleLabel.textColor = [UIColor whiteColor];
        //Customcell.seachButton.backgroundColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        [Customcell.seachButton setBackgroundImage:btnbackground forState:UIControlStateNormal];
        [Customcell.seachButton setBackgroundImage:btnbackgroundselect forState:UIControlStateSelected];
        [Customcell.seachButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
                
        [Customcell.scanButton setTitle:NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        NSString* scanstr = NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        CGSize scanstrsize = [scanstr sizeWithFont:Customcell.scanButton.titleLabel.font constrainedToSize:Customcell.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        scanstrsize = CGSizeMake(scanstrsize.width + 20, scanstrsize.height + 10);
        CGRect scanNewFrame =Customcell.scanButton.frame;
        scanNewFrame.size = scanstrsize;
        scanNewFrame.origin = CGPointMake(scanNewFrame.origin.x , scanNewFrame.origin.y + 10);
        Customcell.scanButton.frame = scanNewFrame;

        [Customcell.scanButton addTarget:self action:@selector(qrscan:) forControlEvents:UIControlEventTouchUpInside];
        Customcell.scanButton.titleLabel.textColor = [UIColor whiteColor];
        //Customcell.scanButton.layer.masksToBounds = YES;
        //Customcell.scanButton.layer.cornerRadius = 4.0f;
      
        [Customcell.scanButton setBackgroundImage:btnbackground forState:UIControlStateNormal];
         [Customcell.scanButton setBackgroundImage:btnbackgroundselect forState:UIControlStateSelected];
        //Customcell.scanButton.backgroundColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    }    
    
	return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 88;
    }
    return 44;
}

-(void)search:(id)sender{
    CameraSearchViewController *cameraSearchView = [[CameraSearchViewController alloc] init];
    cameraSearchView.SearchAddCameraDelegate = self;
    [self.navigationController pushViewController:cameraSearchView animated:YES];
    [cameraSearchView release];
}
-(void)qrscan:(id)sender{
    
    
    //zzy 这里写二维码0713
    iCloudLivePFZUIviewQR *Scan = [[iCloudLivePFZUIviewQR alloc]init];
    Scan.hidesBottomBarWhenPushed = YES;
    Scan.delegate= self;
    [self.navigationController pushViewController:Scan animated:YES];
    [Scan release];
    
}

//反向传值
- (void)displayData:(NSString *)ScanString
{
    self.strCameraID = ScanString;
    UITextField *textField = (UITextField *)[self.view viewWithTag:1];
    textField.text = self.strCameraID;
    NSLog(@"回传后的字符串：%@",ScanString);
    
    
}
/*-(void)setbutton:(id)sender{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    searchButton.frame = CGRectMake(50, 280, 100, 44);
    searchButton.backgroundColor = [UIColor darkGrayColor];
    [searchButton setTitle:NSLocalizedStringFromTable(@"LANSearch", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 4.0;
    searchButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    searchButton.layer.borderWidth = 1.0;
    searchButton.hidden = !bAddCamera;
    [self.view addSubview:searchButton];
    [searchButton release];
    
    UIButton* qrscanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qrscanButton.frame = CGRectMake(winsize.width - 50 - 100, 280, 100, 44);
    qrscanButton.backgroundColor = [UIColor darkGrayColor];
    [qrscanButton setTitle:NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    qrscanButton.layer.masksToBounds = YES;
    qrscanButton.layer.cornerRadius = 4.0;
    qrscanButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    qrscanButton.layer.borderWidth = 1.0;
    qrscanButton.hidden = !bAddCamera;
    [self.view addSubview:qrscanButton];
    [qrscanButton release];
}*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"CameraInfo", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 1){ //lan search
        //return NSLocalizedStringFromTable(@"LAN", @STR_LOCALIZED_FILE_NAME, nil);
        return nil;
    }else { //scan qr code
        ///return NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        return nil;
    }
}

- (void) tableView:(UITableView *)anTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{ 
    [anTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    /*if (anIndexPath.section == 1) { //lan search
        CameraSearchViewController *cameraSearchView = [[CameraSearchViewController alloc] init];
        cameraSearchView.SearchAddCameraDelegate = self;
        [self.navigationController pushViewController:cameraSearchView animated:YES];
        [cameraSearchView release];
    }
    
    if (anIndexPath.section == 2) { //scan qrcode
        [currentTextField resignFirstResponder];
      
        ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:(id<ZXingDelegate>)self showCancel:YES OneDMode:NO];
        QRCodeReader* qrcodeReader= [[QRCodeReader alloc] init];
        NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
        [qrcodeReader release];
        widController.readers = readers;
        [readers release];
////        NSBundle *mainBundle = [NSBundle mainBundle];
////        widController.soundToPlay =
////        [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
        [self presentModalViewController:widController animated:YES];
        [widController release];
    }*/
}


#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    //NSLog(@"keyboardWillShowNotification");
    
    CGRect keyboardRect = CGRectZero;
	
	//
	// Perform different work on iOS 4 and iOS 3.x. Note: This requires that
	// UIKit is weak-linked. Failure to do so will cause a dylib error trying
	// to resolve UIKeyboardFrameEndUserInfoKey on startup.
	//
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
		keyboardRect = [self.view.superview
                        convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        fromView:nil];
	}
	else
	{
		NSArray *topLevelViews = [self.view.window subviews];
		if ([topLevelViews count] == 0)
		{
			return;
		}
		
		UIView *topLevelView = [[self.view.window subviews] objectAtIndex:0];
		
		//
		// UIKeyboardBoundsUserInfoKey is used as an actual string to avoid
		// deprecated warnings in the compiler.
		//
		keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect = [self.view.superview
                        convertRect:keyboardRect
                        fromView:topLevelView];
	}
	
	CGRect viewFrame = self.tableView.frame;
    
	textFieldAnimatedDistance = 0;
	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
	{
		textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
		[self.tableView setFrame:viewFrame];
		[UIView commitAnimations];
	}
    
    //    NSLog(@"currentTextField: %f, %f, %f, %f",currentTextField.bounds.origin.x, currentTextField.bounds.origin.y, currentTextField.bounds.size.height, currentTextField.bounds.size.width);
    
	const CGFloat PageViewControllerTextFieldScrollSpacing = 10;
    
	CGRect textFieldRect =
    [self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
    
    NSArray *rectarray = [self.tableView indexPathsForRowsInRect:textFieldRect];
    if (rectarray.count <= 0) {
        return;
    }
    
    //    NSIndexPath * indexPath = [rectarray objectAtIndex:0];
    //    NSLog(@"row: %d", indexPath.row);
    
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];     
    
}

- (void)keyboardWillHideNotification:(NSNotification* )aNotification
{
    //NSLog(@"keyboardWillHideNotification");
    
    if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	
	CGRect viewFrame = self.tableView.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.tableView setFrame:viewFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}

#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //NSLog(@"textFieldShouldBeginEditing");
    
    self.currentTextField = textField;    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSLog(@"textFieldDidEndEditing");
    
    switch (textField.tag) {
        case TAG_CAMERA_NAME:
            self.strCameraName = textField.text;
            break;
        case TAG_CAMERA_ID:
            self.strCameraID = textField.text;
            break;
//        case TAG_USER_NAME:
//            self.strUser = textField.text;
//            break;
        case TAG_PASSWORD:
            self.strPwd = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 32) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark other


- (void) btnFinished:(id)sender
{
    [currentTextField resignFirstResponder];
    
    NSLog(@"CameraName: %@", strCameraName);
    NSLog(@"CameraID: %@", strCameraID);
    NSLog(@"UserName: %@", strUser);
    NSLog(@"Password: %@", strPwd); 
    
    if ([strCameraName length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCamreraName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if ([strCameraID length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if ([strUser length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputUserName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    BOOL bRet = [editCameraDelegate EditP2PCameraInfo:bAddCamera Name:strCameraName DID:strCameraID User:strUser Pwd:strPwd OldDID:self.strOldDID];
    if (bRet == NO) {
    }
    if (NO == bAddCamera) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark ZXingDelegateMethods
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)resultString {
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"didScanResult");
    
    //resultLabel.text = resultString;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CameraInfoCell *cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];  
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = resultString;
    self.strCameraID = resultString;
 }

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)confirmAndPerformAction:(ResultAction *)action {
    
}

- (void)performResultAction {
    
}

#pragma mark -
#pragma mark SearchAddCameraInfoDelegate

- (void) AddCameraInfo:(NSString *)astrCameraName DID:(NSString *)strDID
{
    self.strCameraName = astrCameraName;
    self.strCameraID = strDID;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CameraInfoCell *cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];  
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = strDID;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];  
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = astrCameraName;
    
}

#pragma mark -
#pragma mark navigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

- (CGSize)scaleImage:(UIImage*)image{
    CGSize size = image.size;
    float scale = 44 / size.height;
    float width = size.width * scale;
    size = CGSizeMake(width, 44);
    return size;
    
}

@end
