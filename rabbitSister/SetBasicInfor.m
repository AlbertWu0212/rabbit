//
//  SetBasicInfor.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "SetBasicInfor.h"

@implementation SetBasicInfor

-(void)basicInfo:(NSString *)user_nick
      user_image:(NSString *)user_image
        province:(NSString *)province
            city:(NSString *)city
        district:(NSString *)district
         address:(NSString *)address
    station_name:(NSString *)station_name
         success:(requesterSuccess)success
          failed:(requesterFailed)failed
{
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    NSMutableDictionary   *postDic=[[NSMutableDictionary alloc] init];
    [postDic setObject:[registInfo objectForKey:@"usercode"] forKey:@"usercode"];
    [postDic setObject:[registInfo objectForKey:@"userkey"] forKey:@"userkey"];
    [postDic setObject:@"user.SetBasicInfo" forKey:@"initWithMethod"];
    [postDic setObject:@"1" forKey:@"useRpc"];
    [postDic setObject:user_nick forKey:@"user_nick"];
    [postDic setObject:user_image forKey:@"user_image"];
    [postDic setObject:province forKey:@"province"];
    [postDic setObject:station_name forKey:@"station_name"];
    [postDic setObject:city forKey:@"city"];
    [postDic setObject:district forKey:@"district"];
    [postDic setObject:address forKey:@"address"];
    
    [[RabbitMKNetwork sharedHTTPClient:@"t"] requestWithMethod:@"user.php" parameter:postDic delegate:self HTTPType:BaseHTTPClient_POST];
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
