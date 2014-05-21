//
//  MatterViewCell.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-15.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatterViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *titleImg;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *localLab;
@property (retain, nonatomic) IBOutlet UILabel *priceLab;
@property (retain, nonatomic) IBOutlet UIImageView *timeImg;
@property (retain, nonatomic) IBOutlet UILabel *timeLab;
@property (retain, nonatomic) IBOutlet UIButton *deleteLab;
@property (retain, nonatomic) IBOutlet UIButton *photoBtn;
@property (retain, nonatomic) IBOutlet UIButton *speakBtn;
@property (retain, nonatomic) IBOutlet UIButton *phoneBtn;
@property (retain, nonatomic) IBOutlet UIImageView *middleLineImg;
@property (retain, nonatomic) IBOutlet UIImageView *downLineImg;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (retain, nonatomic) IBOutlet UIImageView *dianImg;
@property (retain, nonatomic) IBOutlet UIButton *doingBtn;
@property (retain, nonatomic) IBOutlet UIImageView *deleteImg;

@end
