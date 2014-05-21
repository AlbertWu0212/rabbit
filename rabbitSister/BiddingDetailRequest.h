//
//  BiddingDetailRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface BiddingDetailRequest : RabbitBaseRequester

-(void)biddingDetail:(NSString *)demand_sn
       success:(requesterSuccess)success
        failed:(requesterFailed)failed;

@end
