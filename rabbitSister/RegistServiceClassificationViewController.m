//
//  RegistServiceClassificationViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-2.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistServiceClassificationViewController.h"

@interface RegistServiceClassificationViewController ()

@end

@implementation RegistServiceClassificationViewController
static int rabbitType=0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRegisterType:(RegisterType)type
{
    self = [super init];
    if (self) {
        rabbitType=type;
        Notification__CREATE(NotificationBack,REGISTCHOOSEOVER);
        Notification__CREATE(NotificationHelperBack,HELPERBACK);
        
        // Custom initialization
    }
    return self;
}

#pragma mark - 监听事件(提交注册)
- (void)NotificationBack:(NSNotification *) notification
{
//    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    Notification__POST(REGISTSUCCESS,nil);
}

#pragma mark - 监听事件(帮帮返回)
- (void)NotificationHelperBack:(NSNotification *) notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //移除所有父视图
    for (UIView *removeView in self.view.subviews) {
        [removeView removeFromSuperview];
    }
    
    switch (rabbitType) {
        case runer:
            _runnerRabbitVC=[[RunnerRabbitViewController alloc] init];
            [self.view addSubview:_runnerRabbitVC.view];
            self.navigationItem.title=@"跑腿兔";
            break;
            
        case helper:
            _helperRabbitVC=[[HelperRabbitViewController alloc] init];
            [self.view addSubview:_helperRabbitVC.view];
            self.navigationItem.title=@"帮帮兔";
            break;
            
        case driver:
            _driverRabbitVC=[[DriverRabbitViewController alloc] init];
            [self.view addSubview:_driverRabbitVC.view];
            self.navigationItem.title=@"开车兔";
            break;
            
        case hotHeart:
            _hotHeartRabbitVC=[[HotHeartRabbitViewController alloc] init];
            [self.view addSubview:_hotHeartRabbitVC.view];
            self.navigationItem.title=@"热心兔";
            break;
            
        default:
            break;
    }
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
    if (rabbitType==helper) {
        Notification__POST(HELPERRABBIT,nil);
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)dealloc {
    Notification__REMOVE
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
