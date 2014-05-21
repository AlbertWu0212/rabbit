//
//  GetServerTime.h
//  rabbitSister
//
//  Created by Jahnny on 14-1-6.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface GetServerTime : PSSBaseRequester

-(void)getTime:(requesterSuccess)success
               failed:(requesterFailed)failed;

@end
