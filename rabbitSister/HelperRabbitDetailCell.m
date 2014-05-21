//
//  HelperRabbitDetailCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HelperRabbitDetailCell.h"

@implementation HelperRabbitDetailCell

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
    [_chooseView release];
    [_titleView release];
    [_chooseFirstLab release];
    [_chooseSecondLab release];
    [_chooseThirdLab release];
    [_chooseFouthLab release];
    [_chooseFifthLab release];
    [_chooseSixLab release];
    [_chooseSixBtn release];
    [_titleLab release];
    [_chooseTitleLab release];
    [_firstBtn release];
    [_secondBtn release];
    [_thirdBtn release];
    [_fouthBtn release];
    [_fifthBtn release];
    [_sixBtn release];
    [_addImgBtn release];
    [_uploadImg release];
    [_bgImg release];
    [_writeInTextView release];
    [_mustImg release];
    [super dealloc];
}
@end
