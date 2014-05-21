//
//  MarginViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MarginViewController.h"
#import "MarginRequest.h"
#import "MarginList.h"
#import "XMLRPCResult.h"

#import "TopUpViewController.h"

@interface MarginViewController ()

@end

@implementation MarginViewController
static int page=1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        page=1;
        _mainMarginArr=[[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_mainMarginArr removeAllObjects];
    [self getMargin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainListTable.backgroundColor=[UIColor clearColor];
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    self.mainListTable.backgroundView=nil;
    self.mainListTable.bounces=NO;
    
    self.navigationItem.title=@"保证金";
    
    NAVIGATION_BACK(@"   返回");
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - 保证金余额
-(void)getMargin{
    SHOW__LOADING
    MarginRequest *marg=[[MarginRequest alloc] init];
    [marg margin:^(id responseData){
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            self.moneyLab.text=[NSString stringWithFormat:@"￥%@",[RPCResult.res objectForKey:@"amount"]];
#pragma mark - 保证金列表
            MarginList  *margList=[[MarginList alloc] init];
            [margList MargList:[NSString stringWithFormat:@"%d",page] success:^(id responseData){
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    HIDE__LOADING
                    for (NSDictionary *margDic in [RPCResult.res objectForKey:@"list"]) {
                        [_mainMarginArr addObject:margDic];
                    }
                    [self.mainListTable reloadData];
                }else{
                    HIDE__LOADING
                    WARNING__ALERT(RPCResult.res);
                }
            }failed:^(NSError *error){
                HIDE__LOADING
                WARNING__ALERT(@"网络连接错误");
            }];
        }else{
            HIDE__LOADING
            WARNING__ALERT(RPCResult.res);
        }
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"网络连接错误");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mainMarginArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RabbitCreditCell *cell = (RabbitCreditCell *)[[[NSBundle mainBundle] loadNibNamed:@"RabbitCreditCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.titleLab.text=[self timeZone:[[[_mainMarginArr objectAtIndex:indexPath.row] objectForKey:@"ctime"] intValue]];
    cell.contentLab.text=[[_mainMarginArr objectAtIndex:indexPath.row] objectForKey:@"reason"];
    cell.otherLab.text=[[_mainMarginArr objectAtIndex:indexPath.row] objectForKey:@"amount"];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

#pragma mark - 时间戳转换
- (NSString *)timeZone:(int)times{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
}

#pragma mark - 重置
- (IBAction)topUpClick:(id)sender {
    TopUpViewController *_topUp=[[[TopUpViewController alloc] initWithMoney:self.moneyLab.text] autorelease];
    [self.navigationController pushViewController:_topUp animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [_moneyLab release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [self setMoneyLab:nil];
    [super viewDidUnload];
}
@end
