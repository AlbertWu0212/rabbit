//
//  aboutWebViewController.m
//  rabbitSister
//
//  Created by Jahnny on 14-2-21.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "aboutWebViewController.h"

@interface aboutWebViewController ()

@end

@implementation aboutWebViewController

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
    
    self.navigationItem.title=@"关于兔子";
    
    NSURL *url =[NSURL URLWithString:@"http://api.tojie.com/help/t/about.php"];
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
