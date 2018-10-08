//
//  StartViewController.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartViewController : UIViewController {
    IBOutlet UILabel *versionLabel;
    IBOutlet UIImageView* imgView;
}
@property (nonatomic, retain) UIImageView* imgView;
@property (nonatomic, retain) UILabel *versionLabel;

@end
