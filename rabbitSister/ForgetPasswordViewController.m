//
//  ForgetPasswordViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#import "callBackPasswordRequest.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController
static bool truse=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=NO;
    
    self.navigationItem.title=@"忘记密码";
    
    //上一步
    NAVIGATION_BACK(@"  返回");
    
    self.submitBtn.enabled=NO;
    
#pragma mark - 记住用户名密码
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *loginCache=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",LOGINCACHE]]];
    self.submitTextfield.text=[loginCache objectForKey:@"username"];
    
    if (self.submitTextfield.text.length>0) {
        self.submitBtn.enabled=YES;
    }
//    self.passwordTextField.text=[loginCache objectForKey:@"password"];
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - 判断选择框字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length==0) {
        if (textField.text.length==1) {
            self.submitBtn.enabled=NO;
        }
    }else{
        self.submitBtn.enabled=YES;
    }
    
    return YES;
}

- (IBAction)chooseTrust:(id)sender {
    truse=!truse;
    
    UIButton *clickBtn=(UIButton *)sender;
    
    truse?[clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal]:[clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    callBackPasswordRequest *callBack=[[callBackPasswordRequest alloc] init];
    
    SHOW__LOADING
    NSMutableDictionary *submitDic=[[NSMutableDictionary alloc] init];
    [submitDic setObject:self.submitTextfield.text forKey:@"username"];
    [submitDic setObject:@"999999" forKey:@"authcode"];
    [callBack callBackPassword:submitDic success:^(id responseData) {
        HIDE__LOADING
        NSLog(@"返回数据是：%@",responseData);
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"请检查您的网络连接是否通畅");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_submitBtn release];
    [_submitTextfield release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSubmitBtn:nil];
    [self setSubmitTextfield:nil];
    [super viewDidUnload];
}
@end
