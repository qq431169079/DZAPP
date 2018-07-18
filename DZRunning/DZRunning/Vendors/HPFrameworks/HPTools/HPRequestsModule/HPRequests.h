//
//  HPRequests.h
//  MyPractice
//
//  Created by huangpan on 16/7/20.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
// HTTPS 配置
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@class HPQueueHelper;


/**
 *  对应环境变量
 *  HPDistribution      = 0;  正式环境
 *  HPGrayEnvironment   = 1;  灰度环境
 *  HPDevelopment       = 2;  开发环境
 *  HPPersonal          = 3;  个人环境
 */

#define SERVER_TYPE 0

#define HPRunningEnvironment SERVER_TYPE

typedef NS_ENUM(NSInteger, HPRequestsError) {
    HPRequestsErrorNotConnnected     =   -1000, // 没有网络
    HPRequestsErrorRequestError      =   -1001, // 请求错误（未配置API或请求错误）
    HPRequestsErrorFetchedError      =   -1002, // 没有数据返回
    HPRequestsErrorNotMatchData      =   -1003, // 数据格式错误
    HPRequestsErrorServerError       =   -1004, // 服务器错误
};

static NSString * const API_RCODE_KEY                  = @"success";           // 服务器返回编码
static NSString * const API_RDESC_KEY                  = @"result";            // 服务器提示信息
static NSString * const API_RSUCCESS_KEY               = @"success";            /*请求成功编码*/
static NSString * const API_REDIT_KEY                  = @"account.edit";       /*请求成功并处于编辑状态编码*/
static NSString * const API_RBANDING_KEY               = @"account.banding";    /*请求成功并处于绑定账号状态编码*/
static NSInteger  const API_RTOKEN_EXPIRED_KEY         = 2;                     /*错误编码：请求token失效*/
static NSString * const NOTI_TOKEN_EXPIRED             = @"NOTI_TOKEN_EXPIRED"; /*token失效后将发送本通知，请在程序中添加对应逻辑*/
static NSString * const NOTI_DESKEY_LOST               = @"NOTI_DESKEY_LOST";   /*用户丢失了加密私钥*/
static NSString * const NOTI_USER_PICKOUT              = @"NOTI_TOKEN_PICKOUT"; /*用户被踢出*/
static NSString * const NOTI_NETWORK_NOTCONNECTION     = @"NOTI_NETWORK_NOTCONNECTION"; /*网络连接中断之后会发送本通知*/


/** --------------------------------------------------------------------------
 *  网络请求服务
 *  注意：
 *  1. iOS9需要在info.plist中加入
        NSAppTransportSecurity : @{ NSAllowsArbitraryLoads : YES}
 *  2.需要改变HPRunningEnvironment确定当前环境，可以移植到其他文件但是必须被本文件导入
 ** --------------------------------------------------------------------------
 */


@interface HPRequests : NSObject

+ (instancetype)shareInstance;

#pragma mark - Functions 可以重写
/**
 *  解析结构
 *
 *  @param responseObject JSON
 *  @param successBlock   成功回调
 *  @param failureBlock   失败回调
 */
+ (void)doAnalysisResponseObject:(id)responseObject success:(void(^)(id record))successBlock failure:(void (^)(HPRequestsError type, NSError *error))failureBlock;

/**
 *  地址传参形式的兼容，使用参数值替换占位符 | 可以重写本方法用来适应更多的情况
 *
 *  @param apiName    api后缀
 *  @param parameters 参数
 */
+ (NSString *)replaceUrlParams:(NSString *)apiName parameters:(NSDictionary *)parameters;

/**
 *  准备HTTP请求头
 *
 *  @param parameters 参数
 */
+ (void)preparedHttpRequestHeaderWithParams:(NSDictionary *)parameters;

/**
 *  DES加密同时加密请求地址
 *
 *  @param absoluteUrl 为加密的请求地址
 *
 *  @return 已经加密的请求地址
 */
+ (NSURL *)encodeRequestAbsoluteUrl:(NSString *)absoluteUrl;

/**
 *  DES加密参数
 *
 *  @param parameters 请求参数
 *
 *  @return 已经加密的数据块
 */
+ (NSData *)encodeRequestWithPostParams:(NSDictionary *)parameters;

/**
 *  错误提示生成
 */
+ (NSError *)errorWithServiceErrorType:(HPRequestsError)type localizedDescriptionValue:(NSString *)description;

#pragma mark - HTTP 请求部分
/**
 *  添加http请求头内容
 */
+ (void)addHttpHeaderKey:(NSString *)key value:(id)value;

/**
 *  网络是否正常连接
 */
- (BOOL)isNeworkConnected;

/**
 *  开始HTTPS请求
 */
+ (BOOL)openHttpsRequest;

/**
 *  关闭https请求
 */
+ (BOOL)closeHttpsRequest;

/**
 *  是否是https请求
 */
+ (BOOL)isHttpsRequest;

/**
 *  开启DES加密
 */
+ (BOOL)openDESEncrypt;

/**
 *  关闭DES加密
 */
+ (BOOL)closeDESEncrypt;

/**
 *  是否开启DES加密
 */
+ (BOOL)isDESEncrypt;

/**
 *  关闭第三方请求中请求格式默认为AFJSONRequestSerializer－>AFHTTPRequestSerializer
 *  此关闭方法只能生效一次，只对第三方请求生效
 */
+ (BOOL)requestSerializerCloseJson;

/**
 *  GET请求
 */
+ (NSURLSessionDataTask *)get:(NSString *)urlKey
                   parameters:(NSDictionary *)parameters
                      success:(void(^)(id record))successBlcok
                      failure:(void(^)(HPRequestsError type, NSError *error))failureBlock;

/**
 *  POST 1
 */
+ (NSURLSessionDataTask *)post:(NSString *)urlKey
                    parameters:(NSDictionary *)parameters
                       success:(void(^)(id record))successBlcok
                       failure:(void(^)(HPRequestsError type, NSError *error))failureBlock;

/**
 *  POST 2
 */
+ (NSURLSessionDataTask *)post:(NSString *)urlKey
                    parameters:(NSDictionary *)parameters
                          body:(void(^)(id<AFMultipartFormData>formData))bodyBlock
                       success:(void(^)(id record))successBlock
                       failure:(void(^)(HPRequestsError typre, NSError *error))failureBlock
                      progress:(void(^)(NSProgress *))uploadProgress;

/**
 *  PUT
 */
+ (NSURLSessionDataTask *)put:(NSString *)urlKey
                   parameters:(NSDictionary *)parameters
                      success:(void(^)(id record))successBlock
                      failure:(void(^)(HPRequestsError type, NSError *error))failureBlock;

/**
 *  delete
 */
+ (NSURLSessionDataTask *)Delete:(NSString *)urlKey
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(id record))successBlock
                         failure:(void(^)(HPRequestsError type, NSError *error))failureBlock;

/**
 *  Queue
 */
+ (void)queue:(NSArray<NSURLSessionTask *> * (^)(HPQueueHelper ** pointer))taskConstructBlock complete:(void(^)(NSArray<NSURLSessionTask *> *taskArray, NSError *error))completeBlock;

/**
 * 请求操作，用于添加到队列中执行｜未开始，请不要用此方法构造分离的请求
 */
+ (NSURLSessionTask *)dataTaskWithPoint:(HPQueueHelper *)helper
                                 urlKey:(NSString *)urlKey
                          requestMethod:(NSString *)requestMethod
                             parameters:(NSDictionary *)parameters
                                success:(void(^)(id record))successBlock
                                failure:(void(^)(HPRequestsError type, NSError *error))failureBlock
                         uploadProgress:(void(^)(NSProgress *))uploadProgressBlock
                       downloadProgress:(void(^)(NSProgress *))downloadProgressBlcok;

/**
 * 非客户端api，第三方api请求｜注意：不会走基本解析过滤操作
 */
+ (NSURLSessionDataTask *)requestWithAbsoluteUrlKey:(NSString *)absoluteUrlString
                                      requestMethod:(NSString *)requestMethod
                                   headerParameters:(NSDictionary *)headerParameters
                                         parameters:(NSDictionary *)parameters
                                            success:(void(^)(id reponseObject))successBlock
                                            failure:(void(^)(NSError *error))failureBlcok
                                     uploadProgress:(void(^)(NSProgress *uploadProgress))uploadProgressBlock
                                   downloadProgress:(void(^)(NSProgress *downloadProgress))downloadProgressBlcok;

/**
 *  用户退出
 */
+ (void)logoutAction;

#pragma mark - 配置内容部分
/**
 *  主机地址
 */
+ (NSString *)apiHost;

/**
 *  图片地址
 */
+ (NSString *)imageHost;

/**
 *  当前网络环境字符串
 */
+ (NSString *)currentReachabilityString;

/**
 *  当前网络状态枚举值
 *  Unkown ＝ -1,
 *  NotReachable = 0,
 *  WWAN = 1,
 *  WiFi = 2,
 */
+ (NSInteger)currentReachabilityCode;
@end



#define API_HOST                [HPRequests apiHost]
#define API_IMAGE_HOST          [HPRequests imageHost]

@interface HPQueueHelper : NSObject

@property (nonatomic, assign) NSUInteger completeCount;

- (void)push;
- (void)pop;
- (BOOL)isAllCompelete;

@end

/**
 *  将NSData转换成NSDictionary或者NSArray
 *
 *  @return NSDictionary | NSArray | nil
 */
id HPDictionaryFromData(id data);
