//
//  TopUpViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

//支付宝
#import "AlixLibService.h"

@interface TopUpViewController : UIViewController
{
    NSString        *_moneyStr;
    //支付宝
    SEL _result;
}
@property (retain, nonatomic) IBOutlet UILabel *moneyLab;
@property (retain, nonatomic) IBOutlet UITextField *topUpField;

//支付宝
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;

-(id)initWithMoney:(NSString *)money;

@end
