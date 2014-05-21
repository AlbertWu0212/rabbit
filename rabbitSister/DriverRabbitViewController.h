//
//  DriverRabbitViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverRabbitCell.h"

@interface DriverRabbitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray      *_mainInfoArr;
    
    NSMutableArray      *_topArr;       //上部CELL数组
    NSMutableArray      *_topBtnArr;    //上部CELL按钮数组
    
    NSMutableArray      *_middleArr;    //中部CELL数组
    NSMutableArray      *_middleBtnArr; //中部CELL按钮数组
    
    UIButton            *_tempTopBtn;   //临时顶部按钮
    UIButton            *_tempMiddleBtn;//临时中部按钮
    
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
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIButton *carBtn;
@property (retain, nonatomic) IBOutlet UIButton *publicCarBtn;

@end
