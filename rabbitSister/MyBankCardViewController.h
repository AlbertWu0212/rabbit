//
//  MyBankCardViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBankCardViewController : UIViewController
{
    NSMutableDictionary     *_loginInfo;
}
@property (retain, nonatomic) IBOutlet UIView *cardView;
@property (retain, nonatomic) IBOutlet UIView *addCardView;
@property (retain, nonatomic) IBOutlet UITextField *bankCardField;
@property (retain, nonatomic) IBOutlet UITextField *bankNameField;
@property (retain, nonatomic) IBOutlet UILabel *bankNameLab;
@property (retain, nonatomic) IBOutlet UILabel *bankCardLab;
@property (retain, nonatomic) IBOutlet UIButton *change;
- (IBAction)change:(id)sender;

@end
