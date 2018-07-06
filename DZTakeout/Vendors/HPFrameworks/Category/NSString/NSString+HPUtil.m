//
//  NSString+HPUtil.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "NSString+HPUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSArray+HPUtil.h"

static NSString *const UNDERSCORE = @"_";
static NSString *const SPACE = @" ";
static NSString *const EMPTY_STRING = @"";

@implementation NSString (HPUtil)
- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font {
    if (self.length > 0) {
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName : font}
                                  context:nil].size;
    } else {
        return CGSizeZero;
    }
}

- (BOOL)isValid {
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

- (NSString *)removeWhiteSpacesFromString {
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

- (NSArray *)split {
    NSArray *result = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [result select:^BOOL(NSString *string) {
        return string.length > 0;
    }];
}

- (NSArray *)split:(NSString *)delimiter {
    return [self componentsSeparatedByString:delimiter];
}

- (NSString *)camelCase {
    NSString *spaced = [self stringByReplacingOccurrencesOfString:UNDERSCORE withString:SPACE];
    NSString *capitalized = [spaced capitalizedString];
    return [capitalized stringByReplacingOccurrencesOfString:SPACE withString:EMPTY_STRING];
}

- (BOOL)containsString:(NSString *) string {
    NSRange range = [self rangeOfString:string options:NSCaseInsensitiveSearch];
    return range.location != NSNotFound;
}

- (NSString *)strip {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) md5 {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG)[self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

- (BOOL) isBlank {
    if ( !self || self.length == 0 ) {
        return YES;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

- (nullable NSString *)matchExternalAppId {
    if ( [self isValid] ) {
        NSString *pattern = @"id\\d{5,}";
        NSString *resultString = [self matchWithPattern:pattern];
        if ( resultString &&  resultString.length > 2 ) {
            // 过滤字符串“id”
            return [resultString substringWithRange:NSMakeRange(2, resultString.length - 2)];
        }
    }
    return nil;
}

- (nullable NSString *)matchWithPattern:( NSString * _Nonnull)pattern {
    if ( [self isValid ] && [pattern isValid] ) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if ( error ) { return nil; }
        NSRange resultRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        BOOL _overRange = ((resultRange.location + resultRange.length) > self.length);
        if ( !NSEqualRanges(NSMakeRange(0, 0), resultRange) && !_overRange ) {
            return [self substringWithRange:resultRange];
        }
    }
    return nil;
}

- (BOOL)isOpenExternalAppRequire {
    return ( [self containsString:@"https://itunes.apple.com"] && [self matchExternalAppId] );
}

- (NSString *)replacingString:(NSString *)target with:(NSString *)replacment {
    if ( [self containsString:target] ) {
        return [self stringByReplacingOccurrencesOfString:target withString:replacment];
    } else {
        return [self stringByAppendingString:replacment];
    }
}

- (NSString *)stringValue {
    return self;
}

// Counts number of Words in String
- (NSUInteger)countNumberOfWords {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
        count++;
    }
    
    return count;
}

// If my string starts with given string
- (BOOL)isBeginsWith:(NSString *)string {
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string
- (BOOL)isEndssWith:(NSString *)string {
    return ([self hasSuffix:string]) ? YES : NO;
}

// Get Substring from particular location to given lenght
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end
{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

// Add substring to main String
- (NSString *)addString:(NSString *)string {
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string
-(NSString *)removeSubString:(NSString *)subString {
    if ([self containsString:subString]) {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

// If my string contains ony letters
- (BOOL)containsOnlyLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers {
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters {
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// If my string is available in particular array
- (BOOL)isInThisArray:(NSArray*)array {
    for(NSString *string in array) {
        if([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

// Get String from array
+ (NSString *)getStringFromArray:(NSArray *)array {
    return [array componentsJoinedByString:@" "];
}

// Convert Array from my String
- (NSArray *)getArray {
    return [self componentsSeparatedByString:@" "];
}

// Get My Application Version number
+ (NSString *)getMyApplicationVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}

// Get My Application name
+ (NSString *)getMyApplicationName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}

// Convert string to NSData
- (NSData *)convertToData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData
+ (NSString *)getStringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
    
}

// Is Valid Email
- (BOOL)isValidEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

// Is Valid Phone
- (BOOL)isValidPhoneNumber {
    NSString *regex = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

// Is Valid URL
- (BOOL)isValidUrl {
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

@end

NSString *NSStringWithFormat(NSString *formatString, ...) {
    va_list args;
    va_start(args, formatString);
    NSString *string = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
#if defined(__has_feature) && __has_feature(objc_arc)
    return string;
#else
    return [string autorelease];
#endif
}

UIKIT_EXTERN CGFloat HPTextWidth(NSString * text, UIFont * font) {
    return ceil([text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0.0f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size.width);
}
