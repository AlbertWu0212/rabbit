//
//  FindWorkDetailCell.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindWorkDetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *contentLab;
@property (retain, nonatomic) IBOutlet UIImageView *contentImg;
@property (retain, nonatomic) IBOutlet UIButton *soundBtn;
@property (retain, nonatomic) IBOutlet UILabel *soundTime;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (retain, nonatomic) IBOutlet UIView *rangeView;
@property (retain, nonatomic) IBOutlet UILabel *rangeFirst;
@property (retain, nonatomic) IBOutlet UILabel *rangeSecond;
@property (retain, nonatomic) IBOutlet UILabel *rangeThird;
@property (retain, nonatomic) IBOutlet UILabel *rangeFouth;
@property (retain, nonatomic) IBOutlet UIScrollView *rangeScrollView;


@property (retain, nonatomic) IBOutlet UIView *type1;
@property (retain, nonatomic) IBOutlet UIScrollView *type1ScrollView;


@property (retain, nonatomic) IBOutlet UIView *type2;
@property (retain, nonatomic) IBOutlet UIView *type3;

@property (retain, nonatomic) IBOutlet UIView *type4;
@property (retain, nonatomic) IBOutlet UITextField *type4Field;

@property (retain, nonatomic) IBOutlet UIButton *prepaidBtn;
@property (retain, nonatomic) IBOutlet UIButton *nowCashBtn;
@property (retain, nonatomic) IBOutlet UIButton *bigImgBtn;
@property (retain, nonatomic) IBOutlet UILabel *type3Lab;

@end
