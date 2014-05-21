//
//  DriverRabbitCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "DriverRabbitCell.h"

@implementation DriverRabbitCell

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
    [_driverTopView release];
    [_driverMiddleView release];
    [_driverOtherView release];
    [_driverTopWholeBtn release];
    [_driverTopFirstBtn release];
    [_driverTopSecondBtn release];
    [_driverTopThirdBtn release];
    [_driverTopFouthBtn release];
    [_driverTopTitleLab release];
    [_driverTopFirstLab release];
    [_driverTopSecondLab release];
    [_driverTopThirdLab release];
    [_driverTopFouthLab release];
    [_driverTopLastLab release];
    [_driverMiddleTitleBtn release];
    [_driverMiddleFirstBtn release];
    [_driverMiddleSecondBtn release];
    [_driverMiddleThirdBtn release];
    [_driverMiddleTitleLab release];
    [_driverMiddleFirstLab release];
    [_driverMiddleFirstDownLab release];
    [_driverMiddleSectondLab release];
    [_driverMiddleSecondDownLab release];
    [_driverMiddleThirdLab release];
    [_driverMiddleThirdDownLab release];
    [_driverOtherTitleLab release];
    [_driverOtherContentLab release];
    [_driverOtherProfileImg release];
    [_addImgBtn release];
    [_getInformField release];
    [_mustImg release];
    [_tileLabel release];
    [super dealloc];
}
@end
