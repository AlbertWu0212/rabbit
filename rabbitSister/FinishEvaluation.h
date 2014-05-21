//
//  FinishEvaluation.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-20.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface FinishEvaluation : PSSBaseRequester

-(void)finishEva:(NSString *)demand_sn
            success:(requesterSuccess)success
             failed:(requesterFailed)failed;

@end
