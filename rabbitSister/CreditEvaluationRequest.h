//
//  CreditEvaluationRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface CreditEvaluationRequest : RabbitBaseRequester

-(void)evaluation:(NSString *)page
      success:(requesterSuccess)success
       failed:(requesterFailed)failed;

@end
