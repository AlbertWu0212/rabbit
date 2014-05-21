//
//  HelperRabbitDetailViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperRabbitDetailCell.h"

@interface HelperRabbitDetailViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary     *_mainListDic;
    
    NSArray                 *_levelArray;
    
    NSMutableArray          *_mainObjectArr;    //判断数组
    
    NSMutableArray          *_priceOfArr;
    NSMutableDictionary     *_mainPriceDic;
    
    NSString                *_textViewText;
    
    UIImageView         *_tImg;         //第一套临时图片
    UIImageView         *_tImg2;        //第二套临时图片
    UIImageView         *_tImg3;        //第三套临时图片
    
    NSDictionary        *_imgDic;       //图片存储字典
    
    UITextView          *_resumeTextView;   //简历
    
    /**********以下是兔子的类型数组************/
    NSMutableArray      *_houseKeepingArr;
    NSMutableArray      *_careArr;
    NSMutableArray      *_beautyArr;
    NSMutableArray      *_repairArr;
    
    
    NSString            *_helperTypeTitle;
}

@property (retain, nonatomic) IBOutlet UITableView *mainListTable;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIButton *primaryBtn;
@property (retain, nonatomic) IBOutlet UIButton *intermediateBtn;
@property (retain, nonatomic) IBOutlet UIButton *seniorBtn;

-(void)chooseWorkType:(helperRabbitType)workType;

-(void)getPriceRange:(NSArray *)priceArr;

@end
