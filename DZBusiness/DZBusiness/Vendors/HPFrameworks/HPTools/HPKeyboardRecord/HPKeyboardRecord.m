//
//  HPKeyboardRecord.m
//  MyPractice
//
//  Created by huangpan on 16/7/15.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import "HPKeyboardRecord.h"

CGFloat const kDefaultMarginWithKeyboard = 10;

NSString *const kHPkeyboardChangedStatusNotification = @"kHPkeyboardChangedStatusNotification";

@interface HPKeyboardRecord ()
@property (nonatomic, assign, readwrite) BOOL keyboardVisiable;
@end
@implementation HPKeyboardRecord
#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setUp];
    }
    return self;
}

+ (instancetype)shareInstance {
    static HPKeyboardRecord *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)enableNofitication {
    [self shareInstance];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Public
- (void)_keyboardChangedStatus {
    // 直接调用block
    if ( self.keyboardChangedStatus ) {
        self.keyboardChangedStatus(_keyboardVisiable, _keyboardRect);
    }
    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kHPkeyboardChangedStatusNotification object:nil];
}

#pragma mark - Event Handle
- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardVisiable = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardRect = CGRectZero;
    self.keyboardVisiable = NO;
}

#pragma mark - Setter
- (void)setKeyboardVisiable:(BOOL)keyboardVisiable {
    if ( _keyboardVisiable != keyboardVisiable ) {
        _keyboardVisiable = keyboardVisiable;
        [self _keyboardChangedStatus];
    }
}
@end
