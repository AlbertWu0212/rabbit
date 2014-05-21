//
//  RegistBack.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistBack : NSObject

@property(nonatomic,copy)NSString *reason;  //出错时才有

@property(nonatomic,copy)NSString *regkey;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *district;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *reg_time;
@property(nonatomic,copy)NSString *usercode;
@property(nonatomic,copy)NSString *userkey;

+(NSDictionary *)mapping;

@end
