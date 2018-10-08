//
//  UserHelper.m
//  DiceGame
//
//  Created by HuangPan on 2017/10/22.
//  Copyright © 2017年 HuangPan. All rights reserved.
//

#import "UserHelper.h"
#import "HPFileManager.h"
#import "NSString+HPUtil.h"

NSString *const kUserLoginSuccessNotification = @"kUserLoginSuccessNotification";

static NSString *const kDGUserCacheFileName = @"DG_USER_CACHE_FILE";

@interface UserHelper ()
@property (nonatomic, strong) UserModel *userItem;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *temporaryVariables;

@end

@implementation UserHelper

#pragma mark - Init
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (UserHelper *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp
{
    self.temporaryVariables = [NSMutableDictionary dictionary];
    [self _loadUserItem];
}

- (void)_loadUserItem
{
    if ([HPFileManager isFileExistsInDocuments:kDGUserCacheFileName]) {
        _userItem = [UserModel loadFromDocumentWithFileName:kDGUserCacheFileName];
    }
}

- (BOOL)_saveUserItem
{
    return [self.userItem saveToDocumentWithFileName:kDGUserCacheFileName];
}

- (void)_logout
{
    _userItem = nil;
    if ([HPFileManager isFileExistsInDocuments:kDGUserCacheFileName]) {
        [HPFileManager deleteFileInDocumentsWithFileName:kDGUserCacheFileName];
    }
}

- (UserModel *)_getUserItem
{
    return _userItem;
}

- (void)_setUpWithRecord:(NSDictionary *)record
{
    if (record && [record isKindOfClass:NSDictionary.class]) {
        _userItem = [UserModel modelDictionary:record];
        [self _saveUserItem];
        
        [self sendLoginSuccessNotificationIfNeeded];
    }
}
- (void)sendLoginSuccessNotificationIfNeeded
{
    if ([UserHelper isUserLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification object:nil];
    }
}

#pragma mark - 缓存
- (void)temporaryCacheObject:(id)object forKey:(NSString *)key {
    if (!key) { return; }
    if (object) {
        [self.temporaryVariables setObject:object forKey:key];
    } else {
        [self.temporaryVariables removeObjectForKey:key];
    }
}

- (id)temporaryObjectForKey:(NSString *)key {
    if (key) {
        return [self.temporaryVariables objectForKey:key];
    }
    return nil;
}

- (id)removeTemporaryObjectForKey:(NSString *)key {
    if (key) {
        id value = [self.temporaryVariables objectForKey:key];
        [self.temporaryVariables removeObjectForKey:key];
        return value;
    }
    return nil;
}

- (BOOL)persistentObjectForKey:(NSString *)key {
    if (key) {
        id value = [self.temporaryVariables objectForKey:key];
        [self.temporaryVariables removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return NO;
}

- (void)cleanAllTemporaryObjects {
    [self.temporaryVariables removeAllObjects];
}

#pragma mark - Public

+ (BOOL)isUserLogin
{
    return [[[self sharedInstance] _getUserItem].token isNotBlank];
}

/**
 *  用户对象获取
 */
+ (UserModel *)userItem
{
    return [[self sharedInstance] _getUserItem];
}

+ (NSString *)userToken
{
//    return @"cOZ6cjmF9NF";
    return [[self sharedInstance] _getUserItem].token;
}

+ (void)logout
{
    [[self sharedInstance] _logout];
}

+ (void)setUpWithRecord:(NSDictionary *)record
{
    [[self sharedInstance] _setUpWithRecord:record];
}

+ (void)temporaryCacheObject:(id)object forKey:(NSString *)key {
    [[self sharedInstance] temporaryCacheObject:object forKey:key];
}

+ (id)temporaryObjectForKey:(NSString *)key {
    return [[self sharedInstance] temporaryObjectForKey:key];
}

+ (id)removeTemporaryObjectForKey:(NSString *)key {
    return [[self sharedInstance] removeTemporaryObjectForKey:key];
}

+ (BOOL)persistentObjectForKey:(NSString *)key {
    return [[self sharedInstance] persistentObjectForKey:key];
}

+ (void)cleanAllTemporaryObjects {
    [[self sharedInstance] cleanAllTemporaryObjects];
}
@end
