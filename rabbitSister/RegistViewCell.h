//
//  RegistViewCell.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *menuLab;
@property (retain, nonatomic) IBOutlet UIImageView *logoImg;
@property (retain, nonatomic) IBOutlet UITextField *menuTextField;
@property (retain, nonatomic) IBOutlet UIButton *telephoneBtn;
@property (retain, nonatomic) IBOutlet UIButton *chooseNanBtn;
@property (retain, nonatomic) IBOutlet UIButton *chooseNvBtn;
@property (retain, nonatomic) IBOutlet UILabel *nanLab;
@property (retain, nonatomic) IBOutlet UILabel *nvLab;
@property (retain, nonatomic) IBOutlet UIImageView *textFieldBackground;
@property (retain, nonatomic) IBOutlet UIImageView *mustImg;
@property (retain, nonatomic) IBOutlet UIButton *imgAddBtn;
@property (retain, nonatomic) IBOutlet UILabel *cityLab;
@property (retain, nonatomic) IBOutlet UIImageView *MainIdCardImg;

@property (retain, nonatomic) IBOutlet UILabel *asteriskLab;


@end
