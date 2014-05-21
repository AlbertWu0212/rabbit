//
//  SubmitRabbitType.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface SubmitRabbitType : RabbitBaseRequester

-(void)submitType:(NSString *)usercode
               userkey:(NSString *)userkey
                  type:(NSString *)type
            level:(NSString *)level
            cates:(NSString *)cates
         otherDic:(NSMutableDictionary *)otherDic
               success:(requesterSuccess)success
                failed:(requesterFailed)failed;

@end
