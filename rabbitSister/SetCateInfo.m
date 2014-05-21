//
//  SetCateInfo.m
//  rabbitSister
//
//  Created by Jahnny on 14-3-4.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "SetCateInfo.h"

@implementation SetCateInfo

-(void)setCate:(NSDictionary *)otherDic
       success:(requesterSuccess)success
        failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] initWithDictionary:otherDic];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    
    
    [postDic setObject:@"user.UpdateCertsInfo" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"t"];
    [rabbitMk requestWithMethod:@"user.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
