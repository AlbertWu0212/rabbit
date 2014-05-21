//
//  GetCateInstruct.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-4.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "GetCateInstruct.h"

@implementation GetCateInstruct

-(void)getCateInstruct:(NSString *)usercode
               userkey:(NSString *)userkey
                  city:(NSString *)city
            cate_codes:(NSString *)cate_codes
               success:(requesterSuccess)success
                failed:(requesterFailed)failed
{
    //useRpc为1时使用RPC格式，否则使用普通格式
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:@{@"usercode":usercode,@"userkey":userkey,@"city":city,@"cate_codes":cate_codes,@"initWithMethod":@"user.GetCateInstruct",@"useRpc":@"1"} delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
