//
//  openCloseNotifaction.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface openCloseNotifaction : PSSBaseRequester

-(void)notifactionSet:(NSString *)is_open
            success:(requesterSuccess)success
             failed:(requesterFailed)failed;

@end
