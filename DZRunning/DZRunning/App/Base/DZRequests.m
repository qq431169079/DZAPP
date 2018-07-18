//
//  DZRequests.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZRequests.h"

static BOOL validDictionary(id obj) {
    return (obj && [obj isKindOfClass:NSDictionary.class]);
}

static BOOL dictionaryHasKey(NSString *key, NSDictionary *dict) {
    if (key.length > 0 && validDictionary(dict)) {
        return (dict[key] != nil);
    }
    return NO;
}

@implementation DZRequests

/**
 *  解析结构
 *
 *  @param responseObject jsonObject
 *  @param successBlock    成功回调
 *  @param failureBlock    失败回调
 */
+ (void)doAnalysisResponseObject:(id)responseObject success:(void (^)(id))successBlock failure:(void (^)(HPRequestsError, NSError *))failureBlock {
    
    BOOL includKey = dictionaryHasKey(API_RCODE_KEY, responseObject);
    // 请求完成结果
    BOOL success = [responseObject[API_RCODE_KEY] boolValue];
    if (success || !includKey) {
        // 成功结果
        _hy_dispatch_main_async_safe(^(){
            id response = responseObject[@"data"];
            if (!response) {
                response = responseObject;
            }
            if (successBlock)
                successBlock(response);
        });
    }  else {
        // 失败结果
        if (failureBlock) failureBlock(HPRequestsErrorNotMatchData, [self errorWithServiceErrorType:HPRequestsErrorNotMatchData localizedDescriptionValue:responseObject[@"message"] ? : nil]);
    }
}
/*
    else if (failureBlock && responseObject) {
        // 失败结果，数据无法解析
        failureBlock(HPRequestsErrorNotMatchData, [self errorWithServiceErrorType:HPRequestsErrorNotMatchData localizedDescriptionValue:nil]);
    } else if (failureBlock && !responseObject) {
        // 失败结果，数据返回为空
        failureBlock(HPRequestsErrorFetchedError, [self errorWithServiceErrorType:HPRequestsErrorFetchedError localizedDescriptionValue:nil]);
    }
}
 */

/**
 *  错误提示生成
 */
+ (NSError *)errorWithServiceErrorType:(HPRequestsError)type localizedDescriptionValue:(NSString *)description {
    NSString * localizedDescKey = @"";
    switch (type) {
        case HPRequestsErrorNotConnnected:
            localizedDescKey = @"无法连接网络，网络连接已经断开！";
            break;
        case HPRequestsErrorFetchedError:
            localizedDescKey = @"服务器返回数据为空！";
            break;
        case HPRequestsErrorRequestError:
            localizedDescKey = @"请求错误，未录入API接口！->";
            localizedDescKey = [localizedDescKey stringByAppendingString:description];
            break;
        case HPRequestsErrorServerError:
            localizedDescKey = description ? description : @"服务器报错，请检查返回值!";
            break;
        case HPRequestsErrorNotMatchData:
            localizedDescKey = description ? : @"数据异常，请重试。";
            break;
        default:
            break;
    }
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               localizedDescKey, NSLocalizedDescriptionKey,
                               nil];
    return [NSError errorWithDomain:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
                               code:type
                           userInfo:userInfo];
}

@end
