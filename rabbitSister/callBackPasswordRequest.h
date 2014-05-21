//
//  callBackPasswordRequest.h
//  rabbitSister
//
//  Created by Jahnny on 14-5-8.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface callBackPasswordRequest : PSSBaseRequester

-(void)callBackPassword:(NSDictionary *)otherDic
       success:(requesterSuccess)success
        failed:(requesterFailed)failed;

@end
