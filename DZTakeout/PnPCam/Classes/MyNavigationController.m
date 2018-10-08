//
//  MyNavigationController.m
//  P2PCamera
//
//  Created by Cuiheng on 16/7/19.
//
//

#import "MyNavigationController.h"

@implementation MyNavigationController

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
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
