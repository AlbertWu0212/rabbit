//
//  HelperAndFeedbackRequest.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HelperAndFeedbackRequest.h"

@implementation HelperAndFeedbackRequest

-(void)PostFeedback:(NSString *)content
            success:(requesterSuccess)success
             failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:content forKey:@"content"];
    [postDic setObject:@"0bb2cb1f2a52" forKey:@"regkey"];
    [postDic setObject:@"account.AddUserFeedback" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"account.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
