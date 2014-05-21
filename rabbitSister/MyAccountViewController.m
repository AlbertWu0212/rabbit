//
//  MyAccountViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController
static bool isBack=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isBack=NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isBack=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"我的账户";
    
    NAVIGATION_BACK(@"   返回");
    
    self.mainListTable.bounces=NO;
    self.mainListTable.backgroundView=nil;
    self.mainListTable.backgroundColor=[UIColor clearColor];
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    // Do any additional setup after loading the view from its nib.
}

//BACK_ACTION
-(void)backAction{
    if (isBack==YES) {
        return;
    }
//    NSLog(@"456456");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
            cell.titleLab.text=@"服务结算";
            break;
            
        case 1:
            cell.titleLab.text=@"保证金";
            break;
            
        case 2:
            cell.titleLab.text=@"我的银行卡";
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
    isBack=YES;
//    NSLog(@"789789");

    switch (indexPath.section) {
        case 0:
            _serviceSettlementVC=[[ServiceSettlementViewController alloc] init];
            [self.navigationController pushViewController:_serviceSettlementVC animated:YES];
            break;
            
        case 1:
            _marginVC=[[MarginViewController alloc] init];
            [self.navigationController pushViewController:_marginVC animated:YES];
            break;
            
        case 2:
            _myBankCardVC=[[MyBankCardViewController alloc] init];
            [self.navigationController pushViewController:_myBankCardVC animated:YES];
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
