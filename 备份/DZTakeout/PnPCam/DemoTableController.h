//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPPPChannelManagement.h"
#import "FPPopoverController.h"
@interface DemoTableController: UITableViewController <UIAlertViewDelegate>
@property (nonatomic, assign) CPPPPChannelManagement* cppppchannelMgt;
@property (nonatomic, retain) NSString* strDID;
@property (nonatomic, assign) int button_tag;
@property (nonatomic, retain) UIImage* img;
@property (nonatomic, retain) NSArray* imgPath;
@property (nonatomic, assign) int buttontag;
@property (nonatomic, assign) BOOL butonTap;
@property (nonatomic, retain) FPPopoverController* fppopoverCtr;
- (NSString*)PathForDocumentStrDID:(NSString*)strDID;
//- (NSArray*)imagePath:(NSString*)strDID;

-(void)imagewritetofile:(int) tag;

-(void)defaultCell;

@end
