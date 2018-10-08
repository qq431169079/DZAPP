//
//  CustomToolBar.m
//  CustomToolBar
//
//  Created by yan luke on 13-6-14.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import "CustomToolBar.h"
#import <QuartzCore/QuartzCore.h>
@interface CustomToolBar ()
@property (nonatomic) int showNumberOfItems;
@property (nonatomic) float itemWidth;
@property (nonatomic) CGRect aFrame;
@end

@implementation CustomToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initFrom:(UIView* ) parentView andRowItems:(int ) rowItems  andItems:(NSArray* ) items andRowHeight:(float) rowHeight andWidth:(float) width{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up"]];
        self.toolBarBg = [[UIView alloc] initWithFrame:CGRectZero];
        //self.backgroundColor = [UIColor redColor];
        [self addSubview:self.arrowIv];
        [self addSubview:self.toolBarBg];
        
        self.showNumberOfItems = 0;
        self.rowItems = rowItems;
        self.items = items;
        self.parentView = parentView;
        self.rowHeight = rowHeight;
        self.width = width;
        self.itemWidth = (float)self.width/(float)self.rowItems;
        [self computeViewFrame];
        [self layoutItems];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = YES;
        self.arrowIv.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        self.toolBarBg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}
- (void) computeViewFrame{
    CGRect parentFrame = self.parentView.frame;
    CGPoint parentCenter = self.parentView.center;
    self.arrowIv.frame = CGRectMake(parentCenter.x - 10.f, -6.f, 20.f , 20.f);
    int itemsCount = [self.items count];
    int rows = (itemsCount % self.rowItems) ? (itemsCount / self.rowItems + 1) : (itemsCount / self.rowItems);
    
    self.toolBarBg.frame = CGRectMake(0.f, self.arrowIv.frame.origin.y + self.arrowIv.frame.size.height - 6, self.width, rows * self.rowHeight);
    self.toolBarBg.layer.cornerRadius = 5.f;
    self.toolBarBg.layer.masksToBounds = YES;
    self.frame = CGRectMake(0.f, parentFrame.origin.y + parentFrame.size.height, self.width, self.arrowIv.frame.size.height + self.toolBarBg.frame.size.height);
    _show = YES;
    self.alpha = 0.f;
}

- (void) layoutItems{
    for (id item in self.items){
        if ([item isKindOfClass:[CustomToolBarItem class]]) {
            CustomToolBarItem* itm = (CustomToolBarItem*) item;
            itm.frame = CGRectMake((self.showNumberOfItems%self.rowItems) * self.itemWidth, (self.showNumberOfItems/self.rowItems) * self.rowHeight, self.itemWidth, self.rowHeight);
            [self.toolBarBg addSubview:itm];
            self.showNumberOfItems++;
        }
    }
}

- (void) showToolBar{
    [UIView animateWithDuration:0.1f animations:^{
        self.alpha = 1.f;
        _show = NO;
    }];
}
- (void) dismissToolBar{
    [UIView animateWithDuration:0.1f animations:^{
        self.alpha = 0.f;
        _show = YES;
    }];
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
    [_arrowIv release],_arrowIv = nil;
    [_toolBarBg release],_toolBarBg = nil;
}
@end
