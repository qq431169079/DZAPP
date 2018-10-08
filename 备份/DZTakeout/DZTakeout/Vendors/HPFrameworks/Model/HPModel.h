//
//  HPModel.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface HPModel : NSObject<YYModel>

/**
 *  依据数组初始化一个实例数组
 */
+ (NSArray *)modelsWithArray:(id)json;

/**
 *  依据字典初始化一个实例
 */
+ (instancetype)modelDictionary:(NSDictionary *)dictionary;

/**
 *  依据JSON对象初始化一个实例
 */
+ (instancetype)modelWithJSON:(id)json;

@end




@interface HPModel (Archive)

/**
 *  绝对地址归档|将覆盖之前的文件
 *
 *  @param filePath 绝对文件路径
 *
 *  @return 是否执行成功
 */
- (BOOL) saveToFile:(NSString *)filePath;
/**
 *  Document路径下相对地址路径归档
 *
 *  @param fileName 文件名｜可以带文件路径
 *
 *  @return 是否执行成功
 */
- (BOOL)saveToDocumentWithFileName:(NSString *)fileName;
/**
 *  Caches路径下相对地址路径归档
 *
 *  @param fileName 文件名｜可以带文件路径
 *
 *  @return 是否执行成功
 */
- (BOOL)saveToCachesWithFileName:(NSString *)fileName;
/**
 *  Tmp路径下相对地址路径归档
 *
 *  @param fileName 文件名｜可以带文件路径
 *
 *  @return 是否执行成功
 */
- (BOOL)saveToTmpWithFileName:(NSString *)fileName;

/**
 *  绝对地址解码
 *
 *  @param filePath 绝对文件路径
 *
 *  @return 对象｜nil
 */
+ (id)loadFromFile:(NSString *)filePath;
/**
 *  Documents路径下相对地址解码
 *
 *  @param fileName 绝对文件路径
 *
 *  @return 对象｜nil
 */
+ (id)loadFromDocumentWithFileName:(NSString *)fileName;
/**
 *  Caches路径下相对地址解码
 *
 *  @param fileName 绝对文件路径
 *
 *  @return 对象｜nil
 */
+ (id)loadFromCachesWithFileName:(NSString *)fileName;
/**
 *  Tmp路径下相对地址解码
 *
 *  @param fileName 绝对文件路径
 *
 *  @return 对象｜nil
 */
+ (id)loadFromTmpWithFileName:(NSString *)fileName;

@end
