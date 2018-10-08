//
//  CameraListCell.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraListCell.h"


@implementation CameraListCell

@synthesize imageCamera;
@synthesize NameLable;
@synthesize PPPPIDLable;
@synthesize PPPPStatusLable;
@synthesize button ;
@synthesize warnBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.warnBtn.layer.cornerRadius = 5.0;
    self.warnBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state.
}


- (void)dealloc {
    self.imageCamera = nil;
    self.NameLable = nil;
    self.PPPPIDLable = nil;
    self.PPPPStatusLable = nil;
    self.warnBtn = nil;
    [super dealloc];
}


@end
