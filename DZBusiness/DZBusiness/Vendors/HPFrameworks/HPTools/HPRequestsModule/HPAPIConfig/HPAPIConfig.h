//
//  HPAPIConfig.h
//  MyPractice
//
//  Created by huangpan on 16/7/20.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPEnvironmentType) {
    HPDistribution      =   0,
    HPGrayEnvironment   =   1,
    HPDevelopment       =   2,
    HPPersonal          =   3,
};

static NSString * const HPDistributionKey       = @"HPDistributionKey";
static NSString * const HPGrayEnvironmentKey    = @"HPGrayEnvironmentKey";
static NSString * const HPDevelopmentKey        = @"HPDevelopmentKey";
static NSString * const HPPersonalKey           = @"HPPersonalKey";

static NSString * const HPReachHostKey          = @"HPReachHostName";
static NSString * const HPApiServiceKey         = @"HPAPI_Service";

static NSString * const HPBaseUrlKey            = @"HPBaseUrlKey";
static NSString * const HPSSLUrlKey             = @"HPSSLUrlKey";
static NSString * const HPImageUrlKey           = @"HPImageUrlKey";

static NSString * const HPAPINameKey            = @"api";
static NSString * const HPAPIDescriptionKey     = @"desc";

@interface HPAPIConfig : NSObject

@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, copy, readonly) NSString *environmentGroupKey;
@property (nonatomic, assign, readonly) HPEnvironmentType environment;
@property (nonatomic, strong, readonly) NSDictionary *configDictionary;

+ (id)configurationWithEnvironment:(HPEnvironmentType)type fileName:(NSString *)fileName;

- (NSString *)reachHostName;
- (NSString *)baseUrlPrefix;
- (NSString *)sslUrlPrefix;
- (NSString *)imageUrlPrefix;

- (NSString *)descriptionOfApi:(NSString *)apiName;
- (NSString *)api:(NSString *)apiName;

@end
