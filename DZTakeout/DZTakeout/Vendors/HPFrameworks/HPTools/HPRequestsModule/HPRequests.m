//
//  HPRequests.m
//  MyPractice
//
//  Created by huangpan on 16/7/20.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPRequests.h"
#import "HPAPIConfig.h"

@interface HPRequests ()
@property (nonatomic, strong) HPAPIConfig *configurate;
@property (nonatomic, assign) AFNetworkReachabilityStatus status;
@property (nonatomic, strong) NSMutableDictionary *httpHeaderDictionary;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFHTTPSessionManager *sslManager;
@property (nonatomic, assign, getter=isHttpRequestType) BOOL httpsRequestType;
@property (nonatomic, assign, getter=isRequestDESEncrypt) BOOL requestDESEncrypt;
@property (nonatomic, assign, getter=isRequestSerializerJson) BOOL requestSerializerJson;
@end

@implementation HPRequests

- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (instancetype)shareInstance {
    static HPRequests *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.configurate = [HPAPIConfig configurationWithEnvironment:HPRunningEnvironment fileName:nil];
    // HTTP 请求配置
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;// 不要验证域名
    self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self.configurate baseUrlPrefix]]];
//    [self.httpManager setSecurityPolicy:securityPolicy];
    [self.httpManager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    [self.httpManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self.httpManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    // HTTPS配置
    self.sslManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self.configurate sslUrlPrefix]]];
    [self.sslManager setSecurityPolicy:securityPolicy];
    [self.sslManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self.sslManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    // 开始网络监听
    [self enableReachability];
    //
    _httpsRequestType = YES;
    //
    _requestSerializerJson = YES;
}

#pragma mark - 网络监听
- (void)enableReachability {
    __weak HPRequests *weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.status = status;
        NSLog(@"网络状态变更 : %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NETWORK_NOTCONNECTION object:nil];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    _status = AFNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isNeworkConnected {
    return _status != AFNetworkReachabilityStatusNotReachable;
}

#pragma mark - 网络辅助方法
+ (BOOL)openHttpsRequest {
    [[self shareInstance] setHttpsRequestType:YES];
    return [[self shareInstance] isHttpRequestType];
}

+ (BOOL)closeHttpsRequest {
    [[self shareInstance] setHttpsRequestType:NO];
    return [[self shareInstance] isHttpRequestType];
}

+ (BOOL)isHttpsRequest {
    return [[self shareInstance] isHttpRequestType];
}

+ (BOOL)openDESEncrypt {
    [[self shareInstance] setRequestDESEncrypt:YES];
    return [[self shareInstance] isRequestDESEncrypt];
}

+ (BOOL)closeDESEncrypt {
    [[self shareInstance] setRequestDESEncrypt:NO];
    return [[self shareInstance] isRequestDESEncrypt];
}

+ (BOOL)isDESEncrypt {
    return [[self shareInstance] isRequestDESEncrypt];
}

+ (BOOL)requestSerializerCloseJson {
    [[self shareInstance] setRequestSerializerJson:NO];
    return [[self shareInstance] isRequestSerializerJson];
}

+ (BOOL)openRequestSerializerJson {
    [[self shareInstance] setRequestSerializerJson:YES];
    return YES;
}

+ (BOOL)isRequestSerializerJson {
    return [[self shareInstance] isRequestSerializerJson];
}

+ (AFHTTPSessionManager *)manager {
    return [[self shareInstance] isHttpRequestType] ? [[self shareInstance] sslManager] : [[self shareInstance] httpManager];
}

+ (NSError *)errorWithServiceErrorType:(HPRequestsError)type localizedDescriptionValue:(NSString *)description {
    NSString * localizedDescKey = @"";
    switch ( type ) {
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
            localizedDescKey = description != nil ? description : @"服务器报错，请检查返回值!";
            break;
        case HPRequestsErrorNotMatchData:
            localizedDescKey = @"服务器返回的数据无法转译成NSDictionary!";
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

+ (NSError *)errorFilter:(NSError *)error {
    if ( error && error.code == -1011 ) { //无法连接到服务器
        error = [NSError errorWithDomain:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] code:error.code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"无法连接服务器", NSLocalizedDescriptionKey, nil]];
    }
    if ( error && error.code == -999 ) {
        error = nil;
    }
    return error;
}

/**
 *  设置http请求头
 */
- (void)setUpHttpHeader {
    if ( _httpHeaderDictionary ) {
        NSDictionary *headerDictionary = [NSDictionary dictionaryWithDictionary:_httpHeaderDictionary];
        [headerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [[self.httpManager requestSerializer] setValue:obj forHTTPHeaderField:key];
            [[self.sslManager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
}

/**
 *  准备HTTP请求头
 */
+ (void)preparedHttpRequestHeaderWithParams:(NSDictionary *)parameters {
    // 子类重写
}

+ (NSURL *)encodeRequestAbsoluteUrl:(NSString *)absoluteUrl {
    // 子类重写
    return [NSURL URLWithString:absoluteUrl];
}


+ (NSData *)encodeRequestWithPostParams:(NSDictionary *)parameters {
    // 子类重写
    return nil;
}

+ (void)addHttpHeaderKey:(NSString *)key value:(id)value {
    if ( [[self shareInstance] httpHeaderDictionary] == nil ) {
        [[self shareInstance] setHttpHeaderDictionary:[NSMutableDictionary dictionary]];
    }
    if ( key != nil && value != nil ) {
        [[[self shareInstance] httpHeaderDictionary] setObject:value forKey:key];
    }
}

/**
 *  检查网络环境
 */
+ (BOOL)checkNetworkStatusWithFailureBlock:(void(^)(HPRequestsError type, NSError * error))failureBlock {
    if ( ![[self shareInstance] isNeworkConnected] && failureBlock ) {
        failureBlock(HPRequestsErrorNotConnnected, [self errorWithServiceErrorType:HPRequestsErrorNotConnnected localizedDescriptionValue:nil]);
        return NO;
    }
    return YES;
}

/**
 *  检查API是否存在
 */
+ (NSString *)checkAPIKey:(NSString *)key
         withFailureBlock:(void(^)(HPRequestsError type, NSError * error))failureBlock {
    NSString *apiName = [[[self shareInstance] configurate] api:key];
    if ( nil == apiName && failureBlock ) {
        failureBlock(HPRequestsErrorRequestError, [self errorWithServiceErrorType:HPRequestsErrorRequestError localizedDescriptionValue:key]);
    }
    return apiName;
}

/**
 *  解析返回数据
 */
+ (void)analysisResponseObject:(id)responseObject complete:(void (^)(id record))completeBlock failure:(void(^)(HPRequestsError type, NSError *error))failureBlock {
    responseObject = HPDictionaryFromData(responseObject);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doAnalysisResponseObject:responseObject success:completeBlock failure:failureBlock];
    });
}

/**
 *  过滤返回数据
 */
+ (void)doAnalysisResponseObject:(id)responseObject success:(void (^)(id))successBlock failure:(void (^)(HPRequestsError, NSError *))failureBlock {
    // 子类重写
}

/**
 *  地址传参形式的兼容，使用参数值替换占位符
 */
+ (NSString *)replaceUrlParams:(NSString *)apiName parameters:(NSDictionary *)parameters {
    if (!parameters || ![apiName containsString:@"{"]) {
        return apiName;
    }
    
    __block NSString *url = apiName;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *value = nil;
            if ([obj isKindOfClass:[NSString class]]) {
                value = obj;
            } else {
                value = [NSString stringWithFormat:@"%@",obj];
            }
            url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}",key] withString:value];
        }
    }];
    return url;
}

#pragma mark - 网络请求
+ (NSURLSessionDataTask *)get:(NSString *)urlKey
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id))successBlcok
                      failure:(void (^)(HPRequestsError, NSError *))failureBlock {
    // 1.检查网络状态
    if ( ![self checkNetworkStatusWithFailureBlock:failureBlock] ) {
        // 如果网路不同则直接结束
        return nil;
    }
    // 2.添加HTTP请求头
    [self preparedHttpRequestHeaderWithParams:parameters];
    [[self shareInstance] setUpHttpHeader];
    // 3.找API接口
    NSString *apiName = [self checkAPIKey:urlKey withFailureBlock:failureBlock];
    if (nil == apiName) return nil; // 如果找不到接口，则直接结束
    // 地址传参形式兼容
    apiName = [self replaceUrlParams:apiName parameters:parameters];
    // 4.开始请求
    AFHTTPSessionManager *manager = [self manager];
    if ( [self isDESEncrypt] ) {
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:apiName relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        // 4.1 加密参数与链接地址
        [request setURL:[self encodeRequestAbsoluteUrl:request.URL.absoluteString]];
        // 4.2 改变contentType
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (failureBlock) {
                    error = [self errorFilter:error];
                    failureBlock(HPRequestsErrorRequestError, error);
                } else {
                    [self analysisResponseObject:responseObject complete:successBlcok failure:failureBlock];
                }
            }
        }];
        [dataTask resume];
        return dataTask;
    } else {
        return [manager GET:apiName
                 parameters:parameters
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [self analysisResponseObject:responseObject complete:successBlcok failure:failureBlock];
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        error = [self errorFilter:error];
                        if ( failureBlock ) {
                            failureBlock(HPRequestsErrorRequestError, error);
                        }
        }];
    }
}

+ (NSURLSessionDataTask *)post:(NSString *)urlKey parameters:(NSDictionary *)parameters success:(void (^)(id))successBlcok failure:(void (^)(HPRequestsError, NSError *))failureBlock {

    // 1.检查网络状态
    if ( ![self checkNetworkStatusWithFailureBlock:failureBlock] ) {
        return nil;
    }
    // 2.添加HTTP请求头
    [self preparedHttpRequestHeaderWithParams:parameters];
    [[self shareInstance] setUpHttpHeader];
    // 3. 找API接口
    NSString *apiName = [self checkAPIKey:urlKey withFailureBlock:failureBlock];
    if (apiName == nil) return nil;
    apiName = [self replaceUrlParams:apiName parameters:parameters];
    // 4.开始请求
    AFHTTPSessionManager *manager = [self manager];
    if ( [self isDESEncrypt] ) {
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:apiName relativeToURL:manager.baseURL] absoluteString] parameters:@{} error:nil];
        // 4.1 加密请求地址
        [request setURL:[self encodeRequestAbsoluteUrl:request.URL.absoluteString]];
        // 4.2 加密参数
        [request setHTTPBody:[self encodeRequestWithPostParams:parameters]];
        // 4.3 改变contentType
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if ( error ) {
                if ( failureBlock ) {
                    error = [self errorFilter:error];
                    failureBlock(HPRequestsErrorRequestError, error);
                }
            } else {
                [self analysisResponseObject:responseObject complete:successBlcok failure:failureBlock];
            }
        }];
        [dataTask resume];
        return dataTask;
    } else {
        return [manager POST:apiName parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self analysisResponseObject:responseObject complete:successBlcok failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [self errorFilter:error];
            failureBlock(HPRequestsErrorRequestError, error);
        }];
    }
}


+ (NSURLSessionDataTask *)post:(NSString *)urlKey parameters:(NSDictionary *)parameters body:(void (^)(id<AFMultipartFormData>))bodyBlock success:(void (^)(id))successBlock failure:(void (^)(HPRequestsError, NSError *))failureBlock progress:(void (^)(NSProgress *))uploadProgress {
    // 1.检查网络状态
    if ( ![self checkNetworkStatusWithFailureBlock:failureBlock] ) {
        return nil;
    }
    // 2.添加HTTP请求头
    [self preparedHttpRequestHeaderWithParams:parameters];
    [[self shareInstance] setUpHttpHeader];
    // 3. 找API接口
    NSString *apiName = [self checkAPIKey:urlKey withFailureBlock:failureBlock];
    if (apiName == nil) return nil;
    apiName = [self replaceUrlParams:apiName parameters:parameters];
    // 4. 开始请求
    AFHTTPSessionManager *manager = [self manager];
    if ( [self isDESEncrypt] ) {
        NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:apiName relativeToURL:manager.baseURL] absoluteString] parameters:@{} constructingBodyWithBlock:bodyBlock error:nil];
        // 4.1 加密请求地址
        [request setURL:[self encodeRequestAbsoluteUrl:request.URL.absoluteString]];
        // 4.2 加密参数
        [request setHTTPBody:[self encodeRequestWithPostParams:parameters]];
        //4.3 改变contentType
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            if (error) {
                if ( failureBlock ) {
                    error = [self errorFilter:error];
                    failureBlock(HPRequestsErrorRequestError, error);
                }
            } else {
                [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
            }
        }];
        [dataTask resume];
        return dataTask;
    } else {
        return [manager POST:apiName parameters:parameters constructingBodyWithBlock:bodyBlock progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [self errorFilter:error];
            if ( failureBlock ) {
                failureBlock (HPRequestsErrorRequestError, error);
            }
        }];
    }
}

+ (NSURLSessionDataTask *)put:(NSString *)urlKey parameters:(NSDictionary *)parameters success:(void (^)(id))successBlock failure:(void (^)(HPRequestsError, NSError *))failureBlock {
    //1.检查网络状态
    if ( ![self checkNetworkStatusWithFailureBlock:failureBlock] ) return nil;    //如果网络不通直接结束方法
    //2.添加HTTP请求头
    [self preparedHttpRequestHeaderWithParams:parameters];
    [[self shareInstance] setUpHttpHeader];
    //3.找API接口
    NSString * apiName = [self checkAPIKey:urlKey withFailureBlock:failureBlock];
    if ( apiName == nil )   return nil;    //如果未找到接口名字，直接结束方法
    //地址传参形式的兼容
    apiName = [self replaceUrlParams:apiName parameters:parameters];
    //4.开始请求
    AFHTTPSessionManager * manager = [self manager];
    if ( [self isDESEncrypt] ) {
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:apiName relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        //4.1 加密参数
        [request setURL:[self encodeRequestAbsoluteUrl:request.URL.absoluteString]];
        //4.2 改变contentType
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            if (error) {
                if ( failureBlock ) {
                    error = [self errorFilter:error];
                    failureBlock(HPRequestsErrorRequestError, error);
                }
            } else {
                [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
            }
        }];
        [dataTask resume];
        return dataTask;
    } else {
        return [manager PUT:apiName
                 parameters:parameters
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        error = [self errorFilter:error];
                        if ( failureBlock ) failureBlock(HPRequestsErrorRequestError, error);
                    }];
    }

}

+ (NSURLSessionDataTask *)Delete:(NSString *)urlKey parameters:(NSDictionary *)parameters success:(void (^)(id))successBlock failure:(void (^)(HPRequestsError, NSError *))failureBlock {
    //1.检查网络状态
    if ( ![self checkNetworkStatusWithFailureBlock:failureBlock] )    return nil;    //如果网络不通直接结束方法
    //2.添加HTTP请求头
    [self preparedHttpRequestHeaderWithParams:parameters];
    [[self shareInstance] setUpHttpHeader];
    //3.找API接口
    NSString * apiName = [self checkAPIKey:urlKey withFailureBlock:failureBlock];
    if ( apiName == nil )   return nil;    //如果未找到接口名字，直接结束方法
    //地址传参形式的兼容
    apiName = [self replaceUrlParams:apiName parameters:parameters];
    //4.开始请求
    AFHTTPSessionManager * manager = [self manager];
    if ( [self isDESEncrypt] ) {
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:apiName relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
        //4.1 加密参数
        [request setURL:[self encodeRequestAbsoluteUrl:request.URL.absoluteString]];
        //4.3 改变contentType
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            if (error) {
                if ( failureBlock ) {
                    error = [self errorFilter:error];
                    failureBlock(HPRequestsErrorRequestError, error);
                }
            } else {
                [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
            }
        }];
        [dataTask resume];
        return dataTask;
    } else {
        return [manager DELETE:apiName
                    parameters:parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           error = [self errorFilter:error];
                           if ( failureBlock ) failureBlock(HPRequestsErrorRequestError, error);
                       }];
    }
}

+ (void)queue:(NSArray<NSURLSessionTask *> *(^)(HPQueueHelper *__autoreleasing *))taskConstructBlock complete:(void (^)(NSArray<NSURLSessionTask *> *, NSError *))completeBlock {
    // 1. 检查网络状态
    if ( ![[self shareInstance] isNeworkConnected] && completeBlock ) {
        completeBlock(nil, [HPRequests errorWithServiceErrorType:HPRequestsErrorNotConnnected localizedDescriptionValue:nil]);
        return;
    }
    // 2. 如果线程创建方式
    if (!taskConstructBlock) {
        NSLog(@"ERROR>>Queue: taskConstructBlock can not be nil!\n");
        return;
    }
    
    __block HPQueueHelper *helper = [[HPQueueHelper alloc] init];
    // 构造请求
    NSArray<NSURLSessionTask *> *sessionTasks = taskConstructBlock(&helper);
    // 开始执行请求
    [sessionTasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj resume];
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger count = 0;
        while ( ![helper isAllCompelete] && count < 30000) {
            usleep(1000);
            count ++;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            if ( count >= 30000 ) {
                error = [self errorWithServiceErrorType:HPRequestsErrorNotConnnected localizedDescriptionValue:@"请求超时"];
            }
            if ( completeBlock ) {
                completeBlock(sessionTasks, error);
            }
        });
    });
}

/**
 *  请求操作，用于添加到队列中执行 | 不要使用该方法构造分离的请求
 */
+ (NSURLSessionTask *)dataTaskWithPoint:(HPQueueHelper *)helper urlKey:(NSString *)urlKey requestMethod:(NSString *)requestMethod parameters:(NSDictionary *)parameters success:(void (^)(id))successBlock failure:(void (^)(HPRequestsError, NSError *))failureBlock uploadProgress:(void (^)(NSProgress *))uploadProgressBlock downloadProgress:(void (^)(NSProgress *))downloadProgressBlcok {
    // 1. 添加HTTP请求头
    [self preparedHttpRequestHeaderWithParams:parameters];
    [[self shareInstance] setUpHttpHeader];
    // 2. 查找API接口
    NSString *apiName = [self checkAPIKey:urlKey withFailureBlock:failureBlock];
    if ( apiName == nil) return nil;
    apiName = [self replaceUrlParams:apiName parameters:parameters];
    // 3. 构造URLRequest
    NSError *error = nil;
    NSString *urlString = [[NSURL URLWithString:apiName relativeToURL:[self manager].baseURL] absoluteString];
    NSMutableURLRequest *request = [[self manager].requestSerializer requestWithMethod:requestMethod URLString:urlString parameters:parameters error:&error];
    if ( error && failureBlock ) {
        failureBlock(HPRequestsErrorRequestError, error);
        return nil;
    }
    // 4. 请求连接地址加密
    if ( [self isDESEncrypt] ) {
        // 加密地址
        [request setURL:[self encodeRequestAbsoluteUrl:request.URL.absoluteString]];
        // 改变contentType
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        // 机密参数
        if ( [[requestMethod uppercaseString] isEqualToString:@"POST"] ) {
            // 如果是POST请求，需要加密参数
            [request setHTTPBody:[self encodeRequestWithPostParams:parameters]];
        }
    }
    // 5. 构造请求
    [helper push];
    NSURLSessionDataTask *dataTask = [[self manager] dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlcok completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ( error ) {
            error = [self errorFilter:error];
            if ( failureBlock ) {
                failureBlock(HPRequestsErrorRequestError, error);
            }
        } else {
            [self analysisResponseObject:responseObject complete:successBlock failure:failureBlock];
        }
        [helper pop];
    }];
    return dataTask;
}

/**
 * 非客户端api，第三方api请求｜注意：不会解析操作
 */
+ (NSURLSessionDataTask *) requestWithAbsoluteUrlKey : (NSString *) absoluteUrlString
                                       requestMethod : (NSString *) requestMethod
                                    headerParameters : (NSDictionary *) headerParameters
                                          parameters : (NSDictionary *) parameters
                                             success : (void(^)(id responseObject)) successBlock
                                             failure : (void(^)(NSError * error)) failureBlock
                                      uploadProgress : (void(^)(NSProgress *uploadProgress)) uploadProgressBlock
                                    downloadProgress : (void (^)(NSProgress *downloadProgress)) downloadProgressBlock {
    //1.检查网络状态
    if ( ![[self shareInstance] isNeworkConnected] ) {
        NSLog(@"ERROR>>Queue: Network not in connected !\n");
        return nil;    //如果网络不通直接结束方法
    }
    //2.构造Manager
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    if ( [self isHttpsRequest] ) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        [manager setSecurityPolicy:securityPolicy];
    } else {
        [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    }
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    if ( ![self isRequestSerializerJson] ) {
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [self openRequestSerializerJson];
    }
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    //3.构造URLRequest
    NSError * error = nil;
    NSMutableURLRequest * request = [manager.requestSerializer requestWithMethod : requestMethod
                                                                       URLString : absoluteUrlString
                                                                      parameters : parameters
                                                                           error : &error];
    if ( error && failureBlock ) {
        failureBlock(error);
        return nil;
    }
    if ( headerParameters ) {
        [headerParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ( [request.allHTTPHeaderFields.allKeys containsObject:key] ) {
                [request setValue:obj forHTTPHeaderField:key];
            } else {
                [request addValue:obj forHTTPHeaderField:key];
            }
        }];
    }
    //4.AFHTTPRequestOperation构造
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if ( failureBlock ) {
                error = [self errorFilter:error];
                failureBlock(error);
            }
        } else if ( successBlock ) {
            successBlock(responseObject);
        }
    }];
    [dataTask resume];
    return dataTask;
}

/**
 *  登出操作，停止所有请求
 */
+ (void) logoutAction {
    [[[[self shareInstance] httpManager] operationQueue] cancelAllOperations];
    [[[[self shareInstance] sslManager] operationQueue] cancelAllOperations];
}

#pragma mark - 读取配置内容
+ (NSString *)apiHost {
    return [[self shareInstance] isHttpRequestType] ? [[[self shareInstance] configurate] sslUrlPrefix] : [[[self shareInstance] configurate] baseUrlPrefix];
}

+ (NSString *)imageHost {
    return [[[self shareInstance] configurate] imageUrlPrefix];
}

+ (NSString *)currentReachabilityString {
    switch ( [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] ) {
        case AFNetworkReachabilityStatusUnknown:
            return NSLocalizedString(@"Unknow", @"");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return NSLocalizedString(@"No Connection", @"");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return NSLocalizedString(@"Cellular", @"");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return NSLocalizedString(@"WiFi", @"");
            break;
    }
}

+ (NSInteger)currentReachabilityCode {
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}
@end


@implementation HPQueueHelper

- (void)push {
    self.completeCount ++;
}

- (void)pop {
    self.completeCount --;
}

- (BOOL)isAllCompelete {
    return 0 == self.completeCount;
}
@end

id HPDictionaryFromData(id data) {
    if ([data isKindOfClass:[NSData class]]) {
        @try {
            data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        } @catch (NSException *exception) {
            //
            NSLog(@" >>>> error %@",exception);
        }
    }
    return data;
}

