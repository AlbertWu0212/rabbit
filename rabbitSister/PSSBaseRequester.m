//
//  PSSBaseRequester.m
//  PSS
//
//  Created by Jahnny on 13-5-30.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@implementation PSSBaseRequester

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
