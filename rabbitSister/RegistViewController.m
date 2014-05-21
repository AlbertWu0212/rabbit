//
//  RegistViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RegistViewController.h"
#import "PublicDefine.h"
#import "AgreementViewController.h"

#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "RegistNetWork.h"

#import "GetRegistCode.h"
#import "XMLRPCResult.h"
#import "RegistBack.h"

#define PERSONALHEIGHT 660
#define COMPANYHEIGHT  760


//#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X) [X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"
@interface RegistViewController ()

@end

@implementation RegistViewController
static bool isPersonal=YES;     //是否是个人/公司
static bool isArgee=YES;        //是否同意条款
static int  choosePage=0;       //选择城市

static int rangeFrom=0;         //判断选择到哪里
static int chooseMale=1;     //选择性别
static int customerType=1;      //用户类型，1为个人，2为企业

static bool isReload=NO;        //重新加载table判断

static bool isAllowBtn=YES;

static bool isHeadPortrait=YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _localArr=[[NSMutableArray alloc] initWithObjects:@"上海",@"北京",@"重庆",@"广州",@"山西",@"浙江",@"辽宁",@"西藏",@"台湾", nil];
        
        NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        _localArr=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
        
        PSSFileOperations *fileOperation=[[PSSFileOperations alloc] init];
        _cityMainArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:@"select region_name,region_id from cities where region_type=2 and is_open=1" extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
        
        _cityMiddleArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:@"select region_name,region_id from cities where region_type=3 and parent_id>=110000 and parent_id<120000 and is_open=1" extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
        
        
        _cityFinalArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:@"select region_name,region_id from cities where region_type=4 and parent_id>=110000 and parent_id<120000 and is_open=1" extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
        
        
        _chooseCityDic=[[NSMutableDictionary alloc] init];
        _uploadAllField=[[NSMutableArray alloc] initWithObjects:_telephoneField,_authField,_usernameField,_passwordField,_realNameField,_addressField,_idnumberField,_stationName, nil];
        
        if (_chooseCityDic.count==0) {
            [_chooseCityDic setObject:[[_cityMainArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"province"];
            [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
            
            _cityStr=@"北京";
            _localStr=@"北京市";
            _finalStr=@"东城区";
        }
        
        
        _selfLocationStr=@"";
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self personalClick:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isAllowBtn=YES;
    
    self.navigationItem.title=@"注册";
    
    self.loactionPicker.hidden=YES;
//    self.loactionPicker.
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    //读取配置文件
    NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"RegistDetailPlist"];
    _mainPlistArray=[[NSMutableArray alloc]initWithArray:[mainInfoDic objectForKey:@"details"]];
    [mainInfoDic release];
    mainInfoDic=nil;
    
    
    [self.detailTableView addSubview:_personBtn];
    [self.detailTableView addSubview:_personLab];
    [self.detailTableView addSubview:_companyBtn];
    [self.detailTableView addSubview:_companyLab];
    [self.detailTableView addSubview:_agreementBtn];
    [self.detailTableView addSubview:_agreementImg];
    [self.detailTableView addSubview:_comeWebBtn];
    [self.detailTableView addSubview:_submitBtn];
    self.detailTableView.bounces=NO;
    self.detailTableView.showsVerticalScrollIndicator=NO;
    
    
    UIImageView *tabBackground=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllBackground.png"]];
    [self.detailTableView setBackgroundView:tabBackground];
    
    
    [IQKeyBoardManager installKeyboardManager];
    
}

BACK_ACTION

//#pragma mark - 跳转到详情
//-(void)next
//{
//    Notification__POST(REGISTCHOOSEMENU,nil);
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - 点击协议
- (IBAction)agreementClick:(id)sender {
    UIButton *clickBtn=(UIButton *)sender;
    if (isArgee==YES) {
        isArgee=NO;
    }else{
        isArgee=YES;
    }
    isArgee==YES?[clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal]:[clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
    isArgee==YES?[self.submitBtn setBackgroundImage:[UIImage imageNamed:@"Release.png"] forState:UIControlStateNormal]:[self.submitBtn setBackgroundImage:[UIImage imageNamed:@"forbidBtn.png"] forState:UIControlStateNormal];
}

#pragma mark - 验证手机号码
-(BOOL)isValidatePhone:(NSString *)phone {  //正则验证
    
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";         //邮箱
    
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[^4,\\D]))\\d{8}";
    NSString *phoneRegex = @"^1[3456789][0-9]{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

#pragma mark - 验证身份证
-(BOOL)isValidateIdCard:(NSString *)idCard {  //正则验证
    NSString *idCardRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *idCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
    return [idCardTest evaluateWithObject:idCard];
}

#pragma mark - 判断中文
-(BOOL)getChina:(NSString *)string
{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            return NO;
        }else{
            
        }
    }
    return YES;
}

#pragma mark - 提交详情
- (IBAction)submitRegist:(id)sender {
    if (isArgee==NO) {
        return;
    }
    
    if (_imageUrl.length==0) {
        WARNING__ALERT(@"请先上传证件照");
        return;
    }
    
    for (UITextField *chooseField in _uploadAllField) {
        if (chooseField.text.length==0) {
            WARNING__ALERT(@"请将信息填写完整");
        }
        return;
    }
    
    if ([self isValidatePhone:_telephoneField.text]==NO) {
        WARNING__ALERT(@"您的手机号码格式不正确");
        return;
    }
    
    if ((customerType==2)&&(_companyNameField.text.length==0||_companyCode.text.length==0)) {
        WARNING__ALERT(@"请将信息填写完整");
        return;
    }
    
    if ([self isValidateIdCard:_idnumberField.text]==NO) {
        WARNING__ALERT(@"身份证格式错误");
        return;
    }
    
    if (_idImgUrl.length==0) {
        WARNING__ALERT(@"请上传您的证件照片");
        return;
    }
    
    if ([self getChina:_usernameField.text]==NO) {
        WARNING__ALERT(@"用户名不能使用中文");
        return;
    }
    
    if ([self getChina:_passwordField.text]==NO) {
        WARNING__ALERT(@"密码不能使用中文");
        return;
    }
    
    if (_usernameField.text.length<6||_usernameField.text.length>20) {
        WARNING__ALERT(@"用户名字数范围为6～20");
        return;
    }
    
    SHOW__LOADING;
    
    RegistNetWork *registInform=[[RegistNetWork alloc] init];
    NSMutableDictionary *_uploadDic=[[NSMutableDictionary alloc] init];
    [_uploadDic setObject:_usernameField.text forKey:@"username"];
    [_uploadDic setObject:_passwordField.text forKey:@"password"];
    [_uploadDic setObject:_telephoneField.text forKey:@"mobile"];
    [_uploadDic setObject:_idImgUrl forKey:@"id_img"];
//    [_uploadDic setObject:_stationName.text forKey:@"station_name"];
    [_uploadDic setObject:_authField.text forKey:@"authcode"];
    [_uploadDic setObject:_realNameField.text forKey:@"realname"];
    [_uploadDic setObject:_idnumberField.text forKey:@"idnumber"];
    [_uploadDic setObject:[NSString stringWithFormat:@"%d",chooseMale] forKey:@"sex"];
    [_uploadDic setObject:_imageUrl forKey:@"image"];
    [_uploadDic setObject:[_chooseCityDic objectForKey:@"province"] forKey:@"province"];
    [_uploadDic setObject:[_chooseCityDic objectForKey:@"city"] forKey:@"city"];
    [_uploadDic setObject:[_chooseCityDic objectForKey:@"district"] forKey:@"district"];
//    [_uploadDic setObject:_addressField.text forKey:@"address"];
    [_uploadDic setObject:[NSString stringWithFormat:@"%d",customerType] forKey:@"user_belong"];
    if (customerType==2) {
        NSLog(@"合格和：%@",_companyNameField.text);
        [_uploadDic setObject:_companyNameField.text forKey:@"company_name"];
        [_uploadDic setObject:_companyCode.text forKey:@"company_code"];
    }
    
    //提交注册
    [registInform regist:_uploadDic success:^(id responseData){
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        RegistBack *registBack=[RegistBack objectFromJSONObject:RPCResult.res mapping:[RegistBack mapping]];
        if (RPCResult.success==YES) {
            PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
            [writeOperation writeToPlist:WRITEREGIST plistContent:RPCResult.res];
            
            HIDE__LOADING;
            
            Notification__POST(REGISTCHOOSEMENU,nil);
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(registBack.reason);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"呵呵：%@",_mainPlistArray);
    if (isPersonal) {
        return 4;
    }
    return _mainPlistArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *singleArr=[_mainPlistArray objectAtIndex:section];
    return singleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"RegistViewCell";
//    RegistViewCell *cell = (RegistViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell==nil) {
//        cell = (RegistViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"RegistViewCell" owner:self options:nil] lastObject];
        RegistViewCell *cell = (RegistViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"RegistViewCell" owner:self options:nil] lastObject];


        cell.selectionStyle = UITableViewScrollPositionNone;
//    }
    
    [self submitBtnAutoSize];
    
    
    
    cell.cityLab.textAlignment=UITextAlignmentRight;
    
    CGRect logoRect=cell.logoImg.frame;
    logoRect.origin.y-=2;
    logoRect.size.width+=5;
    logoRect.size.height+=5;
    logoRect.origin.x+=10;
    cell.logoImg.frame=logoRect;
    
    cell.menuTextField.textAlignment=UITextAlignmentRight;
    
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.menuTextField.delegate=self;
    [cell.menuTextField addPreviousNextDoneOnKeyboardWithTarget:self
                                                 previousAction:nil
                                                     nextAction:nil
                                                     doneAction:@selector(doneClicked:)];
    [cell.menuTextField setEnablePrevious:NO next:YES];
    
    switch (indexPath.section) {
        case 0:
            cell.logoImg.hidden=NO;
            if (_saveImg) {
                cell.logoImg.image=_saveImg;
            }
            
            cell.imgAddBtn.hidden=NO;
            [cell.imgAddBtn addTarget:self action:@selector(addCremaImg) forControlEvents:UIControlEventTouchUpInside];
            cell.menuTextField.hidden=YES;
            break;
            
        case 1:
            cell.mustImg.hidden=YES;
            cell.textFieldBackground.hidden=NO;
            
            if (indexPath.row==1) {
                cell.textFieldBackground.hidden=YES;
                cell.menuTextField.hidden=YES;
                cell.menuLab.hidden=YES;
                cell.asteriskLab.hidden=YES;
                cell.telephoneBtn.hidden=NO;
                if (isAllowBtn==YES) {
                    cell.telephoneBtn.enabled=YES;
                }else{
                    cell.telephoneBtn.enabled=NO;
                }
                
                [cell.telephoneBtn addTarget:self action:@selector(getTelephoneCode:) forControlEvents:UIControlEventTouchUpInside];
            }else if (indexPath.row==0)
            {
                cell.menuTextField.text=_telephoneField.text;
                cell.menuTextField.keyboardType=UIKeyboardTypeNumberPad;
                _telephoneField=cell.menuTextField;
                [_telephoneField retain];
//                cell.menuTextField.delegate=self;
            }else if (indexPath.row==2)
            {
                cell.menuTextField.text=_authField.text;
                _authField=cell.menuTextField;
                cell.menuTextField.keyboardType=UIKeyboardTypeNumberPad;
                [_authField retain];
            }
            break;
            
        case 2:
            if (indexPath.row==0) {
                cell.menuTextField.text=_usernameField.text;
                _usernameField=cell.menuTextField;
                [_usernameField retain];
            }else if(indexPath.row==1){
                [cell.menuTextField setSecureTextEntry:YES];
                cell.menuTextField.text=_passwordField.text;
                _passwordField=cell.menuTextField;
                [_passwordField retain];
            }else{
                
                cell.menuTextField.text=_stationName.text;
                _stationName=cell.menuTextField;
                [_stationName retain];
            }
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.menuTextField.text=_realNameField.text;
                    _realNameField=cell.menuTextField;
                    [_realNameField retain];
                    break;
                    
//                case 3:
//                    cell.menuTextField.text=_addressField.text;
//                    _addressField=cell.menuTextField;
//                    [_addressField retain];
//                    break;
                    
                case 3:
                    cell.menuTextField.text=_idnumberField.text;
                    _idnumberField=cell.menuTextField;
                    [_idnumberField retain];
                    break;
                    
                case 4:
                    cell.MainIdCardImg.hidden=NO;
                    cell.menuTextField.hidden=YES;
                    if (_idImg) {
                        cell.MainIdCardImg.image=_idImg;
                    }
                    break;
                    
                default:
                    break;
            }
            
            if (indexPath.row==1) {
                cell.menuTextField.hidden=YES;
                
                
                cell.chooseNanBtn.hidden=NO;
                cell.chooseNanBtn.tag=1;    //男的标记为1
                [cell.chooseNanBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
                _maleBtn=cell.chooseNanBtn;
                
                
                cell.chooseNvBtn.hidden=NO;
                cell.chooseNvBtn.tag=2;     //女的标记为2
                [cell.chooseNvBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
                _femaleBtn=cell.chooseNvBtn;
                
                
                cell.nanLab.hidden=NO;
                cell.nvLab.hidden=NO;
                
                if (chooseMale==1) {
                    [_maleBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
                    [_femaleBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
                }else{
                    [_maleBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
                    [_femaleBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
                }
            }
            
            if (indexPath.row==2) {
                
//                NSLog(@"呵呵：%@",_tLab.text);
                cell.menuTextField.hidden=YES;
                cell.telephoneBtn.hidden=NO;
                cell.cityLab.hidden=NO;
                
                if (_selfLocationStr.length>0) {
                    cell.cityLab.text=_selfLocationStr;
                }
                
                _tLab=cell.cityLab;
                [cell.telephoneBtn setImage:nil forState:UIControlStateNormal];
                [cell.telephoneBtn addTarget:self action:@selector(chooseLocation:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            break;
            
        case 4:
            if (indexPath.row==0) {
                cell.menuTextField.text=_companyNameField.text;
                _companyNameField=cell.menuTextField;
                [_companyNameField retain];
            }else{
                cell.menuTextField.text=_companyCode.text;
                _companyCode=cell.menuTextField;
                [_companyCode retain];
            }
            break;
            
        default:
            break;
    }
    
    cell.menuLab.text=[[_mainPlistArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
            
        default:
            return 40;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3&&indexPath.row==4) {
        [self addIdImg];
    }
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==4) {
        return 45;
    }
    return 10;
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

#pragma mark -自动调整submitBtn的frame
-(void)submitBtnAutoSize
{
    float unitHeight=560;
    float addPoint=0;
    
    if (isPersonal) {
        self.detailTableView.contentSize=CGSizeMake(300, PERSONALHEIGHT);
        addPoint=0;
    }else{
        self.detailTableView.contentSize=CGSizeMake(300, COMPANYHEIGHT);
        addPoint=100;
    }
    
    self.personBtn.frame=[self fitFrames:unitHeight-40 rect:self.personBtn.frame];
    self.personLab.frame=[self fitFrames:unitHeight-40 rect:self.personLab.frame];
    self.companyBtn.frame=[self fitFrames:unitHeight-40 rect:self.companyBtn.frame];
    self.companyLab.frame=[self fitFrames:unitHeight-40 rect:self.companyLab.frame];
    self.agreementBtn.frame=[self fitFrames:553+addPoint rect:self.agreementBtn.frame];
    self.agreementImg.frame=[self fitFrames:555+addPoint rect:self.agreementImg.frame];
    self.comeWebBtn.frame=[self fitFrames:555+addPoint rect:self.comeWebBtn.frame];
    self.submitBtn.frame=[self fitFrames:585+addPoint rect:self.submitBtn.frame];
    
    CGRect rect;
    rect=self.agreementBtn.frame;
    
}

#pragma mark - 自动调整请求参数
-(CGRect)fitFrames:(float)fitCoordinates rect:(CGRect)rect
{
    CGRect  fitRect=rect;
    fitRect.origin.y=fitCoordinates;
    return fitRect;
}

#pragma mark - 选择个人
- (IBAction)personalClick:(id)sender {
    customerType=1;
    isPersonal=YES;
    [self.detailTableView reloadData];
    [self.personBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
    [self.companyBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
    
    [self.detailTableView addSubview:_personBtn];
    [self.detailTableView addSubview:_personLab];
    [self.detailTableView addSubview:_companyBtn];
    [self.detailTableView addSubview:_companyLab];
}

#pragma mark - 选择公司
- (IBAction)companyClick:(id)sender {
    customerType=2;
    isPersonal=NO;
    isReload=YES;
    
    [self.detailTableView reloadData];
    
    isReload=NO;
    [self.personBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
    [self.companyBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
    
    [self.detailTableView addSubview:_personBtn];
    [self.detailTableView addSubview:_personLab];
    [self.detailTableView addSubview:_companyBtn];
    [self.detailTableView addSubview:_companyLab];
}

#pragma mark - 结束编辑
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - 选择性别
-(void)chooseSex:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if (clickBtn.tag==1) {
        chooseMale=1;
        [_maleBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
        [_femaleBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
    }else{
        chooseMale=2;
        [_maleBtn setImage:[UIImage imageNamed:@"choosingNo.png"] forState:UIControlStateNormal];
        [_femaleBtn setImage:[UIImage imageNamed:@"chooseingYes.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 选择地点
-(void)chooseLocation:(id)sender
{
    self.chooseLocalFinishView.hidden=NO;
    
    CGRect rect=self.chooseLocalFinishView.frame;
    rect.origin.y=self.loactionPicker.frame.origin.y-rect.size.height;
    self.chooseLocalFinishView.frame=rect;
    
    
    self.loactionPicker.hidden=NO;
    self.loactionPicker.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"AllBackground.png"]];
    self.blackBackgroundBtn.hidden=NO;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return _cityMainArr.count;
            break;
            
        case 1:
            return _cityMiddleArr.count;
            break;
            
        case 2:
            return _cityFinalArr.count;
            break;
            
        default:
            return 0;
            break;
    }
}
#pragma mark pickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return @"";
    
    if (component == 0) {return [[_localArr objectAtIndex:row] objectForKey:@"State"];
    }
    else return [[[[_localArr objectAtIndex:choosePage] objectForKey:@"Cities"] objectAtIndex:row] objectForKey:@"city"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    PSSFileOperations *fileOperation=[[PSSFileOperations alloc] init];
    if (component==0) {
        rangeFrom=[[[_cityMainArr objectAtIndex:row] objectForKey:@"region_id"] intValue];
    }
    
    switch (component) {
        case 0:
            [_chooseCityDic setObject:[[_cityMainArr objectAtIndex:row] objectForKey:@"region_id"] forKey:@"province"];
            _cityStr=[[_cityMainArr objectAtIndex:row] objectForKey:@"region_name"];
            [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
            
            
            [_cityMiddleArr removeAllObjects];
            [_cityMiddleArr release];
            _cityMiddleArr=nil;
            _cityMiddleArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name,region_id from cities where region_type=3 and parent_id>=%d and parent_id<%d and is_open=1",rangeFrom,rangeFrom+10000] extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
            
            [_cityFinalArr removeAllObjects];
            [_cityFinalArr release];
            _cityFinalArr=nil;
            _cityFinalArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name,region_id from cities where region_type=4 and parent_id=%d and is_open=1",rangeFrom+100] extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            _localStr=[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_name"];
            
            
            [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
            _finalStr=[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_name"];
            
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
//            _textLab.text=[_chooseCityDic objectForKey:@"city"];
            break;
            
        case 1:
            [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:row] objectForKey:@"region_id"] forKey:@"city"];
            _localStr=[[_cityMiddleArr objectAtIndex:row] objectForKey:@"region_name"];
            
            [_cityFinalArr removeAllObjects];
            [_cityFinalArr release];
            _cityFinalArr=nil;
//            _cityFinalArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name,region_id from cities where region_type=4 and parent_id=%d and is_open=1",rangeFrom+100*(row+1)] extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
            _cityFinalArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name,region_id from cities where region_type=4 and parent_id=%@ and is_open=1",[_chooseCityDic objectForKey:@"city"]] extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
            [pickerView reloadComponent:2];
            
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
            _finalStr=[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_name"];
            
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
            
        case 2:
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:row] objectForKey:@"region_id"] forKey:@"district"];
            if ([[_chooseCityDic objectForKey:@"city"] isEqualToString:@"110100"]) {
                [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
            }
            _finalStr=[[_cityFinalArr objectAtIndex:row] objectForKey:@"region_name"];
            
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
            
            if (_cityStr.length==0) {
                _cityStr=@"北京";
            }
            
            if (_localStr.length==0) {
                _localStr=@"北京市";
            }
            
//            _tLab.text=[NSString stringWithFormat:@"%@%@%@",_cityStr,_localStr,_finalStr];
//            _selfLocationStr=[NSString stringWithFormat:@"%@%@%@",_cityStr,_localStr,_finalStr];
//            [_selfLocationStr retain];
//            
//            self.loactionPicker.hidden=YES;
//            self.blackBackgroundBtn.hidden=YES;
//
//            [_chooseCityDic setObject:[_chooseCityDic objectForKey:@"city"] forKey:@"city"];
//            [_chooseCityDic setObject:[_chooseCityDic objectForKey:@"district"] forKey:@"district"];
//            [_chooseCityDic setObject:[_chooseCityDic objectForKey:@"province"] forKey:@"province"];
            
//            [_chooseCityDic setObject:@"310100" forKey:@"city"];
//            [_chooseCityDic setObject:@"310104" forKey:@"district"];
//            [_chooseCityDic setObject:@"310000" forKey:@"province"];
            break;
            
        default:
            break;
    }
    
//    if (component == 0){
//        choosePage = row;
//        [pickerView reloadComponent:1];
//    }else{
//        _tLab.text=[NSString stringWithFormat:@"%@%@",[[_localArr objectAtIndex:choosePage] objectForKey:@"State"],[[[[_localArr objectAtIndex:choosePage] objectForKey:@"Cities"] objectAtIndex:row] objectForKey:@"city"]];
//        
//        self.loactionPicker.hidden=YES;
//        self.blackBackgroundBtn.hidden=YES;
//    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 =[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 30.0f)];
    
//    if (component == 0) {mycom1.text=[[_localArr objectAtIndex:row] objectForKey:@"State"];
//        _cityStr=mycom1.text;
//    }
//    else mycom1.text=[[[[_localArr objectAtIndex:choosePage] objectForKey:@"Cities"] objectAtIndex:row] objectForKey:@"city"];_localStr=mycom1.text;
    
    switch (component) {
        case 0:
            mycom1.text=[[_cityMainArr objectAtIndex:row] objectForKey:@"region_name"];
            
            break;
            
        case 1:
            mycom1.text=[[_cityMiddleArr objectAtIndex:row] objectForKey:@"region_name"];
            
            break;
            
        case 2:
            mycom1.text=[[_cityFinalArr objectAtIndex:row] objectForKey:@"region_name"];
            
            break;
            
        default:
            break;
    }
    
    mycom1.textAlignment=NSTextAlignmentCenter;
    [mycom1 setFont:[UIFont boldSystemFontOfSize:15]];
    mycom1.backgroundColor = [UIColor clearColor];
    
    return mycom1;
}

#pragma mark - 选择地区点击完成按钮
- (IBAction)finishChooseLocal:(id)sender {
    _tLab.text=[NSString stringWithFormat:@"%@%@%@",_cityStr,_localStr,_finalStr];
    _selfLocationStr=[NSString stringWithFormat:@"%@%@%@",_cityStr,_localStr,_finalStr];
    [_selfLocationStr retain];
    
    self.loactionPicker.hidden=YES;
    self.blackBackgroundBtn.hidden=YES;
    self.chooseLocalFinishView.hidden=YES;
}

#pragma mark - 60秒后按钮正常
-(void)allowBtn
{
    if (isAllowBtn==YES) {
        return;
    }
    isAllowBtn=YES;
    [self.detailTableView reloadData];
}

#pragma mark - 获取验证码
-(void)getTelephoneCode:(id)sender
{
    [self.view endEditing:YES];
    if ([self isValidatePhone:_telephoneField.text]==NO) {
        WARNING__ALERT(@"您的手机号码格式不正确");
        return;
    }
    
    UIButton *clickBtn=(UIButton *)sender;
    clickBtn.enabled=NO;
    isAllowBtn=NO;
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(allowBtn) userInfo:nil repeats:NO];
    
    SHOW__LOADING
    GetRegistCode *getCode=[[GetRegistCode alloc] init];
    [getCode getCode:_telephoneField.text success:^(id responseData){
        HIDE__LOADING
        
        XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
        if (result.success==NO) {
            isAllowBtn=YES;
            [self.detailTableView reloadData];
        }
        WARNING__ALERT([result.res objectForKey:@"reason"]);
        
        
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
        [self allowBtn];
    }];
}

#pragma mark - 拍照
#pragma mark - 头像
-(void)addCremaImg
{
    isHeadPortrait=YES;
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

#pragma mark - 身份证
-(void)addIdImg
{
    isHeadPortrait=NO;
    
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
    if (isHeadPortrait==YES) {
        _saveImg=tableViewBg;
        [_saveImg retain];
    }else{
        _idImg=tableViewBg;
        [_idImg retain];
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
    [uploadNet upload:@"1" data:path success:^(id responseData){
        UploadInfo *loginObject=[[UploadInfo alloc]initWithStatus:responseData];
        
        if (loginObject.success==YES) {
            if (isHeadPortrait==YES) {
                _imageUrl=loginObject.url;
            }else{
                _idImgUrl=loginObject.url;
            }
            
            HIDE__LOADING;
            WARNING__ALERT(@"上传成功");
            [self.detailTableView reloadData];
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(loginObject.url);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}

- (IBAction)comeToWeb:(id)sender {
    AgreementViewController *agreementVC=[[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
    [agreementVC release];
    agreementVC=nil;
}

- (IBAction)hidBlack:(id)sender {
    self.loactionPicker.hidden=YES;
    self.blackBackgroundBtn.hidden=YES;
    self.chooseLocalFinishView.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_detailTableView release];
    [_personBtn release];
    [_personLab release];
    [_companyBtn release];
    [_companyLab release];
    [_agreementBtn release];
    [_agreementImg release];
    [_submitBtn release];
    [_loactionPicker release];
    [_blackBackgroundBtn release];
    [_comeWebBtn release];
    [_chooseLocalFinishBtn release];
    [_chooseLocalFinishView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDetailTableView:nil];
    [self setPersonBtn:nil];
    [self setPersonLab:nil];
    [self setCompanyBtn:nil];
    [self setCompanyLab:nil];
    [self setAgreementBtn:nil];
    [self setAgreementImg:nil];
    [self setSubmitBtn:nil];
    [self setLoactionPicker:nil];
    [self setBlackBackgroundBtn:nil];
    [self setComeWebBtn:nil];
    [self setChooseLocalFinishBtn:nil];
    [self setChooseLocalFinishView:nil];
    [super viewDidUnload];
}
@end
