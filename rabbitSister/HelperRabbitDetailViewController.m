//
//  HelperRabbitDetailViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-10.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "HelperRabbitDetailViewController.h"

#import "GetCateInstruct.h"
#import "XMLRPCResult.h"

#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "SubmitRabbitType.h"

//初级中级高级
typedef enum{
    primary= 1,
    intermediate,
    senior,
} helperLevel;

@interface HelperRabbitDetailViewController ()

@end

@implementation HelperRabbitDetailViewController
static bool showSixInfo=NO;
static int helpLevels=primary;
static int helperType=1;        //帮帮兔类型

static bool isHouseKeeping=NO;

static bool isAllow=YES;        //判断是否至少有一个选中

static int  chooseImgLocal=1;       //选择图片定位

static bool isInEdit=NO;        //是否处于编辑状态

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isInEdit=NO;
        chooseImgLocal=1;
        isAllow=YES;
        isHouseKeeping=NO;
        helperType=1;
        helpLevels=primary;
        showSixInfo=NO;
        
        // Custom initialization
        _levelArray=[[NSArray alloc] initWithObjects:@"普通",@"专业",@"高级", nil];
        
        _mainObjectArr=[[NSMutableArray alloc] init];
        int j=5;
        if (helperType==repair) {
            j=6;
        }
        for (int i=0; i<j; i++) {
            [_mainObjectArr addObject:@"1"];
        }
        
        _mainPriceDic=[[NSMutableDictionary alloc] init];
        
        _imgDic=[[NSMutableDictionary alloc] init];
        
        _houseKeepingArr=[[NSMutableArray alloc] initWithObjects:@"150",@"151",@"152",@"153",@"154", nil];
        _careArr=[[NSMutableArray alloc] initWithObjects:@"160",@"161",@"162",@"163",@"164", nil];
        _beautyArr=[[NSMutableArray alloc] initWithObjects:@"170",@"171",@"172",@"174", nil];
        _repairArr=[[NSMutableArray alloc] initWithObjects:@"180",@"181",@"182",@"183",@"184",@"185", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tabBackground=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllBackground.png"]];
    [self.mainListTable setBackgroundView:tabBackground];
    self.mainListTable.bounces=NO;
    self.mainListTable.showsVerticalScrollIndicator=NO;
    
    [IQKeyBoardManagerTextView installKeyboardManager];
    
    self.submitBtn.enabled=NO;
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    if (isHouseKeeping==YES) {
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=237;
        
        self.submitBtn.frame=submitRect;
    }else if (helperType==3){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=227;
        self.submitBtn.frame=submitRect;
    }else if (helperType==1){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=257;
        self.submitBtn.frame=submitRect;
    }else if (helperType==2){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=257;
        self.submitBtn.frame=submitRect;
    }
    
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getPriceRange:(NSArray *)priceArr
{
    _priceOfArr=[[NSMutableArray alloc] initWithArray:priceArr];
}

#pragma mark - 获取类型
-(void)chooseWorkType:(helperRabbitType)workType
{
    NSDictionary *allDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"HelperDetail"]];
    
    
    showSixInfo=NO;
    
    [_mainPriceDic release];
    _mainPriceDic=nil;
    isHouseKeeping=NO;
    
    switch (workType) {
        case care:
            _helperTypeTitle=@"保健";
            self.navigationItem.title=@"上门兔保健申请";
            helperType=care;
            _mainListDic=[[NSMutableDictionary alloc] initWithDictionary:[allDic objectForKey:@"care"]];
            
            if (_priceOfArr.count==0) {
                WARNING__ALERT(@"无法获得价目信息");
                return;
            }
            
            _mainPriceDic=[[NSMutableDictionary alloc] initWithDictionary:[_priceOfArr objectAtIndex:1]];
            [_mainListDic setObject:[NSString stringWithFormat:@"保健 %@",[_mainPriceDic objectForKey:@"low"]] forKey:@"title"];
            break;
            
        case houseKeeping:
            _helperTypeTitle=@"家政";
            self.navigationItem.title=@"上门兔家政申请";
            helperType=houseKeeping;
            isHouseKeeping=YES;
            _mainListDic=[[NSMutableDictionary alloc] initWithDictionary:[allDic objectForKey:@"houseKeeping"]];
            if (_priceOfArr.count==0) {
                WARNING__ALERT(@"无法获得价目信息");
                return;
            }
            
            _mainPriceDic=[[NSMutableDictionary alloc] initWithDictionary:[_priceOfArr objectAtIndex:0]];
            [_mainListDic setObject:[NSString stringWithFormat:@"家政 %@",[_mainPriceDic objectForKey:@"low"]] forKey:@"title"];
            break;
            
        case repair:
            _helperTypeTitle=@"修理";
            self.navigationItem.title=@"上门兔修理申请";
            helperType=repair;
            showSixInfo=YES;
            _mainListDic=[[NSMutableDictionary alloc] initWithDictionary:[allDic objectForKey:@"repair"]];
            
            if (_priceOfArr.count==0) {
                WARNING__ALERT(@"无法获得价目信息");
                return;
            }
            
            _mainPriceDic=[[NSMutableDictionary alloc] initWithDictionary:[_priceOfArr objectAtIndex:2]];
            [_mainListDic setObject:[NSString stringWithFormat:@"修理 %@",[_mainPriceDic objectForKey:@"low"]] forKey:@"title"];
            break;
            
        case beauty:
            _helperTypeTitle=@"美容";
            self.navigationItem.title=@"上门兔美容申请";
            helperType=beauty;
            _mainListDic=[[NSMutableDictionary alloc] initWithDictionary:[allDic objectForKey:@"beauty"]];
            
            if (_priceOfArr.count==0) {
                WARNING__ALERT(@"无法获得价目信息");
                return;
            }
            
            _mainPriceDic=[[NSMutableDictionary alloc] initWithDictionary:[_priceOfArr objectAtIndex:2]];
            [_mainListDic setObject:[NSString stringWithFormat:@"美容 %@",[_mainPriceDic objectForKey:@"low"]] forKey:@"title"];
            
            break;
            
        default:
            break;
    }
    
    [_mainObjectArr removeAllObjects];
    int j=5;
    if (helperType==repair) {
        j=6;
    }
    for (int i=0; i<j; i++) {
        [_mainObjectArr addObject:@"1"];
    }
    
    [self.mainListTable reloadData];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isHouseKeeping==YES) {
        if (helpLevels==primary) {
            return 2;
        }
        return 3;
    }
//    NSLog(@"呵呵：%d",helperType);
    if (helperType==3) {
        return 2;
    }
    
    if (helperType==1) {
        if (helpLevels==primary) {
            return 3;
        }
        return 4;
    }
    
    if (helperType==2) {
        if (helpLevels==primary) {
            return 3;
        }
        return 4;
    }
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"HelperRabbitDetailCell";
//    HelperRabbitDetailCell *cell = (HelperRabbitDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell==nil) {
        HelperRabbitDetailCell *cell = (HelperRabbitDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"HelperRabbitDetailCell" owner:self options:nil] lastObject];
//    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    NSArray  *inforArr;
    
    switch (indexPath.section) {
        case 0:
            cell.chooseView.hidden=NO;
            cell.titleView.hidden=YES;
            
            inforArr=[_mainListDic objectForKey:@"mainChoose"];
//            NSLog(@"哈哈：%@",_mainListDic);
            cell.titleLab.text=[NSString stringWithFormat:@"%@%@",[_levelArray objectAtIndex:helpLevels-1],[_mainListDic objectForKey:@"title"]];
            
            if (!showSixInfo) {
                cell.chooseSixLab.hidden=YES;
                cell.chooseSixBtn.hidden=YES;
            }else{
                cell.chooseSixLab.text=[inforArr objectAtIndex:5];
            }
            
            cell.chooseFirstLab.text=[inforArr objectAtIndex:0];
            cell.chooseSecondLab.text=[inforArr objectAtIndex:1];
            cell.chooseThirdLab.text=[inforArr objectAtIndex:2];
            cell.chooseFouthLab.text=[inforArr objectAtIndex:3];
            if (helperType!=beauty) {
                cell.chooseFifthLab.text=[inforArr objectAtIndex:4];
            }else{
                cell.chooseFifthLab.hidden=YES;
                cell.fifthBtn.hidden=YES;
            }
            
            
            [cell.firstBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
            if ([[_mainObjectArr objectAtIndex:0] intValue]==0) {
                [cell.firstBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
            }else{
                [cell.firstBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            }
            cell.firstBtn.tag=1;
            
            [cell.secondBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
            if ([[_mainObjectArr objectAtIndex:1] intValue]==0) {
                [cell.secondBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
            }else{
                [cell.secondBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            }
            cell.secondBtn.tag=2;
            
            [cell.thirdBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
            if ([[_mainObjectArr objectAtIndex:2] intValue]==0) {
                [cell.thirdBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
            }else{
                [cell.thirdBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            }
            cell.thirdBtn.tag=3;
            
            [cell.fouthBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
            if ([[_mainObjectArr objectAtIndex:3] intValue]==0) {
                [cell.fouthBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
            }else{
                [cell.fouthBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            }
            cell.fouthBtn.tag=4;
            
            [cell.fifthBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
            if ([[_mainObjectArr objectAtIndex:4] intValue]==0) {
                [cell.fifthBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
            }else{
                [cell.fifthBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
            }
            cell.fifthBtn.tag=5;
            
            if (helperType==repair) {
                if ([[_mainObjectArr objectAtIndex:5] intValue]==0) {
                    [cell.sixBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
                }else{
                    [cell.sixBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
                }
                cell.sixBtn.hidden=NO;
                [cell.sixBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
                cell.sixBtn.tag=6;
                cell.chooseSixLab.hidden=NO;
                cell.chooseSixLab.text=@"其他";
            }
            
            break;
            
        default:
            cell.chooseView.hidden=YES;
            cell.titleView.hidden=NO;
            cell.chooseTitleLab.text=[[_mainListDic objectForKey:@"certificate"] objectAtIndex:indexPath.section-1];
            
            if (isHouseKeeping==YES) {
                if (indexPath.section==2) {
                    [cell.addImgBtn addTarget:self action:@selector(addResume:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                    [cell.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                switch (indexPath.section) {
                    case 1:
                        if (isInEdit) {
                            cell.uploadImg.image=_tImg.image;
                            _tImg=cell.uploadImg;
                            cell.addImgBtn.tag=1;
                        }else{
                            _tImg=cell.uploadImg;
                            cell.addImgBtn.tag=1;
                        }
                        
                        break;
                        
                    case 2:
                        cell.uploadImg.hidden=YES;
                        cell.chooseTitleLab.text=@"简历";
                        _resumeTextView=cell.writeInTextView;
                        if (isInEdit==YES) {
                            CGRect bgRect=cell.bgImg.frame;
                            bgRect.size.height=90;
                            cell.bgImg.frame=bgRect;
                        }
                        break;
                        
                    default:
                        break;
                }
                
            }else{
                if (indexPath.section!=4) {
                    [cell.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [cell.addImgBtn addTarget:self action:@selector(addResume:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                if(helperType==3&&helpLevels==1){
                    cell.uploadImg.hidden=YES;
                    cell.addImgBtn.hidden=YES;
                    cell.chooseTitleLab.text=@"简历";
                    _resumeTextView=cell.writeInTextView;
                    if (isInEdit==YES&&isHouseKeeping==NO) {
                        CGRect bgRect=cell.bgImg.frame;
                        bgRect.size.height=90;
                        cell.bgImg.frame=bgRect;
                        cell.addImgBtn.hidden=YES;
                    }
                    [cell.addImgBtn addTarget:self action:@selector(addResume:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                switch (indexPath.section) {
                    case 1:
                        if (isInEdit) {
                            cell.uploadImg.image=_tImg.image;
                            _tImg=cell.uploadImg;
                            cell.addImgBtn.tag=1;
                        }else{
                            _tImg=cell.uploadImg;
                            cell.addImgBtn.tag=1;
                        }
                        
                        break;
                        
                    case 2:
                        if (isInEdit) {
                            cell.uploadImg.image=_tImg2.image;
                            _tImg2=cell.uploadImg;
                            cell.addImgBtn.tag=2;
                        }else{
                            _tImg2=cell.uploadImg;
                            cell.addImgBtn.tag=2;
                        }
                        
                        break;
                        
                    case 3:
                        if (helperType==3||(helperType==1&&helpLevels!=1)||(helperType==2&&helpLevels!=1)) {
                            cell.uploadImg.hidden=YES;
                            cell.addImgBtn.hidden=YES;
                            cell.chooseTitleLab.text=@"简历";
                            _resumeTextView=cell.writeInTextView;
                            if (isInEdit==YES&&isHouseKeeping==NO) {
                                CGRect bgRect=cell.bgImg.frame;
                                bgRect.size.height=90;
                                cell.bgImg.frame=bgRect;
                                cell.addImgBtn.hidden=YES;
                            }
                        }else{
                            if (isInEdit) {
                                cell.uploadImg.image=_tImg3.image;
                                _tImg3=cell.uploadImg;
                                cell.addImgBtn.tag=3;
                            }else{
                                _tImg3=cell.uploadImg;
                                cell.addImgBtn.tag=3;
                            }
                        }
                        
                        
                        break;
                        
                    case 4:
                        cell.uploadImg.hidden=YES;
                        cell.chooseTitleLab.text=@"简历";
                        _resumeTextView=cell.writeInTextView;
                        if (isInEdit==YES&&isHouseKeeping==NO) {
                            CGRect bgRect=cell.bgImg.frame;
                            bgRect.size.height=90;
                            cell.bgImg.frame=bgRect;
                        }
                        
                        break;
                        
                    default:
                        break;
                }
            }
            break;
    }
    
    cell.writeInTextView.delegate=self;
    [cell.writeInTextView addPreviousNextDoneOnKeyboardWithTarget:self
                                                   previousAction:nil
                                                       nextAction:nil
                                                       doneAction:@selector(doneClicked:)];
    [cell.writeInTextView setEnablePrevious:NO next:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isHouseKeeping==YES&&indexPath.section==2) {
        [self addResume:nil];
    }
    
    if (isHouseKeeping!=YES&&indexPath.section==4) {
        [self addResume:nil];
    }
    if (helperType==3&&indexPath.section==3) {
        [self addResume:nil];
    }
    
    if (helperType==1&&helpLevels!=1) {
        [self addResume:nil];
    }
    
    if (helperType==2&&helpLevels!=1) {
        [self addResume:nil];
    }
    
    if (helperType==3&&helpLevels==1) {
        [self addResume:nil];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 130;
    }
    
    if (isInEdit==YES&&isHouseKeeping==NO) {
        if (helperType==3) {
            if (indexPath.section==3) {
                return 90;
            }else{
                return 30;
            }
        }else{
            if (indexPath.section==4) {
                return 90;
            }else{
                return 30;
            }
        }
    }
    
    if (isInEdit==YES&&isHouseKeeping==YES) {
        
        if (indexPath.section==2) {
            return 90;
        }else{
            return 30;
        }
    }
    return 30;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

#pragma mark - 选择按钮
-(void)changeBtn:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if ([[_mainObjectArr objectAtIndex:clickBtn.tag-1] isEqualToString:@"1"]) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        [_mainObjectArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"0"];
        
        
        int i=0;
        for (NSString *chooseStr in _mainObjectArr) {
            i+=1;
            if ([chooseStr isEqualToString:@"1"]) {
                break;
            }
            
            if (i==_mainObjectArr.count) {
                isAllow=NO;
                
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
                self.submitBtn.enabled=NO;
            }
            
        }
    }else{
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        [_mainObjectArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"1"];
        isAllow=YES;
        
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled=YES;
    }
}

#pragma mark - 选择普通
- (IBAction)primaryChoose:(id)sender {
    helpLevels=primary;
    
    _tImg.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    _tImg2.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    _tImg3.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    [_tImg retain];
    [_tImg2 retain];
    [_tImg3 retain];
    
    
    [_mainListDic setObject:[NSString stringWithFormat:@"%@ %@",_helperTypeTitle,[_mainPriceDic objectForKey:@"low"]] forKey:@"title"];
    
    [self.mainListTable reloadData];
    
    [self.primaryBtn setTitle:@"" forState:UIControlStateNormal];
    [self.primaryBtn setImage:nil forState:UIControlStateNormal];
    [self.primaryBtn setBackgroundImage:[UIImage imageNamed:@"primaryBtn.png"] forState:UIControlStateNormal];
    [self.intermediateBtn setImage:nil forState:UIControlStateNormal];
    [self.intermediateBtn setBackgroundImage:[UIImage imageNamed:@"middleBtn.png"] forState:UIControlStateNormal];
    [self.seniorBtn setImage:nil forState:UIControlStateNormal];
    [self.seniorBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn.png"] forState:UIControlStateNormal];
    isAllow=YES;
    
    if (helperType==0){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=237;
        self.submitBtn.frame=submitRect;
    }else if (helperType==1){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=257;
        self.submitBtn.frame=submitRect;
    }else if (helperType==2){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=257;
        self.submitBtn.frame=submitRect;
    }else if (helperType==3){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=294;
        }else{
            submitRect.origin.y=227;
        }
        self.submitBtn.frame=submitRect;
    }
    
    self.submitBtn.enabled=NO;
    //    primaryBtn.png
}

#pragma mark - 选择专业
- (IBAction)intermediateChoose:(id)sender {
    helpLevels=intermediate;
    
    _tImg.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    _tImg2.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    _tImg3.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    [_tImg retain];
    [_tImg2 retain];
    [_tImg3 retain];
    
    [_mainListDic setObject:[NSString stringWithFormat:@"%@ %@",_helperTypeTitle,[_mainPriceDic objectForKey:@"normal"]] forKey:@"title"];
    
    [self.mainListTable reloadData];
    
    [self.primaryBtn setTitle:@"普通" forState:UIControlStateNormal];
    [self.primaryBtn setImage:nil forState:UIControlStateNormal];
    [self.primaryBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn.png"] forState:UIControlStateNormal];
    [self.intermediateBtn setImage:[UIImage imageNamed:@"intermediateBtn.png"] forState:UIControlStateNormal];
    [self.intermediateBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.seniorBtn setImage:nil forState:UIControlStateNormal];
    [self.seniorBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn.png"] forState:UIControlStateNormal];
    isAllow=YES;
    //    intermediateBtn.png
    if (helperType==0){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=319;
        }else{
            submitRect.origin.y=267;
        }
        
        self.submitBtn.frame=submitRect;
    }else if (helperType==1){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=349;
        }else{
            submitRect.origin.y=297;
        }
        self.submitBtn.frame=submitRect;
    }else if (helperType==2){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=349;
        }else{
            submitRect.origin.y=297;
        }
        self.submitBtn.frame=submitRect;
    }else if (helperType==3){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=227;
        self.submitBtn.frame=submitRect;
    }
    
    self.submitBtn.enabled=NO;
}

#pragma mark - 选择高级
- (IBAction)seniorChoose:(id)sender {
    helpLevels=senior;
    
    _tImg.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    _tImg2.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    _tImg3.image=[UIImage imageNamed:@"registRabbitIcon.png"];
    [_tImg retain];
    [_tImg2 retain];
    [_tImg3 retain];
    
    [_mainListDic setObject:[NSString stringWithFormat:@"%@ %@",_helperTypeTitle,[_mainPriceDic objectForKey:@"high"]] forKey:@"title"];
    
    [self.mainListTable reloadData];
    
    [self.primaryBtn setTitle:@"普通" forState:UIControlStateNormal];
    [self.primaryBtn setImage:nil forState:UIControlStateNormal];
    [self.primaryBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn.png"] forState:UIControlStateNormal];
    [self.intermediateBtn setImage:nil forState:UIControlStateNormal];
    [self.intermediateBtn setBackgroundImage:[UIImage imageNamed:@"middleBtn.png"] forState:UIControlStateNormal];
    [self.seniorBtn setImage:[UIImage imageNamed:@"seniorBtn.png"] forState:UIControlStateNormal];
    [self.seniorBtn setBackgroundImage:nil forState:UIControlStateNormal];
    isAllow=YES;
    
    //    seniorBtn.png
    if (helperType==0){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=319;
        }else{
            submitRect.origin.y=267;
        }
        self.submitBtn.frame=submitRect;
    }else if (helperType==1){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=349;
        }else{
            submitRect.origin.y=297;
        }
        self.submitBtn.frame=submitRect;
    }else if (helperType==2){
        CGRect submitRect=self.submitBtn.frame;
        if (isInEdit==YES) {
            submitRect.origin.y=349;
        }else{
            submitRect.origin.y=297;
        }
        self.submitBtn.frame=submitRect;
    }else if (helperType==3){
        CGRect submitRect=self.submitBtn.frame;
        submitRect.origin.y=227;
        self.submitBtn.frame=submitRect;
    }
    
    self.submitBtn.enabled=NO;
}

#pragma mark - textView
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - 提交图片
-(void)addImage:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *clickBtn=(UIButton *)sender;
    chooseImgLocal=clickBtn.tag;
    NSLog(@"喵：%d",chooseImgLocal);
    
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
        [_tImg retain];
    }else if(chooseImgLocal==2){
        _tImg2.image=tableViewBg;
        [_tImg2 retain];
    }else if (chooseImgLocal==3){
        _tImg3.image=tableViewBg;
        [_tImg3 retain];
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
            }else if(chooseImgLocal==2){
                [_imgDic setValue:loginObject.url forKey:@"secondImg"];
            }else{
                [_imgDic setValue:loginObject.url forKey:@"thirdImg"];
            }
            //            _imageUrl=loginObject.url;
            HIDE__LOADING;
            WARNING__ALERT(@"上传成功");
            
            self.submitBtn.enabled=YES;
            
            if (helperType==3) {
                if (helpLevels<2) {
                    if (_resumeTextView.text.length==0) {
                        self.submitBtn.enabled=NO;
                    }
                }
            }else{
                if (helpLevels>1) {
                    if (_resumeTextView.text.length==0) {
                        self.submitBtn.enabled=NO;
                    }
                }
            }
            
            switch (helperType) {
                case 0:
                    switch (helpLevels) {
                        case primary:
                            self.submitBtn.enabled=YES;
                            break;
                            
                        case intermediate:
                            if (_resumeTextView.text.length==0) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        case senior:
                            if (_resumeTextView.text.length==0) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        default:
                            break;
                    }
                    break;
                    
                case 1:
                    switch (helpLevels) {
                        case primary:
                            if (_imgDic.count<2) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            
                            break;
                            
                        case intermediate:
                            if (_resumeTextView.text.length==0||_imgDic.count<2) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        case senior:
                            if (_resumeTextView.text.length==0||_imgDic.count<2) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        default:
                            break;
                    }
                    break;
                    
                case 2:
                    switch (helpLevels) {
                        case primary:
                            if (_imgDic.count<2) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            
                            break;
                            
                        case intermediate:
                            if (_resumeTextView.text.length==0||_imgDic.count<2) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        case senior:
                            if (_resumeTextView.text.length==0||_imgDic.count<2) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        default:
                            break;
                    }
                    break;
                    
                case 3:
                    switch (helpLevels) {
                        case primary:
                            if (_resumeTextView.text.length==0) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            
                            break;
                            
                        case intermediate:
                            if (_imgDic.count==0) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        case senior:
                            if (_imgDic.count==0) {
                                self.submitBtn.enabled=NO;
                            }else{
                                self.submitBtn.enabled=YES;
                            }
                            break;
                            
                        default:
                            break;
                    }
                    break;
                    
                default:
                    break;
            }
//            if (isHouseKeeping){
//                if (_imgDic.count<1) {
//                    self.submitBtn.enabled=NO;
//                }
//            }else{
//                
//                if (helperType==3) {
//                    if (_imgDic.count<2) {
//                        self.submitBtn.enabled=NO;
//                    }
//                }else{
//                    if (_imgDic.count<3) {
//                        self.submitBtn.enabled=NO;
//                    }
//                }
//                
//            }
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(loginObject.url);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - 添加简历
-(void)addResume:(id)sender
{
    [_tImg retain];
    [_tImg2 retain];
    [_tImg3 retain];
    isInEdit=YES;
    
    _textViewText=[NSString stringWithFormat:@"%@",_resumeTextView.text];
//    NSLog(@"哈哈：%@",_textViewText);
    [_textViewText retain];
    
    [self.mainListTable reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(becomeFist) userInfo:nil repeats:NO];
    
    CGRect submitRect=self.submitBtn.frame;
//    submitRect.origin.y+=60;
    if (isHouseKeeping==YES) {
        if (helpLevels==primary) {
            submitRect.origin.y=377-(568-480);
        }else{
            submitRect.origin.y=407-(568-480);
        }
        
    }else{
        if (helperType==3) {
            submitRect.origin.y=294;
        }else if(helperType==1||helperType==2){
            submitRect.origin.y=349;
        }else{
            submitRect.origin.y=349;
        }
        
    }
    
//    NSLog(@"呵呵：%f",submitRect.origin.y);
    self.submitBtn.frame=submitRect;
    
    submitRect=self.mainListTable.frame;
//    submitRect.size.height+=60;
    
    submitRect.size.height=346;
//    NSLog(@"哈哈：%f",submitRect.size.height);
    self.mainListTable.frame=submitRect;
    
}

-(void)becomeFist{
    _resumeTextView.hidden=NO;
    [_resumeTextView becomeFirstResponder];
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.submitBtn.enabled=YES;
    if (helperType==3) {
        if (helpLevels<2) {
            if (_resumeTextView.text.length==0) {
                self.submitBtn.enabled=NO;
            }
        }
    }else{
        if (helpLevels>1) {
            if (_resumeTextView.text.length==0) {
                self.submitBtn.enabled=NO;
            }
        }
    }
    
    switch (helperType) {
        case 0:
            switch (helpLevels) {
                case primary:
                    self.submitBtn.enabled=YES;
                    break;
                    
                case intermediate:
                    if (_resumeTextView.text.length==0||_imgDic.count==0) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                case senior:
                    if (_resumeTextView.text.length==0||_imgDic.count==0) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (helpLevels) {
                case primary:
                    if (_imgDic.count<2) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    
                    break;
                    
                case intermediate:
                    if (_resumeTextView.text.length==0||_imgDic.count<2) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                case senior:
                    if (_resumeTextView.text.length==0||_imgDic.count<2) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (helpLevels) {
                case primary:
                    if (_imgDic.count<2) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    
                    break;
                    
                case intermediate:
                    if (_resumeTextView.text.length==0||_imgDic.count<2) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                case senior:
                    if (_resumeTextView.text.length==0||_imgDic.count<2) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 3:
            switch (helpLevels) {
                case primary:
                    if (_resumeTextView.text.length==0) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    
                    break;
                    
                case intermediate:
                    if (_imgDic.count==0) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                case senior:
                    if (_imgDic.count==0) {
                        self.submitBtn.enabled=NO;
                    }else{
                        self.submitBtn.enabled=YES;
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text=[NSString stringWithFormat:@"%@",_textViewText];
    return YES;
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

#pragma mark - 提交信息
- (IBAction)submit:(id)sender {
    if ([self getChina:_resumeTextView.text]>80) {
        WARNING__ALERT(@"简历字数必须少于80字");
        return;
    }
    
    NSMutableArray *judgeArr = nil;
    switch (helperType) {
        case houseKeeping:
            judgeArr=_houseKeepingArr;
            break;
            
        case care:
            judgeArr=_careArr;
            break;
            
        case beauty:
            judgeArr=_beautyArr;
            break;
            
        case repair:
            judgeArr=_repairArr;
            break;
            
        default:
            break;
    }
//    NSLog(@"哈哈：%@",judgeArr);
    
    NSString *submitString=@"";
    for (int i=0; i<judgeArr.count; i++) {
        if ([[_mainObjectArr objectAtIndex:i] intValue]==0) {
        }else{
            if (i==0) {
                submitString=[NSString stringWithFormat:@"%@",[judgeArr objectAtIndex:i]];
            }else{
                submitString=[NSString stringWithFormat:@"%@,%@",submitString,[judgeArr objectAtIndex:i]];
            }
        }
    }
    
    SHOW__LOADING
    //判断是否已经注册过用户
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
    
    
    SubmitRabbitType *_submitRabbit=[[SubmitRabbitType alloc] init];
    
    NSMutableDictionary *uploadDic=[[NSMutableDictionary alloc] init];
    
    if (isHouseKeeping) {
        if (_imgDic.count>0) {
            [uploadDic setObject:[_imgDic objectForKey:@"firstImg"] forKey:@"health_cert"];
        }
        
        if (helpLevels!=primary) {
            [uploadDic setObject:_resumeTextView.text forKey:@"profile"];
        }
        
    }else{
//        NSLog(@"呵呵：%d",helperType);
        if (helperType!=3) {
            if (_imgDic.count>0) {
                [uploadDic setObject:[_imgDic objectForKey:@"firstImg"] forKey:@"health_cert"];
                [uploadDic setObject:[_imgDic objectForKey:@"secondImg"] forKey:@"work_cert"];
//                [uploadDic setObject:[_imgDic objectForKey:@"thirdImg"] forKey:@"skill_cert"];
            }
            
        }else{
            if (_imgDic.count>0) {
//                NSLog(@"哈哈：%@",_imgDic);
                //            [uploadDic setObject:[_imgDic objectForKey:@"firstImg"] forKey:@"work_cert"];
                [uploadDic setObject:[_imgDic objectForKey:@"firstImg"] forKey:@"skill_cert"];
            }

        }
        
        if (_resumeTextView.text!=nil) {
            [uploadDic setObject:_resumeTextView.text forKey:@"profile"];
        }
        
    }
    
//    NSLog(@"呵呵：%d",helpLevels);
    [_submitRabbit submitType:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] type:@"3" level:[NSString stringWithFormat:@"%d",helpLevels] cates:submitString otherDic:uploadDic success:^(id responseData){
        
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
        WARNING__ALERT(@"网络异常，请检查您的网络是否正常");
        return;
    }];
    //    Notification__POST(REGISTCHOOSEOVER,nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [_submitBtn release];
    [_primaryBtn release];
    [_intermediateBtn release];
    [_seniorBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [self setSubmitBtn:nil];
    [self setPrimaryBtn:nil];
    [self setIntermediateBtn:nil];
    [self setSeniorBtn:nil];
    [super viewDidUnload];
}
@end
