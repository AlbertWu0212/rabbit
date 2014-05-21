//
//  MapViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-7.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize search  = _search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _localDic=[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)getLocal:(NSDictionary *)localDicload
{
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
    naviRequest.origin=[AMapGeoPoint locationWithLatitude:[[_localDic objectForKey:@"latitude"] floatValue] longitude:[[_localDic objectForKey:@"longitude"] floatValue]];
    naviRequest.destination=[AMapGeoPoint locationWithLatitude:[[localDicload objectForKey:@"mission_lat"] floatValue] longitude:[[localDicload objectForKey:@"mission_lng"] floatValue]];
    [self.search AMapNavigationSearch: naviRequest];
}

#pragma mark - 获取驾车路径
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    AMapPath *mapPath=[response.route.paths objectAtIndex:0];
    NSLog(@"喵：%d", mapPath.distance);
}

#pragma mark - 定位本地经纬度
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
{
    //    NSLog(@"成功");
    [_localDic setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [_localDic setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"longitude"];

}

-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
    NSLog(@"失败：%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
