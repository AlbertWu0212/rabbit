//
//  timeLocal.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "timeLocal.h"

@implementation timeLocal

-(void)timeLocal:(NSString *)lat
             lng:(NSString *)lng
         success:(requesterSuccess)success
          failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSLog(@"开启定时定位");
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:lat forKey:@"lat"];
    [postDic setObject:lng forKey:@"lng"];
    [postDic setObject:@"server.SaveUserGps" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"server.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
