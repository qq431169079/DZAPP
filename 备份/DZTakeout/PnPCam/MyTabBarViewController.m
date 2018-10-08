//
//  MyTabBarViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTabBarViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
//    UIImage *image = [UIImage imageNamed:@"main_bottom_bg.png"];
//    
//    //self.tabBar.layer.contents = (id)image.CGImage;
//    self.tabBar.backgroundImage = image;
//    
//    self.delegate = self;
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark delegate

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"tabBarController.....");
    int selectIndex = [tabBarController.viewControllers indexOfObject:viewController];
    if (tabBarController.selectedIndex == selectIndex) {
        return NO;
    }
    
    
//    NSArray *array = self.tabBar.items;
//    
//    UITabBarItem *item = [array objectAtIndex:0];
//    
//    item.image = [UIImage imageNamed:@"icon.png"];
//    item.title = @"aaaa";

    
    
//    
//    NSArray *itemArray = [[[tabBarController.view subviews] objectAtIndex:1]subviews];
//    for (int i = 0; i < itemArray.count; i++) {
//        
//        UIImageView *image = [[UIImageView alloc] init];
//        UIView *v = [itemArray objectAtIndex:i];
//        if (i == [tabBarController.viewControllers indexOfObject:viewController]) {
//            
//            image.image = [UIImage imageNamed:@"icon.png"];
//        }else {
//            
//            image.image = [UIImage imageNamed:@"icon.png"];
//        }
//        image.frame =CGRectMake(23,3, 30, 30);
//        
//        NSArray *imageArr = [v subviews];
//        
//        for (UIView *v in imageArr) {
//            
//            if ([v isKindOfClass:[UIImageView class]]) {
//                
//                [v removeFromSuperview];
//            }
//            
//            if ([v isKindOfClass:[UILabel class]])
//                            {
//                //                UILabel *label = (UILabel *)subview;
//                //                
//                //                UILabel *newLabel = [[UILabel alloc] init];
//                //                newLabel.font = label.font;
//                //                newLabel.text = label.text;
//                //                newLabel.textColor = [UIColor redColor];
//                //                newLabel.backgroundColor = [UIColor clearColor];
//                //                newLabel.opaque = YES;
//                //                newLabel.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height + 1);    
//                //                [subview addSubview:newLabel];
//                //                [newLabel release];
//                //            }
//                
//                }
//        [v addSubview:image];
//        [image release];
//        image = nil;
//    }
//    
//    
//    }
    
    return TRUE;
}


@end
