//
//  MatterViewCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-15.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MatterViewCell.h"

@implementation MatterViewCell

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
    [_titleImg release];
    [_titleLab release];
    [_localLab release];
    [_priceLab release];
    [_timeImg release];
    [_timeLab release];
    [_deleteLab release];
    [_photoBtn release];
    [_speakBtn release];
    [_phoneBtn release];
    [_middleLineImg release];
    [_downLineImg release];
    [_backgroundImg release];
    [_dianImg release];
    [_doingBtn release];
    [_deleteImg release];
    [super dealloc];
}
@end
