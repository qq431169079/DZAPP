//
//  HPUtil.m
//  MyPractice
//
//  Created by huangpan on 16/7/8.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPTool.h"
#import "NSString+HPUtil.h"
#import "NSString+BlockHelper.h"

@implementation HPTool
/**
 *  计算文字的长度
 */
CGFloat HPCalculateTextWidth(NSString *text, UIFont *font) {
    if (!font || [text isBlank]) return 0.0f;
    return ceil([text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0.0f) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width);
}

CGSize  HPCalculateTextSize(NSString *text, CGFloat maxLayoutWidth, UIFont *font) {
    if ([text isNotBlank]) {
        return [text sizeWithMaxWidth:maxLayoutWidth font:font];
    } else {
        return CGSizeZero;
    }
}

BOOL HPCheckValue(NSString *value, HPCheckType type) {
    value = value ? [value replacingString:@" " with:@""] : nil;
    if (  !value || [value isBlank] ) { return NO; }
    switch ( type ) {
        case HPCheckTypeQQAccount: {
            return value.isMatch(@"[1-9][0-9]{4,11}");
        } break;
        case HPCheckTypeAlipayAccount:{
            return ([value isValidEmail] || [value isValidPhoneNumber] || value.length <= 30);
        } break;
        case HPCheckTypePhoneNumber: {
            return [value isValidPhoneNumber];
        } break;
        case HPCheckTypeTenPayAccount: {
            return ([value isValidEmail] || [value isValidPhoneNumber] || value.isMatch(@"[1-9][0-9]{4,11}") || value.length <= 30);
        } break;
        case HPCheckTypeEmailAccount: {
            return [value isValidEmail];
        } break;
        case HPCheckTypeUserName: {
            return value.isMatch(@"^[\u4E00-\u9FA5]{2,13}$");
        } break;
        case HPCheckTypeNoCheck: {
            return YES;
        } break;
        default:
            break;
    }
    return NO;
}

NSString *HPConvertTimeToString(NSTimeInterval timeInterval, NSString*formatter) {
    NSDateFormatter* _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:formatter ? : @"yyyy-MM-dd HH:MM:ss"];
    return [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

NSString *HPGetAppVersionInBundle(void) {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

NSString *HPGetBundelIDInBundle(void) {
    return [[NSBundle mainBundle] bundleIdentifier];
}

NSString *HPGetDisplayNameInBundle(void) {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    return infoPlist[@"CFBundleDisplayName"];
}

UIImage *HPGetAppIconInBundle(void) {
    static dispatch_once_t onceToken;
    static UIImage *appIcon = nil;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        if ([icon isValid]) {
            @try {
                appIcon = [UIImage imageNamed:icon];
            }
            @catch (NSException *e) {
                
            }
        }
        
    });
    return appIcon;
}

@end
