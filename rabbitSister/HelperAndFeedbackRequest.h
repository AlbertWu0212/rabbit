//
//  HelperAndFeedbackRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface HelperAndFeedbackRequest : PSSBaseRequester

-(void)PostFeedback:(NSString *)content
         success:(requesterSuccess)success
          failed:(requesterFailed)failed;

@end
