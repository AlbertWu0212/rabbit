//
//  ChangePasswordViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
{
    NSMutableDictionary     *_userInfoDic;
}
@property (retain, nonatomic) IBOutlet UITextField *oldPassword;
@property (retain, nonatomic) IBOutlet UITextField *confirmPassword;
@property (retain, nonatomic) IBOutlet UITextField *newPassword;
@end
