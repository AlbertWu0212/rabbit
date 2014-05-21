//
//  RegistBack.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistBack.h"

@implementation RegistBack

+(NSDictionary *)mapping
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"reason",@"reason",
            @"regkey", @"regkey",
            @"username", @"username",
            @"password", @"password",
            @"mobile",@"mobile",
            @"province",@"province",
            @"city",@"city",
            @"district",@"district",
            @"province",@"province",
            @"address",@"address",
            @"image",@"image",
            @"status",@"status",
            @"reg_time",@"reg_time",
            @"usercode",@"usercode",
            @"userkey",@"userkey",
            nil];
}

@end
