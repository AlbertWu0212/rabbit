//
//  GetCateInstruct.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-4.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface GetCateInstruct : RabbitBaseRequester

-(void)getCateInstruct:(NSString *)usercode
                userkey:(NSString *)userkey
                  city:(NSString *)city
            cate_codes:(NSString *)cate_codes
               success:(requesterSuccess)success
                failed:(requesterFailed)failed;

@end
