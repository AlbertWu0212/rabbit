//
//  RabbitPersonalCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-12.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitPersonalCell.h"

@implementation RabbitPersonalCell

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
    [_personalHeadImg release];
    [_personalName release];
    [_personalLocal release];
    [_iconImg release];
    [_previousLogo release];
    [_functionLab release];
    [_backgroundImg release];
    [super dealloc];
}
@end
