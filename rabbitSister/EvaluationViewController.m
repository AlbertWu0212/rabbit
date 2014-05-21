//
//  EvaluationViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-17.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluationRequest.h"
#import "XMLRPCResult.h"

#import "phoneCall.h"

#import "FinishEvaluation.h"

@interface EvaluationViewController ()
{
    SDWebImageManager *manager;
}
@end

@implementation EvaluationViewController

static int sex=1;
static int age_range=2;
static int level=2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mainDic=[[NSMutableDictionary alloc] init];
        
        _ageBtnArr=[[NSMutableArray alloc] init];
        _commentBtnArr=[[NSMutableArray alloc] init];
        
    }
    return self;
}

#pragma mark - 截取字符串
-(NSString *)cutStr:(NSString *)cutOrign cutStrs:(NSString *)cutStrs page:(int)page
{
    NSArray  *tempArray = [cutOrign componentsSeparatedByString:cutStrs];
    
    return [tempArray objectAtIndex:page];
}

-(void)getLocal:(NSString *)local
{
    //距离
    self.localLab.text=local;
//    _localStr=local;
}

- (IBAction)changeSex:(id)sender {
    UIButton *clickBtn=(UIButton *)sender;
    sex=clickBtn.tag;
    switch (clickBtn.tag) {
        case 1:
            [self.manBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
            [self.womanBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.manBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
            [self.womanBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (IBAction)changeComments:(id)sender {
    UIButton *clickBtn=(UIButton *)sender;
    level=clickBtn.tag;
    [clickBtn setImage:[UIImage imageNamed:@"blue dot.png"] forState:UIControlStateNormal];
    for (UIButton *listBtn in _commentBtnArr) {
        if (![listBtn isEqual:clickBtn]) {
            [listBtn setImage:[UIImage imageNamed:@"dot2.png"] forState:UIControlStateNormal];
        }
    }
//    _commentBtnArr
}

- (IBAction)changeAge:(id)sender {
    UIButton *clickBtn=(UIButton *)sender;
    age_range=clickBtn.tag;
    CGRect btnRect=clickBtn.frame;
    btnRect.size.height=18;
    btnRect.size.width=18;
    clickBtn.frame=btnRect;
    [clickBtn setImage:[UIImage imageNamed:@"age dot.png"] forState:UIControlStateNormal];
    for (UIButton *listBtn in _ageBtnArr) {
        if (![listBtn isEqual:clickBtn]) {
            btnRect=listBtn.frame;
            btnRect.size.height=18;
            btnRect.size.width=18;
            listBtn.frame=btnRect;
            [listBtn setImage:[UIImage imageNamed:@"scrollfwyuan.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)getDic:(NSDictionary *)dic
{
    self.mainScroll.bounces=NO;
    self.mainScroll.contentSize=CGSizeMake(320, 480);
    self.mainScroll.scrollEnabled=YES;
    CGRect imgRect=self.backgroundImg.frame;
    imgRect.size.height=480;
    self.backgroundImg.frame=imgRect;
    
    sex=1;
    age_range=2;
    level=2;
    for (UIButton *listBtn in _ageBtnArr) {
        if (listBtn.tag!=2) {
            [listBtn setImage:[UIImage imageNamed:@"scrollfwyuan.png"] forState:UIControlStateNormal];
        }else{
            [listBtn setImage:[UIImage imageNamed:@"age dot.png"] forState:UIControlStateNormal];
        }
    }
    [self.manBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
    [self.womanBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
    for (UIButton *listBtn in _commentBtnArr) {
        if (listBtn.tag!=2) {
            [listBtn setImage:[UIImage imageNamed:@"dot2.png"] forState:UIControlStateNormal];
        }else{
            [listBtn setImage:[UIImage imageNamed:@"blue dot.png"] forState:UIControlStateNormal];
        }
    }
    self.complaintsText.text=@"默认中评";
    
    
    [_mainDic removeAllObjects];
    [_mainDic setObject:dic forKey:@"mainInfo"];
    
    
//    NSLog(@"哈哈：%@",[dic objectForKey:@"commented"]);
    
    switch ([[dic objectForKey:@"commented"] intValue]) {
        case 1:
            self.submitBtn.hidden=YES;
            self.subShowBtn.hidden=NO;
            self.evaStatusLab.text=@"已评论";
            break;
            
        case 2:
            self.submitBtn.hidden=YES;
            self.subShowBtn.hidden=NO;
            self.evaStatusLab.text=@"已投诉";
            break;
            
        case 3:
            self.submitBtn.hidden=YES;
            self.subShowBtn.hidden=NO;
            self.evaStatusLab.text=@"已处理";
            break;
            
        default:
            self.submitBtn.hidden=NO;
            self.subShowBtn.hidden=NO;
            self.evaStatusLab.text=@"未评论";
            break;
    }
    
//    if ([[dic objectForKey:@"commented"] intValue]>0) {
//        self.submitBtn.hidden=YES;
//        self.subShowBtn.hidden=YES;
//        self.evaStatusLab.text=@"已评论";
//    }else{
//        self.submitBtn.hidden=NO;
//        self.subShowBtn.hidden=NO;
//        self.evaStatusLab.text=@"未评论";
//    }
    
    [self changeViewInfo:dic];
}

-(void)changeViewInfo:(NSDictionary *)infoDic
{
    //头像
    [manager downloadWithURL:[NSURL URLWithString:[infoDic objectForKey:@"image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        self.headImage.image=image;
        self.bigerImg.image=image;
    }];
    
    //标题
    self.titleLab.text=[infoDic objectForKey:@"title"];
    
    //价格
    self.priceLab.text=[NSString stringWithFormat:@"%@元",[infoDic objectForKey:@"order_amount"]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mainScroll.contentOffset=CGPointMake(1000, 1000);
    self.mainScroll.bounces=YES;
    self.mainScroll.contentSize=CGSizeMake(1320, 1500);
    self.mainScroll.scrollEnabled=YES;
}

- (IBAction)submit:(id)sender {
    if (self.complaintsText.text.length==0) {
        self.complaintsText.text=@"";
//        WARNING__ALERT(@"请填写评论");
//        return;
    }
    
    if ([self getChina:self.complaintsText.text]>80) {
        WARNING__ALERT(@"评价字数必须少于80字");
        return;
    }
    
    SHOW__LOADING
    EvaluationRequest *eva=[[EvaluationRequest alloc] init];
    
    [eva Evaluation:[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"demand_sn"] sex:[NSString stringWithFormat:@"%d",sex] age_range:[NSString stringWithFormat:@"%d",age_range] level:[NSString stringWithFormat:@"%d",level] content:self.complaintsText.text success:^(id responseData){
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
//        Notification__POST(EVABACKMAIN,nil);
        if (RPCResult.success==YES) {
            FinishEvaluation *finish=[[FinishEvaluation alloc] init];
            [finish finishEva:[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"demand_sn"] success:^(id responseData) {
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    HIDE__LOADING
                    
                    Notification__POST(EVABACKMAIN,nil);
                }else{
                    HIDE__LOADING;
                    WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
                }
            } failed:^(NSError *error) {
                HIDE__LOADING
                WARNING__ALERT(@"请网络连接是否通畅");
            }];
        }else{
            HIDE__LOADING;
            WARNING__ALERT([RPCResult.res objectForKey:@"reason"]);
        }
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"请网络连接是否通畅");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    [_ageBtnArr addObject:self.ageBtn1];
    [_ageBtnArr addObject:self.ageBtn2];
    [_ageBtnArr addObject:self.ageBtn3];
    [_ageBtnArr addObject:self.ageBtn4];
    
    [_commentBtnArr addObject:self.greatBtn];
    [_commentBtnArr addObject:self.middleBtn];
    [_commentBtnArr addObject:self.badBtn];
    [_commentBtnArr addObject:self.complaintsBtn];
    
    self.complaintsText.delegate=self;
    // Do any additional setup after loading the view from its nib.
    [self.complaintsText addPreviousNextDoneOnKeyboardWithTarget:self
                                                   previousAction:nil
                                                       nextAction:nil
                                                       doneAction:@selector(doneClicked:)];
    [self.complaintsText setEnablePrevious:NO next:YES];
}

#pragma mark - textView
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
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

- (IBAction)phontoClick:(id)sender {
    self.forbidBtn.hidden=NO;
    self.bigerImg.hidden=NO;
//    NSLog(@"哈哈：%@",[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"image"]);
//    [manager downloadWithURL:[NSURL URLWithString:[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
//        
//    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
//        self.bigerImg.image=image;
//    }];
}
- (IBAction)spearkClick:(id)sender {
//    NSLog(@"原来数据是：%@",_mainDic);
    
    
    NSDictionary *postDic=[[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"eusercode"]],@"JID",[NSString stringWithFormat:@"%@",[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"image"]],@"image",[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"demand_sn"],@"BNumber",@"2",@"Status",[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"title"],@"eusername",nil] autorelease];
    Notification__POST(SPEAKER,postDic);
}
- (IBAction)phoneClick:(id)sender {
    SHOW__LOADING
    phoneCall *phone=[[phoneCall alloc] init];
    [phone getPhone:[[_mainDic objectForKey:@"mainInfo"] objectForKey:@"demand_sn"] success:^(id responseData){
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        
        if (RPCResult.success==YES) {
            HIDE__LOADING
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[RPCResult.res objectForKey:@"mobile"]]]];
        }else{
            HIDE__LOADING;
            WARNING__ALERT(RPCResult.res);
        }
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"请检查您的网络连接是否正常");
    }];
    
}
- (IBAction)backSmall:(id)sender {
    self.forbidBtn.hidden=YES;
    self.bigerImg.hidden=YES;
}

#pragma mark - UITextField
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"默认中评"]) {
        textView.text=@"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainScroll release];
    [_headImage release];
    [_titleLab release];
    [_localLab release];
    [_priceLab release];
    [_manBtn release];
    [_womanBtn release];
    [_greatBtn release];
    [_middleBtn release];
    [_badBtn release];
    [_complaintsBtn release];
    [_complaintsText release];
    [_changeSex release];
    [_changeAge release];
    [_ageBtn1 release];
    [_ageBtn2 release];
    [_ageBtn3 release];
    [_ageBtn4 release];
    [_submitBtn release];
    [_subShowBtn release];
    [_backgroundImg release];
    [_forbidBtn release];
    [_bigerImg release];
    [_evaStatusLab release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScroll:nil];
    [self setHeadImage:nil];
    [self setTitleLab:nil];
    [self setLocalLab:nil];
    [self setPriceLab:nil];
    [self setManBtn:nil];
    [self setWomanBtn:nil];
    [self setGreatBtn:nil];
    [self setMiddleBtn:nil];
    [self setBadBtn:nil];
    [self setComplaintsBtn:nil];
    [self setComplaintsText:nil];
    [self setChangeSex:nil];
    [self setChangeAge:nil];
    [self setAgeBtn1:nil];
    [self setAgeBtn2:nil];
    [self setAgeBtn3:nil];
    [self setAgeBtn4:nil];
    [self setSubmitBtn:nil];
    [self setSubShowBtn:nil];
    [self setBackgroundImg:nil];
    [self setForbidBtn:nil];
    [self setBigerImg:nil];
    [self setEvaStatusLab:nil];
    [super viewDidUnload];
}
@end
