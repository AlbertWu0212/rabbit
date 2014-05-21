//
//  SubmitAuction.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-21.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "SubmitAuction.h"

@implementation SubmitAuction

-(void)submitAuction:(NSString *)usercode
             userkey:(NSString *)userkey
           demand_sn:(NSString *)demand_sn
                dic:(NSMutableDictionary *)dic
             success:(requesterSuccess)success
              failed:(requesterFailed)failed
{
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc] initWithDictionary:dic];
    [postDic setObject:usercode forKey:@"usercode"];
    [postDic setObject:userkey forKey:@"userkey"];
    [postDic setObject:demand_sn forKey:@"demand_sn"];
    [postDic setObject:@"mission.AddAuction" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"mission.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
