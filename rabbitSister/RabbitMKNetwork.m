//
//  RabbitMKNetwork.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-22.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitMKNetwork.h"
#import "WPXMLRPCEncoder.h"
#import "WPXMLRPCDecoder.h"

@implementation RabbitMKNetwork

+(RabbitMKNetwork *)sharedHTTPClient:(NSString *)paths
{
    
    static dispatch_once_t pred;
    
    static RabbitMKNetwork *_sharedHTTPClient = nil;
    
    dispatch_once(&pred,^{ _sharedHTTPClient = [[self alloc]
                                                initWithFunctionPath:paths];});
    
    return _sharedHTTPClient;
}

-(RabbitMKNetwork *)sharedHTTPClientPathing:(NSString *)paths
{
    RabbitMKNetwork *_sharedHTTPClient = nil;
    _sharedHTTPClient=[self initWithFunctionPath:paths];
    return _sharedHTTPClient;
}

- (id) initWithFunctionPath:(NSString *)path
{
    self = [super initWithHostName:[NSString stringWithFormat:@"api.tojie.com/%@/",path] customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
//    self = [super initWithHostName:@"img.tojie.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
    
    return self;
}

-(void)requestWithMethod:(NSString *)method parameter:(NSDictionary *)parameter
                delegate:(id<MainNetWorkClientDelegate>)delegate HTTPType:(int)HTTPType
{
//    NSLog(@"嘻嘻：%@",parameter);
    
    MKNetworkOperation *op = [self operationWithPath:method params:parameter httpMethod:@"POST" ssl:YES];
    op.clientCertificate = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"clientToJie.p12"];
    op.clientCertificatePassword = @"tojie12345";
    op.shouldContinueWithInvalidCertificate = YES;
    
    //是否使用XMLRPC（上传文件）
    if ([[parameter objectForKey:@"useRpc"] intValue]==0) {
        [op addFile:[parameter objectForKey:@"data"] forKey:@"data"];
    }
//        [op addFile:nil forKey:@"data"];
    
    NSLog(@"获取数据：%@",parameter);
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if ([[parameter objectForKey:@"useRpc"] intValue]==0) {
            [delegate MainNetWorkClientDidFinishRequest:[operation responseString]];
        }else{
            WPXMLRPCDecoder *decoder = [[WPXMLRPCDecoder alloc] initWithData:[operation responseData]];
            if ([decoder isFault]) {
                NSLog(@"解析错误");
            } else {
                
                [delegate MainNetWorkClientDidFinishRequest:[decoder object]];
            }
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
//        NSLog(@"失败：%@", [error localizedDescription]);
        [delegate MainNetWorkClientDidFailed:error];
    }];

    
    [self enqueueOperation:op];
}

@end
