//
//  SetBasicInfor.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface SetBasicInfor : RabbitBaseRequester

-(void)basicInfo:(NSString *)user_nick
      user_image:(NSString *)user_image
        province:(NSString *)province
            city:(NSString *)city
        district:(NSString *)district
         address:(NSString *)address
        station_name:(NSString *)station_name
        success:(requesterSuccess)success
         failed:(requesterFailed)failed;

@end
