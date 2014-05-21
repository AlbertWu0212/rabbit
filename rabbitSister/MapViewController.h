//
//  MapViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-11-7.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MapViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>
{
    AMapNavigationSearchRequest *naviRequest;
    
    NSMutableDictionary     *_localDic;//本地经纬度字典
}
-(void)getLocal:(NSDictionary *)localDicload;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@end
