//
//  ScanStringDelegate.h
//  P2PCamera
//
//  Created by pengfeiV on 15/7/13.
//
//

#import <Foundation/Foundation.h>

@protocol ScanStringDelegate <NSObject>
//二维码扫描后回传数据
- (void)displayData:(NSString *)ScanString;

@end
