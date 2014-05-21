//
//  TopUpRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface TopUpRequest : RabbitBaseRequester

-(void)topUp:(NSString *)amount
   user_note:(NSString *)user_note
        success:(requesterSuccess)success
         failed:(requesterFailed)failed;

@end
