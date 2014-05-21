//
//  LoginBack.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "LoginBack.h"

@implementation LoginBack

+(NSDictionary *)mapping
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"usercode",@"usercode",
            @"userkey", @"userkey",
            @"username", @"username",
            @"password", @"password",
            @"nickname",@"nickname",
            @"image",@"image",
            @"mobile",@"mobile",
            @"reg_time",@"reg_time",
            @"province",@"province",
            @"city",@"city",
            @"district",@"district",
            @"address",@"address",
            @"status",@"status",
            nil];
}

@end
