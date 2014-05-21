//
//  RegistViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//
//  注册信息填写

#import <UIKit/UIKit.h>
#import "RegistViewCell.h"
#import "PSSFileOperations.h"

@interface RegistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSMutableArray         *_mainPlistArray;
    
    UIImageView             *_tImg;          //存储拍照图片
    UILabel                 *_tLab;          //常驻地址Lab
    
    NSString                *_cityStr;      //市的字段
    NSString                *_localStr;     //分类为3的字段
    NSString                *_finalStr;     //分类为4的字段
    
    NSMutableArray          *_localArr;      //所在地数据数组
    
    NSString                *_imageUrl;      //上传图片地址
    NSString                *_idImgUrl;      //身份证地址
    
    NSMutableArray          *_cityMainArr;   //市数组
    NSMutableArray          *_cityMiddleArr; //分类为3的地理数组
    NSMutableArray          *_cityFinalArr;  //分类为4的地理数组
    NSMutableDictionary     *_chooseCityDic;   //选择城市字典
    
    
    UIButton                *_maleBtn;       //男性选择按钮
    UIButton                *_femaleBtn;     //女性选择按钮
    
    NSString                *_selfLocationStr;
    /**************以下是传送数据的控件**************/
    UITextField             *_telephoneField;
    UITextField             *_authField;
    UITextField             *_usernameField;
    UITextField             *_passwordField;
    UITextField             *_realNameField;
    UITextField             *_addressField;
    UITextField             *_idnumberField;
    UITextField             *_companyNameField;
    UITextField             *_companyCode;
    UITextField             *_stationName;
    
    NSMutableArray          *_uploadAllField;
    
    
    UILabel                 *_textLab;
    
    UIImage                 *_saveImg;
    UIImage                 *_idImg;
    UIButton                *_teleBtn;
}
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) IBOutlet UIButton *personBtn;
@property (retain, nonatomic) IBOutlet UILabel *personLab;
@property (retain, nonatomic) IBOutlet UIButton *companyBtn;
@property (retain, nonatomic) IBOutlet UILabel *companyLab;
@property (retain, nonatomic) IBOutlet UIButton *agreementBtn;
@property (retain, nonatomic) IBOutlet UIImageView *agreementImg;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIPickerView *loactionPicker;
@property (retain, nonatomic) IBOutlet UIButton *blackBackgroundBtn;
@property (retain, nonatomic) IBOutlet UIButton *comeWebBtn;

@property (retain, nonatomic) IBOutlet UIButton *chooseLocalFinishBtn;
@property (retain, nonatomic) IBOutlet UIView *chooseLocalFinishView;


@end
