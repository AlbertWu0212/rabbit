//
//  GetRabbitMission.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-7.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "GetRabbitMission.h"

@implementation GetRabbitMission

-(void)getRabbitMisson:(NSString *)usercode
               userkey:(NSString *)userkey
                  city:(NSString *)city
                  type:(NSString *)type
                 level:(NSString *)level
            cate_codes:(NSString *)cate_codes
                  page:(NSString *)page
               success:(requesterSuccess)success
                failed:(requesterFailed)failed
{
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"mission.php" parameter:@{@"usercode":usercode,@"userkey":userkey,@"city":city,@"type":type,@"level":level,@"cate_codes":cate_codes,@"page":page,@"initWithMethod":@"mission.GetMissionList",@"useRpc":@"1"} delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
