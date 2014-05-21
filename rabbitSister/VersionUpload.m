//
//  VersionUpload.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "VersionUpload.h"

@implementation VersionUpload

-(void)getVerson:(requesterSuccess)success
          failed:(requesterFailed)failed
{
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    
    //获取当前版本
    NSString *curVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [postDic setObject:@"0bb2cb1f2a52" forKey:@"userkey"];
    [postDic setObject:curVer forKey:@"versio"];
    [postDic setObject:@"server.CheckSysUpdate" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"server.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end