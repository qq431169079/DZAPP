//
//  DZMapViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/2.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZMapViewController.h"
#import "DZBMKLocationTool.h"
@interface DZMapViewController ()

@end

@implementation DZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图";
    NSString *lng = [NSString stringWithFormat:@"%f",[DZBMKLocationTool sharedInstance].curLocation.location.coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f",[DZBMKLocationTool sharedInstance].curLocation.location.coordinate.latitude];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:lng forKey:@"lng"];
    [params setValue:lat forKey:@"lat"];
    [self loadWebView:DZMapURL params:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)launch:(NSString *)destn withParams:(NSArray<NSString *> *)params{
    if ([destn isEqualToString:@"saveMap"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkMapAddress:)]) {
            [self.delegate checkMapAddress:params];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
