//
//  XMLRPCResult.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-1.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "XMLRPCResult.h"
#import "AFJSONRequestOperation.h"

@implementation XMLRPCResult

-(id)initWithStatus:(id)Status
{
    self = [super init];  // Call a designated initializer here.
    if (self != nil) {
        if ([Status isKindOfClass:[NSDictionary class]]) {
            AFJSONRequestOperation *JSONRequest=[[AFJSONRequestOperation alloc] init];
//            NSLog(@"报错：%@",Status);
            int tError=[[Status objectForKey:@"error"] intValue];
            if (tError==0) {
                self.success=YES;
                self.res=[JSONRequest otherJsonBack:[Status objectForKey:@"res"]];
            }else{
                self.success=NO;
//                self.res=[Status objectForKey:@"res"];
                self.res=[JSONRequest otherJsonBack:[Status objectForKey:@"res"]];
            }
            
            
        }
    }
    
    return self;
}


@end
