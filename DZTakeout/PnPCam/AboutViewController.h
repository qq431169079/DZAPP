//
//  AboutViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface AboutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate>{
    
    IBOutlet UINavigationBar *navigationBar;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
