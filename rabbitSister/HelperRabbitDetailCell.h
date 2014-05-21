//
//  HelperRabbitDetailCell.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperRabbitDetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *chooseView;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UILabel *chooseFirstLab;
@property (retain, nonatomic) IBOutlet UILabel *chooseSecondLab;
@property (retain, nonatomic) IBOutlet UILabel *chooseThirdLab;
@property (retain, nonatomic) IBOutlet UILabel *chooseFouthLab;
@property (retain, nonatomic) IBOutlet UILabel *chooseFifthLab;
@property (retain, nonatomic) IBOutlet UILabel *chooseSixLab;
@property (retain, nonatomic) IBOutlet UIButton *chooseSixBtn;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *chooseTitleLab;
@property (retain, nonatomic) IBOutlet UIButton *firstBtn;
@property (retain, nonatomic) IBOutlet UIButton *secondBtn;
@property (retain, nonatomic) IBOutlet UIButton *thirdBtn;
@property (retain, nonatomic) IBOutlet UIButton *fouthBtn;
@property (retain, nonatomic) IBOutlet UIButton *fifthBtn;
@property (retain, nonatomic) IBOutlet UIButton *sixBtn;

@property (retain, nonatomic) IBOutlet UIButton *addImgBtn;
@property (retain, nonatomic) IBOutlet UIImageView *uploadImg;
@property (retain, nonatomic) IBOutlet UIImageView *bgImg;
@property (retain, nonatomic) IBOutlet UITextView *writeInTextView;

@property (retain, nonatomic) IBOutlet UIImageView *mustImg;

@end
