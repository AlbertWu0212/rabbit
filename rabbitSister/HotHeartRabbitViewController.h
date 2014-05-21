//
//  HotHeartRabbitViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotHeartRabbitViewCell.h"

@interface HotHeartRabbitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray      *_mainInfoArr;
    
    NSMutableArray      *_incidentallyArr;       //判断数组
    NSMutableArray      *_incidentallyBtnArr;
    
    NSMutableArray      *_carArr;               //车辆判断数组
    NSMutableArray      *_carBtnArr;
    
    UIButton            *_tempMainBtn;          //临时主要按钮指针
    
    NSMutableArray      *_chooseFirstArr;       //选择第一批LAB的数组
    NSMutableArray      *_chooseMainArr;        //选择第二批LAB的数组
    
    UIImageView         *_tImg;         //第一套临时图片
    UIImageView         *_tImg2;        //第二套临时图片
    
    NSDictionary        *_imgDic;       //图片存储字典
    /**********传送数据的field***********/
    UITextField         *_uploadText1;
    UITextField         *_uploadText2;
    UITextField         *_uploadText3;
    UITextField         *_uploadText4;
    
    NSMutableArray      *_uploadFieldArr;   //上传的数据数组
}
@property (retain, nonatomic) IBOutlet UITableView *mainTable;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIButton *incidentallyBtn;
@property (retain, nonatomic) IBOutlet UIButton *carsBtn;

@end
