//
//  AboutRabbitViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "AboutRabbitViewController.h"

#import "AgreementViewController.h"
#import "aboutWebViewController.h"

@interface AboutRabbitViewController ()
{
    AgreementViewController *_agreementVC;
    aboutWebViewController  *_aboutWebVC;
}
@end

@implementation AboutRabbitViewController

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
    self.navigationItem.title=@"关于兔街";
    
    self.mainListTable.bounces=NO;
    self.mainListTable.backgroundView=nil;
    self.mainListTable.backgroundColor=[UIColor clearColor];
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    
    NAVIGATION_BACK(@"   返回");
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAccountCell *cell = (MyAccountCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyAccountCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    switch (indexPath.section) {
        case 0:
            cell.titleLab.text=@"关于";
            break;
            
        case 1:
            cell.titleLab.text=@"帮助与反馈";
            break;
        
//        case 2:
//            cell.titleLab.text=@"帮助与反馈";
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            _aboutWebVC=[[aboutWebViewController alloc] init];
            [self.navigationController pushViewController:_aboutWebVC animated:YES];
            [_aboutWebVC release];
            _aboutWebVC=nil;
            break;
            
        case 1:
//            _systemNotificationVC=[[SystemNotificationViewController alloc] init];
//            [self.navigationController pushViewController:_systemNotificationVC animated:YES];
            
            
            _helperFeed=[[HelpAndFeedbackViewController alloc] init];
            [self.navigationController pushViewController:_helperFeed animated:YES];
//            _functionIntroduceVC=[[functionIntroduceViewController alloc] init];
//            [self.navigationController pushViewController:_functionIntroduceVC animated:YES];
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [super viewDidUnload];
}
@end
