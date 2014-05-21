//
//  LoginBack.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>

//主要返回数据
@interface LoginBack : NSObject

@property(nonatomic,copy)NSString *usercode;
@property(nonatomic,copy)NSString *userkey;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *reg_time;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *district;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *status;

+(NSDictionary *)mapping;

@end
