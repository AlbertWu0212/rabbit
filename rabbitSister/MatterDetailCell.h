//
//  MatterDetailCell.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatterDetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *contentLab;
@property (retain, nonatomic) IBOutlet UIImageView *contentImg;
@property (retain, nonatomic) IBOutlet UIButton *bigImgBtn;
@property (retain, nonatomic) IBOutlet UIButton *soundBtn;
@property (retain, nonatomic) IBOutlet UIView *priceInfoView;
@property (retain, nonatomic) IBOutlet UILabel *priceInfoLab;
@property (retain, nonatomic) IBOutlet UIImageView *topLine;
@property (retain, nonatomic) IBOutlet UIImageView *downLine;

@end
