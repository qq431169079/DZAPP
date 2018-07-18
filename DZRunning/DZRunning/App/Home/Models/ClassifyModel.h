//
//  ClassifyModel.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPModel.h"
#import "DZMenuScrollView.h"

@interface ClassifyModel : HPModel<DZMenuModelProtocol>

@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *keyWord;

@property (nonatomic, copy) NSString *classifyId;

@end
