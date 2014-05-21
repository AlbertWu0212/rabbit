//
//  LoginInfo.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "LoginInfo.h"
#import "AFJSONRequestOperation.h"

@implementation LoginInfo

-(id)initWithStatus:(id)Status
{
    self = [super init];  // Call a designated initializer here.
    if (self != nil) {
        if ([Status isKindOfClass:[NSDictionary class]]) {
            AFJSONRequestOperation *JSONRequest=[[AFJSONRequestOperation alloc] init];
            int tError=[[Status objectForKey:@"error"] intValue];
            if (tError==0) {
                self.success=YES;
                self.res=[JSONRequest otherJsonBack:[Status objectForKey:@"res"]];
            }else{
                self.success=NO;
                self.res=[JSONRequest otherJsonBack:[Status objectForKey:@"res"]];
                self.res=[self.res objectForKey:@"reason"];
            }
            
            
        }
    }
    
    return self;
}

@end
