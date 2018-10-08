//
//  CameraViewController.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraViewController : UIViewController



- (void) StopPPPP;
- (void) StartPPPPThread;

- (IBAction)btnAddCameraTouchDown:(id)sender;
- (IBAction)btnAddCameraTouchUp:(id)sender;

- (NSString*)PathForDocumentStrDID:(NSString*)strDID;

- (void)pushtoView:(UIViewController*)ViewCtr;
- (void)deleteCamera;
@end
