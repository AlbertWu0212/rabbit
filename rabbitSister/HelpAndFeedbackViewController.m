//
//  HelpAndFeedbackViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "HelperAndFeedbackRequest.h"

#import "XMLRPCResult.h"

@interface HelpAndFeedbackViewController ()

@end

@implementation HelpAndFeedbackViewController
static bool isWriten=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"帮助与反馈";
    NAVIGATION_BACK(@"返回");
    
    self.feedbackTextView.delegate=self;
    [self.feedbackTextView addPreviousNextDoneOnKeyboardWithTarget:self
                                                   previousAction:nil
                                                       nextAction:nil
                                                       doneAction:@selector(doneClicked:)];
    [self.feedbackTextView setEnablePrevious:NO next:YES];
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (isWriten==NO) {
        self.feedbackTextView.text = @"";
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    isWriten=YES;
}

- (IBAction)submit:(id)sender {
    isWriten=YES;
    if (self.feedbackTextView.text.length==0) {
        WARNING__ALERT(@"请将信息填写完整");
        return;
    }
    
    if ([self.feedbackTextView.text isEqualToString:@"请填写您的意见建议"]) {
        WARNING__ALERT(@"请填写您的反馈");
        return;
    }
    SHOW__LOADING
    HelperAndFeedbackRequest *feedBack=[[HelperAndFeedbackRequest alloc] init];
    [feedBack PostFeedback:self.feedbackTextView.text success:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
            WARNING__ALERT(@"提交成功");
        }else{
//            NSLog(@"呵呵：%@",responseData);
            HIDE__LOADING
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"网络连接错误，请检查您的网络连接");
    }];
}

#pragma mark - 结束编辑
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_feedbackTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFeedbackTextView:nil];
    [super viewDidUnload];
}
@end
