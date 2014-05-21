//
//  MainNetWorkClient.m
//  PSS
//
//  Created by Jahnny on 13-5-30.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MainNetWorkClient.h"

@implementation MainNetWorkClient
+(MainNetWorkClient *)sharedHTTPClient
{
//    NSString *urlStr = @"https://api.tojie.com/e/";
    NSString *urlStr = @"https://localhost";
    static dispatch_once_t pred;
    static MainNetWorkClient *_sharedHTTPClient = nil;
    dispatch_once(&pred,^{ _sharedHTTPClient = [[self alloc]
                                                initWithBaseURL:[NSURL URLWithString:urlStr]];});
    
    return _sharedHTTPClient;
}

#pragma mark 网络请求初始化
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    [self setAllowsInvalidSSLCertificate:YES];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark 网络请求协议
-(void)requestWithMethod:(NSString *)method parameter:(NSDictionary *)parameter
                delegate:(id<MainNetWorkClientDelegate>)delegate HTTPType:(int)HTTPType
{
    
    if (HTTPType==MainNetWorkClient_GET) {
        [self getPath:method parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [delegate MainNetWorkClientDidFinishRequest:responseObject];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [delegate MainNetWorkClientDidFailed:error];
         }];
    }else{
        [self postPath:method parameters:parameter
               success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [delegate MainNetWorkClientDidFinishRequest:responseObject];
         }
               failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [delegate MainNetWorkClientDidFailed:error];
         }];
    }
}
@end
