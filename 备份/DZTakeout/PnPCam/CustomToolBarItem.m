//
//  CustomToolBarItem.m
//  CustomToolBar
//
//  Created by yan luke on 13-6-14.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import "CustomToolBarItem.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomToolBarItem

- (id)initwithItemId:(int) itemId andTitle:(NSString* )title andDelegate:(id) delegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(-1.f, 0.f, 2.f, 0.f)];
        self.separatorLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        self.separatorLine.image = [UIImage imageNamed:@"line_up"];
        
        self.itemBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.itemBtn.frame = CGRectZero;
        self.itemBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.itemBtn setTitle:title forState:UIControlStateNormal];
        self.itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.itemBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.itemBtn.backgroundColor = [UIColor clearColor];
        self.itemBtn.showsTouchWhenHighlighted = YES;
        [self.itemBtn addTarget:self action:@selector(responseTouchItem:) forControlEvents:UIControlEventTouchUpInside];
        _itemId = itemId;
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_08.jpg"]];
       
        self.bottomseparatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, -1.f, 0.f, 2.f)];
        self.bottomseparatorLine.image = [UIImage imageNamed:@"line"];
        self.bottomseparatorLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
        
        self.delegate = delegate;
        
        [self addSubview:self.itemBtn];
        [self addSubview:self.separatorLine];
        [self addSubview:self.bottomseparatorLine];
        
        
    }
    return self;
}

- (void) responseTouchItem:(id) sender{
    if (self.delegate != nil) {
        [self.delegate TouchToItem:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) dealloc{
    [super dealloc];
    [_separatorLine release],_separatorLine = nil;
    [_itemBtn release],_itemBtn = nil;
    [_bottomseparatorLine release],_bottomseparatorLine = nil;
}
@end
