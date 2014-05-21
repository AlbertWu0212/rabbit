//
//  ServeSettDetail.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-6.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "ServeSettDetail.h"

@implementation ServeSettDetail

-(void)ServeSeDetail:(NSString *)start
                 end:(NSString *)end
             success:(requesterSuccess)success
              failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:@"account.GetRecentCheckDetails" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    [postDic setObject:start forKey:@"start"];
    [postDic setObject:end forKey:@"end"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"account.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
