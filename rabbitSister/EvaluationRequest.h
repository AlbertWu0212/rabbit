//
//  EvaluationRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-3.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface EvaluationRequest : RabbitBaseRequester

-(void)Evaluation:(NSString *)demand_sn
              sex:(NSString *)sex
        age_range:(NSString *)age_range
            level:(NSString *)level
          content:(NSString *)content
          success:(requesterSuccess)success
           failed:(requesterFailed)failed;

@end
