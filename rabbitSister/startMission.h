//
//  startMission.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface startMission : PSSBaseRequester

-(void)missionStart:(NSString *)bnumber
         success:(requesterSuccess)success
          failed:(requesterFailed)failed;

@end
