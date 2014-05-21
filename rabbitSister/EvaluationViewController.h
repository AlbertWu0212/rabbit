//
//  EvaluationViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-17.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationViewController : UIViewController<UITextViewDelegate>
{
    NSMutableDictionary     *_mainDic;
    
    NSString                *_localStr;
    
    NSMutableArray          *_ageBtnArr;
    NSMutableArray          *_commentBtnArr;
}

-(void)getDic:(NSDictionary *)dic;

-(void)getLocal:(NSString *)local;
- (IBAction)changeSex:(id)sender;
- (IBAction)changeComments:(id)sender;
- (IBAction)changeAge:(id)sender;



@property (retain, nonatomic) IBOutlet UIImageView *changeAge;



@property (retain, nonatomic) IBOutlet UIButton *changeSex;
@property (retain, nonatomic) IBOutlet UILabel *evaStatusLab;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *localLab;
@property (retain, nonatomic) IBOutlet UILabel *priceLab;
@property (retain, nonatomic) IBOutlet UIButton *manBtn;
@property (retain, nonatomic) IBOutlet UIButton *womanBtn;
@property (retain, nonatomic) IBOutlet UIButton *greatBtn;
@property (retain, nonatomic) IBOutlet UIButton *middleBtn;
@property (retain, nonatomic) IBOutlet UIButton *badBtn;
@property (retain, nonatomic) IBOutlet UIButton *complaintsBtn;
@property (retain, nonatomic) IBOutlet UITextView *complaintsText;
@property (retain, nonatomic) IBOutlet UIButton *ageBtn1;
@property (retain, nonatomic) IBOutlet UIButton *ageBtn2;
@property (retain, nonatomic) IBOutlet UIButton *ageBtn3;
@property (retain, nonatomic) IBOutlet UIButton *ageBtn4;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIImageView *subShowBtn;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (retain, nonatomic) IBOutlet UIButton *forbidBtn;
@property (retain, nonatomic) IBOutlet UIImageView *bigerImg;

@end
