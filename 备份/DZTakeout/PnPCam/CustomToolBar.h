//
//  CustomToolBar.h
//  CustomToolBar
//
//  Created by yan luke on 13-6-14.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBarItem.h"

@interface CustomToolBar : UIView
@property (nonatomic, retain) UIImageView* arrowIv;
@property (nonatomic, retain) UIView* toolBarBg;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic) int rowItems;
@property (nonatomic) float rowHeight;
@property (nonatomic) float width;
@property (nonatomic, retain) UIView* parentView;
@property (nonatomic) BOOL show;
- (id) initFrom:(UIView* ) parentView andRowItems:(int ) rowItems  andItems:(NSArray* ) items andRowHeight:(float) rowHeight andWidth:(float) width;
- (void) computeViewFrame;
- (void) layoutItems;
- (void) showToolBar;
- (void) dismissToolBar;
@end
