//
//  biddingRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface biddingRequest : RabbitBaseRequester

-(void)bidding:(NSString *)type
             book_type:(NSString *)book_type
           page:(NSString *)page
             success:(requesterSuccess)success
              failed:(requesterFailed)failed;

@end
