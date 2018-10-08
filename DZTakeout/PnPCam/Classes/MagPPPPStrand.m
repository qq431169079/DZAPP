#include "MagPPPPStrand.h"

const char* g_szEyeP2PStrand_URL = "https://authentication.eye4.cn/getInitstring";
const char* g_SeverPPPPName = "PPPPStrand_xxx_Ricky";

static MagPPPPStrand *gMagPPPPStrand = nil;
@interface MagPPPPStrand()
{
    MagPPPPStrand *gMagPPPPStrand;
    NSMutableDictionary*   m_dicPPPStrandKey;
    NSMutableDictionary*   m_dicPPPStrand;
    NSTimer*               m_timer;
    NSRecursiveLock*       m_Lock;
    NSTimeInterval         m_lastTime;
    BOOL                   m_IsSynchronize;
    NSTimeInterval         m_lastSynchronizeTime;
}
@end

@implementation MagPPPPStrand
- (id) init{
    self = [super init];
    if (self) {
        m_timer = nil;
        //m_Lock = [[NSRecursiveLock alloc] init];
        [self initReadFile];
        m_dicPPPStrandKey = [[NSMutableDictionary alloc] init];
        m_IsSynchronize = NO;
    }
    return self;
}

+(id)sharedInstance
{
    @synchronized(self)
    {
        if (gMagPPPPStrand == nil){
            gMagPPPPStrand = [[super alloc] init];
        }
    }
    return gMagPPPPStrand;
}


#pragma mark - 获取P2P初始化串
- (void)getP2PInitializeStrServer:(NSArray *)uidArray ResultBlockSuccess:(void (^)(NSArray *result))success Failure:(void (^)(NSError* error ,NSInteger statusCode ,NSString *resultMessage))failure {
    NSDictionary *param = @{@"uid":uidArray};
    NSString *path = [NSString stringWithUTF8String:g_szEyeP2PStrand_URL];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 3、配置Request
    // 设置请求超时
    [request setTimeoutInterval:3.0];
    // 设置请求方法
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //parameters
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:NULL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 7、创建网络会话     
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    // 8、创建会话任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 10、判断是否请求成功
        if (error){
            failure(error,0,error.localizedDescription);
        }
        else{
            // 如果请求成功，则解析数据。
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            // 11、判断是否解析成功
            if (error) {
                failure(error,-1,error.localizedDescription);
            }else {
                // 解析成功，处理数据
                if ([object isKindOfClass:[NSArray class]]){
                    NSArray *array = [NSArray arrayWithArray:object];
                    success(array);
                }
                else
                   failure(error,-2,error.localizedDescription);
            }
        }
        
        [session finishTasksAndInvalidate];
    }];
    // 9、执行任务
    [task resume];
}

-(void) initReadFile
{
    NSDictionary* dicPPPStrand = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:g_SeverPPPPName]];
    if (dicPPPStrand == nil) {
        m_dicPPPStrand = [[NSMutableDictionary alloc] init];
        NSLog(@"P2PStrand initReadFile nil");
    }
    else{
        m_dicPPPStrand = [[NSMutableDictionary alloc] init];
        NSArray* allKey = [dicPPPStrand allKeys];
        NSArray* allv   = [dicPPPStrand allValues];
        if ([allKey count] == [allv count]) {
            for (int i =0; i < [allKey count]; ++i) {
                NSString* sKey = [allKey objectAtIndex:i];
                NSString* sValue = [allv objectAtIndex:i];
                NSLog(@"P2PStrand initReadFile key:%@ value:%@",sKey,sValue);
                [m_dicPPPStrand setObject:sValue forKey:sKey];
            }
        }
    }
    
    m_timer = [NSTimer timerWithTimeInterval:20 target:self selector:@selector(timerGetp2p:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
    m_lastTime = [[NSDate date] timeIntervalSince1970];
}

-(NSString*) getP2PStrand:(NSString*)strUidPrefix
{
    BOOL bFirstUidPrefix = NO;
    if ([m_dicPPPStrandKey objectForKey:strUidPrefix] == nil) {
        [m_dicPPPStrandKey setObject:@"1" forKey:strUidPrefix];
        bFirstUidPrefix = YES;
    }
    
    NSLog(@"getP2PStrand beg");
    if (m_dicPPPStrand) {
        //内存中取
        NSString* strValue = [m_dicPPPStrand objectForKey:strUidPrefix];
        if (strValue == nil) {
            if (bFirstUidPrefix) {
                NSArray* uidArray = [NSArray arrayWithObject:strUidPrefix];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self getP2PInitializeStrServer:uidArray ResultBlockSuccess:^(NSArray *result) {
                        NSLog(@"getP2PStrand server UID:%@ ret:%@",strUidPrefix,result);
                        NSMutableArray* retArray = [[NSMutableArray alloc] init];
                        [retArray addObjectsFromArray:result];
                        NSLog(@"getP2PStrand server UID:%@ 1",strUidPrefix);
                        if ([retArray count] == 1) {
                            [[MagPPPPStrand sharedInstance] addUIDFromDic:[retArray objectAtIndex:0] UID:strUidPrefix];
                        }
                        NSLog(@"getP2PStrand server UID:%@ 2",strUidPrefix);
                        result = nil;
                        retArray =nil;
                        NSLog(@"getP2PStrand server UID:%@ 3",strUidPrefix);
                        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
                         NSLog(@"getP2PStrand server UID:%@ 4",strUidPrefix);
                        if (nowtime - m_lastTime > 60) {
                            m_lastTime = nowtime;
                            [self P2PStrandSynchronize];
                             NSLog(@"getP2PStrand server UID:%@ 5",strUidPrefix);
                        }
                        else{
                            m_IsSynchronize = YES;
                        }
                        NSLog(@"getP2PStrand server ret end");
                    } Failure:^(NSError *error, NSInteger statusCode, NSString *resultMessage) {
                        NSLog(@"getP2PStrand server error UID:%@ ret:%d",strUidPrefix,statusCode);
                        //[m_Lock lock];
                        [m_dicPPPStrandKey removeObjectForKey:strUidPrefix];
                        //[m_Lock unlock];
                    }];
                });
            }
                               
            NSLog(@"getP2PStrand end1");
            return nil;
        }
        else{
            NSLog(@"getP2PStrand Memory UID:%@ ret:%@",strUidPrefix,strValue);
            NSLog(@"getP2PStrand end2");
            if (m_IsSynchronize) {
                NSTimeInterval nowtime  = [[NSDate date] timeIntervalSince1970];
                if (nowtime - m_lastSynchronizeTime > 60) {
                    [self P2PStrandSynchronize];
                }
            }
            return strValue;
        }
    }

    NSLog(@"getP2PStrand end3");
    return nil;
}

- (void)timerGetp2p:(NSTimer *)timer
{
    //[m_Lock lock];
    [timer invalidate];
    timer = nil;
    NSArray* arrayKey = [m_dicPPPStrandKey allKeys];
    //[m_Lock unlock];
    if (arrayKey == nil || [arrayKey count] == 0) {
        NSLog(@"MagPPPPStrand timerGetp2p error");
        return ;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self getP2PInitializeStrServer:arrayKey ResultBlockSuccess:^(NSArray *result) {
            NSLog(@"timerGetp2p:%@",result);
            NSMutableArray* retArray = [[NSMutableArray alloc] init];
            [retArray addObjectsFromArray:result];
            if ([arrayKey count] == [retArray count]) {
                [[MagPPPPStrand sharedInstance] addUIDsFromDic:retArray UID:arrayKey];
            }
            retArray = nil;
            result = nil;
        } Failure:^(NSError *error, NSInteger statusCode, NSString *resultMessage) {
            [self P2PStrandSynchronize];
        }];
    });
}

-(void) addUIDFromDic:(NSString*) strPPPP UID:(NSString*) strUID
{
    //[m_Lock lock];
    [m_dicPPPStrand setObject:strPPPP forKey:strUID];
    //[m_Lock unlock];
}

-(void) addUIDsFromDic:(NSArray*) strPPPP UID:(NSArray*) strUID
{
    //[m_Lock lock];
    for (int i =0; i < [strPPPP count]; ++i) {
        NSString* sKey = [strUID objectAtIndex:i];
        NSString* sValue = [strPPPP objectAtIndex:i];
        NSLog(@"getP2PStrand timerGetp2p UID:%@ ret:%@",sKey,sValue);
        [m_dicPPPStrand setObject:sValue forKey:sKey];
    }
    
    [self P2PStrandSynchronize];
    //[m_Lock unlock];
}

-(void) P2PStrandSynchronize
{
    if ([m_dicPPPStrand count] > 0) {
        NSLog(@"getP2PStrand P2PStrandSynchronize");
        m_lastSynchronizeTime = [[NSDate date] timeIntervalSince1970];
        m_IsSynchronize = NO;
        [[NSUserDefaults standardUserDefaults] setObject:m_dicPPPStrand forKey:[NSString stringWithUTF8String:g_SeverPPPPName]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end

