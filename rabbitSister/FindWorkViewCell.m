//
//  FindWorkViewCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "FindWorkViewCell.h"

@implementation FindWorkViewCell

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
    [_photoImg release];
    [_photoTitle release];
    [_locationLab release];
    [_timeLab release];
    [_timeImg release];
    [super dealloc];
}
@end
