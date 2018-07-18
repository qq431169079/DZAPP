//
//  HPModel.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPModel.h"

@implementation HPModel

+ (NSArray *)modelsWithArray:(id)json{
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

+ (instancetype)modelDictionary:(NSDictionary *)dictionary{
    
    return [self yy_modelWithDictionary:dictionary];
}

+ (instancetype)modelWithJSON:(id)json{
    
    return [self yy_modelWithJSON:json];
}

+ (NSDictionary<NSString *, id> *) modelCustomPropertyMapper {
    NSMutableDictionary<NSString *, id> * mapDictionary = [NSMutableDictionary dictionary];
    Class clazz = self;
    while ([clazz isSubclassOfClass:HPModel.class]) {
        [mapDictionary addEntriesFromDictionary:[clazz propertyToKeyPair]];
        clazz = [clazz superclass];
    }
    return mapDictionary;
}

+ (NSDictionary<NSString *, id> *) modelContainerPropertyGenericClass {
    NSMutableDictionary<NSString *, id> * mapDictionary = [NSMutableDictionary dictionary];
    Class clazz = self;
    while ([clazz isSubclassOfClass:HPModel.class]) {
        [mapDictionary addEntriesFromDictionary:[clazz propertyToClassPair]];
        clazz = [clazz superclass];
    }
    return mapDictionary;
}

+ (NSDictionary<NSString *, id> *) propertyToClassPair {
    return nil;
}

+ (NSDictionary<NSString *, id> *) propertyToKeyPair {
    return nil;
}

@end


#import "NSObject+NSCoding.h"
#import "HPFileManager.h"
#import "HPMacro.h"

@implementation HPModel (Archive)

#pragma mark - Archive
- (BOOL)saveToFile:(NSString *)filePath {
    if (filePath) {
        if ([HPFileManager isFileExistsAtPath:filePath]) {
            [HPFileManager deleteFileAtPath:filePath];
        }
        return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    }
    return NO;
}

- (BOOL)saveToDocumentWithFileName:(NSString *) fileName {
    NSString * filePath = [HPFileManager createFileInDocumentsWithFileName:fileName];
    return [self saveToFile:filePath];
}

- (BOOL)saveToCachesWithFileName:(NSString *) fileName {
    NSString * filePath = [HPFileManager createFileInCachesWithFileName:fileName];
    return [self saveToFile:filePath];
}

- (BOOL)saveToTmpWithFileName:(NSString *)fileName {
    NSString * filePath = [HPFileManager createFileInTmpWithFileName:fileName];
    return [self saveToFile:filePath];
}

+ (id)loadFromFile:(NSString *)filePath {
    if ( filePath ) {
        if ([HPFileManager isFileExistsAtPath:filePath]) {
            id object = nil;
            @try {
                object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            } @catch (NSException *exception) {
                HPLog(@">> HP : EXCEPTION IN NSKeyedUnarchiver<loadFromFile:>!");
            } @finally {
                return object;
            }
        } else {
            HPLog(@">> HP : Can not found file <loadFromFile:>!");
        }
    }
    return nil;
}

+ (id)loadFromDocumentWithFileName:(NSString *) fileName {
    NSString * filePath = [HPFileManager filePathInDocumentsWithFileName:fileName];
    return [self loadFromFile:filePath];
}

+ (id)loadFromCachesWithFileName:(NSString *) fileName {
    NSString * filePath = [HPFileManager filePathInCachesWithFileName:fileName];
    return [self loadFromFile:filePath];
}

+ (id)loadFromTmpWithFileName:(NSString *)fileName {
    NSString * filePath = [HPFileManager filePathInTmpWithFileName:fileName];
    return [self loadFromFile:filePath];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self autoDecode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self autoEncodeWithCoder:aCoder];
}
@end
