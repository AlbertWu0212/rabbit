//
//  timeLocal.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface timeLocal : PSSBaseRequester

-(void)timeLocal:(NSString *)lat
             lng:(NSString *)lng
         success:(requesterSuccess)success
          failed:(requesterFailed)failed;

@end
