//
//  PersonalInforViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-15.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistViewCell.h"
#import "ChangePasswordViewController.h"

@interface PersonalInforViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray         *_mainPlistArray;
    
    NSMutableDictionary     *_userInfoDic;
    
    ChangePasswordViewController    *_changePasswordVC;
    
    UIImageView             *_tImg;          //存储拍照图片
    UILabel                 *_tLab;          //常驻地址Lab
    
    NSMutableArray          *_localArr;      //所在地数据数组
    
    NSString                *_cityStr;      //市的字段
    NSString                *_localStr;     //区的字段
    NSString                *_finalStr;     //分类为4的字段
    
    NSString                *_mainLocalStr;
    
    NSString                *_imageUrl;
    
    
    
    /************所在地配置************/
    NSMutableArray          *_cityMainArr;   //市数组
    NSMutableArray          *_cityMiddleArr; //分类为3的地理数组
    NSMutableArray          *_cityFinalArr;  //分类为4的地理数组
    NSMutableDictionary     *_chooseCityDic;   //选择城市字典
    NSString                *_selfLocationStr;
    
    /************所在地配置************/
}
@property (retain, nonatomic) IBOutlet UIPickerView *loactionPicker;
@property (retain, nonatomic) IBOutlet UITableView *mainTableList;
@property (retain, nonatomic) IBOutlet UIButton *blackBackgroundBtn;

@property (retain, nonatomic) IBOutlet UIView *chooseLocalFinishView;

@end
