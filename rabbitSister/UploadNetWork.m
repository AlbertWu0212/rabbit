//
//  UploadNetWork.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "UploadNetWork.h"

@implementation UploadNetWork

-(void)upload:(NSString *)type
         data:(NSString *)data
      success:(requesterSuccess)success
       failed:(requesterFailed)failed
{
    //useRpc为1时使用RPC格式，否则使用普通格式
    //data为文件路径
//    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
//    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    RabbitMKNetwork *rabbitMk=[[RabbitMKNetwork alloc] initWithFunctionPath:@"c"];
    [rabbitMk requestWithMethod:@"upload.php" parameter:@{@"userkey":@"0bb2cb1f2a52",@"type":type,@"data":data,@"initWithMethod":@"/c/upload.php",@"useRpc":@"0"} delegate:self HTTPType:BaseHTTPClient_POST];
    [rabbitMk release];
    rabbitMk=nil;
    
    self.requesterSuccessBlock = success;
    self.requesterFailedBlock = failed;
}

@end
