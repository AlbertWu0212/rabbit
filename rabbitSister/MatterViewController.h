//
//  MatterViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatterViewCell.h"
#import "EvaluationViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "XMPPManager.h"
#import "ZBAudioRecorder.h"

@interface MatterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapSearchDelegate,UIScrollViewDelegate>
{
    NSString        *_promptStr;
    NSString        *_emergencyStr;
    
    EvaluationViewController    *_evaluationVC;
    
    NSMutableArray  *_mainInfoArray;
    
    UIColor         *_wholeColor;
    
    
    
    
    NSMutableDictionary     *_localDic;//本地经纬度字典
    NSMutableArray          *_localArr;//计算定位结果数组
    
    NSMutableArray          *_allInfoArr;//所有数据
    AMapNavigationSearchRequest *naviRequest;
    
    NSMutableArray          *_timeTitleArr;   //时间标题的数组
    
    NSMutableArray          *_titleImgArr;
    NSMutableArray          *_subscribeInfoArr;
    
    NSString                *navTitle;
    
    
    NSMutableArray          *_speakerGetArr;    //聊天通知信息
    NSMutableArray          *_spearkerDetailArr;
    
    
    NSMutableArray          *_deleteBtnArr;     //删除按钮数组
    
    FMDatabase      *db;//数据库
    FMResultSet     *rs;
    
    //定时器组
    NSMutableArray          *_doningBtnArr;      //显示开始结束按钮，只有在中标的当日和预约用到
    NSMutableArray          *_doingTimerArr;     //总时间数组
}

@property (retain, nonatomic) IBOutlet UIImageView *cursorImg;
@property (retain, nonatomic) IBOutlet UIButton *biddingBtn;
@property (retain, nonatomic) IBOutlet UIButton *winningBtn;
@property (retain, nonatomic) IBOutlet UIButton *overBtn;
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;
@property (retain, nonatomic) IBOutlet UIButton *emergencyBtn;
@property (retain, nonatomic) IBOutlet UIButton *todayBtn;
@property (retain, nonatomic) IBOutlet UIButton *subscribeBtn;
@property (retain, nonatomic) IBOutlet UILabel *promptLab;
@property (retain, nonatomic) IBOutlet UIButton *blackHidBtn;
@property (retain, nonatomic) IBOutlet UIImageView *bigerImg;
@property (retain, nonatomic) IBOutlet UIImageView *biddingDInImg;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (retain, nonatomic) IBOutlet UIImageView *callImage;
@property (retain, nonatomic) IBOutlet UIImageView *callImage2;

@end
