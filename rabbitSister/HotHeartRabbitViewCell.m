//
//  HotHeartRabbitViewCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HotHeartRabbitViewCell.h"

@implementation HotHeartRabbitViewCell

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
    [_certificateImg release];
    [_titleLab release];
    [_contentLab release];
    [_listView release];
    [_chooseView release];
    [_chooseFirstBtn release];
    [_chooseSecondBtn release];
    [_chooseFirstLab release];
    [_chooseSecondLab release];
    [_chooseFirstView release];
    [_incidentallyMainBtn release];
    [_incidentally1 release];
    [_incidentally2 release];
    [_incidentally3 release];
    [_incidentally4 release];
    [_incidentally5 release];
    [_incidentally6 release];
    [_carMainBtn release];
    [_car1 release];
    [_car2 release];
    [_car3 release];
    [_car4 release];
    [_car5 release];
    [_car6 release];
    [_car7 release];
    [_car8 release];
    [_firstLab1 release];
    [_firstLab2 release];
    [_firstLab3 release];
    [_firstLab4 release];
    [_firstLab5 release];
    [_firstLab6 release];
    [_chooseLab1 release];
    [_chooseLab2 release];
    [_chooselab3 release];
    [_chooseLab4 release];
    [_chooseLab5 release];
    [_chooseLab6 release];
    [_chooseLab7 release];
    [_chooseLab8 release];
    [_addImgBtn release];
    [_getInformField release];
    [super dealloc];
}
@end
