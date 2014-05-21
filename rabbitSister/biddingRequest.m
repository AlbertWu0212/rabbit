//
//  biddingRequest.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "biddingRequest.h"

@implementation biddingRequest

-(void)bidding:(NSString *)type
     book_type:(NSString *)book_type
          page:(NSString *)page
       success:(requesterSuccess)success
        failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:type forKey:@"type"];
    [postDic setObject:book_type forKey:@"book_type"];
    [postDic setObject:page forKey:@"page"];
    [postDic setObject:@"mission.GetOwnMissionList" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
//    NSLog(@"传递参数是：%@",postDic);
    
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"mission.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
