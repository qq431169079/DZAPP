    //
//  StartViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "obj_common.h"

@implementation StartViewController

@synthesize versionLabel;
@synthesize imgView;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super init];
//    
//    return  self;
//}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    CGRect winsize = [[UIScreen mainScreen] bounds];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        //[[NSBundle mainBundle] loadNibNamed:@"Start_iPad" owner:self options:nil];
//        imgView.frame = winsize;
//        versionLabel.frame = CGRectMake(winsize.origin.x, winsize.size.height - 50.0f, winsize.size.width, 45.0f);
//        [versionLabel.font fontWithSize:25.0f];
//    }else{
//        //[[NSBundle mainBundle] loadNibNamed:@"StartView" owner:self options:nil];
//    }
    imgView.frame =winsize;
    NSString *strVersion = [NSString stringWithFormat:@"Ver %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    versionLabel.text = strVersion;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.shadowColor = [UIColor blackColor];
    versionLabel.shadowOffset = CGSizeMake(1,1);
    //CGRect winsize = [[UIScreen mainScreen] bounds];
    
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
    [imgView  release];
    [versionLabel release];
    [super dealloc];
}


@end
