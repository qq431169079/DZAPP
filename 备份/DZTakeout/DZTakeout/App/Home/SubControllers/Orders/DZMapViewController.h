//
//  DZMapViewController.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/2.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZWKWebViewController.h"
@protocol DZMapDelegate<NSObject>
@optional

-(void)checkMapAddress:(NSArray *)Address;
@end
@interface DZMapViewController : DZWKWebViewController
@property (nonatomic,weak) id<DZMapDelegate> delegate;
@end
