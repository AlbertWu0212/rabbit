//
//  rabbitAppDelegate.h
//  rabbitSister
//
//  Created by Jahnny on 13-8-28.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TutorialViewController.h"

#import "XMPPManager.h"

@interface rabbitAppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,XMPPChatDelegate,XMPPLoginDelegate>
{
    LoginViewController       *_rabbitLoginVC;
    TutorialViewController    *_tutorialVC;
    UINavigationController          *_navC;
    
    XMPPManager               *_xmppManager;
}

@property (strong, nonatomic) UIWindow *window;
+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data;

@property (copy,nonatomic)NSMutableArray *speakerTimeArr;

@end
