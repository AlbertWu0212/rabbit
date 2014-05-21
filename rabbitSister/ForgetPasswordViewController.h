//
//  ForgetPasswordViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//
//  忘记密码

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UITextField *submitTextfield;


@end
