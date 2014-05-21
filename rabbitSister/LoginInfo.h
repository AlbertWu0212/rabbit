//
//  LoginInfo.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>

//判断返回是否正常
@interface LoginInfo : NSObject

@property(assign)BOOL success;
@property(assign)id res;

-(id)initWithStatus:(id)Status;

@end
