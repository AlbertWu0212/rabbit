//
//  SetCateInfo.h
//  rabbitSister
//
//  Created by Jahnny on 14-3-4.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface SetCateInfo : PSSBaseRequester

-(void)setCate:(NSDictionary *)otherDic
       success:(requesterSuccess)success
        failed:(requesterFailed)failed;

@end
