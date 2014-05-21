//
//  PSSBaseRequester.h
//  PSS
//
//  Created by Jahnny on 13-5-30.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainNetWorkClient.h"

typedef void (^requesterSuccess)(id responseData);
typedef void (^requesterFailed)(NSError *error);

@interface PSSBaseRequester : NSObject<MainNetWorkClientDelegate>
@property(copy,nonatomic)requesterFailed requesterSuccessBlock;
@property(copy,nonatomic)requesterSuccess requesterFailedBlock;

@end
