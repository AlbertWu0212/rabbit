//
//  MatterViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MatterViewController.h"
#import "AnimationEffects.h"

#import "biddingRequest.h"

#import "GetRabbitMission.h"
#import "GetMissionDetail.h"
#import "DropMission.h"
#import "OverMission.h"
#import "XMLRPCResult.h"
#import "cancelMission.h"
#import "startMission.h"
#import "HttpsStartMission.h"

#import <MAMapKit/MAMapKit.h>

#import "MapViewController.h"

#import "LoadingMoreFooterView.h"
#import "EGORefreshTableHeaderView.h"

#import "AFJSONRequestOperation.h"

#import "BiddingDetailRequest.h"

#import "WiningOverRequest.h"

#import "phoneCall.h"

#import "GetServerTime.h"

#import "MissionOverEmployer.h"

#import "SoundPlayer.h"

#define REFRESHINGVIEW_HEIGHT 128

@interface MatterViewController ()
{
    SDWebImageManager *manager;
    
    SoundPlayer *_soundPlayer;
}
@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@property(nonatomic,readwrite) BOOL loadingmore;

@property(nonatomic, retain) EGORefreshTableHeaderView * refreshHeaderView;  //下拉刷新
@property(nonatomic, readwrite) BOOL isRefreshing;

@property (nonatomic, retain)UISegmentedControl *showSegment;

@property (nonatomic, retain)UISegmentedControl *modeSegment;

@end

@implementation MatterViewController
@synthesize mapView = _mapView;     //地图对象
@synthesize search  = _search;      //地图搜索对象

@synthesize showSegment, modeSegment;

static int rabbitMissionType=0;
static int missionStatueType=0;
static int page=1;

static bool localSuccess=NO;       //判断定位成功失败

static int reload=1;

static bool isLoadAll=NO;           //是否全部加载完毕

static bool isShowCallImage=NO;     //是否显示红点图标
static bool isShowCallImage2=NO;    //是否显示结束红点图标

static bool isFirst=NO;

static int serverTime=0;        //服务器时间戳
static int cutSeverTime=0;      //服务器时间和当前时间差值

static bool isChoose=NO;        //判断雇主选中

@synthesize loadFooterView=_loadFooterView,loadingmore=_loadingmore;
@synthesize refreshHeaderView=_refreshHeaderView,isRefreshing=_isRefreshg;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _emergencyStr=@"服务报价12分钟内不可撤销        雇主选中付款锁定6分钟";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            _promptStr=@"提示\n请您及时按下开始键开始执行任务30分钟不执行违约赔款15%，60分钟未执行违约双倍赔款";
        }else{
            _promptStr=@"提示                                                  请您及时按下开始键开始执行任务30分钟不执行违约赔款15%，60分钟未执行违约双倍赔款";
        }
        
        Notification__CREATE(NotificationFunEVA,EVABACKMAIN);
        Notification__CREATE(NotificationNoticeSpeak,SPEAKERSNOTICE);
        
        //公共推送
        Notification__CREATE(NotificationCancelMission,CANCELMISSION);
        Notification__CREATE(NotificationEmpolyerCancelMission,EMPOLYERCANCELMISSION);
        Notification__CREATE(NotificationChoose, CHOOSERABBIT);
        
        _localDic=[[NSMutableDictionary alloc] init];
        
        _allInfoArr=[[NSMutableArray alloc] init];
        _localArr=[[NSMutableArray alloc] init];
        
        _timeTitleArr=[[NSMutableArray alloc] init];
        _titleImgArr=[[NSMutableArray alloc] init];
        
        _subscribeInfoArr=[[NSMutableArray alloc] init];
        _speakerGetArr=[[NSMutableArray alloc] init];
        _spearkerDetailArr=[[NSMutableArray alloc] init];
        
        _doningBtnArr=[[NSMutableArray alloc] init];
        _doingTimerArr=[[NSMutableArray alloc] init];
        
        
        _deleteBtnArr=[[NSMutableArray alloc] init];
        
        _soundPlayer=[[SoundPlayer alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=NO;
    HIDE__LOADING
    
//    Notification__POST(HIDENAV, nil);
    
    if (isChoose==YES) {
        self.callImage.hidden=NO;
        isChoose=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _wholeColor=self.biddingBtn.titleLabel.textColor;
    [_wholeColor retain];
    
    self.promptLab.text=_emergencyStr;
    
    self.mainListTable.backgroundView=nil;
    self.mainListTable.backgroundColor=[UIColor clearColor];
//    self.mainListTable.bounces=NO;
    
    _evaluationVC=[[EvaluationViewController alloc] init];
//    _evaluationVC.view.hidden=YES;
    [self.view addSubview:_evaluationVC.view];
    CGRect evaRect;
    evaRect=_evaluationVC.view.frame;
    evaRect.origin.x=320;
    _evaluationVC.view.frame=evaRect;
    
    //主要数据
    _mainInfoArray=[[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        NSMutableArray *tArr=[[NSMutableArray alloc] init];
        for (int j=0; j<3; j++) {
            [tArr addObject:@""];
        }
        [_mainInfoArray addObject:tArr];
    }
    
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
    self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,  -REFRESHINGVIEW_HEIGHT, self.mainListTable.frame.size.width,REFRESHINGVIEW_HEIGHT)] autorelease];
    [self.mainListTable addSubview:self.refreshHeaderView];
    self.isRefreshing = NO;
    /***************刷新***************/
    
    /***************更多***************/
    self.loadFooterView.hidden=YES;
    self.loadFooterView=[[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0, self.mainListTable.contentSize.height, self.mainListTable.contentSize.width, 44.f)];
    [self.mainListTable addSubview:self.loadFooterView];
    self.loadingmore = NO;
    /***************更多***************/
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    //红点
    if (isShowCallImage==YES) {
        self.callImage.hidden=NO;
    }
    if (isShowCallImage2==YES) {
        self.callImage2.hidden=NO;
    }
    
//    if
    
    //专有定时，每秒都获取次系统时间
    [NSTimer scheduledTimerWithTimeInterval:1
     
                                     target:self
     
                                   selector:@selector(timerLocal:)
     
                                   userInfo:nil
     
                                    repeats:YES];
    // Do any additional setup after loading the view from its nib.
    [self getServerTime];       //获取服务器时间
}

-(void)getServerTime
{
    GetServerTime *getServe=[[GetServerTime alloc] init];
    [getServe getTime:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            serverTime=[[RPCResult.res objectForKey:@"time"] intValue];
            cutSeverTime=serverTime-[[self nowTimeCode] intValue];
        }else{
            
        }
    } failed:^(NSError *error) {
        WARNING__ALERT(@"网络连接错误");
    }];
}

#pragma mark - 监听事件
- (void)NotificationFunEVA:(NSNotification *) notification
{
    CGRect evaRect;
    evaRect=_evaluationVC.view.frame;
    evaRect.origin.x=0;
    _evaluationVC.view.frame=evaRect;
    evaRect.origin.x=320;
    [AnimationEffects MainAnimation:_evaluationVC.view Animations:moving endEffectMoving:evaRect endEffectAlpha:1 time:0.5 overFunction:nil];
//    WARNING__ALERT(@"评论成功");
    [_allInfoArr release];
    _allInfoArr=nil;
    [self reloadInform];
}

- (void)NotificationNoticeSpeak:(NSNotification *) notification
{
    [_soundPlayer playSound:@"info_come"];
    NSString *type = [[[notification.userInfo objectForKey:@"message"] attributeForName:@"type"] stringValue];
    
    if ([type isEqualToString:@"chat"]) {
        NSString *bodyStr=[[[notification.userInfo objectForKey:@"message"] elementForName:@"body"] stringValue];
        
        NSString *BNumber=[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1];
        
        NSString *from = [[[notification.userInfo objectForKey:@"message"] attributeForName:@"from"] stringValue];

        NSString *currentJIDComunicateWith=from=[self cutStr:from cutStrs:@"/" page:0];
        
//        NSLog(@"草草：%d",[[self cutStr:[self cutStr:bodyStr cutStrs:@"</Status>" page:0] cutStrs:@"<Status>" page:1] intValue]);
        if ([[self cutStr:[self cutStr:bodyStr cutStrs:@"</Status>" page:0] cutStrs:@"<Status>" page:1] intValue]==1) {
            isShowCallImage=YES;
            self.callImage.hidden=NO;
        }else{
            isShowCallImage2=YES;
            self.callImage2.hidden=NO;
        }
        
        if (![_speakerGetArr containsObject:[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1]]) {
            [_speakerGetArr addObject:[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1]];
            
            NSMutableDictionary *postDic=[[NSMutableDictionary alloc] init];
            [postDic setObject:[self cutStr:[self cutStr:bodyStr cutStrs:@"</Status>" page:0] cutStrs:@"<Status>" page:1] forKey:@"Status"];
            [postDic setObject:[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1] forKey:@"BNumber"];
            [_spearkerDetailArr addObject:postDic];
        }
        
        if (![[self cutStr:[self cutStr:bodyStr cutStrs:@"</Info>" page:0] cutStrs:@"<Info>" page:1] isEqualToString:@"-1"]) {
            
            [self speakingCacheOpen];
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@','%d','%@','%@','%@',1)",currentJIDComunicateWith,0,[self cutStr:[self cutStr:bodyStr cutStrs:@"</Info>" page:0] cutStrs:@"<Info>" page:1],[self getNowTime],BNumber]];
            [self speakingCacheClose];
        }else if (![[self cutStr:[self cutStr:bodyStr cutStrs:@"</Voice>" page:0] cutStrs:@"<Voice>" page:1] isEqualToString:@"-1"]){
            [self speakingCacheOpen];
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@','%d','%@','%@','%@',1)",currentJIDComunicateWith,1,[self cutStr:[self cutStr:bodyStr cutStrs:@"</Voice>" page:0] cutStrs:@"<Voice>" page:1],[self getNowTime],BNumber]];
            [self speakingCacheClose];
        }else{
            [self speakingCacheOpen];
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@','%d','%@','%@','%@',1)",currentJIDComunicateWith,2,[self cutStr:[self cutStr:bodyStr cutStrs:@"</Img>" page:0] cutStrs:@"<Img>" page:1],[self getNowTime],BNumber]];
            [self speakingCacheClose];
        }
        
        [self.mainListTable reloadData];
    }
    
}
#pragma mark - 监听事件

#pragma mark - 公共推送监听
-(void)NotificationCancelMission:(NSNotification *) notification
{
    [_soundPlayer playSound:@"info_come"];
    if (missionStatueType==bidding) {
        NSMutableArray  *arr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
        int i=0;
        for (NSDictionary *infoDic in _allInfoArr) {
            if ([[infoDic objectForKey:@"demand_sn"] isEqualToString:[notification.userInfo objectForKey:@"bnumber"]]) {
                [arr removeObjectAtIndex:i];
            }
            i+=1;
        }
        
        [_allInfoArr release];
        _allInfoArr=nil;
        _allInfoArr=[[NSMutableArray alloc] initWithArray:arr];
        
        if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
            [self newInnerReload];
        }
        
        [self.mainListTable reloadData];
//        [self reloadInform];
    }else{
        self.biddingDInImg.hidden=NO;
    }
}

-(void)NotificationEmpolyerCancelMission:(NSNotification *) notification
{
//    NSLog(@"123");
    [_soundPlayer playSound:@"info_come"];
    if (missionStatueType==winning) {
//        NSLog(@"123");
        NSMutableArray  *arr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
        int i=0;
        for (NSDictionary *infoDic in _allInfoArr) {
            if ([[infoDic objectForKey:@"demand_sn"] isEqualToString:[notification.userInfo objectForKey:@"bnumber"]]) {
                [arr removeObjectAtIndex:i];
                [_doningBtnArr removeObjectAtIndex:i];
            }
            i+=1;
        }
        
        [_allInfoArr release];
        _allInfoArr=nil;
        _allInfoArr=[[NSMutableArray alloc] initWithArray:arr];

        if ((rabbitMissionType==subscribe||rabbitMissionType==today)&&missionStatueType!=finishing) {
//            NSLog(@"456");
            [self newInnerReload];
        }
        
        [self.mainListTable reloadData];
        
    }else{
//        NSLog(@"345");
        self.callImage.hidden=NO;
    }
}

-(void)NotificationChoose:(NSNotification *) notification
{
//    Notification__POST(SPEAKERSNOTICE, nil);
    [_soundPlayer playSound:@"info_come"];
    if (missionStatueType==bidding) {
        NSMutableArray  *arr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
        int i=0;
        for (NSDictionary *infoDic in _allInfoArr) {
            if ([[infoDic objectForKey:@"demand_sn"] isEqualToString:[notification.userInfo objectForKey:@"bnumber"]]) {
                [arr removeObjectAtIndex:i];
            }
            i+=1;
        }
        
        [_allInfoArr release];
        _allInfoArr=nil;
        _allInfoArr=[[NSMutableArray alloc] initWithArray:arr];
        
        if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
            [self newInnerReload];
        }
        
        [self.mainListTable reloadData];
        
//        NSLog(@"草草草：%@",_speakerGetArr);
        
        self.callImage.hidden=NO;
    }else{
        self.biddingDInImg.hidden=NO;
    }
}
#pragma mark - 公共推送监听

#pragma mark - 获得系统时间
-(NSString *)getNowTime
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //        [dateformatter setDateFormat:@"HH:mm"];
    //        NSString *  locationString=[dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    return morelocationString;
}


#pragma mark - 获得当前时间戳
-(NSString *)nowTimeCode
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]-28800];//时间戳的值
    
    return timeSp;
}

#pragma mark 获取Document路径下的文件/文件夹
-(NSString *)mainPath:(NSString *)path
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *returnPath=[documentDirectory stringByAppendingPathComponent:path];
    return returnPath;
}

#pragma mark - 用户聊天缓存
-(void)speakingCacheOpen
{
    NSString *dbPath=[self mainPath:@"SpeakDatabase.db"];
    db=[FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"error");
    }
    rs=[db executeQuery:@"select id from UsersCache limit(0,1)"];
    
    if(![rs next]){
        [db executeUpdate:@"CREATE TABLE UsersCache (id integer primary key autoincrement,usercode text,type text,Message text,time text,respondType text,BNumber text)"];
    }
}

-(void)speakingCacheClose
{
    if (db) {
        [db close];
    }
    if (rs) {
        [rs close];
    }
}

#pragma mark - 截取字符串
-(NSString *)cutStr:(NSString *)cutOrign cutStrs:(NSString *)cutStrs page:(int)page
{
    NSArray  *tempArray = [cutOrign componentsSeparatedByString:cutStrs];
    
    return [tempArray objectAtIndex:page];
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
    
    if (reload==_allInfoArr.count) {
        
        HIDE__LOADING
        
        self.isRefreshing=NO;
        [self.mainListTable reloadData];
        
        if (self.loadFooterView.showActivityIndicator==NO) {
            //自定坐标
            self.mainListTable.contentOffset=CGPointMake(0, 0);
        }
        
        self.loadFooterView.showActivityIndicator = NO;
        self.loadFooterView.frame=CGRectMake(0, self.mainListTable.contentSize.height, self.mainListTable.contentSize.width, 44.f);
        self.loadingmore = NO;
        self.loadFooterView.hidden=NO;
        
        if (isLoadAll==YES) {
            self.loadingmore = YES;
            self.loadFooterView.hidden=YES;
        }

        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainListTable];
        
//        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
//        [dic setObject:@"3889956815651" forKey:@"bnumber"];
//        Notification__POST(EMPOLYERCANCELMISSION, dic);
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
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainListTable];
        self.isRefreshing=NO;
        [self.mainListTable reloadData];
        
        self.loadFooterView.showActivityIndicator = NO;
        self.loadFooterView.frame=CGRectMake(0, self.mainListTable.contentSize.height, self.mainListTable.contentSize.width, 44.f);
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
    //    NSLog(@"成功");
    [_localDic setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [_localDic setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"longitude"];
    if (localSuccess==NO) {
        localSuccess=YES;
        [self reloadInform];
    }
    localSuccess=YES;
}

-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
    localSuccess=NO;
}

#pragma mark - 取消竞价
-(void)dropMission:(NSString *)demand_sn
{
    NSMutableArray  *arr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
    int i=0;
    for (NSDictionary *infoDic in _allInfoArr) {
        if ([[infoDic objectForKey:@"demand_sn"] isEqualToString:demand_sn]) {
            [arr removeObjectAtIndex:i];
        }
        i+=1;
    }
    
    [_allInfoArr release];
    _allInfoArr=nil;
    _allInfoArr=[[NSMutableArray alloc] initWithArray:arr];
    [self newInnerReload];
    
    [self.mainListTable reloadData];
}

#pragma mark - 获取信息详情
-(void)getDetailInform:(NSString *)demand_en local:(NSString *)local
{
    SHOW__LOADING
    
    if (missionStatueType==bidding) {
        BiddingDetailRequest *biddingDetail=[[BiddingDetailRequest alloc] init];
        [biddingDetail biddingDetail:demand_en success:^(id responseData){
            XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
            
            if (RPCResult.success==YES) {
                HIDE__LOADING;
                NSDictionary *postDic=[[[NSDictionary alloc] initWithObjectsAndKeys:navTitle,@"title",@"NO",@"isHidden",RPCResult.res,@"MainInfo",local,@"location", nil] autorelease];
                
                Notification__POST(MATTERDETAIL,postDic);
                
                self.navigationItem.hidesBackButton=NO;
                
                [self.mainListTable reloadData];
            }else{
                HIDE__LOADING;
                WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
            }
        }failed:^(NSError *error){
            HIDE__LOADING;
            WARNING__ALERT(@"请检查网络连接是否顺畅");
        }];
    }else{
        WiningOverRequest *winingOver=[[WiningOverRequest alloc] init];
        [winingOver WiningOver:demand_en success:^(id responseData){
            XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
            
//            NSLog(@"呵呵：%@",responseData);
            
            if (RPCResult.success==YES) {
                HIDE__LOADING;
                NSDictionary *postDic=[[[NSDictionary alloc] initWithObjectsAndKeys:navTitle,@"title",@"NO",@"isHidden",RPCResult.res,@"MainInfo",local,@"location", nil] autorelease];
                
                Notification__POST(MATTERDETAIL,postDic);
                
                self.navigationItem.hidesBackButton=NO;
            }else{
                HIDE__LOADING;
                WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
            }
        }failed:^(NSError *error){
            HIDE__LOADING;
            WARNING__ALERT(@"请检查网络连接是否顺畅");
        }];
    }
}

#pragma mark - 重新从网上获取页面内容
-(void)reloadInform
{
//    NSLog(@"123123123123vfoidjcdsjcojcsdo");
    //获取服务器数据
    SHOW__LOADING
    
    biddingRequest  *_bidReq=[[biddingRequest alloc] init];
    
    [_bidReq bidding:[NSString stringWithFormat:@"%d",missionStatueType+1] book_type:[NSString stringWithFormat:@"%d",rabbitMissionType+1] page:[NSString stringWithFormat:@"%d",page] success:^(id responseData){
        
//        NSLog(@"呵呵：%@",responseData);
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
//        NSLog(@"呵呵：%@",RPCResult.res);
        if ([[RPCResult.res objectForKey:@"count"] intValue]==0) {
            
            HIDE__LOADING;
            if (page==0) {
                WARNING__ALERT(@"当前无任务");
            }else{
                WARNING__ALERT(@"已经显示所有项目");
            }
            self.isRefreshing=NO;
            self.loadFooterView.showActivityIndicator = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainListTable];
//            page-=1;
            self.loadingmore = YES;
            self.loadFooterView.hidden=YES;
            [self.mainListTable reloadData];
            
            return;
        }
        
        if ([[RPCResult.res objectForKey:@"count"] intValue]<15) {
            isLoadAll=YES;
        }else{
            isLoadAll=NO;
        }
        
        if (RPCResult.success==YES) {
            reload=0;
            
            
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
//            NSLog(@"哈哈：%@",[RPCResult.res objectForKey:@"list"]);
            [_subscribeInfoArr removeAllObjects];
            [_localArr removeAllObjects];
            [_titleImgArr removeAllObjects];
            [_doingTimerArr removeAllObjects];
            [_timeTitleArr removeAllObjects];
            [_doningBtnArr removeAllObjects];
            //            [RPCResult.res objectForKey:@"image"]
            
//            NSLog(@"嘻嘻：%@",_allInfoArr);
            
            for (NSDictionary *dic in _allInfoArr) {
                [_localArr addObject:@"无法定位获取"];
            }
            
            
            for (NSDictionary *infoDic in _allInfoArr) {
                //                NSLog(@"喵：%@",infoDic);
                //计算定位信息
                naviRequest.origin=[AMapGeoPoint locationWithLatitude:[[_localDic objectForKey:@"latitude"] floatValue] longitude:[[_localDic objectForKey:@"longitude"] floatValue]];
                naviRequest.destination=[AMapGeoPoint locationWithLatitude:[[infoDic objectForKey:@"mission_lat"] floatValue] longitude:[[infoDic objectForKey:@"mission_lng"] floatValue]];
                
                [self.search AMapNavigationSearch: naviRequest];
                
                if (![_timeTitleArr containsObject:[infoDic objectForKey:@"book_time"]]) {
                    [_timeTitleArr addObject:[infoDic objectForKey:@"book_time"]];
                }
                
                [_titleImgArr addObject:[infoDic objectForKey:@"image"]];
                
//                if (![_doingTimerArr containsObject:[infoDic objectForKey:@"book_time"]]) {
                    [_doingTimerArr addObject:[infoDic objectForKey:@"book_time"]];
//                NSLog(@"草草草：%@",_doingTimerArr);
//                }
            }
            
            
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
        WARNING__ALERT(@"请检查您的网络是否连接");
    }];
}

#pragma mark - 竞标
- (IBAction)bidding:(id)sender {
    page=1;
    
    self.biddingDInImg.hidden=YES;
    self.emergencyBtn.hidden=NO;
    self.todayBtn.hidden=NO;
    self.subscribeBtn.hidden=NO;
    
    missionStatueType=bidding;
    
    CGRect cursorRect=self.cursorImg.frame;
    UIButton *clickBtn=(UIButton *)sender;
    
    cursorRect.origin.x=clickBtn.frame.origin.x;
    
    [self changeBtn:cursorRect];
    
    [self.biddingBtn setTitleColor:_wholeColor forState:UIControlStateNormal];
    [self.winningBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.overBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.promptLab.text=_emergencyStr;
    
    [_allInfoArr release];
    _allInfoArr=nil;
    
    CGRect ListRect=self.mainListTable.frame;
    ListRect.origin.y=168;
    ListRect.size.height=305;
    
    if (IS_IPHONE_5) {
        ListRect.size.height=340;
    }else{
        ListRect.size.height=260;
    }
    
    self.mainListTable.frame=ListRect;
    
    
    CGRect prompRect=self.promptLab.frame;
    prompRect.size.height=64;
    self.promptLab.frame=prompRect;
    
    
    [_timeTitleArr removeAllObjects];
    [_subscribeInfoArr removeAllObjects];
    [_localArr removeAllObjects];
    [_titleImgArr removeAllObjects];
    [_doingTimerArr removeAllObjects];
    [self reloadInform];
}

#pragma mark - 中标
- (IBAction)winning:(id)sender {
    page=1;
    
    self.callImage.hidden=YES;
    self.emergencyBtn.hidden=NO;
    self.todayBtn.hidden=NO;
    self.subscribeBtn.hidden=NO;
    
    missionStatueType=winning;
    
    CGRect cursorRect=self.cursorImg.frame;
    UIButton *clickBtn=(UIButton *)sender;
    
    cursorRect.origin.x=clickBtn.frame.origin.x;
    
    [self changeBtn:cursorRect];
    
    [self.biddingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.winningBtn setTitleColor:_wholeColor forState:UIControlStateNormal];
    [self.overBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    self.promptLab.text=_promptStr;
    
    [_allInfoArr release];
    _allInfoArr=nil;
    
    CGRect ListRect=self.mainListTable.frame;
    ListRect.origin.y=168;
//    ListRect.size.height=305;
    if (IS_IPHONE_5) {
        ListRect.size.height=340;
    }else{
        ListRect.size.height=260;
    }
    
    self.mainListTable.frame=ListRect;
    
    
    CGRect prompRect=self.promptLab.frame;
    prompRect.size.height=64;
    self.promptLab.frame=prompRect;
    
    
    
    [_doingTimerArr removeAllObjects];

    [_timeTitleArr removeAllObjects];
    [_subscribeInfoArr removeAllObjects];
    [_localArr removeAllObjects];
    [_titleImgArr removeAllObjects];
    [_doingTimerArr removeAllObjects];
    
    [self reloadInform];
}

#pragma mark - 结束
- (IBAction)over:(id)sender {
    page=1;
    
    self.callImage2.hidden=YES;
    self.emergencyBtn.hidden=YES;
    self.todayBtn.hidden=YES;
    self.subscribeBtn.hidden=YES;
    missionStatueType=finishing;
    
    CGRect cursorRect=self.cursorImg.frame;
    UIButton *clickBtn=(UIButton *)sender;
    
    cursorRect.origin.x=clickBtn.frame.origin.x;
    
    [self changeBtn:cursorRect];
    
    [self.biddingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.winningBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.overBtn setTitleColor:_wholeColor forState:UIControlStateNormal];
    
    self.promptLab.text=@"服务提交结束后方可结算";
    
    [_allInfoArr release];
    _allInfoArr=nil;
    
    CGRect ListRect=self.mainListTable.frame;
    ListRect.origin.y=100;
//    ListRect.size.height=342;
    if (IS_IPHONE_5) {
        ListRect.size.height=390;
    }else{
         ListRect.size.height=390-568+480;
    }
   
    self.mainListTable.frame=ListRect;
    
    
    
    CGRect prompRect=self.promptLab.frame;
    prompRect.size.height=36;
    self.promptLab.frame=prompRect;
//    [_timeTitleArr removeAllObjects];
//    [_subscribeInfoArr removeAllObjects];
//    [_timeTitleArr removeAllObjects];
    
    [_doingTimerArr removeAllObjects];
    
    [_timeTitleArr removeAllObjects];
    [_subscribeInfoArr removeAllObjects];
    [_localArr removeAllObjects];
    [_titleImgArr removeAllObjects];
    [_doingTimerArr removeAllObjects];
    
    [self reloadInform];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_doningBtnArr removeAllObjects];
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
//        NSLog(@"呵呵：%@",_timeTitleArr);
        return _timeTitleArr.count;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_doningBtnArr removeAllObjects];
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
        int i=0;
        
        NSMutableArray *addArr=[[NSMutableArray alloc] init];
        for (NSDictionary *tDic in _allInfoArr) {
#pragma mark - 自定义时间排序
            if ([[self timeZone:[[_timeTitleArr objectAtIndex:section] intValue]] isEqualToString:[self timeZone:[[tDic objectForKey:@"book_time"] intValue]]]) {
                [addArr addObject:tDic];
                i+=1;
            }
        }
        [_subscribeInfoArr replaceObjectAtIndex:section withObject:addArr];
        
        return i;
    }
    return _allInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MatterViewCell *cell = (MatterViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MatterViewCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];

    if (missionStatueType==bidding) {
        CGRect mainRect=cell.backgroundImg.frame;
        mainRect.size.height=60;
        cell.backgroundImg.frame=mainRect;
        
        cell.phoneBtn.hidden=YES;
        cell.photoBtn.hidden=YES;
        cell.speakBtn.hidden=YES;
        cell.downLineImg.hidden=YES;
    }
    
    //点击结束
    if (missionStatueType==winning&&rabbitMissionType==emergency) {
        cell.doingBtn.hidden=NO;
        cell.tag=indexPath.row;
        [cell.doingBtn addTarget:self action:@selector(overDoing:) forControlEvents:UIControlEventTouchUpInside];
    }else if(missionStatueType==winning&&rabbitMissionType!=emergency){
        
        
        int doingLocal=0;
        if (indexPath.section==0) {
            doingLocal=indexPath.row;
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
                doingLocal=count+indexPath.row;
            }
            
        }
        
        if (doingLocal<_doningBtnArr.count) {
            UIButton *btn=[_doningBtnArr objectAtIndex:doingLocal];
            if ([btn.titleLabel.text isEqualToString:@"1"]) {
                cell.doingBtn.hidden=NO;
                [cell.doingBtn addTarget:self action:@selector(otherOverDoing:) forControlEvents:UIControlEventTouchUpInside];
                [cell.doingBtn setImage:[UIImage imageNamed:@"missionStartBtn.png"] forState:UIControlStateNormal];
            }else if ([btn.titleLabel.text isEqualToString:@"2"]){
                cell.doingBtn.hidden=NO;
                [cell.doingBtn removeTarget:self action:@selector(otherOverDoing:) forControlEvents:UIControlEventTouchUpInside];
                [cell.doingBtn addTarget:self action:@selector(OverMissionOther:) forControlEvents:UIControlEventTouchUpInside];
                [cell.doingBtn setImage:[UIImage imageNamed:@"missionEndBtn.png"] forState:UIControlStateNormal];
            }
        }else{
            bool isContain=NO;
            for (UIButton *btn in _doningBtnArr) {
                if (btn.tag==doingLocal) {
                    isContain=YES;
                }
            }
            if (isContain==NO) {
                [_doningBtnArr addObject:cell.doingBtn];
                [cell.doingBtn addTarget:self action:@selector(otherOverDoing:) forControlEvents:UIControlEventTouchUpInside];
                cell.doingBtn.tag=doingLocal;
            }
        }
        
    }
    
    
    NSURL *imgUrl=nil;
    if (rabbitMissionType!=subscribe) {
        
        imgUrl=[NSURL URLWithString:[_titleImgArr objectAtIndex:indexPath.row]];
    }else{
//        NSLog(@"呵呵：%d",indexPath.section);
        if (indexPath.section==0) {
//            NSLog(@"123");
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
//                NSLog(@"789");
                imgUrl=[NSURL URLWithString:[_titleImgArr objectAtIndex:count+indexPath.row]];
            }
            
        }
    }
    
    [manager downloadWithURL:imgUrl options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        cell.titleImg.image=image;
    }];
    
    if (_localArr.count>0) {
        if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
        {
            if (indexPath.section==0) {
                cell.localLab.text=[_localArr objectAtIndex:indexPath.row];
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
                    
                    cell.localLab.text=[_localArr objectAtIndex:count+indexPath.row];
                }
                
            }
        }else{
            cell.localLab.text=[_localArr objectAtIndex:indexPath.row];
        }
        
    }
    
    
    
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
    {
        if (indexPath.section==0) {
            cell.priceLab.text=[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"order_amount"];
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
                cell.priceLab.text=[[_allInfoArr objectAtIndex:count+indexPath.row] objectForKey:@"order_amount"];
            }
            
        }
    }else{
        cell.priceLab.text=[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"order_amount"];
    }
    
    if (missionStatueType==bidding) {
        cell.deleteLab.hidden=NO;
        cell.deleteImg.hidden=NO;
    }else{
        cell.deleteImg.hidden=YES;
        cell.deleteLab.hidden=YES;
    }
    
    
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
        NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
        //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
        if (arr.count>0) {
            int i=0;
            int count=0;
            for (NSArray *totalArr in _subscribeInfoArr) {
                if (i==indexPath.section) {
                    break;
                }
                count+=totalArr.count;
                i+=1;
            }
            cell.deleteLab.tag=count+indexPath.row;
        }
        
    }else{
        cell.deleteLab.tag=indexPath.row;
    }
    
    
    [cell.deleteLab addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    //有聊天小红点
    int race=0;
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
    {
        if (indexPath.section==0) {
            race=indexPath.row;
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
                
                race=count+indexPath.row;
            }
        }
    }else{
        race=indexPath.row;
    }
    
    if ([_speakerGetArr containsObject:[[_allInfoArr objectAtIndex:race] objectForKey:@"demand_sn"]]) {
        cell.dianImg.hidden=NO;
    }
    
    //聊天按钮
    [cell.speakBtn addTarget:self action:@selector(speakClick:) forControlEvents:UIControlEventTouchUpInside];
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
    {
        if (indexPath.section==0) {
            cell.speakBtn.tag=indexPath.row;
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
                
                cell.speakBtn.tag=count+indexPath.row;
            }
            
        }
    }else{
        cell.speakBtn.tag=indexPath.row;
    }
    
    
    [cell.phoneBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
    {
        if (indexPath.section==0) {
            cell.phoneBtn.tag=indexPath.row;
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
                
                cell.phoneBtn.tag=count+indexPath.row;
            }
            
        }
    }else{
        cell.phoneBtn.tag=indexPath.row;
    }
    
    
    [cell.photoBtn addTarget:self action:@selector(bigerPhoto:) forControlEvents:UIControlEventTouchUpInside];
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
    {
        if (indexPath.section==0) {
            cell.photoBtn.tag=indexPath.row;
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
                
                cell.photoBtn.tag=count+indexPath.row;
            }
            
        }
    }else{
        cell.photoBtn.tag=indexPath.row;
    }
    
    
    if (missionStatueType==finishing) {
        cell.timeLab.hidden=NO;
        switch ([[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"commented"] intValue]) {
            case 0:
                cell.timeLab.text=@"确定";
                break;
                
            case 1:
                cell.timeLab.text=@"已评价";
                break;
                
            case 3:
                cell.timeLab.text=@"已处理";
                break;
                
            default:
                cell.timeLab.text=@"已投诉";
                break;
        }
    }else{
        NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
        switch (rabbitMissionType) {
            case emergency:
                cell.timeImg.image=[UIImage imageNamed:@"time.png"];
                cell.timeLab.text=@"即刻";
                break;
                
            case today:
                cell.timeLab.text=[self timeZoneCell:[[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"book_time"] intValue]];
                break;
                
            default:
                if (arr.count>0) {
                    cell.timeLab.text=[self timeZoneCell:[[[[_subscribeInfoArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"book_time"] intValue]];
                }
                
                break;
        }
    }
    
    
    //标题
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
    {
        NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
        //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
        if (arr.count>0) {
            cell.titleLab.text=[[[_subscribeInfoArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
        }else{
            
        }
        
    }else{
        cell.titleLab.text=[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    
    
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (missionStatueType==bidding) {
        return 65;
    }
    return 108;
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
            [self reloadInform];
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
        [self reloadInform];
    }
    /********************下拉更多**********************/
}

#pragma mark -点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (missionStatueType==finishing) {
//        NSLog(@"呵呵：%@",_allInfoArr);
//        _evaluationVC.view.hidden=NO;
        Notification__POST(NAVIGATIONBARHIDE,nil);
        [_evaluationVC getDic:[_allInfoArr objectAtIndex:indexPath.row]];
        [_evaluationVC getLocal:[_localArr objectAtIndex:indexPath.row]];
        
        CGRect evaRect;
        evaRect=_evaluationVC.view.frame;
        evaRect.origin.x=320;
        _evaluationVC.view.frame=evaRect;
        evaRect.origin.x=0;
        [AnimationEffects MainAnimation:_evaluationVC.view Animations:moving endEffectMoving:evaRect endEffectAlpha:1 time:0.5 overFunction:nil];
    }else{
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
        
        
        if (rabbitMissionType==subscribe&&missionStatueType!=finishing)
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
                
                NSArray *arr=[_subscribeInfoArr objectAtIndex:indexPath.section];
                //            if ([[_subscribeInfoArr objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
                if (arr.count>0) {
                    [self getDetailInform:[[[_subscribeInfoArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"demand_sn"] local:[_localArr objectAtIndex:count]];
                }
                
                
            }
        }else{
            [self getDetailInform:[[_allInfoArr objectAtIndex:indexPath.row] objectForKey:@"demand_sn"] local:[_localArr objectAtIndex:indexPath.row]];
        }
        
        
    }
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
        if ([_timeTitleArr isKindOfClass:[NSArray class]]) {
            titleLab.text=[self timeZone:[[_timeTitleArr objectAtIndex:section] intValue]];
        }
        
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

#pragma mark - 转换时间戳
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
}

//- (NSString *)timeZoneCell:(int)times{
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"HH:MM"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
//    
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
//    NSString *strTimes = [formatter stringFromDate:confromTimesp];
//    return strTimes;
//}

- (NSString *)timeZoneTest:(int)times{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:MM:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
}

#pragma mark - 修改动画
-(void)changeBtn:(CGRect)Rect
{
    [AnimationEffects MainAnimation:self.cursorImg Animations:moving endEffectMoving:Rect endEffectAlpha:1 time:0.7 overFunction:nil];
}

- (IBAction)emergencyMission:(id)sender {
    [_allInfoArr release];
    _allInfoArr=nil;
    
    page=1;
    
    [self.emergencyBtn setImage:[UIImage imageNamed:@"list1b.png"] forState:UIControlStateNormal];
    [self.todayBtn setImage:[UIImage imageNamed:@"list2c.png"] forState:UIControlStateNormal];
    [self.subscribeBtn setImage:[UIImage imageNamed:@"list3a.png"] forState:UIControlStateNormal];
    rabbitMissionType=emergency;
    [_doingTimerArr removeAllObjects];
    [self reloadInform];
}

- (IBAction)todayMission:(id)sender {
    [_allInfoArr release];
    _allInfoArr=nil;
    
    page=1;
    
    [self.emergencyBtn setImage:[UIImage imageNamed:@"list1a.png"] forState:UIControlStateNormal];
    [self.todayBtn setImage:[UIImage imageNamed:@"list2a.png"] forState:UIControlStateNormal];
    [self.subscribeBtn setImage:[UIImage imageNamed:@"list3a.png"] forState:UIControlStateNormal];
    rabbitMissionType=today;
    [_doingTimerArr removeAllObjects];
    [self reloadInform];
}

- (IBAction)subscribeMission:(id)sender {
    [_allInfoArr release];
    _allInfoArr=nil;
    [_timeTitleArr removeAllObjects];
    
    page=1;
    
    [self.emergencyBtn setImage:[UIImage imageNamed:@"list1a.png"] forState:UIControlStateNormal];
    [self.todayBtn setImage:[UIImage imageNamed:@"list2c.png"] forState:UIControlStateNormal];
    [self.subscribeBtn setImage:[UIImage imageNamed:@"list3c.png"] forState:UIControlStateNormal];
    rabbitMissionType=subscribe;
    [_doingTimerArr removeAllObjects];
    [self reloadInform];
}

#pragma mark - 图片放大
-(void)bigerPhoto:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if ([[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"mission_image"] isEqualToString:@""]) {
        WARNING__ALERT(@"该任务没有图片");
        return;
    }
    
    self.blackHidBtn.hidden=NO;
    self.bigerImg.hidden=NO;
    
    
    [manager downloadWithURL:[NSURL URLWithString:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"mission_image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        self.bigerImg.image=image;
    }];
}

#pragma mark - 图片隐藏
- (IBAction)hiddenBigImg:(id)sender {
    self.blackHidBtn.hidden=YES;
    self.bigerImg.hidden=YES;
}

#pragma mark - 聊天
-(void)speakClick:(id)sender
{
//    self.navigationController.navigationBarHidden=NO;
    Notification__POST(SHOWNAV, nil);
    UIButton *clickBtn=(UIButton *)sender;
    int status=1;
    if (missionStatueType==finishing) {
        status=2;
    }
    
    NSString *demand=[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"];
    if ([_speakerGetArr containsObject:demand]) {
        
        [_speakerGetArr removeObject:demand];
        [self.mainListTable reloadData];
        //去除数组
        isShowCallImage=NO;
        isShowCallImage2=NO;
        self.callImage.hidden=YES;
        self.callImage2.hidden=YES;
        int i=0;
        int removeInt=0;
        for (NSDictionary *detailDic in _spearkerDetailArr) {
            if ([[detailDic objectForKey:@"BNumber"] isEqualToString:demand]) {
                removeInt=i;
            }else{
                if ([[detailDic objectForKey:@"Status"] intValue]==1) {
                    self.callImage.hidden=NO;
                    isShowCallImage=YES;
                }else if ([[detailDic objectForKey:@"Status"] intValue]==2)
                {
                    self.callImage2.hidden=NO;
                    isShowCallImage2=YES;
                }
            }
            
            i+=1;
        }
        
        [_spearkerDetailArr removeObjectAtIndex:removeInt];
        
        if (_speakerGetArr.count==0) {
            Notification__POST(OVERNOTICE, nil);
        }
    }
    
    NSDictionary *postDic=[[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"eusercode"]],@"JID",[NSString stringWithFormat:@"%@",[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"image"]],@"image",[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"],@"BNumber",[NSString stringWithFormat:@"%d",status],@"Status",[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"title"],@"eusername",nil] autorelease];
//    NSLog(@"嘻嘻：%@",postDic);
    Notification__POST(SPEAKER,postDic);
}

#pragma mark - 删除
-(void)deleteCell:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
//    NSMutableArray *tSubScribeInfo=[[NSMutableArray alloc] initWithArray:_subscribeInfoArr];
    NSMutableArray *tAllInfoArr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
    
    if (rabbitMissionType!=subscribe) {
        SHOW__LOADING
        
        DropMission *drop=[[DropMission alloc] init];
        [drop dropMission:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
            XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
            
            
            
            if (RPCResult.success==YES) {
                cancelMission *cancel=[[cancelMission alloc] init];
                [cancel cancelNotice:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
                    
                    //                                    NSLog(@"123");
                    
                    XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                    
                    //                                    NSLog(@"456");
                    
                    if (RPCResult.success==YES) {
                        HIDE__LOADING;
                        
                        WARNING__ALERT(@"取消成功");
                        
                        [tAllInfoArr removeObjectAtIndex:clickBtn.tag];
                        [_allInfoArr release];;
                        _allInfoArr=nil;
                        _allInfoArr=[[NSMutableArray alloc] initWithArray:tAllInfoArr];
                        
                        [_timeTitleArr removeAllObjects];
                        //                                [_subscribeInfoArr removeAllObjects];
                        //                                [_localArr removeAllObjects];
                        //                                [_titleImgArr removeAllObjects];
                        
                        [self newInnerReload];
                        [self.mainListTable reloadData];
                    }else{
                        HIDE__LOADING;
                        WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
                    }
                } failed:^(NSError *error) {
                    HIDE__LOADING
                    WARNING__ALERT(@"请检查您的网络连接");
                }];
                
                
            }else{
                HIDE__LOADING;
                WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
            }
        } failed:^(NSError *error) {
            HIDE__LOADING
            WARNING__ALERT(@"请检查您的网络连接");
        }];
        return;
        
    }
    
//    int i=0;
    int allTag=0;
    if (_subscribeInfoArr.count>0) {
//        NSLog(@"哈哈：%@",_subscribeInfoArr);
        for (NSMutableArray *inArr in _subscribeInfoArr) {
//            NSLog(@"呵呵：%@",inArr);
            if (inArr.count>0) {
                int j=0;
                for (NSDictionary *inDic in inArr) {
                    if (allTag==clickBtn.tag) {
                        SHOW__LOADING
                        
                        DropMission *drop=[[DropMission alloc] init];
                        [drop dropMission:[inDic objectForKey:@"demand_sn"] success:^(id responseData) {
                            XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                            
                            
                            
                            if (RPCResult.success==YES) {
                                cancelMission *cancel=[[cancelMission alloc] init];
                                [cancel cancelNotice:[inDic objectForKey:@"demand_sn"] success:^(id responseData) {
                                    
//                                    NSLog(@"123");
                                    
                                    XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                                    
//                                    NSLog(@"456");
                                    
                                    if (RPCResult.success==YES) {
                                        HIDE__LOADING;
                                        
                                        WARNING__ALERT(@"取消成功");
                                        
                                        [tAllInfoArr removeObject:inDic];
                                        [_allInfoArr release];;
                                        _allInfoArr=nil;
                                        _allInfoArr=[[NSMutableArray alloc] initWithArray:tAllInfoArr];
                                        
                                        [_timeTitleArr removeAllObjects];
                                        //                                [_subscribeInfoArr removeAllObjects];
                                        //                                [_localArr removeAllObjects];
                                        //                                [_titleImgArr removeAllObjects];
                                        
                                        [self newInnerReload];
                                        [self.mainListTable reloadData];
                                    }else{
                                        HIDE__LOADING;
                                        WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
                                    }
                                } failed:^(NSError *error) {
                                    HIDE__LOADING
                                    WARNING__ALERT(@"请检查您的网络连接");
                                }];
                                
                                
                            }else{
                                HIDE__LOADING;
                                WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
                            }
                        } failed:^(NSError *error) {
                            HIDE__LOADING
                            WARNING__ALERT(@"请检查您的网络连接");
                        }];
                        return;
                    }
                    allTag+=1;
                    j+=1;
                }
            }
        }
    }
}

#pragma mark - 打电话
-(void)callPhone:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    SHOW__LOADING
    phoneCall *phone=[[phoneCall alloc] init];
    [phone getPhone:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData){
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        if (RPCResult.success==YES) {
            HIDE__LOADING
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[RPCResult.res objectForKey:@"mobile"]]]];
        }else{
            HIDE__LOADING;
            WARNING__ALERT(RPCResult.res);
        }
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"请检查您的网络连接是否正常");
    }];
//
}

#pragma mark - 结束任务（应急）
-(void)overDoing:(id)sender
{
    UIButton    *clickBtn=(UIButton *)sender;
    
//    NSLog(@"qweqweqweqweqwewqeqweqwe");
//    
//    return;
    
//    NSLog(@"呵呵：%d",clickBtn.tag);
    
    SHOW__LOADING
    OverMission *overMission=[[OverMission alloc] init];
    [overMission overMission:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        MissionOverEmployer *overEmpolyer=[[MissionOverEmployer alloc] init];
        [overEmpolyer over:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
            
        } failed:^(NSError *error) {
            
        }];
        
        if (RPCResult.success==YES) {
            HIDE__LOADING
            WARNING__ALERT(@"成功结束");
            [_allInfoArr removeAllObjects];
            [self newInnerReload];
            [self reloadInform];
        }else{
            HIDE__LOADING;
            WARNING__ALERT(RPCResult.res);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"请检查网络是否通畅");
    }];
//    clickBtn.tag
}

#pragma mark - 开始任务（非应急）
-(void)otherOverDoing:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    SHOW__LOADING
    startMission *start=[[startMission alloc] init];
    
    HttpsStartMission *httpStart=[[HttpsStartMission alloc] init];
    
//    NSLog(@"嘻嘻：%@",_doningBtnArr);
//    NSLog(@"嘻嘻：%@",_allInfoArr);
//    NSLog(@"呵呵：%d",clickBtn.tag);
    
    [httpStart missionStart:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            [start missionStart:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    HIDE__LOADING
                    WARNING__ALERT(@"任务已开始");
                    [clickBtn setImage:[UIImage imageNamed:@"missionEndBtn.png"] forState:UIControlStateNormal];
                    
                    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[_allInfoArr objectAtIndex:clickBtn.tag]];
                    [dic setObject:@"5" forKey:@"order_status"];
                    [arr replaceObjectAtIndex:clickBtn.tag withObject:dic];
                    [_allInfoArr release];
                    _allInfoArr=nil;
                    _allInfoArr=[[NSMutableArray alloc] initWithArray:arr];
                }else{
                    HIDE__LOADING;
                    WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
                }
            } failed:^(NSError *error) {
                HIDE__LOADING;
                WARNING__ALERT(@"请检查网络连接是否顺畅");
            }];
        }else{
            HIDE__LOADING;
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING;
        WARNING__ALERT(@"请检查网络连接是否顺畅");
    }];
}

#pragma mark - 结束任务（非紧急）
-(void)OverMissionOther:(id)sender
{
//    NSLog(@"das;ljdasdjsaoidj");
//    
//    return;
//    
    UIButton *clickBtn=(UIButton *)sender;
    
    OverMission *over=[[OverMission alloc] init];
    SHOW__LOADING
    [over overMission:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        if (RPCResult.success==YES) {
            HIDE__LOADING
            
            
            MissionOverEmployer *overEmpolyer=[[MissionOverEmployer alloc] init];
            [overEmpolyer over:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"] success:^(id responseData) {
                
            } failed:^(NSError *error) {
                
            }];
            
            NSMutableArray  *arr=[[NSMutableArray alloc] initWithArray:_allInfoArr];
            int i=0;
            for (NSDictionary *infoDic in _allInfoArr) {
                if ([[infoDic objectForKey:@"demand_sn"] isEqualToString:[[_allInfoArr objectAtIndex:clickBtn.tag] objectForKey:@"demand_sn"]]) {
                    [arr removeObjectAtIndex:i];
                    [_doningBtnArr removeObjectAtIndex:i];
                }
                i+=1;
            }
            
            [_allInfoArr release];
            _allInfoArr=nil;
            _allInfoArr=[[NSMutableArray alloc] initWithArray:arr];
            
            if (rabbitMissionType==subscribe&&missionStatueType!=finishing) {
                [self newInnerReload];
            }
            
            [self.mainListTable reloadData];
        }else{
            HIDE__LOADING;
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING;
        WARNING__ALERT(@"请检查网络连接是否顺畅");
    }];
}

#pragma mark - 获取当前时间计时器
-(void)timerLocal:(NSTimer *)timer
{
    if (missionStatueType==winning&&rabbitMissionType!=emergency) {
//        NSLog(@"嘻嘻：%@",[self getNowTime]);
        int i=0;
//        for (NSString *timeStr in _timeTitleArr) {
//        NSLog(@"嘻嘻：%@",_doingTimerArr);
        for (NSString *timeStr in _doingTimerArr) {
            if (i>=_doningBtnArr.count) {
                return;
            }
//            NSLog(@"呵呵：%d",[timeStr intValue]);
//            NSLog(@"哈哈：%d",[[self nowTimeCode] intValue]+cutSeverTime);
            
            
            if ([[[_allInfoArr objectAtIndex:i] objectForKey:@"order_status"] intValue]==5) {
                UIButton *changeBtn=[_doningBtnArr objectAtIndex:i];
                [changeBtn setTitle:@"2" forState:UIControlStateNormal];
                
                [changeBtn setImage:[UIImage imageNamed:@"missionEndBtn.png"] forState:UIControlStateNormal];
                changeBtn.hidden=NO;
                [changeBtn removeTarget:self action:@selector(otherOverDoing:) forControlEvents:UIControlEventTouchUpInside];
                [changeBtn addTarget:self action:@selector(OverMissionOther:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([timeStr intValue]<=[[self nowTimeCode] intValue]+cutSeverTime) {
                UIButton *changeBtn=[_doningBtnArr objectAtIndex:i];
                
                [changeBtn setTitle:@"1" forState:UIControlStateNormal];
                
//                NSLog(@"嘻嘻：%@",[self timeZoneTest:[timeStr intValue]]);
//                NSLog(@"哈哈：%@",[self timeZoneTest:[[self nowTimeCode] intValue]]);
//                NSLog(@"tag是：%d",changeBtn.tag);
                
                [changeBtn setImage:[UIImage imageNamed:@"missionStartBtn.png"] forState:UIControlStateNormal];
                changeBtn.hidden=NO;
                [changeBtn addTarget:self action:@selector(otherOverDoing:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            
            i+=1;
        }
    }
}

#pragma mark - 内部重新刷新数据
-(void)innerReload
{
    [_subscribeInfoArr removeAllObjects];
    [_localArr removeAllObjects];
    [_titleImgArr removeAllObjects];
    //            [RPCResult.res objectForKey:@"image"]
    
    for (NSDictionary *infoDic in _allInfoArr) {
        //                NSLog(@"喵：%@",infoDic);
        //计算定位信息
        naviRequest.origin=[AMapGeoPoint locationWithLatitude:[[_localDic objectForKey:@"latitude"] floatValue] longitude:[[_localDic objectForKey:@"longitude"] floatValue]];
        naviRequest.destination=[AMapGeoPoint locationWithLatitude:[[infoDic objectForKey:@"mission_lat"] floatValue] longitude:[[infoDic objectForKey:@"mission_lng"] floatValue]];
        
        [self.search AMapNavigationSearch: naviRequest];
        
        if (![_timeTitleArr containsObject:[infoDic objectForKey:@"book_time"]]) {
            [_timeTitleArr addObject:[infoDic objectForKey:@"book_time"]];
        }
        
        [_titleImgArr addObject:[infoDic objectForKey:@"image"]];
    }
    
    //            NSLog(@"重新获取数据是：%@",RPCResult.res);
    
    for (int i=0; i<_timeTitleArr.count; i++) {
        [_subscribeInfoArr addObject:@""];
    }
    
}

#pragma mark - 重新刷新数据
-(void)newInnerReload
{
    [_subscribeInfoArr removeAllObjects];
    [_localArr removeAllObjects];
    [_titleImgArr removeAllObjects];
    [_timeTitleArr removeAllObjects];
    [_doingTimerArr removeAllObjects];
    //            [RPCResult.res objectForKey:@"image"]
    for (NSDictionary *dic in _allInfoArr) {
        [_localArr addObject:@"无法定位获取"];
    }
    
    for (NSDictionary *infoDic in _allInfoArr) {
        //                NSLog(@"喵：%@",infoDic);
        //计算定位信息
        naviRequest.origin=[AMapGeoPoint locationWithLatitude:[[_localDic objectForKey:@"latitude"] floatValue] longitude:[[_localDic objectForKey:@"longitude"] floatValue]];
        naviRequest.destination=[AMapGeoPoint locationWithLatitude:[[infoDic objectForKey:@"mission_lat"] floatValue] longitude:[[infoDic objectForKey:@"mission_lng"] floatValue]];
        
        [self.search AMapNavigationSearch: naviRequest];
        
        if (![_timeTitleArr containsObject:[infoDic objectForKey:@"book_time"]]) {
            [_timeTitleArr addObject:[infoDic objectForKey:@"book_time"]];
        }
        
        [_titleImgArr addObject:[infoDic objectForKey:@"image"]];
        
//        if (![_doingTimerArr containsObject:[infoDic objectForKey:@"book_time"]]) {
            [_doingTimerArr addObject:[infoDic objectForKey:@"book_time"]];
//        }
    }
    
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
        [_subscribeInfoArr addObject:@""];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_cursorImg release];
    [_biddingBtn release];
    [_winningBtn release];
    [_overBtn release];
    [_mainListTable release];
    [_emergencyBtn release];
    [_todayBtn release];
    [_subscribeBtn release];
    [_promptLab release];
    [_blackHidBtn release];
    [_bigerImg release];
    [_callImage release];
    [_callImage2 release];
    [_biddingDInImg release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCursorImg:nil];
    [self setBiddingBtn:nil];
    [self setWinningBtn:nil];
    [self setOverBtn:nil];
    [self setMainListTable:nil];
    [self setEmergencyBtn:nil];
    [self setTodayBtn:nil];
    [self setSubscribeBtn:nil];
    [self setPromptLab:nil];
    [self setBlackHidBtn:nil];
    [self setBigerImg:nil];
    [self setCallImage:nil];
    [self setCallImage2:nil];
    [self setBiddingDInImg:nil];
    [super viewDidUnload];
}
@end
