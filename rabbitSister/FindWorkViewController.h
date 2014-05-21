//
//  FindWorkViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-12.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindWorkViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "XMPPManager.h"

@interface FindWorkViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapSearchDelegate,UIScrollViewDelegate>
{
    NSMutableDictionary     *_localDic;//本地经纬度字典
    NSMutableArray          *_localArr;//计算定位结果数组
    
    NSMutableArray          *_allInfoArr;//所有数据
    AMapNavigationSearchRequest *naviRequest;
    
    NSMutableArray          *_timeTitleArr;   //时间标题的数组
    
    NSMutableArray          *_titleImgArr;
    
    NSMutableArray          *_subscribeInfoArr;
    
    NSString                *navTitle;
}

@property (retain, nonatomic) IBOutlet UITableView *mainList;
@property (retain, nonatomic) IBOutlet UIButton *emergencyBtn;
@property (retain, nonatomic) IBOutlet UIButton *todayBtn;
@property (retain, nonatomic) IBOutlet UIButton *subscribeBtn;

@property (retain, nonatomic) IBOutlet UIImageView *emergencyDian;
@property (retain, nonatomic) IBOutlet UIImageView *todayDian;
@property (retain, nonatomic) IBOutlet UIImageView *subscribeDian;


@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
