//
//  LoginNetWork.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "LoginNetWork.h"

@implementation LoginNetWork

-(void)login:(NSString *)username
    password:(NSString *)password
     success:(requesterSuccess)success
      failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *tokenDic=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",DEVICETOKEN]]];
    
    NSString *device=[tokenDic objectForKey:@"token"];
    
    if (device.length==0||device==nil) {
        device=@"";
    }
    
    //useRpc为1时使用RPC格式，否则使用普通格式
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:@{@"userkey":@"0bb2cb1f2a52",@"username":username,@"password":password,@"initWithMethod":@"user.Login",@"useRpc":@"1",@"devicetoken":device} delegate:self HTTPType:BaseHTTPClient_POST];
//    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:@{@"userkey":@"0bb2cb1f2a52",@"username":username,@"password":password,@"initWithMethod":@"user.Login",@"useRpc":@"0"} delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
