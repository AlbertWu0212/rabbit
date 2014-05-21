//
//  RunnerRabbitCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RunnerRabbitCell.h"

@implementation RunnerRabbitCell

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
    [_titleLab release];
    [_contentLab release];
    [_chooseBtn release];
    [super dealloc];
}
@end
