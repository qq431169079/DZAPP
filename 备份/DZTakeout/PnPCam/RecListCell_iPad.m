//
//  RecListCell_iPad.m
//  P2PCamera
//
//  Created by yan luke on 12-12-29.
//
//

#import "RecListCell_iPad.h"

@implementation RecListCell_iPad
@synthesize imageView3,imageView2,imageView1;
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
    imageView1 = nil;
    imageView2 = nil;
    imageView3 = nil;
}
@end
