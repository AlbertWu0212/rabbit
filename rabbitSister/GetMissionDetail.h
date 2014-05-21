//
//  GetMissionDetail.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-14.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface GetMissionDetail : RabbitBaseRequester

-(void)getMissionDetail:(NSString *)usercode
                userkey:(NSString *)userkey
            demand_en:(NSString *)demand_en
                success:(requesterSuccess)success
                 failed:(requesterFailed)failed;
@end
