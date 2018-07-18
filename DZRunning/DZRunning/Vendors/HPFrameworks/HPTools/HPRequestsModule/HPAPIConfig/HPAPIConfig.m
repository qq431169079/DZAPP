//
//  HPAPIConfig.m
//  MyPractice
//
//  Created by huangpan on 16/7/20.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPAPIConfig.h"

@implementation HPAPIConfig
+ (id)configurationWithEnvironment:(HPEnvironmentType)type fileName:(NSString *)fileName {
    return [[self alloc] initWithEnvironment:type fileName:fileName];
}

- (instancetype)initWithEnvironment:(HPEnvironmentType)type fileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _environment = type;
        _fileName = fileName;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:(self.fileName ? self.fileName : @"HPAPIConfig") ofType:@"plist"];
    if ( filePath ) {
        _configDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        [self initEnvironmentGroupKey];
    } else {
        NSLog(@"HP >>HPAPIConfig: File Named %s not found!\n", self.fileName ? self.fileName.UTF8String : [@"HPAPI" UTF8String]);
    }
}

- (void)initEnvironmentGroupKey {
    switch (_environment) {
        case HPDistribution:
            _environmentGroupKey = HPDistributionKey;
            break;
        case HPGrayEnvironment:
            _environmentGroupKey = HPGrayEnvironmentKey;
            break;
        case HPDevelopment:
            _environmentGroupKey = HPDevelopmentKey;
            break;
        case HPPersonal:
            _environmentGroupKey = HPPersonalKey;
            break;
        default:
            _environmentGroupKey = HPDistributionKey;
            break;
    }
}

- (NSString *)reachHostName {
    return [_configDictionary objectForKey:HPReachHostKey];
}

- (NSString *) baseUrlPrefix {
    return [[_configDictionary objectForKey:_environmentGroupKey] objectForKey:HPBaseUrlKey];
}

- (NSString *) imageUrlPrefix {
    return [[_configDictionary objectForKey:_environmentGroupKey] objectForKey:HPImageUrlKey];
}

- (NSString *) sslUrlPrefix {
    return [[_configDictionary objectForKey:_environmentGroupKey] objectForKey:HPSSLUrlKey];
}

- (NSString *)descriptionOfApi:(NSString *)apiName {
    if (apiName) {
        NSDictionary * dict = [[_configDictionary objectForKey:HPApiServiceKey] objectForKey:apiName];
        if (dict) {
            return [dict objectForKey:HPAPIDescriptionKey];
        } else {
            NSLog(@"ERROR>>HPAPIConfig : your apiName can not found!\n");
        }
    } else {
        NSLog(@"ERROR>>HPAPIConfig : your apiName is nil !\n");
    }
    return nil;
}

- (NSString *)api:(NSString *)apiName {
    if (apiName) {
        NSDictionary *dict = [[_configDictionary objectForKey:HPApiServiceKey] objectForKey:apiName];
        if (dict ) {
            return [dict objectForKey:HPAPINameKey];
        } else {
            NSLog(@"ERROR>>LEConfigurate : your apiName can not found!\n");
        }
    } else {
        NSLog(@"ERROR>>LEConfigurate : your apiName is nil !\n");
    }
    return nil;
}
@end
