//
//  XMLRPCResult.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-1.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>

//通过XMLRPC获取后的数据
@interface XMLRPCResult : NSObject

@property(assign)BOOL success;
@property(assign)id res;

-(id)initWithStatus:(id)Status;

@end
