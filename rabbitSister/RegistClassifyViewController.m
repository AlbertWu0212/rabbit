//
//  RegistClassifyViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-2.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistClassifyViewController.h"
#import "PublicDefine.h"

@interface RegistClassifyViewController ()

@end

#define RegistClassifyTableHeight 95
#define RegistClassifyOverTableHeight 134

@implementation RegistClassifyViewController
static bool isFirstReg=YES;//判断是否是上传基本资料后

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        Notification__CREATE(NotificationFun,REGISTCHOOSEMENU);
        Notification__CREATE(NotificationBack,REGISTCHOOSEOVER);
        Notification__CREATE(NotificationHelperBack,HELPERBACK);
        isFirstReg=YES;
    }
    return self;
}

#pragma mark - 监听事件(提交注册)
- (void)NotificationBack:(NSNotification *) notification
{
    //    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    Notification__POST(REGISTSUCCESS,nil);
}

#pragma mark - 监听事件(帮帮返回)
- (void)NotificationHelperBack:(NSNotification *) notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听事件(返回确认)
- (void)NotificationFun:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:REGISTCHOOSEMENU])
    {
        WARNING__ALERT(@"信息提交成功");
        //返回确认
        isFirstReg=NO;
//        NSLog(@"哈哈哈哈哈");
        [self.classifyTab reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"兔子项目说明";
    
    self.navigationController.navigationBar.hidden=NO;
    
    //返回按钮
    NAVIGATION_BACK(@"  上一步");
    
    
    //下一步
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nextNavBtn.png"]
                      forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(next)
     forControlEvents:UIControlEventTouchUpInside];
    rButton.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:12];
    [rButton setTitle:@"下一步" forState:UIControlStateNormal];
    rButton.frame = CGRectMake(0, 0, 55, 27);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
//    UIBarButtonItem *nextBtn=[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(next)];
//    self.navigationItem.rightBarButtonItem=nextBtn;
    
    //读取配置文件
    NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"RegistClassifyPlist"];
    _mainInfoArr=[[NSMutableArray alloc] initWithArray:[mainInfoDic objectForKey:@"infor"]];
    [mainInfoDic release];
    mainInfoDic=nil;
    
    self.classifyTab.bounces=NO;
    self.classifyTab.backgroundColor=[UIColor clearColor];
    self.classifyTab.backgroundView=nil;
    // Do any additional setup after loading the view from its nib.
    
    
    //判断是否已经注册过用户
//    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
//    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
//    if (registInfo.count==0) {
//        isFirstReg=YES;
//    }
}

BACK_ACTION

#pragma mark - 修改isFirstReg状态
-(void)changeStatus:(BOOL)status
{
    isFirstReg=status;
//    isFirstReg=YES;
}

#pragma mark - 跳转到详情
-(void)next
{
    _registVC=[[RegistViewController alloc] init];
    [self.navigationController pushViewController:_registVC animated:YES];
    [_registVC release];
    _registVC=nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mainInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RegistClassifyCell";
    RegistClassifyCell *cell = (RegistClassifyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = (RegistClassifyCell *)[[[NSBundle mainBundle] loadNibNamed:@"RegistClassifyCell" owner:self options:nil] lastObject];
        
        cell.selectionStyle = UITableViewScrollPositionNone;
    }
    
    if (isFirstReg) {
//        cell.chooseMenuBackground.hidden=YES;
        cell.chooseMenuBtn.hidden=YES;
    }else{
//        cell.chooseMenuBackground.hidden=NO;
        cell.chooseMenuBtn.hidden=NO;
        cell.chooseMenuBtn.tag=indexPath.section;
        [cell.chooseMenuBtn addTarget:self action:@selector(selectWork:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.chooseMenuBackground.image=[UIImage imageNamed:[[_mainInfoArr objectAtIndex:indexPath.section] objectForKey:@"title"]];
//    cell.titleLab.text=[[_mainInfoArr objectAtIndex:indexPath.section] objectForKey:@"title"];
    cell.firstLine.text=[[_mainInfoArr objectAtIndex:indexPath.section] objectForKey:@"firstLine"];
    cell.secondLine.text=[[_mainInfoArr objectAtIndex:indexPath.section] objectForKey:@"secondLine"];
    cell.thirdLine.text=[[_mainInfoArr objectAtIndex:indexPath.section] objectForKey:@"thirdLine"];
    
    
    if (indexPath.section==3) {
        CGRect rect;
        
//        rect=cell.firstLine.frame;
//        float heights=rect.size.height;
//        rect.size.height=2*rect.size.height;
//        cell.firstLine.frame=rect;
//        cell.firstLine.numberOfLines=2;
//        
//        
//        rect=cell.secondLine.frame;
//        rect.origin.y+=heights;
//        cell.secondLine.frame=rect;
//        
//        
//        rect=cell.thirdLine.frame;
//        rect.origin.y+=heights;
//        cell.thirdLine.frame=rect;
//        
//        
//        rect=cell.chooseMenuBtn.frame;
//        rect.origin.y+=heights;
//        cell.chooseMenuBtn.frame=rect;
        
        
        
        
        
        rect=cell.firstLine.frame;
        rect.size.height=36;
        cell.firstLine.frame=rect;
        cell.firstLine.numberOfLines=2;
        
        
        rect=cell.secondLine.frame;
        rect.origin.y=15+55;
        cell.secondLine.frame=rect;
        
        
        rect=cell.thirdLine.frame;
        rect.origin.y=15+71;
        cell.thirdLine.frame=rect;
        
        
        rect=cell.chooseMenuBtn.frame;
        rect.origin.y=15+94;
        cell.chooseMenuBtn.frame=rect;
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isFirstReg) {
        self.navigationItem.title=@"兔子申请";
        self.navigationItem.rightBarButtonItem=nil;
        if (indexPath.section==3) {
            return RegistClassifyOverTableHeight+12;
        }
        return RegistClassifyOverTableHeight;
    }
    
    if (indexPath.section==3) {
        return RegistClassifyTableHeight+12;
    }
    return RegistClassifyTableHeight;
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

#pragma mark - 选择工作类型
-(void)selectWork:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    switch (clickBtn.tag) {
        case runer:
            _runnerRabbitVC=[[RunnerRabbitViewController alloc] init];
//            [self.view addSubview:_runnerRabbitVC.view];
            [self.navigationController pushViewController:_runnerRabbitVC animated:YES];
            self.navigationItem.title=@"跑腿兔";
            break;
            
        case helper:
            _helperRabbitVC=[[HelperRabbitViewController alloc] init];
//            [self.view addSubview:_helperRabbitVC.view];
            [self.navigationController pushViewController:_helperRabbitVC animated:YES];
            self.navigationItem.title=@"上门兔";
            break;
            
        case driver:
            _driverRabbitVC=[[DriverRabbitViewController alloc] init];
//            [self.view addSubview:_driverRabbitVC.view];
            [self.navigationController pushViewController:_driverRabbitVC animated:YES];
            self.navigationItem.title=@"开车兔";
            break;
            
        case hotHeart:
            _hotHeartRabbitVC=[[HotHeartRabbitViewController alloc] init];
//            [self.view addSubview:_hotHeartRabbitVC.view];
            [self.navigationController pushViewController:_hotHeartRabbitVC animated:YES];
            self.navigationItem.title=@"帮帮兔";
            break;
            
        default:
            break;
    }
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    
    
//    _RegistServiceClassificationVC=[[RegistServiceClassificationViewController alloc] initWithRegisterType:clickBtn.tag];
//    [self.navigationController pushViewController:_RegistServiceClassificationVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_classifyTab release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setClassifyTab:nil];
    [super viewDidUnload];
}
@end
