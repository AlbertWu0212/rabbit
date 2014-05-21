//
//  WiningOverRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface WiningOverRequest : RabbitBaseRequester

-(void)WiningOver:(NSString *)demand_sn
             success:(requesterSuccess)success
              failed:(requesterFailed)failed;

@end
