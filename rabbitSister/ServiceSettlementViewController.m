//
//  ServiceSettlementViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "ServiceSettlementViewController.h"

#import "ServiceSettlementRequest.h"
#import "ServeSettDetail.h"

@interface ServiceSettlementViewController ()

@end

@implementation ServiceSettlementViewController
static int showPage=-1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mainListArr=[[NSMutableArray alloc] init];
        _detailListArr=[[NSMutableArray alloc] init];
        
        showPage=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainListTable.backgroundColor=[UIColor clearColor];
    self.mainListTable.backgroundView=nil;
//    self.mainListTable.bounces=NO;
    
    self.navigationItem.title=@"服务结算";
    
    NAVIGATION_BACK(@"   返回");
    
    [self getSectionList];
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - 获取内层列表
-(void)getSectionDetailList:(NSString *)start end:(NSString *)end
{
    SHOW__LOADING
    ServeSettDetail *_serverDetail=[[ServeSettDetail alloc] init];
    [_serverDetail ServeSeDetail:start end:end success:^(id responseData) {
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            [_detailListArr removeAllObjects];
            HIDE__LOADING
            for (NSDictionary *detailDic in [RPCResult.res objectForKey:@"list"]) {
                [_detailListArr addObject:detailDic];
            }
            [self.mainListTable reloadData];
        }else{
            HIDE__LOADING
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"请检查网络连接是否通畅");
    }];
}
#pragma mark - 获取外层列表
-(void)getSectionList
{
    SHOW__LOADING
    ServiceSettlementRequest *_serviceSettle=[[ServiceSettlementRequest alloc] init];
    [_serviceSettle ServerSett:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
            [_mainListArr removeAllObjects];
            for (NSDictionary *missionDic in [RPCResult.res objectForKey:@"list"]) {
                [_mainListArr addObject:missionDic];
            }
            [self.mainListTable reloadData];
        }else{
            HIDE__LOADING
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"请检查网络连接是否通畅");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mainListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showPage==section) {
        return _detailListArr.count+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RabbitCreditCell *cell = (RabbitCreditCell *)[[[NSBundle mainBundle] loadNibNamed:@"RabbitCreditCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    
    if (indexPath.row==0) {
        cell.spreadView.hidden=NO;
        if (showPage==indexPath.section) {
            cell.spreadView.image=[UIImage imageNamed:@"rebbit_hiden_content.png"];
        }else{
            cell.spreadView.image=[UIImage imageNamed:@"rebbit_show_content.png"];
        }
        cell.mainBackground.image=[UIImage imageNamed:@"bg-_03.png"];
        cell.titleLab.text=[self timeZone:[[[_mainListArr objectAtIndex:indexPath.section] objectForKey:@"end"] intValue]];
        cell.contentLab.text=[[_mainListArr objectAtIndex:indexPath.section] objectForKey:@"title"];
        cell.otherLab.text=[[_mainListArr objectAtIndex:indexPath.section] objectForKey:@"amount"];
    }else{
        
        cell.titleLab.text=[self timeZone:[[[_detailListArr objectAtIndex:indexPath.row-1] objectForKey:@"ctime"] intValue]];
        cell.contentLab.text=[[_detailListArr objectAtIndex:indexPath.row-1] objectForKey:@"reason"];
        cell.otherLab.text=[[_detailListArr objectAtIndex:indexPath.row-1] objectForKey:@"amount"];
    }
    
    
//    if (indexPath.section==2) {
//        cell.otherLab.textColor=[UIColor greenColor];
//        cell.titleLab.textColor=[UIColor greenColor];
//        cell.contentLab.textColor=[UIColor greenColor];
//    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

#pragma mark -点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        if (showPage==indexPath.section) {
            showPage=-1;
            [_detailListArr removeAllObjects];
            [self.mainListTable reloadData];
        }else{
            showPage=indexPath.section;
            [self getSectionDetailList:[[_mainListArr objectAtIndex:indexPath.section] objectForKey:@"start"] end:[[_mainListArr objectAtIndex:indexPath.section] objectForKey:@"end"]];
        }
    }
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
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

#pragma mark - 时间戳转换
- (NSString *)timeZone:(int)times{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
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
