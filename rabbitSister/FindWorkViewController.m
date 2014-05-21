//
//  FindWorkViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-12.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "FindWorkViewController.h"
#import "PublicDefine.h"

#import "GetRabbitMission.h"
#import "GetMissionDetail.h"
#import "XMLRPCResult.h"

#import <MAMapKit/MAMapKit.h>

#import "MapViewController.h"

#import "LoadingMoreFooterView.h"
#import "EGORefreshTableHeaderView.h"

#import "AFJSONRequestOperation.h"

#import "timeLocal.h"

#import "SoundPlayer.h"

#define REFRESHINGVIEW_HEIGHT 128

@interface FindWorkViewController ()
{
    SDWebImageManager *manager;
    
    timeLocal           *_timeLocal;
    
    
    SoundPlayer *_soundPlayer;
}
@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@property(nonatomic,readwrite) BOOL loadingmore;

@property(nonatomic, retain) EGORefreshTableHeaderView * refreshHeaderView;  //下拉刷新
@property(nonatomic, readwrite) BOOL isRefreshing;

@property (nonatomic, retain)UISegmentedControl *showSegment;

@property (nonatomic, retain)UISegmentedControl *modeSegment;



@end

@implementation FindWorkViewController
@synthesize mapView = _mapView;
@synthesize search  = _search;
@synthesize showSegment, modeSegment;

static int rabbitMissionType=0;
static int page=0;

static bool localSuccess=NO;       //判断定位成功失败

static int reload=1;

static bool isLoadAll=NO;           //是否全部加载完毕

@synthesize loadFooterView=_loadFooterView,loadingmore=_loadingmore;
@synthesize refreshHeaderView=_refreshHeaderView,isRefreshing=_isRefreshg;

static bool isFirst=YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _localDic=[[NSMutableDictionary alloc] init];
        
        _allInfoArr=[[NSMutableArray alloc] init];
        _localArr=[[NSMutableArray alloc] init];
        
        _timeTitleArr=[[NSMutableArray alloc] init];
        
        _titleImgArr=[[NSMutableArray alloc] init];
        
        _subscribeInfoArr=[[NSMutableArray alloc] init];
        
        _timeLocal=[[timeLocal alloc] init];
        
        _soundPlayer=[[SoundPlayer alloc] init];
        
        Notification__CREATE(NotificationPostLocal, GETLOCATION);
        
        Notification__CREATE(NotificationNewMission, PUBLISHMISSION);
    }
    return self;
}

#pragma mark - 发送定位信息
- (void)NotificationPostLocal:(NSNotification *) notification
{
    if (_localDic.count==0) {
        return;
    }
    [_timeLocal timeLocal:[_localDic objectForKey:@"latitude"] lng:[_localDic objectForKey:@"longitude"] success:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        if (RPCResult.success==YES) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败哈哈");
        }
    } failed:^(NSError *error) {
        NSLog(@"失败");
    }];
//    Notification__POST(POSTLOCATION, _localDic);
}

#pragma mark - 收到新消息
- (void)NotificationNewMission:(NSNotification *) notification
{
    [_soundPlayer playSound:@"info_come"];
    switch ([[notification.userInfo objectForKey:@"booktype"] intValue]) {
        case 1:
            self.emergencyDian.hidden=NO;
            break;
            
        case 2:
            self.todayDian.hidden=NO;
            break;
            
        case 3:
            self.subscribeDian.hidden=NO;
            break;
            
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    HIDE__LOADING

//    [_allInfoArr removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainList.backgroundView=nil;
    self.mainList.backgroundColor=[UIColor clearColor];
    //    self.mainList.bounces=NO;
    
    /***************高德地图定位和计算***************/
    [MAMapServices sharedServices].apiKey=@"df653578c0349768e7c43c866a95c448";
    self.search = [[AMapSearchAPI alloc] initWithSearchKey: @"df653578c0349768e7c43c866a95c448" Delegate:self];
    self.search.delegate = self;
    self.mapView=[[MAMapView alloc] init];
    self.mapView.frame = CGRectMake(0, 0, 320, 480);
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.strategy=1;
    naviRequest.searchType = AMapSearchType_NaviDrive;
    naviRequest.requireExtension = YES;
    /***************高德地图定位和计算***************/
    
    
    /***************刷新***************/
    self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,  -REFRESHINGVIEW_HEIGHT, self.mainList.frame.size.width,REFRESHINGVIEW_HEIGHT)] autorelease];
    [self.mainList addSubview:self.refreshHeaderView];
    self.isRefreshing = NO;
    /***************刷新***************/
    
    /***************更多***************/
    self.loadFooterView.hidden=YES;
    self.loadFooterView=[[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0, self.mainList.contentSize.height, self.mainList.contentSize.width, 44.f)];
    [self.mainList addSubview:self.loadFooterView];
    self.loadingmore = NO;
    /***************更多***************/
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 获取驾车路径
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    reload+=1;
    AMapPath *mapPath=[response.route.paths objectAtIndex:0];
    
    int i=0;
    for (NSDictionary *infoDic in _allInfoArr) {
        if ([[infoDic objectForKey:@"mission_lat"] floatValue]==response.route.destination.latitude) {
            if ([[_localArr objectAtIndex:i] isEqualToString:@"无法定位获取"]) {
                [_localArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d米",mapPath.distance]];
                break;
            }
        }
        i+=1;
    }
    
//    response.route.destination.latitude
//    response.route.destination.longitude
    
    if (reload==_allInfoArr.count) {
        HIDE__LOADING
        
        self.isRefreshing=NO;
        [self.mainList reloadData];
        
        self.loadFooterView.showActivityIndicator = NO;
        self.loadFooterView.frame=CGRectMake(0, self.mainList.contentSize.height, self.mainList.contentSize.width, 44.f);
        self.loadingmore = NO;
        self.loadFooterView.hidden=NO;
        
        if (isLoadAll==YES) {
            self.loadingmore = YES;
            self.loadFooterView.hidden=YES;
        }
        
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainList];
    }
}

- (void)search:(id)searchRequest error:(NSString*)errInfo
{
    if (errInfo) {
        reload+=1;
//        [_localArr addObject:@"无法定位获取"];
    }
    if (reload==_allInfoArr.count) {
        HIDE__LOADING
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainList];
        self.isRefreshing=NO;
        [self.mainList reloadData];
        
        self.loadFooterView.showActivityIndicator = NO;
        self.loadFooterView.frame=CGRectMake(0, self.mainList.contentSize.height, self.mainList.contentSize.width, 44.f);
        self.loadingmore = NO;
        self.loadFooterView.hidden=NO;
        
        if (isLoadAll==YES) {
            self.loadingmore = YES;
            self.loadFooterView.hidden=YES;
        }
    }
}

#pragma mark - 定位本地经纬度
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
{
    [_localDic setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [_localDic setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"longitude"];
    if (localSuccess==NO) {
        localSuccess=YES;
        [self reloadInform];
    }
    
    if (isFirst==YES) {
        isFirst=NO;
        [_timeLocal timeLocal:[_localDic objectForKey:@"latitude"] lng:[_localDic objectForKey:@"longitude"] success:^(id responseData) {
            XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
            
            if (RPCResult.success==YES) {
                NSLog(@"成功");
            }else{
                NSLog(@"失败哈哈");
            }
        } failed:^(NSError *error) {
            NSLog(@"失败");
        }];
    }
    localSuccess=YES;
}

-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
//    NSLog(@"失败：%@",error);
    localSuccess=NO;
    
//    Notification__POST(NOLOCATION, nil);
}

#pragma mark - 获取信息详情
-(void)getDetailInform:(NSString *)demand_en local:(NSString *)local
{
    SHOW__LOADING
    //抽取本地信息
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    GetMissionDetail *_getMission=[[GetMissionDetail alloc] init];
    [_getMission getMissionDetail:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] demand_en:demand_en success:^(id responseData){
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        if (RPCResult.success==YES) {
            HIDE__LOADING;
//            NSLog(@"呵呵：%@",RPCResult.res);
            NSDictionary *postDic=[[[NSDictionary alloc] initWithObjectsAndKeys:navTitle,@"title",@"NO",@"isHidden",RPCResult.res,@"MainInfo",local,@"location", nil] autorelease];
            
            Notification__POST(FINDWORKBACK,postDic);
            
            self.navigationItem.hidesBackButton=NO;
        }else{
            HIDE__LOADING;
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
            
//            AFJSONRequestOperation *JSONRequest=[[AFJSONRequestOperation alloc] init];
//            NSLog(@"呵呵：%@",[JSONRequest otherJsonBack:RPCResult.res]);
//            
//            WARNING__ALERT([[JSONRequest otherJsonBack:RPCResult.res] objectForKey:@"reason"]);
        }
        
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"请检查网络连接是否顺畅");
    }];
}

#pragma mark - 重新从网上获取页面内容
-(void)reloadInform
{
//    NSLog(@"456456456vfoidjcdsjcojcsdo");
    
    if (localSuccess==NO) {
        return;
    }
    
    //获取服务器数据
    SHOW__LOADING
    //抽取本地信息
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    GetRabbitMission  *_getRabbitMission=[[GetRabbitMission alloc] init];
    
//    NSLog(@"哈哈：%d",page);
//    NSLog(@"类型是：%@",registInfo);
    [_getRabbitMission getRabbitMisson:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] city:[registInfo objectForKey:@"city"] type:[NSString stringWithFormat:@"%d",rabbitMissionType+1] level:[registInfo objectForKey:@"serve_level"] cate_codes:[registInfo objectForKey:@"serve_cates"] page:[NSString stringWithFormat:@"%d",page+1] success:^(id responseData){
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        
        switch (rabbitMissionType) {
            case emergency:
                self.emergencyDian.hidden=YES;
                break;
                
            case today:
                self.todayDian.hidden=YES;
                break;
                
            case subscribe:
                self.subscribeDian.hidden=YES;
                break;
                
            default:
                break;
        }
        
        if ([[RPCResult.res objectForKey:@"count"] intValue]==0) {
            
//            [_allInfoArr removeAllObjects];
            
            HIDE__LOADING;
            if (page==0) {
                WARNING__ALERT(@"当前无任务");
            }else{
                WARNING__ALERT(@"已经显示所有项目");
            }
            
            self.isRefreshing=NO;
            self.loadFooterView.showActivityIndicator = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainList];
            page-=1;
            self.loadingmore = YES;
            self.loadFooterView.hidden=YES;
            [self.mainList reloadData];
            
            return;
        }
        
        if ([[RPCResult.res objectForKey:@"count"] intValue]<6) {
            isLoadAll=YES;
        }else{
            isLoadAll=NO;
        }
//        NSLog(@"呵呵：%@",RPCResult.res);
        if (RPCResult.success==YES) {
            //此处下啦更多还要调整
            reload=0;
            
            [_timeTitleArr removeAllObjects];
//            NSLog(@"第一次：%@",_timeTitleArr);
            if (self.isRefreshing==YES) {
                _allInfoArr=[RPCResult.res objectForKey:@"list"];
            }else{
                if (self.loadingmore==YES) {
                    NSMutableArray *tArr=[[NSMutableArray alloc] initWithArray:[RPCResult.res objectForKey:@"list"]];
                    NSMutableArray *senseArr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
                    [senseArr addObjectsFromArray:tArr];
                    _allInfoArr=[[NSMutableArray alloc] initWithArray:senseArr];
                    
                }else{
                    _allInfoArr=[RPCResult.res objectForKey:@"list"];
                }
            }
//            NSLog(@"哈哈：%@",_allInfoArr);
            [_subscribeInfoArr removeAllObjects];
            [_localArr removeAllObjects];
            [_titleImgArr removeAllObjects];
            [_localArr removeAllObjects];
            
            for (NSDictionary *dic in _allInfoArr) {
                [_localArr addObject:@"无法定位获取"];
            }
//            [RPCResult.res objectForKey:@"image"]
            for (NSDictionary *infoDic in _allInfoArr) {
                //计算定位信息
                naviRequest.origin=[AMapGeoPoint locationWithLatitude:[[_localDic objectForKey:@"latitude"] floatValue] longitude:[[_localDic objectForKey:@"longitude"] floatValue]];
                naviRequest.destination=[AMapGeoPoint locationWithLatitude:[[infoDic objectForKey:@"mission_lat"] floatValue] longitude:[[infoDic objectForKey:@"mission_lng"] floatValue]];
                
                [self.search AMapNavigationSearch: naviRequest];
                
                if (![_timeTitleArr containsObject:[infoDic objectForKey:@"book_time"]]) {
                    [_timeTitleArr addObject:[infoDic objectForKey:@"book_time"]];
                }
                
                [_titleImgArr addObject:[infoDic objectForKey:@"image"]];
            }
//            NSLog(@"第二次：%@",_timeTitleArr);
#pragma mark - 判断相同时间点
            NSMutableArray *tAddArr=[[NSMutableArray alloc] init];          //临时添加形数组
            NSMutableArray *tAddArrjudge=[[NSMutableArray alloc] init];         //判断形数组
            
            for (NSString *timer in _timeTitleArr) {
                
                NSString *getTimer=[self timeZone:[timer intValue]];
                if (![tAddArrjudge containsObject:getTimer]) {
                    [tAddArrjudge addObject:getTimer];
                    [tAddArr addObject:timer];
                }
            }
            [_timeTitleArr release];
            _timeTitleArr=nil;
            _timeTitleArr=[[NSMutableArray alloc] initWithArray:tAddArr];

            
            for (int i=0; i<_timeTitleArr.count; i++) {
                NSArray *arr=[[NSArray alloc] init];
                [_subscribeInfoArr addObject:arr];
            }
            
        }else{
            HIDE__LOADING;
            WARNING__ALERT(RPCResult.res);
    }
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"获取数据失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (rabbitMissionType==subscribe) {
//        NSLog(@"呵呵：%@",_allInfoArr);
        return _timeTitleArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"呵呵：%@",_allInfoArr);
    if (rabbitMissionType==subscribe) {
        int i=0;
        
        NSMutableArray *addArr=[[NSMutableArray alloc] init];
        for (NSDictionary *tDic in _allInfoArr) {
//            if ([[tDic objectForKey:@"book_time"] intValue]==[[_timeTitleArr objectAtIndex:section] intValue]) {
//                [addArr addObject:tDic];
//                i+=1;
//            }
#pragma mark - 自定义时间排序
            if ([[self timeZone:[[_timeTitleArr objectAtIndex:section] intValue]] isEqualToString:[self timeZone:[[tDic objectForKey:@"book_time"] intValue]]]) {
                [addArr addObject:tDic];
                i+=1;
            }
        }
        
        [_subscribeInfoArr replaceObjectAtIndex:section withObject:addArr];
//        [_subscribeInfoArr addObject:addArr];
        
        return i;
    }
    
    
    return _allInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"123");
    //    NSString *CellIdentifier = [NSString stringWithFormat:@"cell"];
    //
    //    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    FindWorkViewCell *cell = (FindWorkViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FindWorkViewCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    if (_localArr.count>0) {
        if (rabbitMissionType!=subscribe) {
            cell.locationLab.text=[_localArr objectAtIndex:indexPath.row];
        }else{
            NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
            //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
            if (arr.count>0) {
                
                int count=0;
                NSArray *arr;
                for (int i=0; i<indexPath.section; i++) {
                    arr=[_subscribeInfoArr objectAtIndex:i];
                    count+=arr.count;
                }
                cell.locationLab.text=[_localArr objectAtIndex:indexPath.row+count];
            }
            
        }
//        cell.locationLab.text=[_localArr objectAtIndex:indexPath.row];
    }
    
    if (rabbitMissionType==emergency) {
        cell.timeImg.image=[UIImage imageNamed:@"time.png"];
        cell.timeLab.text=@"即刻";
    }
    
    //临时方案
    NSURL *imgUrl=nil;
    if (rabbitMissionType!=subscribe) {
        imgUrl=[NSURL URLWithString:[_titleImgArr objectAtIndex:indexPath.row]];
    }else{
        if (indexPath.section==0) {
            imgUrl=[NSURL URLWithString:[_titleImgArr objectAtIndex:indexPath.row]];
        }else{
            NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
            //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
            if (arr.count>0) {
                int i=0;
                int count=0;
                for (NSArray *totalArr in _subscribeInfoArr) {
                    count+=totalArr.count;
                    i+=1;
                    if (i==indexPath.section) {
                        break;
                    }
                }
                imgUrl=[NSURL URLWithString:[_titleImgArr objectAtIndex:count+indexPath.row]];
            }
            
        }
    }
    
    [manager downloadWithURL:imgUrl options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        cell.photoImg.image=image;
    }];
    
//    NSLog(@"哈哈：%@",_allInfoArr);
    if (rabbitMissionType!=subscribe) {
        cell.timeLab.text=[self timeZoneCell:[[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"book_time"] intValue]];
    }else{
        NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
        //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
        if (arr.count>0) {
            cell.timeLab.text=[self timeZoneCell:[[[[_subscribeInfoArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"book_time"] intValue]];
        }
    }
    
    
    if (rabbitMissionType==subscribe)
    {
        NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
        //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
        if (arr.count>0) {
            
            cell.photoTitle.text=[[[_subscribeInfoArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
        }else{
            
        }
        
        
    }else{
        cell.photoTitle.text=[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.mainList.hidden=YES;
    
    switch (rabbitMissionType) {
        case emergency:
            navTitle=@"即刻任务";
            break;
            
        case today:
            navTitle=@"当日任务";
            break;
            
        default:
            navTitle=@"预约任务";
            break;
    }
    
    
    if (rabbitMissionType==subscribe)
    {
        if (indexPath.section==0) {
            [self getDetailInform:[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"demand_sn"] local:[_localArr objectAtIndex:indexPath.row]];
        }else{
            int i=0;
            int count=0;
            for (NSArray *totalArr in _subscribeInfoArr) {
                count+=totalArr.count;
                i+=1;
                if (i==indexPath.section) {
                    break;
                }
            }
            
            [self getDetailInform:[[[_subscribeInfoArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"demand_sn"] local:[_localArr objectAtIndex:count]];
        }
    }else{
        [self getDetailInform:[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"demand_sn"] local:[_localArr objectAtIndex:indexPath.row]];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (rabbitMissionType==subscribe) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (rabbitMissionType==subscribe) {
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
        
        titleLab.text=[self timeZone:[[_timeTitleArr objectAtIndex:section] intValue]];
        titleLab.font=[UIFont fontWithName:@"STHeitiTC-Light" size:12];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.backgroundColor=[UIColor clearColor];
        
        return [titleLab autorelease];
    }
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
    [formatter setDateFormat:@"YYYY年MM月dd日"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
}

- (NSString *)timeZoneCell:(int)times{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
//    NSLog(@"哈哈：%@",confromTimesp);
//    NSLog(@"嘻嘻：%d",times);
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
            page=0;
            [self reloadInform];
        }else{
            self.isRefreshing = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
        }
    }
    
    /********************下拉更多**********************/
    //滑动标准
    float scrollStandard=self.mainList.contentSize.height-self.mainList.frame.size.height;
    if (scrollView.contentOffset.y>scrollStandard+35&&self.loadingmore==NO) {
        self.loadingmore=YES;
        self.loadFooterView.showActivityIndicator = YES;
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        scrollView.contentSize=CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+65);
        scrollView.contentOffset=CGPointMake(0, bottomEdge);
        page+=1;
        [self reloadInform];
    }
    /********************下拉更多**********************/
}

#pragma mark - 选择类型
#pragma mark - 应急
- (IBAction)emergencyMission:(id)sender {
    self.emergencyDian.hidden=YES;
    
    [_allInfoArr release];
    _allInfoArr=nil;
    
    [self.emergencyBtn setImage:[UIImage imageNamed:@"list1b.png"] forState:UIControlStateNormal];
    [self.todayBtn setImage:[UIImage imageNamed:@"list2c.png"] forState:UIControlStateNormal];
    [self.subscribeBtn setImage:[UIImage imageNamed:@"list3a.png"] forState:UIControlStateNormal];
    rabbitMissionType=emergency;
    //    [self.mainList reloadData];
    page=0;
    [self reloadInform];
}

#pragma mark - 当日
- (IBAction)todayMission:(id)sender {
    self.todayDian.hidden=YES;
    
    [_allInfoArr release];
    _allInfoArr=nil;
    
    [self.emergencyBtn setImage:[UIImage imageNamed:@"list1a.png"] forState:UIControlStateNormal];
    [self.todayBtn setImage:[UIImage imageNamed:@"list2a.png"] forState:UIControlStateNormal];
    [self.subscribeBtn setImage:[UIImage imageNamed:@"list3a.png"] forState:UIControlStateNormal];
    rabbitMissionType=today;
    //    [self.mainList reloadData];
    page=0;
    [self reloadInform];
}

#pragma mark - 预约
- (IBAction)subscribeMission:(id)sender {
    self.subscribeDian.hidden=YES;
    
    [_allInfoArr release];
    _allInfoArr=nil;
    
    [_timeTitleArr removeAllObjects];
    
    [self.emergencyBtn setImage:[UIImage imageNamed:@"list1a.png"] forState:UIControlStateNormal];
    [self.todayBtn setImage:[UIImage imageNamed:@"list2c.png"] forState:UIControlStateNormal];
    [self.subscribeBtn setImage:[UIImage imageNamed:@"list3c.png"] forState:UIControlStateNormal];
    rabbitMissionType=subscribe;
    //    [self.mainList reloadData];
    page=0;
    [self reloadInform];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainList release];
    [_emergencyBtn release];
    [_todayBtn release];
    [_subscribeBtn release];
    [_emergencyDian release];
    [_todayDian release];
    [_subscribeDian release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainList:nil];
    [self setEmergencyBtn:nil];
    [self setTodayBtn:nil];
    [self setSubscribeBtn:nil];
    [self setEmergencyDian:nil];
    [self setTodayDian:nil];
    [self setSubscribeDian:nil];
    [super viewDidUnload];
}
@end
