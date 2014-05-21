//
//  AnimationEffects.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-12.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicDefine.h"

@interface AnimationEffects : NSObject

+(void)MainAnimation:(UIView *)effectView Animations:(Animations)Animations endEffectMoving:(CGRect)endEffectMoving endEffectAlpha:(float)endEffectAlpha time:(float)time overFunction:(id)overFunction;

@end
