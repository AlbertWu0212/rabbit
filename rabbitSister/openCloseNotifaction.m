//
//  openCloseNotifaction.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "openCloseNotifaction.h"

@implementation openCloseNotifaction

-(void)notifactionSet:(NSString *)is_open
              success:(requesterSuccess)success
               failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:is_open forKey:@"is_open"];
    [postDic setObject:@"server.SetPushSwitch" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"server.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
