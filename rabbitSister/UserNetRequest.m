//
//  UserNetRequest.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-27.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "UserNetRequest.h"
#import "PublicDefine.h"

@implementation UserNetRequest
-(void)login:(NSString *)username
    password:(NSString *)password
     userkey:(NSString *)userkey
     success:(requesterSuccess)success
      failed:(requesterFailed)failed
{
//    [[MainNetWorkClient sharedHTTPClient] requestWithMethod:@RequestInterfaceTypeLogin parameter:@{@"userkey":@"eb25d21c8595",@"username":@"liuchuang02",@"password":@"liuchuang02"} delegate:self HTTPType:BaseHTTPClient_GET];
    [[MainNetWorkClient sharedHTTPClient] requestWithMethod:@RequestInterfaceTypeLogin parameter:nil delegate:self HTTPType:BaseHTTPClient_GET];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}
@end
