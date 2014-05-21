//
//  BasePublicClient.m
//  PSS
//
//  Created by Jahnny on 13-5-20.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "BasePublicClient.h"

@implementation BasePublicClient

#pragma mark 警告框
-(void)publicAlert:(NSString *)alertText view:(UIView *)view
{
    hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = alertText;
    hud.margin = 10.f;
    hud.yOffset = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end
