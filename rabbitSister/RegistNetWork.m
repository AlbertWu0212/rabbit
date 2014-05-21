//
//  RegistNetWork.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistNetWork.h"

@implementation RegistNetWork

-(void)regist:(NSDictionary *)postDic
      success:(requesterSuccess)success
       failed:(requesterFailed)failed
{
    NSMutableDictionary *mainDic=[[NSMutableDictionary alloc] initWithDictionary:postDic];
    [mainDic setObject:@"1" forKey:@"useRpc"];
    [mainDic setObject:@"user.Register" forKey:@"initWithMethod"];
    [mainDic setObject:@"0bb2cb1f2a52" forKey:@"regkey"];
    //useRpc为1时使用RPC格式，否则使用普通格式
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:mainDic delegate:self HTTPType:BaseHTTPClient_POST];
    
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
