//
//  MissionOverEmployer.m
//  rabbitSister
//
//  Created by Jahnny on 14-1-9.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "MissionOverEmployer.h"

@implementation MissionOverEmployer

-(void)over:(NSString *)bnumber
            success:(requesterSuccess)success
             failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:bnumber forKey:@"bnumber"];
    [postDic setObject:@"sm.tuziFinishNotice" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"s"];
    [rabbitMk requestWithMethod:@"sm.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
