//
//  IQTextView.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-7.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

/*****************IQKeyBoardManager***********************/
@interface IQKeyBoardManagerTextView : NSObject
{
    //Boolean to maintain keyboard is showing or it is hide. To solve rootViewController.view.frame calculations;
    BOOL isKeyboardShowing;
    
    //To save rootViewController.view.frame.
    CGRect topViewBeginRect;
    
    //TextField or TextView object.
    UIView *textFieldView;
    
    //To save keyboard animation duration.
    CGFloat animationDuration;
    
    // To save keyboard size
    CGSize kbSize;
}

//Call it on your AppDelegate to initialize keyboardManager;
+(void)installKeyboardManager;

//To set keyboard distance from textField
+(void)setTextFieldDistanceFromKeyboard:(CGFloat)distance;  /*can't be less than zero. Default is 10.0*/

//Enable keyboard manager.
+(void)enableKeyboardManger;    /*default enabled*/

//Desable keyboard manager.
+(void)disableKeyboardManager;

//return YES if keyboard manager is enabled.
+(BOOL)isEnabled;

@end

/*****************UITextField***********************/
@interface UITextView (ToolbarOnKeyboard)

//Helper functions to add Done button on keyboard.
-(void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

//Helper function to add SegmentedNextPrevious and Done button on keyboard.
-(void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

//Helper methods to enable and desable previous next buttons.
-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;


@end


/*****************IQSegmentedNextPrevious***********************/
@interface IQSegmentedNextPreviousTextView : UISegmentedControl
{
    id buttonTarget;
    SEL previousSelector;
    SEL nextSelector;
}
-(id)initWithTarget:(id)target previousSelector:(SEL)pSelector nextSelector:(SEL)nSelector;

@end