//
//  BasePublicClient.h
//  PSS
//
//  Created by Jahnny on 13-5-20.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface BasePublicClient : NSObject
{
    MBProgressHUD   *hud;//小转子
}

-(void)publicAlert:(NSString *)alertText view:(UIView *)view;//默认警告框

@end
