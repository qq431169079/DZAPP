//
//  iCloudLivePFZUIviewQR.h
//  TempScanf
//
//  Created by pengfeiV on 14-8-20.
//  Copyright (c) 2014年 VStarcam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanStringDelegate.h"

@interface iCloudLivePFZUIviewQR : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id<ScanStringDelegate> delegate;

@end
