//
//  MissionOverEmployer.h
//  rabbitSister
//
//  Created by Jahnny on 14-1-9.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface MissionOverEmployer : PSSBaseRequester

-(void)over:(NSString *)bnumber
            success:(requesterSuccess)success
             failed:(requesterFailed)failed;

@end
