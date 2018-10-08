//
//  PicListCell.m
//  P2PCamera
//
//  Created by mac on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PicListCell.h"

@implementation PicListCell

@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        self = [super init];
//    }

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
            }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc
{
    self.imageView1 = nil;
    self.imageView2 = nil;
    self.imageView3 = nil;
    self.imageView4 = nil;
    self.dateLabel1 = nil;
    self.dateLabel2 = nil;
    self.dateLabel3 = nil;
    self.dateLabel4 = nil;

}

@end
