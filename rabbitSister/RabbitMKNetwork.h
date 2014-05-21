//
//  RabbitMKNetwork.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-22.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MKNetworkEngine.h"

#define MainNetWorkClient_GET 0        //判断get传送数据
#define MainNetWorkClient_POST 1       //判断post传送数据

@protocol MainNetWorkClientDelegate <NSObject>
-(void)MainNetWorkClientDidFinishRequest:(id)data;
-(void)MainNetWorkClientDidFailed:(NSError *)error;
@end

@interface RabbitMKNetwork : MKNetworkEngine

- (id) initWithFunctionPath:(NSString *)path;

+(RabbitMKNetwork *)sharedHTTPClient:(NSString *)paths;

-(RabbitMKNetwork *)sharedHTTPClientPathing:(NSString *)paths;

-(void)requestWithMethod:(NSString *)method parameter:(NSDictionary *)parameter
                delegate:(id<MainNetWorkClientDelegate>)delegate HTTPType:(int)HTTPType;

@end
