//
//  MarginRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface MarginRequest : RabbitBaseRequester

-(void)margin:(requesterSuccess)success
           failed:(requesterFailed)failed;

@end
