//
//  PersonalInforViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-15.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PersonalInforViewController.h"
#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "SetBasicInfor.h"

#import "XMLRPCResult.h"

#import "RegistrationCertificateViewController.h"

@interface PersonalInforViewController ()
{
    SDWebImageManager *manager;
    PSSFileOperations *fileOperation;
}
@end

@implementation PersonalInforViewController
static int choosePage=0;

static int rangeFrom=0;         //判断选择到哪里

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //读取配置文件
        NSMutableDictionary *mainInfoDic=[PSSFileOperations getMainBundlePlist:@"PersonalInfo"];
        _mainPlistArray=[[NSMutableArray alloc]initWithArray:[mainInfoDic objectForKey:@"infor"]];
        
//        NSLog(@"哈哈：%@",_mainPlistArray);
        
        [mainInfoDic release];
        mainInfoDic=nil;
        
        NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        _localArr=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
        
        
//        NSLog(@"h啊哈:%@",_userInfoDic);
        
        
        fileOperation=[[PSSFileOperations alloc] init];
        
        _cityMainArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:@"select region_name,region_id from cities where region_type=2 and is_open=1" extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
        
        _cityMiddleArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:@"select region_name,region_id from cities where region_type=3 and parent_id>=110000 and parent_id<120000 and is_open=1" extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
        
        
        _cityFinalArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:@"select region_name,region_id from cities where region_type=4 and parent_id>=110000 and parent_id<120000 and is_open=1" extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
        
        if (_chooseCityDic.count==0) {
            _chooseCityDic=[[NSMutableDictionary alloc] init];
            [_chooseCityDic setObject:[[_cityMainArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"province"];
            [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
            
            _cityStr=@"北京";
            _localStr=@"北京市";
            _finalStr=@"东城区";
        }
        
        _chooseCityDic=[[NSMutableDictionary alloc] init];
        _selfLocationStr=@"";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"个人信息";
    
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    _userInfoDic=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NAVIGATION_BACK(@"   返回");
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    self.mainTableList.backgroundColor=[UIColor clearColor];
    self.mainTableList.backgroundView=nil;
    self.mainTableList.bounces=NO;
    
    self.mainTableList.showsHorizontalScrollIndicator=NO;
    self.mainTableList.showsVerticalScrollIndicator=NO;
    
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"呵呵：%@",_userInfoDic);
    if ([[_userInfoDic objectForKey:@"tuzi_type"] intValue]==1) {
        return _mainPlistArray.count-1;
    }else if ([[_userInfoDic objectForKey:@"serve_cates"] isEqualToString:@"193,192,191,190"]){
        return _mainPlistArray.count-1;
    }
    return _mainPlistArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tArr=[_mainPlistArray objectAtIndex:section];
    if (section==5) {
        switch ([[_userInfoDic objectForKey:@"user_belong"] intValue]) {
            case 1:
                return 1;
                break;
                
            default:
                break;
        }
    }
    
    
    return tArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegistViewCell *cell = (RegistViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"RegistViewCell" owner:self options:nil] lastObject];
    
    cell.cityLab.textAlignment=UITextAlignmentRight;
    
    cell.asteriskLab.hidden=YES;
    
    CGRect logoRect=cell.logoImg.frame;
    logoRect.origin.y-=2;
    logoRect.size.width+=5;
    logoRect.size.height+=5;
    logoRect.origin.x+=10;
    cell.logoImg.frame=logoRect;
    
    cell.menuTextField.textAlignment=UITextAlignmentRight;
    
    CGRect fieldRect=cell.menuTextField.frame;
    fieldRect.origin.x+=10;
    cell.menuTextField.frame=fieldRect;
    
    cell.mustImg.hidden=YES;
    switch (indexPath.section) {
        case 0:
            cell.mustImg.hidden=NO;
            
            //设置头像
            [manager downloadWithURL:[NSURL URLWithString:[_userInfoDic objectForKey:@"image"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                cell.logoImg.image=image;
            }];
            
            cell.logoImg.hidden=NO;
            _tImg=cell.logoImg;
            cell.imgAddBtn.hidden=NO;
            cell.menuTextField.hidden=YES;
            [cell.imgAddBtn addTarget:self action:@selector(addCremaImg) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 1:
            cell.cityLab.hidden=NO;
            cell.menuTextField.hidden=YES;
            
            if (indexPath.row==0) {
                cell.cityLab.text=[_userInfoDic objectForKey:@"work_sn"];
            }else{
                cell.cityLab.text=[self timeZone:[[_userInfoDic objectForKey:@"reg_time"] intValue]];
            }
            break;
            
        case 2:
            cell.menuTextField.hidden=YES;
            if (indexPath.row==1) {
                cell.mustImg.hidden=NO;
                cell.cityLab.hidden=NO;
                cell.cityLab.text=@"**********";
            }else if(indexPath.row==0){
                cell.mustImg.hidden=YES;
                cell.cityLab.hidden=NO;
                cell.cityLab.text=[_userInfoDic objectForKey:@"username"];
            }else if(indexPath.row==2){
                cell.mustImg.hidden=NO;
//                cell.cityLab.hidden=NO;
//                cell.cityLab.text=[_userInfoDic objectForKey:@"station_name"];
                
                
                cell.cityLab.hidden=YES;
                cell.menuTextField.hidden=NO;
                cell.menuTextField.text=[_userInfoDic objectForKey:@"station_name"];
                cell.menuTextField.tag=0;
                cell.menuTextField.delegate=self;
                [cell.menuTextField addPreviousNextDoneOnKeyboardWithTarget:self
                                                             previousAction:nil
                                                                 nextAction:nil
                                                                 doneAction:@selector(doneClicked:)];
                [cell.menuTextField setEnablePrevious:NO next:YES];
            }else{
                cell.mustImg.hidden=YES;
                cell.cityLab.hidden=NO;
                switch ([[_userInfoDic objectForKey:@"tuzi_type"] intValue]) {
                    case 1:
                        cell.cityLab.text=@"跑腿兔";
                        break;
                        
                    case 2:
                        cell.cityLab.text=@"开车兔";
                        break;
                        
                    case 3:
                        cell.cityLab.text=@"上门兔";
                        switch ([[_userInfoDic objectForKey:@"serve_level"] intValue]) {
                            case 1:
                                cell.cityLab.text=[NSString stringWithFormat:@"普通%@",cell.cityLab.text];
                                break;
                                
                            case 2:
                                cell.cityLab.text=[NSString stringWithFormat:@"专业%@",cell.cityLab.text];
                                break;
                                
                            case 3:
                                cell.cityLab.text=[NSString stringWithFormat:@"高级%@",cell.cityLab.text];
                                break;
                                
                            default:
                                break;
                        }
                        break;
                        
                    case 4:
                        cell.cityLab.text=@"帮帮兔";
                        break;
                        
                    default:
                        break;
                }
            }
            
            
            break;
            
        case 3:
            cell.menuTextField.hidden=YES;
            if (indexPath.row==0) {
                cell.cityLab.hidden=NO;
                cell.cityLab.text=[_userInfoDic objectForKey:@"realname"];
            }else if(indexPath.row==2){
                cell.cityLab.hidden=NO;
                cell.cityLab.text=[_userInfoDic objectForKey:@"mobile"];
            }else{
                cell.cityLab.hidden=NO;
                switch ([[_userInfoDic objectForKey:@"sex"] intValue]) {
                    case 1:
                        cell.cityLab.text=@"男";
                        break;
                        
                    case 2:
                        cell.cityLab.text=@"女";
                        break;
                        
                    default:
                        break;
                }
            }
            break;
            
        case 4:
            //所在地
            if (indexPath.row==0) {
                cell.mustImg.hidden=NO;
                fileOperation=[[PSSFileOperations alloc] init];
                NSString *cityStr=[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@ and is_open=1",[_userInfoDic objectForKey:@"province"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"];
                NSString *localStr=[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@ and is_open=1",[_userInfoDic objectForKey:@"city"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"];
                NSString *detailStr=[[[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name from cities where region_id=%@ and is_open=1",[_userInfoDic objectForKey:@"district"]] extension:[[NSArray alloc] initWithObjects:@"region_name", nil]] objectAtIndex:0] objectForKey:@"region_name"];
                _mainLocalStr=[NSString stringWithFormat:@"%@%@",localStr,detailStr];
                //            cell.mustImg.hidden=NO;
                cell.cityLab.hidden=NO;
                if (_selfLocationStr.length>0) {
                    cell.cityLab.text=_selfLocationStr;
                }else{
                    cell.cityLab.text=_mainLocalStr;
                }
                
                cell.menuTextField.hidden=YES;
            }else if(indexPath.row==1){
                cell.mustImg.hidden=NO;
                cell.cityLab.hidden=YES;
                cell.menuTextField.hidden=NO;
                cell.menuTextField.text=[_userInfoDic objectForKey:@"address"];
                cell.menuTextField.tag=1;
                cell.menuTextField.delegate=self;
                [cell.menuTextField addPreviousNextDoneOnKeyboardWithTarget:self
                                                             previousAction:nil
                                                                 nextAction:nil
                                                                 doneAction:@selector(doneClicked:)];
                [cell.menuTextField setEnablePrevious:NO next:YES];
            }else if(indexPath.row==2){
                cell.menuTextField.hidden=YES;
                cell.cityLab.hidden=NO;
                cell.cityLab.text=[_userInfoDic objectForKey:@"id_number"];
            }else{
                cell.menuTextField.hidden=YES;
                cell.cityLab.hidden=YES;
                cell.MainIdCardImg.hidden=NO;
                
                //设置头像
                [manager downloadWithURL:[NSURL URLWithString:[_userInfoDic objectForKey:@"id_img"]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                    
                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                    if (error) {
                        cell.MainIdCardImg.image=[UIImage imageNamed:@"mini_avatar.9.png"];
                    }else{
                        cell.MainIdCardImg.image=image;
                    }
                    
                }];
                
            }
            
            break;
            
        case 5:
            cell.menuTextField.hidden=YES;
            cell.cityLab.hidden=NO;
            if (indexPath.row==0) {
                switch ([[_userInfoDic objectForKey:@"user_belong"] intValue]) {
                    case 1:
                        cell.cityLab.text=@"个人";
                        break;
                        
                    default:
                        cell.cityLab.text=@"企业";
                        break;
                }
            }else if(indexPath.row==1){
                cell.cityLab.text=[_userInfoDic objectForKey:@"company_name"];
            }else{
                cell.cityLab.text=[_userInfoDic objectForKey:@"company_code"];
            }
            
            break;
            
        case 6:
            cell.menuTextField.hidden=YES;
            cell.cityLab.hidden=YES;
            cell.mustImg.hidden=NO;
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.menuLab.text=[[_mainPlistArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2&&indexPath.row==1) {
        _changePasswordVC=[[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:_changePasswordVC animated:YES];
    }else if (indexPath.section==4&&indexPath.row==0)
    {
        self.chooseLocalFinishView.hidden=NO;
        CGRect rect=self.chooseLocalFinishView.frame;
        rect.origin.y=self.loactionPicker.frame.origin.y-rect.size.height;
        self.chooseLocalFinishView.frame=rect;
        
        self.loactionPicker.hidden=NO;
        self.loactionPicker.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"AllBackground.png"]];
        self.blackBackgroundBtn.hidden=NO;
    }else if (indexPath.section==6){
        BOOL isAllow=NO;
        switch ([[_userInfoDic objectForKey:@"is_cert_change"] intValue]) {
            case 0:
                isAllow=NO;
                break;
                
            case 1:
                isAllow=YES;
                break;
                
            default:
                break;
        }
        RegistrationCertificateViewController *regCertVC=[[RegistrationCertificateViewController alloc] initWithArray:[_userInfoDic objectForKey:@"certs"] allInfo:_userInfoDic  isAllowEdit:isAllow];
//        NSLog(@"呵呵：%@",_userInfoDic);
        [self.navigationController pushViewController:regCertVC animated:YES];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    return 40;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    fileOperation=[[PSSFileOperations alloc] init];
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
            //            _textLab.text=[_chooseCityDic objectForKey:@"city"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            break;
            
        case 1:
            [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:row] objectForKey:@"region_id"] forKey:@"city"];
            _localStr=[[_cityMiddleArr objectAtIndex:row] objectForKey:@"region_name"];
            
            [_cityFinalArr removeAllObjects];
            [_cityFinalArr release];
            _cityFinalArr=nil;
            _cityFinalArr=[[NSMutableArray alloc] initWithArray:[fileOperation publicFilePerform:PSSFileOperationsDatabaseSelect infoStr:[NSString stringWithFormat:@"select region_name,region_id from cities where region_type=4 and parent_id=%@ and is_open=1",[_chooseCityDic objectForKey:@"city"]] extension:[[NSArray alloc] initWithObjects:@"region_name",@"region_id", nil]]];
            
            [pickerView reloadComponent:2];
            
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
            _finalStr=[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_name"];
            //            _textLab.text=[_chooseCityDic objectForKey:@"city"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            break;
            
        case 2:
            [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:row] objectForKey:@"region_id"] forKey:@"district"];
            if ([[_chooseCityDic objectForKey:@"city"] isEqualToString:@"110100"]) {
                [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
            }
            _finalStr=[[_cityFinalArr objectAtIndex:row] objectForKey:@"region_name"];
            
            if (_cityStr.length==0) {
                _cityStr=@"北京";
            }
            
            if (_localStr.length==0) {
                _localStr=@"北京市";
            }
            
            
            
            break;
            
        default:
            break;
    }
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

#pragma mark 结束编辑
- (IBAction)finishChooseLocal:(id)sender {
    _tLab.text=[NSString stringWithFormat:@"%@%@",_localStr,_finalStr];
    _selfLocationStr=[NSString stringWithFormat:@"%@%@",_localStr,_finalStr];
    [_selfLocationStr retain];
    
    self.loactionPicker.hidden=YES;
    self.blackBackgroundBtn.hidden=YES;
    self.chooseLocalFinishView.hidden=YES;
    
    
    if (_chooseCityDic.count==0) {
        [_chooseCityDic setObject:[[_cityMainArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"province"];
        [_chooseCityDic setObject:[[_cityMiddleArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
        [_chooseCityDic setObject:[[_cityFinalArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"district"];
        
        _cityStr=@"北京";
        _localStr=@"北京市";
        _finalStr=@"东城区";
    }
    
    if ([_chooseCityDic objectForKey:@"province"]==nil) {
        [_chooseCityDic setObject:[[_cityMainArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"province"];
    }
    
    if ([_chooseCityDic objectForKey:@"city"]==nil) {
        [_chooseCityDic setObject:[[_cityMainArr objectAtIndex:0] objectForKey:@"region_id"] forKey:@"city"];
    }
    
    _mainLocalStr=[NSString stringWithFormat:@"%@%@",_localStr,_finalStr];
    
    SHOW__LOADING
    SetBasicInfor *_setBasicInfo=[[SetBasicInfor alloc] init];
    
//    [_setBasicInfo basicInfo:[_userInfoDic objectForKey:@"username"] user_image:[_userInfoDic objectForKey:@"image"] province:[_chooseCityDic objectForKey:@"province"] city:[_chooseCityDic objectForKey:@"city"] district:[_chooseCityDic objectForKey:@"district"] address:[_userInfoDic objectForKey:@"address"] station_name:[_userInfoDic objectForKey:@"station_name"] success:^(id responseData){
    [_setBasicInfo basicInfo:[_userInfoDic objectForKey:@"username"] user_image:[_userInfoDic objectForKey:@"image"] province:[_chooseCityDic objectForKey:@"province"] city:[_chooseCityDic objectForKey:@"city"] district:[_chooseCityDic objectForKey:@"district"] address:_mainLocalStr station_name:[_userInfoDic objectForKey:@"station_name"] success:^(id responseData){
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
            [_userInfoDic setObject:[_chooseCityDic objectForKey:@"district"] forKey:@"district"];
            [_userInfoDic setObject:[_chooseCityDic objectForKey:@"province"] forKey:@"province"];
            [_userInfoDic setObject:[_chooseCityDic objectForKey:@"city"] forKey:@"city"];
            
            [_userInfoDic setObject:_mainLocalStr forKey:@"address"];
            
            
            PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
            [writeOperation writeToPlist:WRITELOGIN plistContent:_userInfoDic];
            [self.mainTableList reloadData];
        }else{
            HIDE__LOADING;
            WARNING__ALERT(RPCResult.res);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - 拍照
-(void)addCremaImg
{
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
    _tImg.image=tableViewBg;
    _tImg.image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //上传图片
    
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
            _imageUrl=loginObject.url;
//            HIDE__LOADING;
//            WARNING__ALERT(@"上传成功");
            
            SetBasicInfor *_setBasicInfo=[[SetBasicInfor alloc] init];
            [_setBasicInfo basicInfo:[_userInfoDic objectForKey:@"username"] user_image:_imageUrl province:[_userInfoDic objectForKey:@"province"] city:[_userInfoDic objectForKey:@"city"] district:[_userInfoDic objectForKey:@"district"] address:[_userInfoDic objectForKey:@"address"] station_name:[_userInfoDic objectForKey:@"station_name"] success:^(id responseData){
                
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    HIDE__LOADING
                    WARNING__ALERT(@"修改成功");
                    [_userInfoDic setObject:[NSString stringWithFormat:@"http://img.tojie.com%@",_imageUrl] forKey:@"image"];
                    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
                    [writeOperation writeToPlist:WRITELOGIN plistContent:_userInfoDic];
                }else{
                    HIDE__LOADING;
                    WARNING__ALERT(RPCResult.res);
                }
                
//                HIDE__LOADING;
//                WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
            }failed:^(NSError *error){
                HIDE__LOADING;
                WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
            }];
            
            
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
    
    NSFileManager* managers = [NSFileManager defaultManager];
    
    if ([managers fileExistsAtPath:filePath]){
        
        return [[managers attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}

- (IBAction)hidBlack:(id)sender {
    self.loactionPicker.hidden=YES;
    self.blackBackgroundBtn.hidden=YES;
    self.chooseLocalFinishView.hidden=YES;
}

#pragma mark - 时间戳转换
- (NSString *)timeZone:(int)times{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *strTimes = [formatter stringFromDate:confromTimesp];
    return strTimes;
}

#pragma mark - textField
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    SetBasicInfor *_setBasicInfo=[[SetBasicInfor alloc] init];
    switch (textField.tag) {
        case 0:
            [_setBasicInfo basicInfo:[_userInfoDic objectForKey:@"username"] user_image:[_userInfoDic objectForKey:@"image"] province:[_userInfoDic objectForKey:@"province"] city:[_userInfoDic objectForKey:@"city"] district:[_userInfoDic objectForKey:@"district"] address:[_userInfoDic objectForKey:@"address"] station_name:textField.text success:^(id responseData){
                
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    [_userInfoDic setObject:textField.text forKey:@"station_name"];
                    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
                    [writeOperation writeToPlist:WRITELOGIN plistContent:_userInfoDic];
                }else{
                    HIDE__LOADING;
                    WARNING__ALERT(RPCResult.res);
                }
            }failed:^(NSError *error){
                HIDE__LOADING;
                WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
            }];
            break;

        case 1:
            [_setBasicInfo basicInfo:[_userInfoDic objectForKey:@"username"] user_image:[_userInfoDic objectForKey:@"image"] province:[_userInfoDic objectForKey:@"province"] city:[_userInfoDic objectForKey:@"city"] district:[_userInfoDic objectForKey:@"district"] address:textField.text station_name:[_userInfoDic objectForKey:@"station_name"] success:^(id responseData){
                
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                if (RPCResult.success==YES) {
                    [_userInfoDic setObject:textField.text forKey:@"address"];
                    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
                    [writeOperation writeToPlist:WRITELOGIN plistContent:_userInfoDic];
                }else{
                    HIDE__LOADING;
                    WARNING__ALERT(RPCResult.res);
                }
            }failed:^(NSError *error){
                HIDE__LOADING;
                WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
            }];
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainTableList release];
    [_loactionPicker release];
    [_blackBackgroundBtn release];
    [_chooseLocalFinishView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainTableList:nil];
    [self setLoactionPicker:nil];
    [self setBlackBackgroundBtn:nil];
    [self setChooseLocalFinishView:nil];
    [super viewDidUnload];
}
@end
