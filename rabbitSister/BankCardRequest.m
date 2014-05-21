//
//  BankCardRequest.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "BankCardRequest.h"

@implementation BankCardRequest

-(void)binddingBank:(NSString *)bank_account
          bank_name:(NSString *)bank_name
            success:(requesterSuccess)success
             failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:@"account.BindCard" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    [postDic setObject:bank_account forKey:@"bank_account"];
    [postDic setObject:bank_name forKey:@"bank_name"];
//    [postDic setObject:bank_address forKey:@"bank_address"];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"account.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
