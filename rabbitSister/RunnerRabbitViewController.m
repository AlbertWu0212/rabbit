//
//  RunnerRabbitViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RunnerRabbitViewController.h"
#import "GetCateInstruct.h"
#import "XMLRPCResult.h"

#import "SubmitRabbitType.h"

@interface RunnerRabbitViewController ()

@end

@implementation RunnerRabbitViewController
static bool chooseFirst=YES;
static bool chooseSecond=YES;
static bool chooseThird=YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSDictionary *_mainDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"RunnerRabbit"]];
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:[_mainDic objectForKey:@"infor"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainListTab.bounces=NO;
    
    self.navigationItem.title=@"跑腿兔";
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    
    SHOW__LOADING
    //判断是否已经注册过用户
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
    
    GetCateInstruct *getCate=[[GetCateInstruct alloc] init];
    [getCate getCateInstruct:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] city:[registInfo objectForKey:@"city"] cate_codes:[NSString stringWithFormat:@"11,12,13"] success:^(id responseData){
//        NSLog(@"哈哈：%@",responseData);
        HIDE__LOADING
        
        XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
        if (result.success==YES) {
            //总的价钱数据
            NSArray *priceArr=[[NSArray alloc] initWithArray:result.res];
            
            [[_mainInfoArr objectAtIndex:0] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"代购 %@",[[priceArr objectAtIndex:0] objectForKey:@"low"]]];
            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"代办 %@",[[priceArr objectAtIndex:1] objectForKey:@"low"]]];
            [[_mainInfoArr objectAtIndex:2] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"速递 %@",[[priceArr objectAtIndex:2] objectForKey:@"low"]]];
            
            [self.mainListTab reloadData];
        }else{
            WARNING__ALERT([result.res objectForKey:@"reason"]);
        }
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"获取数据失败，请您检查网络连接是否通常");
    }];
    
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

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
    RunnerRabbitCell *cell = (RunnerRabbitCell *)[[[NSBundle mainBundle] loadNibNamed:@"RunnerRabbitCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.chooseBtn.tag=indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleLab.text=[[_mainInfoArr objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.contentLab.text=[[_mainInfoArr objectAtIndex:indexPath.row] objectAtIndex:1];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    if (chooseFirst==YES||chooseSecond==YES||chooseThird==YES) {
        
        NSMutableArray *submitTypeArr=[[NSMutableArray alloc] init];
        if (chooseFirst==YES) {
            [submitTypeArr addObject:@"110,111,112,113,114"];
        }
        
        if (chooseSecond==YES) {
            [submitTypeArr addObject:@"120,121,122,123"];
        }
        
        if (chooseThird==YES) {
            [submitTypeArr addObject:@"130,131,132"];
        }
        
        
        
        NSString *submitString=@"";
        int i=0;
        for (NSString *tString in submitTypeArr) {
            if (i==0) {
                submitString=[NSString stringWithFormat:@"%@",tString];
            }else{
                submitString=[NSString stringWithFormat:@"%@,%@",submitString,tString];
            }
            
            i+=1;
        }
        
        
        SHOW__LOADING
        //判断是否已经注册过用户
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
        
        SubmitRabbitType *_submitRabbit=[[SubmitRabbitType alloc] init];
        [_submitRabbit submitType:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] type:@"1" level:@"1" cates:submitString otherDic:nil success:^(id responseData){
            
            HIDE__LOADING;
            
            XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
            if (result.success==YES) {
                //跳转注释
                Notification__POST(REGISTCHOOSEOVER,nil);
            }else{
                WARNING__ALERT([result.res objectForKey:@"reason"]);
            }
            
        }failed:^(NSError *error){
            HIDE__LOADING;
            WARNING__ALERT(@"请检查您的网络连接是否正常");
            return;
        }];
    }else{
        HIDE__LOADING
        WARNING__ALERT(@"必须选中一项才能提交");
        return;
    }
}

#pragma mark - 选择类型
-(void)chooseType:(id)sender{
    UIButton *clickBtn=(UIButton *)sender;
    
    switch (clickBtn.tag) {
        case 0:
            chooseFirst?[clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal]:[clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            chooseFirst=!chooseFirst;
            break;
            
        case 1:
            chooseSecond?[clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal]:[clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            chooseSecond=!chooseSecond;
            break;
            
        case 2:
            chooseThird?[clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal]:[clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            chooseThird=!chooseThird;
            break;
            
        default:
            break;
    }
    
    if (chooseSecond==NO&&chooseFirst==NO&&chooseThird==NO) {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=NO;
    }else{
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTab release];
    [_submitBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTab:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
}
@end
