//
//  HttpsStartMission.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface HttpsStartMission : PSSBaseRequester

-(void)missionStart:(NSString *)bnumber
            success:(requesterSuccess)success
             failed:(requesterFailed)failed;

@end
