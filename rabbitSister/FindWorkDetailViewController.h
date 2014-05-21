//
//  FindWorkDetailViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindWorkDetailCell.h"

@interface FindWorkDetailViewController : UIViewController<UITextFieldDelegate>
{
    NSMutableDictionary     *_mainInfoDic;
    
    NSMutableDictionary     *_detaileDic;
    
    NSMutableDictionary     *_plistDic;     //配置字典
    NSMutableDictionary     *_topDic;       //上部分的数据字典
    NSMutableDictionary     *_userDic;      //用户信息数据字典
    NSMutableDictionary     *_downPlistDic;      //下部分的数据字典
    NSMutableDictionary     *_downValueDic; //下部分的实际数据字典
    
    NSString                *_localStr;     //距离
    
    NSMutableArray          *_allBtnArr1;   //第一排范围按钮数组
    NSMutableArray          *_allBtnArr2;   //第二排范围按钮数组
    
    NSMutableArray          *_checkTypeArr; //选择类型按钮数组
    
    
    NSMutableDictionary     *_submitDic;    //提交字典信息
    
    UIImage                 *_bigersImg;
    
    
    NSMutableArray          *_allTopKeys;
    NSMutableArray          *_allTopVals;
}

- (id)initWithTitle:(NSString *)navTitle isHidden:(NSString *)isHidden;

-(void)getMainInfo:(NSMutableDictionary *)mainDic local:(NSString *)local;  //获取信息详情

@property (retain, nonatomic) IBOutlet UITableView *mainListTable;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UILabel *biddingLab;
@property (retain, nonatomic) IBOutlet UIButton *blackHidBtn;
@property (retain, nonatomic) IBOutlet UIImageView *bigerImg;
@property (retain, nonatomic) IBOutlet UIImageView *userImg;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *localLab;
@property (retain, nonatomic) IBOutlet UIImageView *usersIconImg;
@property (retain, nonatomic) IBOutlet UIImageView *rankImage;

@end
