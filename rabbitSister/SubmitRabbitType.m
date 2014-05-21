//
//  SubmitRabbitType.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "SubmitRabbitType.h"

@implementation SubmitRabbitType

-(void)submitType:(NSString *)usercode
          userkey:(NSString *)userkey
             type:(NSString *)type
            level:(NSString *)level
            cates:(NSString *)cates
        otherDic:(NSMutableDictionary *)otherDic
          success:(requesterSuccess)success
           failed:(requesterFailed)failed
{
//    NSLog(@"呵呵：%@",otherDic);
    if (otherDic==nil||otherDic.count==0) {
        [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:@{@"usercode":usercode,@"userkey":userkey,@"type":type,@"level":level,@"cates":cates,@"initWithMethod":@"user.SetCateInfo",@"useRpc":@"1"} delegate:self HTTPType:BaseHTTPClient_POST];
    }else{
        NSMutableDictionary *uploadDic=[[NSMutableDictionary alloc] initWithDictionary:otherDic];
        [uploadDic setObject:usercode forKey:@"usercode"];
        [uploadDic setObject:userkey forKey:@"userkey"];
        [uploadDic setObject:type forKey:@"type"];
        [uploadDic setObject:level forKey:@"level"];
        [uploadDic setObject:cates forKey:@"cates"];
        [uploadDic setObject:@"user.SetCateInfo" forKey:@"initWithMethod"];
        [uploadDic setObject:@"1" forKey:@"useRpc"];
        
        NSLog(@"哈哈：%@",uploadDic);
        
        [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:uploadDic delegate:self HTTPType:BaseHTTPClient_POST];
    }
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
