//
//  GetMissionDetail.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-14.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "GetMissionDetail.h"

@implementation GetMissionDetail

-(void)getMissionDetail:(NSString *)usercode
                userkey:(NSString *)userkey
              demand_en:(NSString *)demand_en
                success:(requesterSuccess)success
                 failed:(requesterFailed)failed
{
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"mission.php" parameter:@{@"usercode":usercode,@"userkey":userkey,@"demand_sn":demand_en,@"initWithMethod":@"mission.GetMissionDetails",@"useRpc":@"1"} delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
