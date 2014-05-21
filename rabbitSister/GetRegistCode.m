//
//  GetRegistCode.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-1.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "GetRegistCode.h"

@implementation GetRegistCode

-(void)getCode:(NSString *)mobile
       success:(requesterSuccess)success
        failed:(requesterFailed)failed
{
    //useRpc为1时使用RPC格式，否则使用普通格式
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"t"];
    [rabbitMk requestWithMethod:@"user.php" parameter:@{@"userkey":@"0bb2cb1f2a52",@"mobile":mobile,@"initWithMethod":@"user.VerifyMobile",@"useRpc":@"1"} delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
