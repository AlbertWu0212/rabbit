//
//  RegistViewCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistViewCell.h"

@implementation RegistViewCell

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
    [_menuLab release];
    [_logoImg release];
    [_menuTextField release];
    [_telephoneBtn release];
    [_chooseNanBtn release];
    [_chooseNvBtn release];
    [_nanLab release];
    [_nvLab release];
    [_textFieldBackground release];
    [_mustImg release];
    [_imgAddBtn release];
    [_cityLab release];
    [_MainIdCardImg release];
    [_asteriskLab release];
    [super dealloc];
}
@end
