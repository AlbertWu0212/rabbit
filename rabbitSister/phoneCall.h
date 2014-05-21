//
//  phoneCall.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-4.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface phoneCall : RabbitBaseRequester

-(void)getPhone:(NSString *)demand_sn
        success:(requesterSuccess)success
         failed:(requesterFailed)failed;

@end
