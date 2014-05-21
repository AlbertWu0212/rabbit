//
//  MainNetWorkClient.h
//  PSS
//
//  Created by Jahnny on 13-5-30.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "AFNetworking.h"

#define MainNetWorkClient_GET 0        //判断get传送数据
#define MainNetWorkClient_POST 1       //判断post传送数据

@protocol MainNetWorkClientDelegate <NSObject>
-(void)MainNetWorkClientDidFinishRequest:(id)data;
-(void)MainNetWorkClientDidFailed:(NSError *)error;
@end

@interface MainNetWorkClient : AFHTTPClient
+(MainNetWorkClient *)sharedHTTPClient;
-(id)initWithBaseURL:(NSURL *)url;
-(void)requestWithMethod:(NSString *)method parameter:(NSDictionary *)parameter
                delegate:(id<MainNetWorkClientDelegate>)delegate HTTPType:(int)HTTPType;
@end
