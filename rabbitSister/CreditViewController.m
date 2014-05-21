//
//  CreditViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "CreditViewController.h"
#import "CreditEvaluationRequest.h"
#import "XMLRPCResult.h"

#import "LoadingMoreFooterView.h"
#import "EGORefreshTableHeaderView.h"

#define REFRESHINGVIEW_HEIGHT 128

@interface CreditViewController ()
{
    SDWebImageManager *manager;
}
@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@property(nonatomic,readwrite) BOOL loadingmore;

@property(nonatomic, retain) EGORefreshTableHeaderView * refreshHeaderView;  //下拉刷新
@property(nonatomic, readwrite) BOOL isRefreshing;

@end

@implementation CreditViewController
static int page=1;
@synthesize loadFooterView=_loadFooterView,loadingmore=_loadingmore;
@synthesize refreshHeaderView=_refreshHeaderView,isRefreshing=_isRefreshg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        page=1;
        _allCredInfo=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"信用评价";
    
    NAVIGATION_BACK(@"   返回");
    
    self.mainListTable.backgroundView=nil;
    self.mainListTable.backgroundColor=[UIColor clearColor];
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *userInfoDic=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    [manager downloadWithURL:[NSURL URLWithString:[userInfoDic objectForKey:@"rank_img"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        self.levelImg.image=image;
    }];
    
    /***************刷新***************/
    self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,  -REFRESHINGVIEW_HEIGHT, self.mainListTable.frame.size.width,REFRESHINGVIEW_HEIGHT)] autorelease];
    [self.mainListTable addSubview:self.refreshHeaderView];
    self.isRefreshing = NO;
    /***************刷新***************/
    
    /***************更多***************/
    self.loadFooterView.hidden=NO;
    self.loadFooterView=[[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0, self.mainListTable.contentSize.height+20, self.mainListTable.contentSize.width, 44.f)];
    [self.mainListTable addSubview:self.loadFooterView];
    self.loadingmore = NO;
    /***************更多***************/
    
    [self getCredit];
    // Do any additional setup after loading the view from its nib.
}

-(void)getCredit
{
    SHOW__LOADING
    CreditEvaluationRequest *credit=[[CreditEvaluationRequest alloc] init];
    
    [credit evaluation:[NSString stringWithFormat:@"%d",page] success:^(id responseData){
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
            
            if (self.isRefreshing==YES) {
                _allCredInfo=[RPCResult.res objectForKey:@"list"];
            }else{
                if (self.loadingmore==YES) {
                    for (NSDictionary *listDic in [RPCResult.res objectForKey:@"list"]) {
                        [_allCredInfo addObject:listDic];
                    }
                }else{
                    _allCredInfo=[RPCResult.res objectForKey:@"list"];
                }
            }
            
            
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainListTable];
            self.isRefreshing=NO;
            [self.mainListTable reloadData];
            
            self.loadFooterView.showActivityIndicator = NO;
            self.loadFooterView.frame=CGRectMake(0, self.mainListTable.contentSize.height, self.mainListTable.contentSize.width, 44.f);
            
            NSArray *tArr=RPCResult.res;
            if (tArr.count<10) {
                self.loadFooterView.hidden=YES;
                self.loadingmore = YES;
            }else{
                self.loadingmore = NO;
                self.loadFooterView.hidden=NO;
            }
            
            [self.mainListTable reloadData];
        }else{
            HIDE__LOADING
            WARNING__ALERT(@"获取列表数据失败");
        }
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"网络连接错误");
    }];
}

BACK_ACTION

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allCredInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RabbitCreditCell *cell = (RabbitCreditCell *)[[[NSBundle mainBundle] loadNibNamed:@"RabbitCreditCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.titleLab.text=[self timeZone:[[[_allCredInfo objectAtIndex:indexPath.row] objectForKey:@"ctime"] intValue]];
    
    cell.contentLab.text=[[_allCredInfo objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    NSString *levelStr;
    switch ([[[_allCredInfo objectAtIndex:indexPath.row] objectForKey:@"level"] intValue]) {
        case 1:
            levelStr=@"好评";
            break;
            
        case 2:
            levelStr=@"中评";
            break;
            
        case 3:
            levelStr=@"差评";
            break;
            
        case 4:
            levelStr=@"投诉";
            break;
            
        default:
            break;
    }
    cell.otherLab.text=levelStr;
    
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

#pragma mark - scrollView刷新，更多
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
    /********************上拉刷新**********************/
    if (scrollView_.contentOffset.y<-35) {
        [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView_];
        self.isRefreshing = YES;
    }
    /********************上拉刷新**********************/
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isRefreshing == YES) {
        if (scrollView.contentOffset.y<-35) {
            [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
            page=1;
            [self getCredit];
        }else{
            self.isRefreshing = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
        }
    }
    
    /********************下拉更多**********************/
    //滑动标准
    float scrollStandard=self.mainListTable.contentSize.height-self.mainListTable.frame.size.height;
    if (scrollView.contentOffset.y>scrollStandard+35&&self.loadingmore==NO) {
        self.loadingmore=YES;
        self.loadFooterView.showActivityIndicator = YES;
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        scrollView.contentSize=CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+65);
        scrollView.contentOffset=CGPointMake(0, bottomEdge);
        page+=1;
        [self getCredit];
    }
    /********************下拉更多**********************/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [_levelImg release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [self setLevelImg:nil];
    [super viewDidUnload];
}
@end
