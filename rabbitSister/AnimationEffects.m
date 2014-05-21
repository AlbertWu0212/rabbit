//
//  AnimationEffects.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-12.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "AnimationEffects.h"

@implementation AnimationEffects

+(void)MainAnimation:(UIView *)effectView Animations:(Animations)Animations endEffectMoving:(CGRect)endEffectMoving endEffectAlpha:(float)endEffectAlpha time:(float)time overFunction:(id)overFunction
{
    [UIView beginAnimations:@"publicEffect" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    if (overFunction!=nil) {
        [UIView setAnimationDidStopSelector:@selector(overFunction)];
    }
    
    switch (Animations) {
        case moving:
            effectView.frame=endEffectMoving;
            break;
            
        case alpha:
            effectView.alpha=endEffectAlpha;
            break;
            
        default:
            break;
    }
    
    [UIView commitAnimations];
}

@end
