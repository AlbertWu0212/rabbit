//
//  LoginViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//
//  登陆

//forbid10
//ownerblood

#import <UIKit/UIKit.h>
#import "RegistClassifyViewController.h"
#import "ForgetPasswordViewController.h"
#import "RabbitMainViewController.h"

#import "Reachability.h"

//支付宝
#import "AlixLibService.h"

//XMPP
#import "XMPPManager.h"
#import <TargetConditionals.h>


#import <CoreLocation/CoreLocation.h>


@interface LoginViewController : UIViewController<NSURLConnectionDelegate,XMPPLoginDelegate,CLLocationManagerDelegate>
{
    RegistClassifyViewController        *_registClassifyVC;
    ForgetPasswordViewController        *_forgetPasswordVC;
    
    RabbitMainViewController            *_rabbitMainVC;
    
    RabbitMKNetwork                     *rabbit;
    
    SEL _result;
    
    NSMutableDictionary                 *_loginDic;
}
- (IBAction)regist:(id)sender;
- (IBAction)forgetPassword:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *login;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIImageView *warningView;


@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;

@end
