//
//  DZJSInteractiveExport.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/13.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol DZJSInteractiveExport <JSExport>

JSExportAs
(base,
 - (void)base:(JSValue *)destn
 );

JSExportAs
(valLink,
 - (void)valLink:(JSValue *)destn final:(JSValue *)param
 );


JSExportAs
(moreLink,
 - (void)moreLink:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg
 );


JSExportAs
(orderCheck,
 - (void)orderCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg
 );
JSExportAs
(moreValCheck,
 - (void)moreValCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg four:(JSValue *)fourArg
 );
@end
