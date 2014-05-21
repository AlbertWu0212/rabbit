//
//  RegistClassifyCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-9.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistClassifyCell.h"

@implementation RegistClassifyCell

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
    [_titleImg release];
    [_firstLine release];
    [_secondLine release];
    [_thirdLine release];
    [_fouthLine release];
    [_chooseMenuBackground release];
    [_chooseMenuBtn release];
    [super dealloc];
}
@end
