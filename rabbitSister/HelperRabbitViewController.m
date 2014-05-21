//
//  HelperRabbitViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HelperRabbitViewController.h"

#import "GetCateInstruct.h"
#import "XMLRPCResult.h"

@interface HelperRabbitViewController ()

@end

@implementation HelperRabbitViewController
static bool isDetail=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary *_mainDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"HelperRabbit"]];
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:[_mainDic objectForKey:@"infor"]];
        
        Notification__CREATE(NotificationBack,HELPERRABBIT);
    }
    return self;
}

#pragma mark - 监听事件(返回)
- (void)NotificationBack:(NSNotification *) notification
{
//    if (isDetail==YES) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        
//        _helperRabbitDetailVC.view.alpha=0.0f;
//        
//        [UIView commitAnimations];
//        
//        isDetail=NO;
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mianListTable.bounces=NO;
    
//    _helperRabbitDetailVC=[[HelperRabbitDetailViewController alloc] init];
//    [self.view addSubview:_helperRabbitDetailVC.view];
//    _helperRabbitDetailVC.view.alpha=0;
    
    self.navigationItem.title=@"上门兔";
    
    [self reloadInform];
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 重新从网上获取页面内容
-(void)reloadInform
{
    //获取服务器数据
    SHOW__LOADING
    //判断是否已经注册过用户
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
    
    GetCateInstruct *getCate=[[GetCateInstruct alloc] init];
    [getCate getCateInstruct:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] city:[registInfo objectForKey:@"city"] cate_codes:[NSString stringWithFormat:@"15,16,17,18"] success:^(id responseData){
        
//        NSLog(@"呵呵：%@",responseData);
        HIDE__LOADING
        
        XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
        
        if (result.success==YES) {
            _pricesArr=[[NSMutableArray alloc] initWithArray:result.res];
            
//            [_mainInfoArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"家政 %@",[[result.res objectAtIndex:0] objectForKey:@"low"]]];
//            
//            [_mainInfoArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"保健 %@",[[result.res objectAtIndex:1] objectForKey:@"low"]]];
//            
//            [_mainInfoArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"美容 %@",[[result.res objectAtIndex:2] objectForKey:@"low"]]];
//            
//            [_mainInfoArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"修理 %@",[[result.res objectAtIndex:3] objectForKey:@"low"]]];
//            
//            [self.mianListTable reloadData];
            
            
        }else{
            WARNING__ALERT([result.res objectForKey:@"reason"]);
        }
        
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"获取数据失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mainInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelperRabbitCell *cell = (HelperRabbitCell *)[[[NSBundle mainBundle] loadNibNamed:@"HelperRabbitCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.titleLab.text=[_mainInfoArr objectAtIndex:indexPath.row];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _helperRabbitDetailVC=[[HelperRabbitDetailViewController alloc] init];
    [_helperRabbitDetailVC getPriceRange:_pricesArr];
    [_helperRabbitDetailVC chooseWorkType:indexPath.row];
    
    [self.navigationController pushViewController:_helperRabbitDetailVC animated:YES];
    
//    [UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//    
//    [_helperRabbitDetailVC chooseWorkType:indexPath.row];
//    
//	_helperRabbitDetailVC.view.alpha=1.0f;
//    
//    [UIView commitAnimations];
    isDetail=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    Notification__REMOVE
    [_mianListTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMianListTable:nil];
    [super viewDidUnload];
}
@end
