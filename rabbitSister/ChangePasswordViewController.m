//
//  ChangePasswordViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "ChangePassword.h"

#import "XMLRPCResult.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        _userInfoDic=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
        NSLog(@"个人信息：%@",_userInfoDic);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.oldPassword setSecureTextEntry:YES];
    [self.confirmPassword setSecureTextEntry:YES];
    [self.newPassword setSecureTextEntry:YES];
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    self.navigationItem.title=@"修改密码";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 判断中文
-(BOOL)getChina:(NSString *)string
{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            return NO;
        }else{
            
        }
    }
    return YES;
}

- (IBAction)submit:(id)sender {
    [self.view endEditing:YES];
    if (self.newPassword.text.length==0||self.confirmPassword.text.length==0||self.oldPassword.text.length==0) {
        WARNING__ALERT(@"请将信息填写完整");
        return;
    }
    
    if ([self getChina:self.newPassword.text]==NO||[self getChina:self.confirmPassword.text]==NO||[self getChina:self.oldPassword.text]==NO) {
        WARNING__ALERT(@"密码不能为中文");
        return;
    }
    
    if (![self.newPassword.text isEqualToString:self.confirmPassword.text]) {
        WARNING__ALERT(@"两次输入密码不同");
        return;
    }
    SHOW__LOADING
    ChangePassword *change=[[ChangePassword alloc] init];
    [change change:self.oldPassword.text newpass:self.newPassword.text conpass:self.confirmPassword.text success:^(id responseData){
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
            WARNING__ALERT(@"修改成功");
        }else{
            HIDE__LOADING
            WARNING__ALERT(@"修改失败");
        }
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"网络连接异常");
    }];
}

BACK_ACTION

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_newPassword release];
    [_confirmPassword release];
    [_oldPassword release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNewPassword:nil];
    [self setConfirmPassword:nil];
    [self setOldPassword:nil];
    [super viewDidUnload];
}
@end
