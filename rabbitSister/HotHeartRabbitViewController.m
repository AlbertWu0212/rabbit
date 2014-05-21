//
//  HotHeartRabbitViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HotHeartRabbitViewController.h"

#import "GetCateInstruct.h"
#import "XMLRPCResult.h"

#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "SubmitRabbitType.h"

@interface HotHeartRabbitViewController ()

@end

@implementation HotHeartRabbitViewController
static bool isIncidentally=NO;  //判断是否是顺便
static bool isMainAllow=YES;

static int  chooseImgLocal=1;       //选择图片定位

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        chooseImgLocal=1;
        isMainAllow=YES;
        isIncidentally=NO;
        
        NSDictionary *_mainDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"DriverRabbit"]];
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:[_mainDic objectForKey:@"infor"]];
        // Custom initialization
        
        _incidentallyArr=[[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            [_incidentallyArr addObject:@"1"];
        }
        
        _incidentallyBtnArr=[[NSMutableArray alloc] init];
        
        _carArr=[[NSMutableArray alloc] init];
        for (int j=0; j<1; j++) {
            [_carArr addObject:@"1"];
        }
        
        _carBtnArr=[[NSMutableArray alloc] init];
        
        _chooseFirstArr=[[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            [_chooseFirstArr addObject:@""];
        }
        _chooseMainArr=[[NSMutableArray alloc] init];
        for (int i=0; i<1; i++) {
            [_chooseMainArr addObject:@""];
        }
        
        _uploadFieldArr=[[NSMutableArray alloc] init];
        for (int i=0; i<1; i++) {
            [_uploadFieldArr addObject:@""];
        }
        
        _imgDic=[[NSMutableDictionary alloc] init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
//    UIImageView *tabBackground=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllBackground.png"]];
//    [self.mainTable setBackgroundView:tabBackground];
    self.navigationItem.title=@"帮帮兔申请";
    
    [self.mainTable addSubview:_submitBtn];
    self.mainTable.bounces=NO;
    self.mainTable.backgroundColor=[UIColor clearColor];
    self.mainTable.backgroundView=nil;
    self.mainTable.showsVerticalScrollIndicator=NO;
    
    [IQKeyBoardManager installKeyboardManager];
    
    [self reloadInform];
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - 重新从网上获取页面内容
-(void)reloadInform
{
    //获取服务器数据
    SHOW__LOADING
    //判断是否已经注册过用户
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
    
    GetCateInstruct *getCate=[[GetCateInstruct alloc] init];
    [getCate getCateInstruct:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] city:[registInfo objectForKey:@"city"] cate_codes:[NSString stringWithFormat:@"190,191,192,193,143"] success:^(id responseData){
        
        XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
        
        if (result.success==YES) {
            //总的价钱数据
            NSArray *priceArr=[[NSArray alloc] initWithArray:result.res];
            
            
//            NSLog(@"嘻嘻：%@",priceArr);
//            NSLog(@"123123123123123213");
            //重置显示数据
            if (!isIncidentally) {
                for (int i=0; i<_chooseFirstArr.count; i++) {
                    switch (i) {
                        case 0:
                            [_chooseFirstArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"旅游代购 %@",[[priceArr objectAtIndex:i+1] objectForKey:@"low"]]];
                            break;
                            
                        case 1:
                            [_chooseFirstArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"旅游速递 %@",[[priceArr objectAtIndex:i+1] objectForKey:@"low"]]];
                            break;
                            
                        case 2:
                            [_chooseFirstArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"异地捎客 %@",[[priceArr objectAtIndex:i+1] objectForKey:@"low"]]];
                            break;
                            
                        case 3:
                            [_chooseFirstArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"异地捎货 %@",[[priceArr objectAtIndex:i+1] objectForKey:@"low"]]];
                            break;
                            
                        default:
                            break;
                    }
                }
            }else{
                for (int i=0; i<_chooseMainArr.count; i++) {
                    switch (i) {
                        case 0:
                            [_chooseMainArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"代驾 %@",[[priceArr objectAtIndex:i] objectForKey:@"low"]]];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            
//            NSLog(@"哈哈：%@",_chooseFirstArr);
//            NSLog(@"456456456456456456");
            HIDE__LOADING
        }else{
            HIDE__LOADING
            WARNING__ALERT([result.res objectForKey:@"reason"]);
        }
        
        [self.mainTable reloadData];
        
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"获取数据失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!isIncidentally) {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    switch (section) {
        case 3:
            return 4;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HotHeartRabbitViewCell";
    HotHeartRabbitViewCell *cell = (HotHeartRabbitViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //自动调整submitBtn的frame
    [self submitBtnAutoSize];
    
    if (cell==nil) {
        cell = (HotHeartRabbitViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HotHeartRabbitViewCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    NSArray *infoArr=nil;
    
    
    cell.getInformField.delegate=self;
    [cell.getInformField addPreviousNextDoneOnKeyboardWithTarget:self
                                                  previousAction:nil
                                                      nextAction:nil
                                                      doneAction:@selector(doneClicked:)];
    [cell.getInformField setEnablePrevious:NO next:YES];
    
    
    switch (indexPath.section) {
        case 0:
            cell.listView.hidden=YES;
            cell.chooseFirstView.hidden=YES;
            cell.chooseView.hidden=NO;
            
            if (!isIncidentally) {
                cell.firstLab1.text=[_chooseFirstArr objectAtIndex:0];
                cell.firstLab2.text=[_chooseFirstArr objectAtIndex:1];
                cell.firstLab3.text=[_chooseFirstArr objectAtIndex:2];
                cell.firstLab4.text=[_chooseFirstArr objectAtIndex:3];
//                cell.firstLab5.text=[_chooseFirstArr objectAtIndex:4];
//                cell.firstLab6.text=[_chooseFirstArr objectAtIndex:5];
                
                
                cell.chooseView.hidden=YES;
                cell.chooseFirstView.hidden=NO;
                
                //添加点击事件
                _tempMainBtn=cell.incidentallyMainBtn;
                [cell.incidentallyMainBtn addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                cell.incidentally1.tag=1;
                [cell.incidentally1 addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_incidentallyBtnArr addObject:cell.incidentally1];
                
                cell.incidentally2.tag=2;
                [cell.incidentally2 addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_incidentallyBtnArr addObject:cell.incidentally2];
                
                cell.incidentally3.tag=3;
                [cell.incidentally3 addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_incidentallyBtnArr addObject:cell.incidentally3];
                
                cell.incidentally4.tag=4;
                [cell.incidentally4 addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_incidentallyBtnArr addObject:cell.incidentally4];
                
//                cell.incidentally5.tag=5;
//                [cell.incidentally5 addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_incidentallyBtnArr addObject:cell.incidentally5];
//                
//                cell.incidentally6.tag=6;
//                [cell.incidentally6 addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_incidentallyBtnArr addObject:cell.incidentally6];
            }else{
                cell.chooseLab1.text=[_chooseMainArr objectAtIndex:0];
//                cell.chooseLab2.text=[_chooseMainArr objectAtIndex:1];
//                cell.chooselab3.text=[_chooseMainArr objectAtIndex:2];
//                cell.chooseLab4.text=[_chooseMainArr objectAtIndex:3];
//                cell.chooseLab5.text=[_chooseMainArr objectAtIndex:4];
//                cell.chooseLab6.text=[_chooseMainArr objectAtIndex:5];
//                cell.chooseLab7.text=[_chooseMainArr objectAtIndex:6];
//                cell.chooseLab8.text=[_chooseMainArr objectAtIndex:7];
                
                //添加点击事件
                _tempMainBtn=cell.carMainBtn;
                [cell.carMainBtn addTarget:self action:@selector(mainCarClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                cell.car1.tag=1;
                [cell.car1 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_carBtnArr addObject:cell.car1];
                
//                cell.car2.tag=2;
//                [cell.car2 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car2];
//                
//                cell.car3.tag=3;
//                [cell.car3 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car3];
//                
//                cell.car4.tag=4;
//                [cell.car4 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car4];
//                
//                cell.car5.tag=5;
//                [cell.car5 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car5];
//                
//                cell.car6.tag=6;
//                [cell.car6 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car6];
//                
//                cell.car7.tag=7;
//                [cell.car7 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car7];
//                
//                cell.car8.tag=8;
//                [cell.car8 addTarget:self action:@selector(otherCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [_carBtnArr addObject:cell.car8];
            }
            break;
            
        default:
            infoArr=[_mainInfoArr objectAtIndex:indexPath.section+1];
            cell.listView.hidden=NO;
            cell.chooseView.hidden=YES;
            cell.chooseFirstView.hidden=YES;
            
            if (indexPath.section==2) {
                cell.certificateImg.hidden=YES;
                cell.addImgBtn.hidden=YES;
                
                
                cell.getInformField.delegate=self;
                switch (indexPath.row) {
                    case 0:
                        _uploadText1=cell.getInformField;
                        [_uploadFieldArr replaceObjectAtIndex:0 withObject:_uploadText1];
                        break;
                        
                    case 1:
                        _uploadText2=cell.getInformField;
                        [_uploadFieldArr replaceObjectAtIndex:1 withObject:_uploadText2];
                        break;
                        
                    case 2:
                        _uploadText3=cell.getInformField;
                        [_uploadFieldArr replaceObjectAtIndex:2 withObject:_uploadText3];
                        break;
                        
                    case 3:
                        _uploadText4=cell.getInformField;
                        [_uploadFieldArr replaceObjectAtIndex:3 withObject:_uploadText4];
                        break;
                        
                    default:
                        break;
                }
            }else{
                cell.contentLab.hidden=YES;
                cell.getInformField.hidden=YES;
                cell.certificateImg.hidden=NO;
                cell.addImgBtn.hidden=NO;
                
                switch (indexPath.section) {
                    case 2:
                        cell.addImgBtn.tag=1;
                        _tImg=cell.certificateImg;
                        break;
                        
                    default:
                        cell.addImgBtn.tag=2;
                        _tImg2=cell.certificateImg;
                        break;
                }
                
                [cell.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            if (indexPath.section==1) {
                cell.titleLab.text=@"驾驶证";
            }else{
                cell.titleLab.text=@"驾龄";
            }
//            cell.titleLab.text=[infoArr objectAtIndex:indexPath.row];
            break;
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (!isIncidentally) {
            return 183;
        }
        return 80;
    }
    return 30;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.000001f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
//    
//    return [view autorelease];
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

#pragma mark - textField
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - 自动调整submitBtn的frame
-(void)submitBtnAutoSize
{
    if (!isIncidentally) {
        self.mainTable.contentSize=CGSizeMake(300, 0);
        CGRect tabRect=self.submitBtn.frame;
        tabRect.origin.y=198;
        self.submitBtn.frame=tabRect;
        return;
    }
    self.mainTable.contentSize=CGSizeMake(300, 598);
    CGRect tabRect=self.submitBtn.frame;
    tabRect.origin.y=170;
    self.submitBtn.frame=tabRect;
}

#pragma mark - 主要点击勾选
-(void)mainClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if (isMainAllow==YES) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        
        //将所有副选框的按钮修改
        for (UIButton *chooseBtn in _incidentallyBtnArr) {
            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        }
        
        //将所有的按钮状态修改
        for (int i=0; i<_incidentallyArr.count; i++) {
            [_incidentallyArr replaceObjectAtIndex:i withObject:@"0"];
        }
        
        isMainAllow=NO;
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=NO;
    }else{
        for (UIButton *chooseBtn in _incidentallyBtnArr) {
            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        }
        
        for (int i=0; i<_incidentallyArr.count; i++) {
            [_incidentallyArr replaceObjectAtIndex:i withObject:@"1"];
        }
        
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        isMainAllow=YES;
        
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=YES;
        
        
    }
    
}

-(void)mainCarClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if (isMainAllow==YES) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        
        for (UIButton *chooseBtn in _carBtnArr) {
            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        }
        
        for (int i=0; i<_carArr.count; i++) {
            [_carArr replaceObjectAtIndex:i withObject:@"0"];
        }
        
        isMainAllow=NO;
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=NO;
    }else{
        for (UIButton *chooseBtn in _carBtnArr) {
            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        }
        
        for (int i=0; i<_carArr.count; i++) {
            [_carArr replaceObjectAtIndex:i withObject:@"1"];
        }
        
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        isMainAllow=YES;
        
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=YES;
    }
    
    if (!isIncidentally) {
        NSString *imgUrl=[_imgDic objectForKey:@"secondImg"];
        if (_uploadText1.text.length==0||imgUrl.length==0) {
            self.submitBtn.enabled=NO;
        }
    }

    if (isIncidentally) {
        NSString *imgUrl=[_imgDic objectForKey:@"secondImg"];
        if (_uploadText1.text.length==0||imgUrl.length==0) {
            self.submitBtn.enabled=NO;
        }
    }
}

#pragma mark - 其他点击勾选
-(void)otherBtnClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if ([[_incidentallyArr objectAtIndex:clickBtn.tag-1] isEqualToString:@"1"]) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        [_incidentallyArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"0"];
        
        int i=0;
        for (NSString *chooseStr in _incidentallyArr) {
            i+=1;
            if ([chooseStr isEqualToString:@"1"]) {
                break;
            }
            
            if (i==_incidentallyArr.count) {
                [_tempMainBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
                isMainAllow=NO;
                
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
                self.submitBtn.enabled=NO;
            }
            
        }
    }else{
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        [_incidentallyArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"1"];
        
        [_tempMainBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        isMainAllow=YES;
        
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=YES;
    }
}

-(void)otherCarBtnClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if ([[_carArr objectAtIndex:clickBtn.tag-1] isEqualToString:@"1"]) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        [_carArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"0"];
        
        int i=0;
        for (NSString *chooseStr in _carArr) {
            if ([chooseStr isEqualToString:@"1"]) {
                break;
            }
            i+=1;
            
            if (i==_carArr.count) {
                [_tempMainBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
                isMainAllow=NO;
                
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
                self.submitBtn.enabled=NO;
            }
        }
    }else{
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        [_carArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"1"];
        
        [_tempMainBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        isMainAllow=YES;
        
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=YES;
        
        if (isIncidentally) {
            NSString *imgUrl=[_imgDic objectForKey:@"secondImg"];
            if (_uploadText1.text.length==0||imgUrl.length==0) {
                self.submitBtn.enabled=NO;
            }
        }
    }
}

#pragma mark - 顺便
- (IBAction)incidentallyBtn:(id)sender {
    isIncidentally=NO;
    isMainAllow=YES;
    [self.mainTable reloadData];
    
    [self.incidentallyBtn setImage:[UIImage imageNamed:@"passingBtn.png"] forState:UIControlStateNormal];
    [self.incidentallyBtn setTitle:@"" forState:UIControlStateNormal];
    [self.incidentallyBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.carsBtn setImage:nil forState:UIControlStateNormal];
    [self.carsBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn.png"] forState:UIControlStateNormal];
    
    [self reloadInform];
//    passingBtn.png
    self.submitBtn.enabled=YES;
}

#pragma mark - 车辆
- (IBAction)carClick:(id)sender {
    isIncidentally=YES;
    isMainAllow=YES;
    [self.mainTable reloadData];
    
    [self.incidentallyBtn setImage:nil forState:UIControlStateNormal];
    [self.incidentallyBtn setTitle:@"顺便" forState:UIControlStateNormal];
    [self.incidentallyBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn.png"] forState:UIControlStateNormal];
    [self.carsBtn setImage:[UIImage imageNamed:@"carBtn1.png"] forState:UIControlStateNormal];
    [self.carsBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self reloadInform];
//    carBtn.png
    self.submitBtn.enabled=NO;
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    if (isMainAllow==NO) {
        WARNING__ALERT(@"必须选中一项才能提交");
        return;
    }
    
    //定义Cates
    NSMutableArray *getCatesArr=[[NSMutableArray alloc] init];
    int i=0;
    
    if (!isIncidentally) {
        for (NSString *catesStr in _incidentallyArr) {
            switch (i) {
                case 0:
                    if ([catesStr intValue]==1) {
                        [getCatesArr addObject:@"190"];
                    }
                    break;
                    
                case 1:
                    if ([catesStr intValue]==1) {
                        [getCatesArr addObject:@"191"];
                    }
                    break;
                    
                case 2:
                    if ([catesStr intValue]==1) {
                        [getCatesArr addObject:@"192"];
                    }
                    break;
                    
                case 3:
                    if ([catesStr intValue]==1) {
                        [getCatesArr addObject:@"193"];
                    }
                    break;
                    
                default:
                    break;
            }
            i+=1;
        }
    }else{
        for (NSString *catesStr in _incidentallyArr) {
            switch (i) {
                case 0:
                    if ([catesStr intValue]==1) {
                        [getCatesArr addObject:@"143"];
                    }
                    break;
                    
                default:
                    break;
            }
            i+=1;
        }
    }
    
    //重组cates
    NSString *submitString=@"";
    int j=0;
    for (NSString *tString in getCatesArr) {
        if (j==0) {
            submitString=[NSString stringWithFormat:@"%@",tString];
        }else{
            submitString=[NSString stringWithFormat:@"%@,%@",submitString,tString];
        }
        
        j+=1;
    }
    
    SHOW__LOADING
    //判断是否已经注册过用户
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
    
    
    SubmitRabbitType *_submitRabbit=[[SubmitRabbitType alloc] init];
    
    NSMutableDictionary *uploadDic=[[NSMutableDictionary alloc] init];
    
//    NSLog(@"呵呵：%@",_imgDic);
    
    if (isIncidentally) {
        
        [uploadDic setObject:[_imgDic objectForKey:@"secondImg"] forKey:@"driver_cert"];
//        [uploadDic setObject:[_imgDic objectForKey:@"secondImg"] forKey:@"driving_cert"];
//        [uploadDic setObject:_uploadText1.text forKey:@"car_type"];
//        [uploadDic setObject:_uploadText2.text forKey:@"car_color"];
//        [uploadDic setObject:_uploadText3.text forKey:@"plate_number"];
//        [uploadDic setObject:_uploadText4.text forKey:@"experience"];
        [uploadDic setObject:_uploadText1.text forKey:@"experience"];
        [uploadDic setObject:@"2" forKey:@"car_style"];
        
    }else{
        
        [uploadDic setObject:@"1" forKey:@"car_style"];
    }
    
    
    [_submitRabbit submitType:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] type:@"4" level:@"1" cates:submitString otherDic:uploadDic success:^(id responseData){
        HIDE__LOADING;
        
        XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
        
        if (result.success==YES) {
            //跳转注释
            Notification__POST(REGISTCHOOSEOVER,nil);
        }else{
            WARNING__ALERT([result.res objectForKey:@"reason"]);
        }
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"必须选中一项才能提交");
        return;
    }];
//    @"190,191,194,195,196,197"
    
//    Notification__POST(REGISTCHOOSEOVER,nil);
}

#pragma mark - 提交图片
-(void)addImage:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    chooseImgLocal=clickBtn.tag;
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    
    //保存的相片
    UIImagePickerController *picker;
    switch (buttonIndex) {
        case 0:
            picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];//进入照相界面
            [picker release];
            
            break;
            
        case 1:
            //    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
            //    }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentModalViewController:pickerImage animated:YES];
            [pickerImage release];
            break;
            
        default:
            
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (![info objectForKey:@"UIImagePickerControllerEditedImage"]) {
        return;
    }
    UIImage *tableViewBg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (chooseImgLocal==1) {
        _tImg.image=tableViewBg;
    }else{
        _tImg2.image=tableViewBg;
    }
    
    
    SHOW__LOADING;
    //转存图片
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [NSString stringWithString:[documentsPaths objectAtIndex:0]];         //将图片存储到本地documents
    
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //图片压缩
    [fileManager createFileAtPath:[filePath stringByAppendingString:@"/uploadImage.jpg"] contents:UIImageJPEGRepresentation(tableViewBg,0.1) attributes:nil];
    
    NSString *path=[NSString stringWithFormat:@"%@/uploadImage.jpg",[documentsPaths objectAtIndex:0]];
    
    
    UploadNetWork *uploadNet=[[UploadNetWork alloc] init];
    [uploadNet upload:@"2" data:path success:^(id responseData){
        UploadInfo *loginObject=[[UploadInfo alloc]initWithStatus:responseData];
        
        if (loginObject.success==YES) {
            if (chooseImgLocal==1) {
                [_imgDic setValue:loginObject.url forKey:@"firstImg"];
            }else{
                [_imgDic setValue:loginObject.url forKey:@"secondImg"];
            }
            //            _imageUrl=loginObject.url;
            HIDE__LOADING;
            WARNING__ALERT(@"上传成功");
            
            self.submitBtn.enabled=YES;
            
            for (id chooseField in _uploadFieldArr) {
                if (![chooseField isKindOfClass:[UITextField class]]) {
                    return;
                }
                
                UITextField *choose=(UITextField *)chooseField;
                
                if (choose.text.length==0) {
                    self.submitBtn.enabled=NO;
                    return;
                }
            }
            
            if (_imgDic.count==0) {
                self.submitBtn.enabled=NO;
            }
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(loginObject.url);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    for (UITextField *chooseField in _uploadFieldArr) {
        if (chooseField.text.length==0) {
            self.submitBtn.enabled=NO;
            return;
        }
    }
    
    if (_imgDic.count==0) {
        self.submitBtn.enabled=NO;
        return;
    }
    
    self.submitBtn.enabled=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainTable release];
    [_submitBtn release];
    [_incidentallyBtn release];
    [_carsBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainTable:nil];
    [self setSubmitBtn:nil];
    [self setIncidentallyBtn:nil];
    [self setCarsBtn:nil];
    [super viewDidUnload];
}
@end
