//
//  GetRegistCode.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-1.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface GetRegistCode : RabbitBaseRequester

-(void)getCode:(NSString *)mobile
     success:(requesterSuccess)success
      failed:(requesterFailed)failed;

@end
