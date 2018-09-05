//
//  DZJSActionModel.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/3.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZJSActionRouter.h"
#import "DZJSInteractiveExport.h"
@interface DZJSActionRouter()<DZJSInteractiveExport>

@end
@implementation DZJSActionRouter

- (void)actionRouterBase:(JSValue *)destn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(base:)]) {
        [self.delegate base:destn];
    }
}



 - (void)actionRouterValLink:(JSValue *)destn final:(JSValue *)param{
     if (self.delegate && [self.delegate respondsToSelector:@selector(valLink:final:)]) {
         [self.delegate valLink:destn final:param];
     }
 }



 - (void)actionRouterMoreLink:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg{
     if (self.delegate && [self.delegate respondsToSelector:@selector(moreLink:first:second:)]) {
         [self.delegate moreLink:destn first:firstArg second:secondArg];
     }
 }



 - (void)actionRouterOrderCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg{
     if (self.delegate && [self.delegate respondsToSelector:@selector(orderCheck:first:second:third:)]) {
         [self.delegate orderCheck:destn first:firstArg second:secondArg third:thirdArg];
     }
 }

 - (void)actionRouterMoreValCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg four:(JSValue *)fourArg{
     if (self.delegate && [self.delegate respondsToSelector:@selector(moreValCheck:first:second:third:four:)]) {
         [self.delegate moreValCheck:destn first:firstArg second:secondArg third:thirdArg four:fourArg];
     }
 }
@end
