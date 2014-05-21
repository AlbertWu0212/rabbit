//
//  EvaluationRequest.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-3.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "EvaluationRequest.h"

@implementation EvaluationRequest

-(void)Evaluation:(NSString *)demand_sn
              sex:(NSString *)sex
        age_range:(NSString *)age_range
            level:(NSString *)level
          content:(NSString *)content
          success:(requesterSuccess)success
           failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:@"mission.AddComment" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    [postDic setObject:demand_sn forKey:@"demand_sn"];
    [postDic setObject:sex forKey:@"sex"];
    [postDic setObject:age_range forKey:@"age_range"];
    [postDic setObject:level forKey:@"level"];
    [postDic setObject:content forKey:@"content"];
    
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"mission.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
