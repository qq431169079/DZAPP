//
//  HPFileManager.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPFileManager.h"
#import "HPMacro.h"

@implementation HPFileManager

#pragma mark - 通用操作
+ (BOOL) createFileAtPath : (NSString *) rootPath data : (NSData *) data {
    if ([HPFileManager deleteFileAtPath:rootPath]) {
        if ( ![[NSFileManager defaultManager] createFileAtPath:rootPath contents:data attributes:nil] ) {
            HPLog("HPFileManager : Create File Error Path = %s\n", rootPath.UTF8String);
            return NO;
        }
    }
    return YES;;
}

+ (BOOL) deleteFileAtPath : (NSString *) rootPath {
    if ([HPFileManager isFileExistsAtPath:rootPath]) {
        NSError * error = nil;
        if ( ![[NSFileManager defaultManager] removeItemAtPath:rootPath error:&error] ) {
            HPLog("\nLEFileManager : Remove File Error : %s Path = %s\n", error.localizedDescription.UTF8String, rootPath.UTF8String);
            return NO;
        }
    }
    return YES;
}

+ (BOOL) isFileExistsAtPath : (NSString *) rootPath {
    return [[NSFileManager defaultManager] fileExistsAtPath:rootPath];
}

+ (BOOL) isDirectoryExistsAtPath : (NSString *) rootPath {
    BOOL isDirectory = NO;
    if ( [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDirectory] ) {
        return isDirectory;
    }
    return NO;
}

+ (BOOL) createFileAtDirectoryPath : (NSString *) rootDirectoryPath fileName : (NSString *) fileName {
    if ( rootDirectoryPath && rootDirectoryPath.length > 0 ) {
        NSError * error = nil;
        if (![HPFileManager isDirectoryExistsAtPath:rootDirectoryPath]) {
            if ( ![[NSFileManager defaultManager] createDirectoryAtPath:rootDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error] ) {
                HPLog("\n LEFileManager : createDirectory Error : %s path = %s \n",error.localizedDescription.UTF8String, rootDirectoryPath.UTF8String);
                return NO;
            }
        }
        if (fileName && fileName.length > 0 ) {
            rootDirectoryPath = [rootDirectoryPath stringByAppendingPathComponent:fileName];
            if ([HPFileManager deleteFileAtPath:rootDirectoryPath] && ![[NSFileManager defaultManager] createDirectoryAtPath:rootDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error] ) {
                HPLog("\n LEFileManager : createFile Error : %s path = %s \n",error.localizedDescription.UTF8String, rootDirectoryPath.UTF8String);
                return NO;
            }
        }
    }
    return YES;
}

/**
 *  文件大小｜单位M
 */
+ (double) sizeAtPath : (NSString *) floderOrFilePath {
    if ([HPFileManager isDirectoryExistsAtPath:floderOrFilePath]) {
        NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:floderOrFilePath] objectEnumerator];
        NSString * fileName;
        long long floderSize = 0;
        while ( (fileName = [childFilesEnumerator nextObject]) != nil ) {
            NSString* fileAbsolutePath = [floderOrFilePath stringByAppendingPathComponent:fileName];
            floderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return (double)floderSize / 1024.0f / 1024.0f;
    }
    return [self fileSizeAtPath:floderOrFilePath];
}

+ (long long) fileSizeAtPath : (NSString *) filePath {
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - Documents
+ (BOOL) createFileInDocumentsWithFileName : (NSString *) fileName data : (NSData *) data {
    NSString * path = [[HPFileManager documentsPath] stringByAppendingPathComponent:fileName];
    if ([HPFileManager deleteFileAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        return YES;
    }
    return NO;
}

+ (NSString *) createFileInDocumentsWithFileName : (NSString *) fileName {
    NSString * path = [[HPFileManager documentsPath] stringByAppendingPathComponent:fileName];
    if ([HPFileManager deleteFileAtPath:path] && [HPFileManager createFileAtPath:path data:nil]) {
        return path;
    }
    return nil;
}

+ (NSString *) filePathInDocumentsWithFileName : (NSString *) fileName {
    return [[HPFileManager documentsPath] stringByAppendingPathComponent:fileName];
}

+ (BOOL) isFileExistsInDocuments : (NSString *) fileRootName {
    NSString * filePath = [[HPFileManager documentsPath] stringByAppendingPathComponent:fileRootName];
    return [HPFileManager isFileExistsAtPath:filePath];
}

+ (BOOL) deleteFileInDocumentsWithFileName : (NSString *) fileName {
    NSString * filePath = [[HPFileManager documentsPath] stringByAppendingPathComponent:fileName];
    return [HPFileManager deleteFileAtPath:filePath];
}

+ (NSString *) documentsPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

#pragma mark - Caches
+ (BOOL) createFileInCachesWithFileName : (NSString *) fileName data : (NSData *) data {
    NSString * path = [[HPFileManager cachesPath] stringByAppendingPathComponent:fileName];
    if ([HPFileManager deleteFileAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        return YES;
    }
    return NO;
}

+ (NSString *) createFileInCachesWithFileName : (NSString *) fileName {
    NSString * path = [[HPFileManager cachesPath] stringByAppendingPathComponent:fileName];
    if ([HPFileManager deleteFileAtPath:path] && [HPFileManager createFileAtPath:path data:nil] ) {
        return path;
    }
    return nil;
}

+ (NSString *) filePathInCachesWithFileName : (NSString *) fileName {
    return [[HPFileManager cachesPath] stringByAppendingPathComponent:fileName];
}

+ (BOOL) isFileExistsInCaches : (NSString *) fileRootName {
    NSString * filePath = [[HPFileManager cachesPath] stringByAppendingPathComponent:fileRootName];
    return [HPFileManager isFileExistsAtPath:filePath];
}

+ (BOOL) deleteFileInCachesWithFileName : (NSString *) fileRootName {
    NSString * filePath = [[HPFileManager cachesPath] stringByAppendingPathComponent:fileRootName];
    return [HPFileManager deleteFileAtPath:filePath];
}

+ (NSString *) cachesPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
}

#pragma mark - Tmp
+ (NSString *) tmpPath {
    return NSTemporaryDirectory();
}

+ (BOOL) createFileInTmpWithFileName : (NSString *) fileName data : (NSData *) data {
    NSString * path = [[HPFileManager tmpPath] stringByAppendingPathComponent:fileName];
    if ( [HPFileManager deleteFileAtPath:path] ) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        return YES;
    }
    return NO;
}

+ (NSString *) createFileInTmpWithFileName : (NSString *) fileName {
    NSString * path = [[HPFileManager tmpPath] stringByAppendingPathComponent:fileName];
    if ([HPFileManager deleteFileAtPath:path] && [HPFileManager createFileAtPath:path data:nil] ) {
        return path;
    }
    return nil;
}

+ (NSString *) filePathInTmpWithFileName : (NSString *) fileName {
    return [[HPFileManager tmpPath] stringByAppendingPathComponent:fileName];
}

+ (BOOL) isFileExistsInTmp : (NSString *) fileRootName {
    NSString * filePath = [[HPFileManager tmpPath] stringByAppendingPathComponent:fileRootName];
    return [HPFileManager isFileExistsAtPath:filePath];
}

+ (BOOL) deleteFileInTmpWithFileName : (NSString *) fileRootName {
    NSString * filePath = [[HPFileManager tmpPath] stringByAppendingPathComponent:fileRootName];
    return [HPFileManager deleteFileAtPath:filePath];
}

@end
