//
//  RegistServiceClassificationViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-2.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//
//  注册服务分类细分

#import <UIKit/UIKit.h>
#import "RunnerRabbitViewController.h"
#import "HelperRabbitViewController.h"
#import "DriverRabbitViewController.h"
#import "HotHeartRabbitViewController.h"

@interface RegistServiceClassificationViewController : UIViewController
{
    RunnerRabbitViewController  *_runnerRabbitVC;
    HelperRabbitViewController  *_helperRabbitVC;
    DriverRabbitViewController  *_driverRabbitVC;
    HotHeartRabbitViewController    *_hotHeartRabbitVC;
}

- (id)initWithRegisterType:(RegisterType)type;

@end
