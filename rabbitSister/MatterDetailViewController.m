//
//  MatterDetailViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-11-26.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MatterDetailViewController.h"

#import "SubmitAuction.h"

//声音
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "AnimationEffects.h"


#import "MKNetworkEngine.h"

#import "MatterDetailCell.h"

@interface MatterDetailViewController ()<PlayingDelegate>
{
    SDWebImageManager *manager;
}
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation MatterDetailViewController
static bool isHiddenBtn=NO;
static int buttonPage=1;        //判断是第几排范围选项
static int checkType=1;

static int fieldTag=1;          //输入框的tag

static bool isChangeHeight=NO;       //为table添加button

static bool totalFeeBug=NO;
//110~130调整成finish time

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
        totalFeeBug=NO;
        
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
    
//    [self.mainListTable setTableFooterView:self.submitBtn];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        CGRect btnRect=self.mainListTable.frame;
//        btnRect.size.width=310;
//        self.mainListTable.frame=btnRect;
//    }
    // Do any additional setup after loading the view from its nib.
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
}

//BACK_ACTION
-(void)backAction{
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

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
//    NSLog(@"草草：%@",_detaileDic);
    
    NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"MatterDetailPlist"];
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
//    NSLog(@"获取价格是：%@",_downValueDic);
//    NSLog(@"哈哈：%@",[_topDic objectForKey:@"fee"]);
    
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
//    NSLog(@"嘻嘻：%@",_allTopKeys);
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _plistDic.count;
    }
    
    return _downPlistDic.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0&&indexPath.row==0&&isChangeHeight==NO) {
//        isChangeHeight=YES;
//        self.mainListTable.contentSize=CGSizeMake(self.mainListTable.contentSize.width, self.mainListTable.contentSize.height+41);
//    }
    
    MatterDetailCell *cell = (MatterDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"MatterDetailCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    CGRect tRect;
    
    switch (indexPath.section) {
        case 0:
            /************录音，图片隐藏***************/
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
            }
            
            cell.backgroundImg.frame=tRect;
            /************录音，图片隐藏***************/
            //            cell.titleLab.text=[_plistDic.allValues objectAtIndex:indexPath.row];
            //            cell.contentLab.text=[_topDic objectForKey:[_plistDic.allKeys objectAtIndex:indexPath.row]];
            
            cell.titleLab.text=[_allTopVals objectAtIndex:indexPath.row];
            cell.contentLab.text=[_topDic objectForKey:[_allTopKeys objectAtIndex:indexPath.row]];
            
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
            
            
//            PSSFileOperations *fileOperation=[[PSSFileOperations alloc] init];
//            if ([[_allTopKeys objectAtIndex:indexPath.row] isEqualToString:@"arrive_addr"]&&[[_detaileDic objectForKey:@"cate_code"] intValue]>=190) {
//                
//                cell.contentLab.text=[NSString stringWithFormat:@"%@%@",[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@ and is_open=1",[[_detaileDic objectForKey:@"mission"] objectForKey:@"arrive_city"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"],cell.contentLab.text];
//            }
//            
//            
//            if ([[_allTopKeys objectAtIndex:indexPath.row] isEqualToString:@"work_addr"]&&[[_detaileDic objectForKey:@"cate_code"] intValue]>=190) {
//                cell.contentLab.text=[NSString stringWithFormat:@"%@%@",[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@ and is_open=1",[[_detaileDic objectForKey:@"mission"] objectForKey:@"city"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"],cell.contentLab.text];
//            }
//            
//            
//            if ([[_allTopKeys objectAtIndex:indexPath.row] isEqualToString:@"pickup_addr"]&&[[_detaileDic objectForKey:@"cate_code"] intValue]>=190) {
//                cell.contentLab.text=[NSString stringWithFormat:@"%@%@",[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@ and is_open=1",[[_detaileDic objectForKey:@"mission"] objectForKey:@"start_city"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"],cell.contentLab.text];
//            }
            
            
            break;
            
        default:
            /************录音，图片隐藏***************/
            cell.contentImg.hidden=YES;
            cell.soundBtn.hidden=YES;
            cell.contentLab.hidden=YES;
            cell.backgroundImg.hidden=YES;
            
            tRect=cell.backgroundImg.frame;
            tRect.size.height=40;
            cell.backgroundImg.frame=tRect;
            cell.backgroundImg.image=[UIImage imageNamed:@"10.png"];
            cell.contentLab.textColor=[UIColor orangeColor];
            /************录音，图片隐藏***************/
//            tRect=cell.titleLab.frame;
//            tRect.size.width=100;
//            tRect.origin.y=13;
//            cell.titleLab.frame=tRect;
            
            if (indexPath.row==0) {
                cell.topLine.hidden=NO;
            }
            
            if (indexPath.row==_downPlistDic.count) {
                cell.downLine.hidden=NO;
                cell.topLine.hidden=NO;
                cell.titleLab.text=@"金额总计";
                
                CGRect rect;
                rect=cell.titleLab.frame;
                rect.origin.x+=180;
                cell.titleLab.frame=rect;
                
                rect=cell.contentLab.frame;
                rect.origin.x+=160;
                cell.contentLab.frame=rect;
            }else{
                cell.titleLab.text=[[_downPlistDic allValues] objectAtIndex:indexPath.row];
            }
            
//            NSLog(@"哈哈：%@",_downValueDic);
//            NSLog(@"呵呵：%@",_downValueDic.allValues);
            cell.contentLab.hidden=NO;
            
            if ([[[_downValueDic allKeys] objectAtIndex:indexPath.row] isEqualToString:@"total_fee"]&&_downValueDic.count-1!=indexPath.row) {
                totalFeeBug=YES;
            }
            
            if (totalFeeBug==NO) {
                cell.contentLab.text=[NSString stringWithFormat:@"￥%@",[_downValueDic.allValues objectAtIndex:indexPath.row]];
            }else{
                if (indexPath.row!=_downValueDic.count-1) {
                    cell.contentLab.text=[NSString stringWithFormat:@"￥%@",[_downValueDic.allValues objectAtIndex:indexPath.row+1]];
                }else{
                    cell.contentLab.text=[NSString stringWithFormat:@"￥%@",[_downValueDic objectForKey:@"total_fee"]];
                }
                
            }
            
            
            
            if ([[[_downValueDic allKeys] objectAtIndex:indexPath.row] isEqualToString:@"check_type"]) {
                cell.titleLab.text=@"商品金额";
                switch ([[_downValueDic objectForKey:@"check_type"] intValue]) {
                    case 1:
                        cell.contentLab.text=@"现结";
                        break;
                        
                    default:
                        cell.contentLab.text=@"预付";
                        break;
                }
            }
            
            
            break;
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==_plistDic.allValues.count-1) {
//            NSString *tStr=[_topDic objectForKey:@"detail"];
////            NSLog(@"字符数：%d",([self getChina:tStr]/12)*12+40);
//            return ([self getChina:tStr]/12)*12+40;
//            return 85;
            NSString *tStr=[_topDic objectForKey:@"detail"];
            //            NSLog(@"字符数：%d",([self getChina:tStr]/12)*12+40);
            if (tStr.length>12) {
                return ([self getChina:tStr]/12)*12+40;
            }
            
            return 85;

        }
        return 20;
    }
    return 20;
//    return 45;
}
//-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0) {
//        if (indexPath.row==_plistDic.allValues.count-1) {
//            NSString *tStr=[_topDic objectForKey:@"detail"];
//            //            NSLog(@"字符数：%d",([self getChina:tStr]/12)*12+40);
//            if (tStr.length>12) {
//                return ([self getChina:tStr]/12)*12+40;
//            }
//            
//            return 85;
//        }
//        return 20;
//    }
//    return 45;
//}

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
    if (section==1) {
        return 45;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 1;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.biddingLab.text=@"   我要竞价";
    }
    
    return self.biddingLab;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
    UIView *abc=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    abc.backgroundColor=[UIColor redColor];
    return abc;
    
    return self.submitBtn;
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

- (void)bigerPhoto:(id)sender {
    if (_bigersImg==nil) {
        return;
    }
    self.blackHideBtn.hidden=NO;
    self.bigerImg.hidden=NO;
    self.bigerImg.image=_bigersImg;
}

#pragma mark - 图片隐藏
- (IBAction)hiddenBigerImg:(id)sender {
    self.blackHideBtn.hidden=YES;
    self.bigerImg.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [_submitBtn release];
    [_usersIconImg release];
    [_titleLab release];
    [_localLab release];
    [_biddingLab release];
    [_blackHideBtn release];
    [_bigerImg release];
    [_rankImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [self setSubmitBtn:nil];
    [self setUsersIconImg:nil];
    [self setTitleLab:nil];
    [self setLocalLab:nil];
    [self setBiddingLab:nil];
    [self setBlackHideBtn:nil];
    [self setBigerImg:nil];
    [self setRankImage:nil];
    [super viewDidUnload];
}
@end
