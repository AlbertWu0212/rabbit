//
//  NewMessageCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "NewMessageCell.h"

@implementation NewMessageCell

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
    [_openLab release];
    [_menuSwich release];
    [super dealloc];
}
@end
