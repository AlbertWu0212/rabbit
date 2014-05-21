//
//  RabbitBaseRequester.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@implementation RabbitBaseRequester

-(void)MainNetWorkClientDidFinishRequest:(id)data
{
    self.requesterSuccessBlock(data);
}

-(void)MainNetWorkClientDidFailed:(NSError *)error
{
    self.requesterFailedBlock(error);
}

- (void)dealloc {
    [self.requesterSuccessBlock release];
    self.requesterSuccessBlock=nil;
    [self.requesterFailedBlock release];
    self.requesterFailedBlock=nil;
    [super dealloc];
}

@end
