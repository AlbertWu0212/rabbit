//
//  ServiceSettlementRequest.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-6.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface ServiceSettlementRequest : RabbitBaseRequester

-(void)ServerSett:(requesterSuccess)success
             failed:(requesterFailed)failed;

@end
