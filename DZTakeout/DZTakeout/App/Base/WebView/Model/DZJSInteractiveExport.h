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
 - (void)actionRouterBase:(JSValue *)destn
 );

JSExportAs
(valLink,
 - (void)actionRouterValLink:(JSValue *)destn final:(JSValue *)param
 );


JSExportAs
(moreLink,
 - (void)actionRouterMoreLink:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg
 );


JSExportAs
(orderCheck,
 - (void)actionRouterOrderCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg
 );
JSExportAs
(moreValCheck,
 - (void)actionRouterMoreValCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg four:(JSValue *)fourArg
 );
@end
