//
//  DropMission.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface DropMission : PSSBaseRequester

-(void)dropMission:(NSString *)demand_sn
             success:(requesterSuccess)success
              failed:(requesterFailed)failed;

@end
