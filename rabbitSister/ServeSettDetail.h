//
//  ServeSettDetail.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-6.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface ServeSettDetail : RabbitBaseRequester

-(void)ServeSeDetail:(NSString *)start
          end:(NSString *)end
            success:(requesterSuccess)success
             failed:(requesterFailed)failed;

@end
