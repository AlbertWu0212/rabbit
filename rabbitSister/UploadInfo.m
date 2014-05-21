//
//  UploadInfo.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "UploadInfo.h"
#import "AFJSONRequestOperation.h"

@implementation UploadInfo

-(id)initWithStatus:(id)Status
{
    self = [super init];  // Call a designated initializer here.
    if (self != nil) {
        if (Status) {
            AFJSONRequestOperation *JSONRequest=[[AFJSONRequestOperation alloc] init];
            NSDictionary *resDic=[JSONRequest otherJsonBack:Status];
            
            if ([[resDic objectForKey:@"error"] intValue]!=0) {
                self.success=NO;
                self.url=[[resDic objectForKey:@"data"] objectForKey:@"reason"];
            }else{
                self.success=YES;
                
                self.url=[[resDic objectForKey:@"data"] objectForKey:@"url"];
            }
        }
    }
    
    return self;
}

@end
