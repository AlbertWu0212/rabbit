//
//  BiddingNotice.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-19.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface BiddingNotice : PSSBaseRequester

-(void)biddingNotice:(NSString *)demand_sn
           success:(requesterSuccess)success
            failed:(requesterFailed)failed;

@end
