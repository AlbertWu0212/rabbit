//
//  FindWorkDetailViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-9-25.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "FindWorkDetailViewController.h"

#import "SubmitAuction.h"

//声音
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "AnimationEffects.h"


#import "MKNetworkEngine.h"

#import "BiddingNotice.h"

@interface FindWorkDetailViewController ()<PlayingDelegate>
{
    SDWebImageManager *manager;
}
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation FindWorkDetailViewController
//static int arrayCount=0;
//static int arrayNextCount=0;
static bool isHiddenBtn=NO;
static int buttonPage=1;        //判断是第几排范围选项
static int checkType=1;

static int fieldTag=1;          //输入框的tag

static bool isChangeHeight=NO;       //为table添加button

static bool isFirstIn=YES;      //输入默认值
static bool isUseFirstChoose=NO;  //输入默认数字

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (id)initWithTitle:(NSString *)navTitle isHidden:(NSString *)isHidden
{
    if (self) {
        buttonPage=1;
        checkType=1;
        isHiddenBtn=NO;
        fieldTag=1;
        isChangeHeight=NO;
        
        isFirstIn=YES;
        isUseFirstChoose=NO;
        
        
        self.navigationItem.title=navTitle;
        if ([isHidden isEqualToString:@"YES"]) {
            isHiddenBtn=YES;
        }else{
            isHiddenBtn=NO;
        }
        // Custom initialization
        //读取配置文件
        NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"MissionPlist"];
        _mainInfoDic=[[NSMutableDictionary alloc]initWithDictionary:[mainInfoDic objectForKey:@"homeKitchen"]];
        [mainInfoDic release];
        mainInfoDic=nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    NAVIGATION_BACK(@"   返回");
    
    self.mainListTable.bounces=NO;
//    self.mainListTable.scrollEnabled=YES;
    self.mainListTable.backgroundView=nil;
    self.mainListTable.backgroundColor=[UIColor clearColor];
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    
    [self.mainListTable setTableFooterView:self.submitBtn];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        CGRect btnRect=self.mainListTable.frame;
        btnRect.size.width=310;
        self.mainListTable.frame=btnRect;
    }
    
//    [self.mainListTable addSubview:self.submitBtn];
//    [self.mainListTable addSubview:self.biddingLab];
//    
//    if (isHiddenBtn==YES) {
//        self.submitBtn.hidden=YES;
//    }else{
//        self.submitBtn.hidden=NO;
//    }
//    
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    [manager downloadWithURL:[NSURL URLWithString:[_userDic objectForKey:@"image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        self.usersIconImg.image=image;
    }];
    
    [manager downloadWithURL:[NSURL URLWithString:[_userDic objectForKey:@"rank_img"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        self.rankImage.image=image;
    }];
    
    if ([_localStr intValue]==0) {
        self.localLab.text=@"无法定位";
    }else{
        self.localLab.text=_localStr;
    }
    
    self.titleLab.text=[[_detaileDic objectForKey:@"mission"] objectForKey:@"title"];
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - 获取声音
-(void)getVoice:(NSString *)urlPath
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *urlAsString = urlPath;
    NSURL    *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:&error];
    
    /* 下载的数据 */
    if (data != nil){
        if ([data writeToFile:[NSString stringWithFormat:@"%@/downloadVoice/downloadVoice.spx",[documentsPaths objectAtIndex:0]] atomically:YES]) {
        }
        else
        {
            WARNING__ALERT(@"保存声音失败，请检查您的硬盘容量");
        }
    } else {
        WARNING__ALERT(@"声音下载失败");
    }
}

#pragma mark - 获取信息详情
-(void)getMainInfo:(NSMutableDictionary *)mainDic local:(NSString *)local
{
    _detaileDic=[[NSMutableDictionary alloc] initWithDictionary:mainDic];
    
//    NSLog(@"嘻嘻：%@",_detaileDic);
    
    NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"MainFieldPlist"];
    NSMutableDictionary *lostDic=[[[NSMutableDictionary alloc]initWithDictionary:[mainInfoDic objectForKey:@"topField"]] autorelease];
    
    NSMutableDictionary *_downTempDic=[[[NSMutableDictionary alloc] initWithDictionary:[mainInfoDic objectForKey:@"downField"]] autorelease];
    //获取字段数据
    _topDic=[[NSMutableDictionary alloc] initWithDictionary:[_detaileDic objectForKey:@"mission"]];
    _plistDic=[lostDic objectForKey:[[_detaileDic objectForKey:@"mission"] objectForKey:@"cate_code"]];
    
//    NSArray *keyArray = [[_plistDic  allKeys]sortedArrayUsingSelector:@selector(compare:)]; //经行排序
//    NSLog(@"吼吼：%@",keyArray);
    _userDic=[[NSMutableDictionary alloc] initWithDictionary:[_detaileDic objectForKey:@"user"]];
    _downPlistDic=[_downTempDic objectForKey:[[_detaileDic objectForKey:@"mission"] objectForKey:@"cate_code"]];
    _downValueDic=[[NSMutableDictionary alloc] initWithDictionary:[_topDic objectForKey:@"fee"]];
//    NSLog(@"哈哈：%@",_downPlistDic);
    
    _submitDic=[_downTempDic objectForKey:[[_detaileDic objectForKey:@"mission"] objectForKey:@"cate_code"]];
    for (NSString *submitStr in _submitDic.allValues) {
        submitStr=@"";
    }
    
    //时间戳转换
    if ([_topDic.allKeys containsObject:@"pickup_time"]) {
        [_topDic setObject:[self timeZoneCell:[[_topDic objectForKey:@"pickup_time"] intValue]] forKey:@"pickup_time"];
    }
    
    if ([_topDic.allKeys containsObject:@"arrive_time"]) {
        [_topDic setObject:[self timeZoneCell:[[_topDic objectForKey:@"arrive_time"] intValue]] forKey:@"arrive_time"];
    }
    
    if ([_topDic.allKeys containsObject:@"reg_time"]) {
        [_topDic setObject:[self timeZoneCell:[[_topDic objectForKey:@"reg_time"] intValue]] forKey:@"reg_time"];
    }
    
    if ([_topDic.allKeys containsObject:@"finish_time"]) {
        [_topDic setObject:[self timeZoneCell:[[_topDic objectForKey:@"finish_time"] intValue]] forKey:@"finish_time"];
    }
    
    _localStr=local;
    
    //综合按钮数组初始化
    _allBtnArr1=[[NSMutableArray alloc] init];
    _allBtnArr2=[[NSMutableArray alloc] init];
    _checkTypeArr=[[NSMutableArray alloc] init];
    
    
    [_plistDic removeObjectForKey:@"detail"];
    _allTopKeys=[[NSMutableArray alloc] initWithArray:_plistDic.allKeys];
    [_allTopKeys addObject:@"detail"];
    _allTopVals=[[NSMutableArray alloc] initWithArray:_plistDic.allValues];
    [_allTopVals addObject:@"服务描述"];
    [_plistDic setObject:@"服务描述" forKey:@"detail"];
    
    if (![[_topDic objectForKey:@"voice"] isEqualToString:@""]) {
//        NSLog(@"地址是：%@",[_topDic objectForKey:@"voice"]);
        [self getVoice:[_topDic objectForKey:@"voice"]];
    }
    
    
//    NSLog(@"喵：%@",_detaileDic);
}

#pragma mark - 转换时间戳
- (NSString *)timeZoneCell:(int)times{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
//        NSLog(@"日：%@",[_plistDic objectForKey:@"detail"]);
//        NSLog(@"呵呵：%@",_topDic);
//        return 5;
        return _plistDic.count;
    }
//    return 1;
    return _downPlistDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"123");
//    NSLog(@"草草：%d",indexPath.row);
    if (indexPath.section==0&&indexPath.row==0&&isChangeHeight==NO) {
        isChangeHeight=YES;
        self.mainListTable.contentSize=CGSizeMake(self.mainListTable.contentSize.width, self.mainListTable.contentSize.height+41);
    }
    
    FindWorkDetailCell *cell = (FindWorkDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"FindWorkDetailCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    CGRect tRect;
    
    switch (indexPath.section) {
        case 0:
            /************录音，图片隐藏***************/
            cell.contentLab.numberOfLines=1;
            cell.rangeView.hidden=YES;
            tRect=cell.backgroundImg.frame;
            if (indexPath.row==_plistDic.allValues.count-1) {
                tRect.size.height=85;
                
                [manager downloadWithURL:[NSURL URLWithString:[_topDic objectForKey:@"image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                    
                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                    cell.contentImg.image=image;
                    _bigersImg=image;
                }];
                
                if ([[_topDic objectForKey:@"voice"] isEqualToString:@""]) {
                    cell.soundBtn.hidden=YES;
                }else{
                    [cell.soundBtn addTarget:self action:@selector(voiceSound) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                cell.bigImgBtn.hidden=NO;
                [cell.bigImgBtn addTarget:self action:@selector(bigerPhoto:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                tRect.size.height=20;
                cell.contentImg.hidden=YES;
                cell.soundBtn.hidden=YES;
                cell.soundTime.hidden=YES;
                
            }
            
            cell.backgroundImg.frame=tRect;
            /************录音，图片隐藏***************/
//            cell.titleLab.text=[_plistDic.allValues objectAtIndex:indexPath.row];
//            cell.contentLab.text=[_topDic objectForKey:[_plistDic.allKeys objectAtIndex:indexPath.row]];
            
            cell.titleLab.text=[_allTopVals objectAtIndex:indexPath.row];
            
            if ([[_allTopKeys objectAtIndex:indexPath.row] isEqualToString:@"detail"]) {
                cell.contentLab.numberOfLines=1;
                
                CGRect contentLab=cell.contentLab.frame;
                
                contentLab.size.width=140;
                
                NSString *tStr=[_topDic objectForKey:@"detail"];
                
                //                NSString *imgUrl=[_topDic objectForKey:@"image"];
                
                if ([self getChina:tStr]>12) {
                    cell.contentLab.numberOfLines=[self getChina:tStr]/20+1;
                    //                    cell.contentLab.numberOfLines=4;
                    //                    NSLog(@"呵呵：%d",cell.contentLab.numberOfLines);
                    contentLab.size.height=([self getChina:tStr]/20+1)*15;
                    contentLab.origin.y=cell.titleLab.frame.origin.y;
                    
                    //                NSLog(@"高度是：%f",contentLab.size.height);
                    
                    cell.contentLab.frame=contentLab;
                    //                    cell.contentLab.backgroundColor=[UIColor redColor];
                    
                    contentLab=cell.backgroundImg.frame;
                    //                    contentLab.size.height=([self getChina:tStr]/12)*12+40;
                    contentLab.size.height=85;
                    cell.backgroundImg.frame=contentLab;
                    
                    
                    
                    CGRect soundRect=cell.soundBtn.frame;
                    soundRect.origin.y=cell.contentLab.frame.origin.y+cell.contentLab.frame.size.height+3;
                    cell.soundBtn.frame=soundRect;
                }
            }
            
            
//            NSLog(@"呵呵：%@",[_topDic objectForKey:[_allTopKeys objectAtIndex:indexPath.row]]);
            id lengthStr=[_topDic objectForKey:[_allTopKeys objectAtIndex:indexPath.row]];
            if (![lengthStr isKindOfClass:[NSString class]]) {
                cell.contentLab.text=@"普通件";
            }else{
                cell.contentLab.text=[_topDic objectForKey:[_allTopKeys objectAtIndex:indexPath.row]];
            }
            
            
            
            if ([[_allTopVals objectAtIndex:indexPath.row] isEqualToString:@"服务时间"]) {
                cell.contentLab.text=[NSString stringWithFormat:@"%@小时",[_topDic objectForKey:[_allTopKeys objectAtIndex:indexPath.row]]];
            }
            
            
            break;
            
        default:
            /************录音，图片隐藏***************/
            cell.contentImg.hidden=YES;
            cell.soundBtn.hidden=YES;
            cell.soundTime.hidden=YES;
            cell.contentLab.hidden=YES;
            
            tRect=cell.backgroundImg.frame;
            tRect.size.height=40;
            cell.backgroundImg.frame=tRect;
            cell.backgroundImg.image=[UIImage imageNamed:@"10.png"];
            /************录音，图片隐藏***************/
            tRect=cell.titleLab.frame;
            tRect.size.width=100;
            tRect.origin.y=13;
            cell.titleLab.frame=tRect;
            
            NSDictionary *plistDic=[_downValueDic objectForKey:[[_downPlistDic allKeys]objectAtIndex:indexPath.row]];
            int type=[[[_downValueDic objectForKey:[[_downPlistDic allKeys]objectAtIndex:indexPath.row]] objectForKey:@"type"] intValue];       //兔子类型
            
            cell.titleLab.text=[[_downPlistDic allValues] objectAtIndex:indexPath.row];
            
            
            if (type==2) {
                cell.titleLab.text=@"商品金额";
            }
            
            NSArray *inforRangeArr;
            switch (type) {
                    // 范围选择
                case 1:
                    cell.type1.hidden=NO;
                    if (![[[plistDic objectForKey:@"val"] objectForKey:@"unit"] isEqualToString:@""]) {
                        
                        NSString *addStr;
                        
                        switch ([[[plistDic objectForKey:@"val"] objectForKey:@"unit"] intValue]) {
                            case 1:
                                addStr=@"/11km";
                                break;
                                
                            case 2:
                                addStr=@"/小时";
                                break;
                                
                            case 3:
                                addStr=@"/次";
                                break;
                                
                            case 4:
                                addStr=@"/1km+起步费";
                                break;
                                
                            default:
                                addStr=@"";
                                break;
                        }
                        
//                        cell.titleLab.text=[NSString stringWithFormat:@"%@%@",cell.titleLab.text,addStr];
                        cell.titleLab.text=[NSString stringWithFormat:@"%@%@",cell.titleLab.text,[[plistDic objectForKey:@"val"] objectForKey:@"unit"] ];
                    }
                    
                    /*****调整scrollView上面的控件******/
                    inforRangeArr=[[[_downValueDic objectForKey:[[_downPlistDic allKeys]objectAtIndex:indexPath.row]] objectForKey:@"val"] objectForKey:@"range"];
                    
                    if (inforRangeArr.count>4) {
                        cell.type1ScrollView.contentSize=CGSizeMake(310, cell.type1ScrollView.contentSize.height);
                    }
                    
                    for (id views in cell.type1ScrollView.subviews) {
                        //校准横杠
                        if ([views isKindOfClass:[UIImageView class]]) {
                            UIImageView *img=(UIImageView *)views;
                            if (img.tag>inforRangeArr.count-1) {
                                img.hidden=YES;
                            }
                        }
                        
                        //校准显示数字
                        if ([views isKindOfClass:[UILabel class]]) {
                            UILabel *lab=(UILabel *)views;
                            if (lab.tag>inforRangeArr.count) {
                                lab.hidden=YES;
                            }else{
                                lab.text=[NSString stringWithFormat:@"%@",[inforRangeArr objectAtIndex:lab.tag-1]];
                            }
                        }
                        
                        //校准按钮
                        if ([views isKindOfClass:[UIButton class]]) {
                            UIButton *btn=(UIButton *)views;
                            if (btn.tag>inforRangeArr.count) {
                                btn.hidden=YES;
                            }else{
                                [btn setTitle:[NSString stringWithFormat:@"%@",[inforRangeArr objectAtIndex:btn.tag-1]] forState:UIControlStateNormal];
                                
                                [btn addTarget:self action:@selector(chooseRange:) forControlEvents:UIControlEventTouchUpInside];
                                
                                if (isFirstIn==YES&&isUseFirstChoose==NO) {
                                    [self chooseRange:btn];
                                }
                                
                                if (buttonPage==1) {
                                    [_allBtnArr1 addObject:btn];
                                }else{
                                    [_allBtnArr2 addObject:btn];
                                }
                                
                                
                            }
                        }
                    }
                    /*****调整scrollView上面的控件******/
                    buttonPage+=1;
                    break;
                    
                case 2:
                    // 结算类型 (现结，预付)二选一
                    cell.type2.hidden=NO;
                    [_checkTypeArr addObject:cell.prepaidBtn];
                    [_checkTypeArr addObject:cell.nowCashBtn];
                    [cell.prepaidBtn addTarget:self action:@selector(chooseCheckType:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.nowCashBtn addTarget:self action:@selector(chooseCheckType:) forControlEvents:UIControlEventTouchUpInside];
                    if (isFirstIn==YES) {
                        [self chooseCheckType:cell.prepaidBtn];
                    }
                    
                    
                    break;
                    
                case 3:
                    // 物品价格
                    cell.type3.hidden=NO;
                    NSDictionary *valueDic=[[[NSDictionary alloc] initWithDictionary:[[_downValueDic allValues] objectAtIndex:indexPath.row]] autorelease] ;
                    
//                    NSLog(@"呵呵：%@",[valueDic objectForKey:@"val"]);
                    
                    cell.type3Lab.text=[NSString stringWithFormat:@"￥%@",[(NSNumber*)[valueDic objectForKey:@"val"] stringValue]];
                    if ([cell.type3Lab.text isEqualToString:@"-1"]) {
                        cell.type3Lab.text=@"打表";
                    }
                    
                    if ([cell.type3Lab.text isEqualToString:@"0"]) {
                        cell.type3Lab.text=@"￥1";
                    }
                    
                    [_submitDic setObject:cell.type3Lab.text forKey:[[_downValueDic allKeys] objectAtIndex:indexPath.row]];
                    
                    break;
                    
                case 4:
                    // 用户输入类型
                    cell.type4.hidden=NO;
                    
                    cell.type4Field.delegate=self;
                    cell.type4Field.tag=fieldTag;
                    fieldTag+=1;
                    
                    [cell.type4Field addPreviousNextDoneOnKeyboardWithTarget:self
                                                                 previousAction:nil
                                                                     nextAction:nil
                                                                     doneAction:@selector(doneClicked:)];
                    [cell.type4Field setEnablePrevious:NO next:YES];
                    break;
                    
                default:
                    break;
            }
            
//            _downValueDic
            cell.titleLab.font=[UIFont fontWithName:@"STHeitiTC-Medium" size:14];
            
            if (_downValueDic.count==indexPath.row+1) {
                isFirstIn=NO;
            }
            
            break;
    }
    
//    NSLog(@"日日：%d",indexPath.row);
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==_plistDic.allValues.count-1) {
            NSString *tStr=[_topDic objectForKey:@"detail"];
//            NSLog(@"字符数：%d",([self getChina:tStr]/12)*12+40);
//            NSString *imgUrl=[_topDic objectForKey:@"image"];
            
            if (tStr.length>12) {
                
//                NSLog(@"呵呵：%d",([self getChina:tStr]/12)*12+40);
                return ([self getChina:tStr]/12)*12+40;
            }
            
            return 85;
        }
        return 20;
    }
    return 45;
}

#pragma mark - 判断字符数
-(int)getChina:(NSString *)string
{
    int strCount=0;
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            strCount+=2;
        }else{
            strCount+=1;
        }
    }
    
    return strCount;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 55;
    return 1;
    if (section==1) {
        return 55;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 55;
    if (section==1) {
        return 1;
        return 55;
    }
    return 55;
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
//    NSLog(@"呵呵：%d",section);
    self.biddingLab.text=@"\n我要竞价";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        self.biddingLab.text=@"\n   我要竞价";
    }
    self.biddingLab.backgroundColor=[UIColor clearColor];
    return self.biddingLab;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    self.biddingLab.text=@"\n我要竞价";
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        
//        self.biddingLab.text=@"\n   我要竞价";
//    }
//    self.biddingLab.backgroundColor=[UIColor redColor];
//    return self.biddingLab;
    self.biddingLab.hidden=YES;
    if (section==1) {
        return nil;
    }
    UIView *returnView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 55)];
    UILabel *addLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
    addLab.text=@"\n我要竞价";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        addLab.text=@"\n   我要竞价";
    }
    addLab.font=[UIFont fontWithName:@"Arial" size:15.0f];
    addLab.text=@"我要竞价";
    addLab.backgroundColor=[UIColor clearColor];
    [returnView addSubview:addLab];
    
    return returnView;
    
    return self.submitBtn;
}

#pragma mark - 结束编辑
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int i=0;
    BOOL isMutableField=NO;
    
    if (textField.tag==2) {
        isMutableField=YES;
    }
    
    for (NSDictionary *getDic in _downValueDic.allValues) {
        if ([[getDic objectForKey:@"type"] intValue]==4) {
            if (isMutableField==YES) {
                isMutableField=NO;
            }else{
                [_submitDic setObject:textField.text forKey:[[_downValueDic allKeys] objectAtIndex:i]];
                break;
            }
        }
        i+=1;
    }
}

#pragma mark - 播放声音
-(void)voiceSound
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        
        self.isPlaying = YES;
        [[PlayerManager sharedManager] playAudioWithFileName:[NSString stringWithFormat:@"%@/downloadVoice/downloadVoice.spx",[documentsPaths objectAtIndex:0]] delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}

- (void)playingStoped {
    self.isPlaying = NO;
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    for (NSString *submitStr in _submitDic.allValues) {
        if ([submitStr intValue]==0) {
            if (![submitStr isEqualToString:@"打表"]) {
                if (![[submitStr substringToIndex:1] isEqualToString:@"￥"]) {
                    WARNING__ALERT(@"请将竞价信息填写完整");
                    return;
                }
                
            }else{
                [_submitDic setObject:@"-1" forKey:@"serve_fee"];
            }
        }
    }

    SHOW__LOADING   
    
    //抽取本地信息
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    SubmitAuction *submitAuction=[[SubmitAuction alloc] init];
    [submitAuction submitAuction:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] demand_sn:[[_detaileDic objectForKey:@"mission"] objectForKey:@"demand_sn"] dic:_submitDic success:^(id responseData){
//        NSLog(@"成功：%@",responseData);
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        if (RPCResult.success==YES) {
#pragma mark - 提交公共推送
            BiddingNotice *bidingNotice=[[BiddingNotice alloc] init];
            [bidingNotice biddingNotice:[[_detaileDic objectForKey:@"mission"] objectForKey:@"demand_sn"] success:^(id responseData) {
                
//                NSLog(@"嘻嘻：%@",responseData);
                
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    self.navigationController.navigationBar.hidden=YES;
                    HIDE__LOADING
                    WARNING__ALERT(@"提交成功");
                    [_allBtnArr1 removeAllObjects];
                    Notification__POST(SUBMITINFO,nil);
                    
                    
                    Notification__POST(HIDENAV, nil);
                    
                }else{
                    HIDE__LOADING
                    WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
                }
            } failed:^(NSError *error) {
                HIDE__LOADING
                WARNING__ALERT(@"网络连接不通，请检查网络连接");
            }];
        }else{
            HIDE__LOADING
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"网络连接不通，请检查网络连接");
    }];
    
}

#pragma mark - 图片放大
- (IBAction)bigerPhoto:(id)sender {
    self.blackHidBtn.hidden=NO;
    self.bigerImg.hidden=NO;
    self.bigerImg.image=_bigersImg;
}

#pragma mark - 图片隐藏
- (IBAction)hiddenBigImg:(id)sender {
    self.blackHidBtn.hidden=YES;
    self.bigerImg.hidden=YES;
}

#pragma mark - 点击选择范围
-(void)chooseRange:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
//    NSLog(@"呵呵：%@",clickBtn.titleLabel.text);
    bool isFirstValue=YES;
    
    NSArray *tArr;
//    NSLog(@"喵：%@",_allBtnArr1);
//    NSLog(@"汪：%@",_allBtnArr2);
    
    if ([_allBtnArr1 containsObject:clickBtn]){
        tArr=_allBtnArr1;
        isFirstValue=YES;
        for (UIButton *changeBtn in _allBtnArr1) {
            if (changeBtn.tag!=clickBtn.tag) {
                [changeBtn setImage:[UIImage imageNamed:@"scrollfwyuan.png"] forState:UIControlStateNormal];
            }
        }
    }else{
        tArr=_allBtnArr2;
        isFirstValue=NO;
        for (UIButton *changeBtn in _allBtnArr2) {
            if (changeBtn.tag!=clickBtn.tag) {
                [changeBtn setImage:[UIImage imageNamed:@"scrollfwyuan.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    int i=0;
//    NSLog(@"呵呵：%@",_downValueDic);
    
    for (NSDictionary *checkType in _downValueDic.allValues) {
        
        if ([[checkType objectForKey:@"type"] intValue]==1) {
            
            if (isFirstValue==YES||isUseFirstChoose==NO) {
                
                [_submitDic setObject:clickBtn.titleLabel.text forKey:[_downValueDic.allKeys objectAtIndex:i]];
                break;
            }else{
                isFirstValue=YES;
            }
        }
        i+=1;
    }
    
    [clickBtn setImage:[UIImage imageNamed:@"blue dot.png"] forState:UIControlStateNormal];
    
    isUseFirstChoose=YES;
}

#pragma mark - 点击选择类型
-(void)chooseCheckType:(id)sender
{
    int submitType=1;
    
    UIButton *clickBtn=(UIButton *)sender;
    checkType=clickBtn.tag;
    for (UIButton *chooseBtn in _checkTypeArr) {
        if (clickBtn.tag!=chooseBtn.tag) {
            [chooseBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
            submitType=1;
        }else{
            [chooseBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
            submitType=2;
        }
    }
    
    int i=0;
    for (NSDictionary *checkType in _downValueDic.allValues) {
        if ([[checkType objectForKey:@"type"] intValue]==2) {
            [_submitDic setObject:[NSString stringWithFormat:@"%d",submitType] forKey:[_downValueDic.allKeys objectAtIndex:i]];
            break;
        }
        i+=1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [_submitBtn release];
    [_biddingLab release];
    [_blackHidBtn release];
    [_bigerImg release];
    [_userImg release];
    [_titleLab release];
    [_localLab release];
    [_usersIconImg release];
    [_rankImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [self setSubmitBtn:nil];
    [self setBiddingLab:nil];
    [self setBlackHidBtn:nil];
    [self setBigerImg:nil];
    [self setUserImg:nil];
    [self setTitleLab:nil];
    [self setLocalLab:nil];
    [self setUsersIconImg:nil];
    [self setRankImage:nil];
    [super viewDidUnload];
}
@end
