//
//  RegistClassifyViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-2.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//
//  注册分类选择

#import <UIKit/UIKit.h>
#import "RegistClassifyCell.h"
#import "RegistViewController.h"
#import "PSSFileOperations.h"
#import "RegistServiceClassificationViewController.h"

#import "RunnerRabbitViewController.h"
#import "HelperRabbitViewController.h"
#import "DriverRabbitViewController.h"
#import "HotHeartRabbitViewController.h"

@interface RegistClassifyViewController : UIViewController
{
    RegistViewController    *_registVC;
    RegistServiceClassificationViewController   *_RegistServiceClassificationVC;
    
    NSMutableArray          *_mainInfoArr;
    
    RunnerRabbitViewController  *_runnerRabbitVC;
    HelperRabbitViewController  *_helperRabbitVC;
    DriverRabbitViewController  *_driverRabbitVC;
    HotHeartRabbitViewController    *_hotHeartRabbitVC;
}
@property (retain, nonatomic) IBOutlet UITableView *classifyTab;

-(void)changeStatus:(BOOL)status;   //修改isFirstReg状态

@end
