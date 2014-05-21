//
//  LoginNetWork.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RabbitBaseRequester.h"

@interface LoginNetWork : RabbitBaseRequester
-(void)login:(NSString *)username
    password:(NSString *)password
     success:(requesterSuccess)success
      failed:(requesterFailed)failed;
@end
