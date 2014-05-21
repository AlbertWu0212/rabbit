//
//  UserNetRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-27.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSSBaseRequester.h"

@interface UserNetRequest : PSSBaseRequester
-(void)login:(NSString *)username
    password:(NSString *)password
     userkey:(NSString *)userkey
     success:(requesterSuccess)success
      failed:(requesterFailed)failed;

@end
