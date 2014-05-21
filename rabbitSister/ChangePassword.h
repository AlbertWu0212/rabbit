//
//  ChangePassword.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface ChangePassword : RabbitBaseRequester

-(void)change:(NSString *)oldpass
      newpass:(NSString *)newpass
      conpass:(NSString *)conpass
         success:(requesterSuccess)success
          failed:(requesterFailed)failed;

@end
