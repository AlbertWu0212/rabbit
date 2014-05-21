//
//  BankCardRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface BankCardRequest : RabbitBaseRequester

-(void)binddingBank:(NSString *)bank_account
   bank_name:(NSString *)bank_name
     success:(requesterSuccess)success
      failed:(requesterFailed)failed;
@end
