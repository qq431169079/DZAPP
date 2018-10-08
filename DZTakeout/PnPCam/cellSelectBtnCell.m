//
//  cellSelectBtnCell.m
//  P2PCamera
//
//  Created by yan luke on 13-7-3.
//
//

#import "cellSelectBtnCell.h"

@implementation cellSelectBtnCell

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

- (void) dealloc{
    _btn = nil;

}

@end
