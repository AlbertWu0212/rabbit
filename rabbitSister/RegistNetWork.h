//
//  RegistNetWork.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface RegistNetWork : RabbitBaseRequester
-(void)regist:(NSDictionary *)postDic
     success:(requesterSuccess)success
      failed:(requesterFailed)failed;

@end
