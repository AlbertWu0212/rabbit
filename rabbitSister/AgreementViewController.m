//
//  AgreementViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

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
    //返回
    NAVIGATION_BACK(@"  返回");
    
    self.navigationItem.title=@"用户协议";
    
    NSURL *url =[NSURL URLWithString:@"http://api.tojie.com/help/t/agreement.php"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
    self.navigationController.navigationBarHidden=NO;
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainWebView:nil];
    [super viewDidUnload];
}
@end
