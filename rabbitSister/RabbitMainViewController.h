//
//  RabbitMainViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//
//  主要控制器

#import <UIKit/UIKit.h>
#import "RabbitPersonalViewController.h"
#import "FindWorkViewController.h"
#import "MatterViewController.h"

#import "FindWorkDetailViewController.h"
#import "PersonalInforViewController.h"
#import "CreditViewController.h"
#import "MyAccountViewController.h"
#import "SetUpViewController.h"
#import "ChatViewController.h"

#import "ILBarButtonItem.h"

#import <MessageUI/MessageUI.h>

#import "MatterDetailViewController.h"

@interface RabbitMainViewController : UIViewController<UITabBarControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    RabbitPersonalViewController    *_rabbitPersonalVC;
    FindWorkViewController          *_findWorkVC;
    MatterViewController            *_matterVC;
    
    FindWorkDetailViewController    *_findWorkDetailVC;
    PersonalInforViewController     *_personalInforVC;
    CreditViewController            *_creditVC;
    MyAccountViewController         *_myAccountVC;
    SetUpViewController             *_setupVC;
    ChatViewController              *_chatVC;
    
    UITabBarController              *_mainTabBar;
    
    MatterDetailViewController      *_matterDetailVC;
}

-(void)calledPublicBack;

@end
