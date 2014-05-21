//
//  cancelMission.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-20.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "cancelMission.h"

@implementation cancelMission

-(void)cancelNotice:(NSString *)demand_sn
            success:(requesterSuccess)success
             failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:demand_sn forKey:@"bnumber"];
    [postDic setObject:@"sm.tuziToCancel" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"s"];
    [rabbitMk requestWithMethod:@"sm.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
