//
//  SubmitAuction.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-21.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface SubmitAuction : RabbitBaseRequester

-(void)submitAuction:(NSString *)usercode
                userkey:(NSString *)userkey
              demand_sn:(NSString *)demand_sn
                 dic:(NSMutableDictionary *)dic
                success:(requesterSuccess)success
                 failed:(requesterFailed)failed;

@end
