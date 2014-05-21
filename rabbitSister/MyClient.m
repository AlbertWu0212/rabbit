//
//  MyClient.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-27.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MyClient.h"

@implementation MyClient

- (void)getHtml:(NSString *)path
{
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.tojie.com/e/user.php?userkey=eb25d21c8595&username=liuchuang02&password=liuchuang02"]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://localhost"]];
    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success=%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

@end
