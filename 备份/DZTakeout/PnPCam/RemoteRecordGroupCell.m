//
//  RemoteRecordGroupCell.m
//  P2PCamera
//
//  Created by yan luke on 13-1-24.
//
//

#import "RemoteRecordGroupCell.h"

@implementation RemoteRecordGroupCell

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
- (void)dealloc{
    _dateLabel = nil;
    _iconImg = nil;
    [super dealloc];
}
@end
