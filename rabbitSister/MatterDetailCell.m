//
//  MatterDetailCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MatterDetailCell.h"

@implementation MatterDetailCell

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

- (void)dealloc {
    [_backgroundImg release];
    [_titleLab release];
    [_contentLab release];
    [_contentImg release];
    [_bigImgBtn release];
    [_soundBtn release];
    [_priceInfoView release];
    [_priceInfoLab release];
    [_topLine release];
    [_downLine release];
    [super dealloc];
}
@end
