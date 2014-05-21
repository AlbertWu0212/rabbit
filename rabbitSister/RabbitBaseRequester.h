//
//  RabbitBaseRequester.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RabbitMKNetwork.h"

typedef void (^requesterSuccess)(id responseData);
typedef void (^requesterFailed)(NSError *error);

@interface RabbitBaseRequester : NSObject<MainNetWorkClientDelegate>
@property(copy,nonatomic)requesterSuccess requesterSuccessBlock;
@property(copy,nonatomic)requesterFailed requesterFailedBlock;

@end
