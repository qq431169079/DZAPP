//
//  PicListCell_iPad.m
//  P2PCamera
//
//  Created by yan luke on 12-12-27.
//
//

#import "PicListCell_iPad.h"

@implementation PicListCell_iPad
@synthesize imageView1,imageView2,imageView3,imageView4;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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

-(void)dealloc
{
    [super dealloc];
    _dateLabel1 = nil;
    _dateLabel2 = nil;
    _dateLabel3 = nil;
    _dateLabel4 = nil;
    imageView1 = nil;
    imageView2 = nil;
    imageView3 = nil;
    imageView4 = nil;
}
@end
