//
//  GetRabbitMission.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-7.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface GetRabbitMission : RabbitBaseRequester

-(void)getRabbitMisson:(NSString *)usercode
          userkey:(NSString *)userkey
             city:(NSString *)city
            type:(NSString *)type
            level:(NSString *)level
        cate_codes:(NSString *)cate_codes
            page:(NSString *)page
          success:(requesterSuccess)success
           failed:(requesterFailed)failed;

@end
