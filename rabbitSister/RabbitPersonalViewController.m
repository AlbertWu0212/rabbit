//
//  RabbitPersonalViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitPersonalViewController.h"

@interface RabbitPersonalViewController ()
{
    SDWebImageManager *manager;
}

@end

@implementation RabbitPersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"PersonalMainList"];
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:[mainInfoDic objectForKey:@"infor"]];
        [mainInfoDic release];
        mainInfoDic=nil;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取个人信息
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *loginInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    //用户名
    _personalDic=[[NSMutableDictionary alloc] init];
    [_personalDic setObject:[loginInfo objectForKey:@"username"] forKey:@"username"];
    [_personalDic setObject:[loginInfo objectForKey:@"status"] forKey:@"status"];
    //所在地
    PSSFileOperations *fileOperation=[[PSSFileOperations alloc] init];
    [_personalDic setObject:[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@",[loginInfo objectForKey:@"city"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"] forKey:@"city"];
    //头像
    [_personalDic setObject:[NSString stringWithFormat:@"%@",[loginInfo objectForKey:@"image"]] forKey:@"image"];
    
    [self.personalTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.personalTableView.backgroundView=self.backgroundImg;
    self.personalTableView.backgroundColor=[UIColor clearColor];
    self.personalTableView.bounces=NO;
    
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    RabbitPersonalCell *cell = (RabbitPersonalCell *)[[[NSBundle mainBundle] loadNibNamed:@"RabbitPersonalCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.section>0) {
        CGRect  tRect;
        tRect=cell.backgroundImg.frame;
        tRect.size.height=34;
        cell.backgroundImg.frame=tRect;
        
        cell.personalHeadImg.hidden=YES;
        cell.personalLocal.hidden=YES;
        cell.personalName.hidden=YES;
        
        cell.previousLogo.image=[UIImage imageNamed:[[_mainInfoArr objectAtIndex:indexPath.section-1] objectForKey:@"image"]];
        cell.functionLab.text=[[_mainInfoArr objectAtIndex:indexPath.section-1] objectForKey:@"title"];
    }else{
        cell.previousLogo.hidden=YES;
        cell.functionLab.hidden=YES;
        
//        NSLog(@"哈哈：%@",_personalDic);
        switch ([[_personalDic objectForKey:@"status"] intValue]) {
            case 1:
                cell.personalName.text=[NSString stringWithFormat:@"%@(审核)",[_personalDic objectForKey:@"username"]];
                break;
                
            case 3:
                cell.personalName.text=[NSString stringWithFormat:@"%@(锁定)",[_personalDic objectForKey:@"username"]];
                break;
                
            default:
                cell.personalName.text=[NSString stringWithFormat:@"%@(正常)",[_personalDic objectForKey:@"username"]];
                break;
        }
        
        
        cell.personalLocal.text=[_personalDic objectForKey:@"city"];
        //设置头像
        [manager downloadWithURL:[NSURL URLWithString:[_personalDic objectForKey:@"image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
            
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
            cell.personalHeadImg.image=image;
        }];
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 68;
    }
    return 34;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
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

#pragma mark - 选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            Notification__POST(PERSONALPUSH,nil);
            break;
            
        case 1:
            Notification__POST(CREDITPUSH, nil);
            break;
            
        case 2:
            Notification__POST(MYACCOUNT, nil);
            break;
            
        case 3:
            Notification__POST(SETUP, nil);
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_personalTableView release];
    [_backgroundImg release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPersonalTableView:nil];
    [self setBackgroundImg:nil];
    [super viewDidUnload];
}
@end
