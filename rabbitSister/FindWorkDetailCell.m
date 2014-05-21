//
//  FindWorkDetailCell.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "FindWorkDetailCell.h"

@implementation FindWorkDetailCell

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
    [_contentImg release];
    [_soundBtn release];
    [_soundTime release];
    [_backgroundImg release];
    [_rangeView release];
    [_rangeFirst release];
    [_rangeSecond release];
    [_rangeThird release];
    [_rangeFouth release];
    [_type1 release];
    [_type2 release];
    [_type3 release];
    [_type4 release];
    [_type4Field release];
    [_type1ScrollView release];
    [_prepaidBtn release];
    [_nowCashBtn release];
    [_bigImgBtn release];
    [_type3Lab release];
    [super dealloc];
}
@end
