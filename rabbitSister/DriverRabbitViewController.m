//
//  DriverRabbitViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "DriverRabbitViewController.h"
#import "RegistViewCell.h"

#import "GetCateInstruct.h"
#import "XMLRPCResult.h"

#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "SubmitRabbitType.h"

@interface DriverRabbitViewController ()

@end

@implementation DriverRabbitViewController
static bool isMainAllow=YES;
static bool isOthderAllow=YES;

static bool isDriver=YES;

static int  chooseImgLocal=1;       //选择图片定位

static bool isFirst=YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary *_mainDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"DriverRabbit"]];
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:[_mainDic objectForKey:@"infor"]];
        
        _topArr=[[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            [_topArr addObject:@"1"];
        }
        
        _topBtnArr=[[NSMutableArray alloc] init];
        
        _middleArr=[[NSMutableArray alloc] init];
        for (int i=0; i<3; i++) {
            [_middleArr addObject:@"1"];
        }
        
        _middleBtnArr=[[NSMutableArray alloc] init];
        
        _imgDic=[[NSMutableDictionary alloc] init];
        
        _uploadFieldArr=[[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            [_uploadFieldArr addObject:@""];
        }
        
//        NSLog(@"哈哈：%@",_mainInfoArr);
        
        isDriver=YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars=NO;
//    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //上一步
    NAVIGATION_BACK(@"   上一步");
    
    [self.detailTableView addSubview:_submitBtn];
    self.detailTableView.bounces=NO;
    self.detailTableView.showsVerticalScrollIndicator=NO;
    self.detailTableView.backgroundView=nil;
    self.detailTableView.backgroundColor=[UIColor clearColor];
//    self.detailTableView.tableHeaderView=nil;
//    self.detailTableView.tableFooterView=nil;
    
    self.navigationItem.title=@"开车兔";
    
    [self reloadInform];
    
    //[IQKeyBoardManager installKeyboardManager];
    
    self.submitBtn.enabled=NO;
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
    [getCate getCateInstruct:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] city:[registInfo objectForKey:@"city"] cate_codes:[NSString stringWithFormat:@"140,141,142,143,11,12,13"] success:^(id responseData){
//        NSLog(@"呵呵：%@",responseData);
        HIDE__LOADING
        
        XMLRPCResult *result=[[XMLRPCResult alloc] initWithStatus:responseData];
        if (result.success==YES) {
            //总的价钱数据
            NSArray *priceArr=[[NSArray alloc] initWithArray:result.res];
            //替换原有数据
            
            [[_mainInfoArr objectAtIndex:0] replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"叫车：%@",[[priceArr objectAtIndex:0] objectForKey:@"low"]]];
            [[_mainInfoArr objectAtIndex:0] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"代接送客：%@",[[priceArr objectAtIndex:1] objectForKey:@"low"]]];
            [[_mainInfoArr objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"代运货：%@",[[priceArr objectAtIndex:2] objectForKey:@"low"]]];
            [[_mainInfoArr objectAtIndex:0] replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"车辆：%@",[[priceArr objectAtIndex:3] objectForKey:@"low"]]];
            
//            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"代购 %@",[[priceArr objectAtIndex:4] objectForKey:@"low"]]];
//            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"代办 %@",[[priceArr objectAtIndex:5] objectForKey:@"low"]]];
//            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"速递 %@",[[priceArr objectAtIndex:6] objectForKey:@"low"]]];
            
            
            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"代购"]];
            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"代办"]];
            [[_mainInfoArr objectAtIndex:1] replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"速递"]];
//            NSLog(@"呵呵：%@",[priceArr objectAtIndex:4]);
            
            [self.detailTableView reloadData];
        }else{
            WARNING__ALERT([result.res objectForKey:@"reason"]);
        }
        
    }failed:^(NSError *error){
        HIDE__LOADING
        WARNING__ALERT(@"获取数据失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mainInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=_mainInfoArr.count-1;
    if (section==count) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DriverRabbitCell";
    DriverRabbitCell *cell = (DriverRabbitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //添加submitBtn
    [self submitBtnAutoSize];
    
    if (cell==nil) {
        cell = (DriverRabbitCell *)[[[NSBundle mainBundle] loadNibNamed:@"DriverRabbitCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    NSArray *infoArr=[_mainInfoArr objectAtIndex:indexPath.section];
    
    
    cell.getInformField.delegate=self;
    [cell.getInformField addPreviousNextDoneOnKeyboardWithTarget:self
                                                 previousAction:nil
                                                     nextAction:nil
                                                     doneAction:@selector(doneClicked:)];
    [cell.getInformField setEnablePrevious:NO next:YES];
    
    switch (indexPath.section) {
        case 0:
            cell.driverTopView.hidden=NO;
            cell.driverMiddleView.hidden=YES;
            cell.driverOtherView.hidden=YES;
            
            cell.driverTopTitleLab.text=[infoArr objectAtIndex:0];
            cell.driverTopFirstLab.text=[infoArr objectAtIndex:1];
            cell.driverTopSecondLab.text=[infoArr objectAtIndex:2];
            cell.driverTopThirdLab.text=[infoArr objectAtIndex:3];
            cell.driverTopFouthLab.text=[infoArr objectAtIndex:4];
            cell.driverTopLastLab.text=[infoArr objectAtIndex:5];
            
            //主要点击
            [cell.driverTopWholeBtn addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];
            _tempTopBtn=cell.driverTopWholeBtn;
            
            
            //其他点击
            cell.driverTopFirstBtn.tag=1;
            [cell.driverTopFirstBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBtnArr addObject:cell.driverTopFirstBtn];
            
            cell.driverTopSecondBtn.tag=2;
            [cell.driverTopSecondBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBtnArr addObject:cell.driverTopSecondBtn];
            
            cell.driverTopThirdBtn.tag=3;
            [cell.driverTopThirdBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBtnArr addObject:cell.driverTopThirdBtn];
            
            cell.driverTopFouthBtn.tag=4;
            [cell.driverTopFouthBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBtnArr addObject:cell.driverTopFouthBtn];
            
            break;
            
        case 1:
            cell.driverTopView.hidden=YES;
            cell.driverMiddleView.hidden=NO;
            cell.driverOtherView.hidden=YES;
            
            cell.driverMiddleTitleLab.text=[infoArr objectAtIndex:0];
            cell.driverMiddleFirstLab.text=[infoArr objectAtIndex:1];
            cell.driverMiddleFirstDownLab.text=[infoArr objectAtIndex:2];
            cell.driverMiddleSectondLab.text=[infoArr objectAtIndex:3];
            cell.driverMiddleSecondDownLab.text=[infoArr objectAtIndex:4];
            cell.driverMiddleThirdLab.text=[infoArr objectAtIndex:5];
            cell.driverMiddleThirdDownLab.text=[infoArr objectAtIndex:6];
            
            
            //主要点击
            [cell.driverMiddleTitleBtn addTarget:self action:@selector(mainMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
            _tempMiddleBtn=cell.driverMiddleTitleBtn;
            
            
            //其他点击
            cell.driverMiddleFirstBtn.tag=1;
            [cell.driverMiddleFirstBtn addTarget:self action:@selector(otherMiddleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_middleBtnArr addObject:cell.driverMiddleFirstBtn];
            
            cell.driverMiddleSecondBtn.tag=2;
            [cell.driverMiddleSecondBtn addTarget:self action:@selector(otherMiddleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_middleBtnArr addObject:cell.driverMiddleSecondBtn];
            
            cell.driverMiddleThirdBtn.tag=3;
            [cell.driverMiddleThirdBtn addTarget:self action:@selector(otherMiddleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_middleBtnArr addObject:cell.driverMiddleThirdBtn];
            
            if (isFirst==YES) {
                isFirst=NO;
                [self mainMiddleClick:cell.driverMiddleTitleBtn];
            }
            break;
            
        default:
            
            cell.driverOtherTitleLab.text=[infoArr objectAtIndex:indexPath.row];
            
            cell.driverTopView.hidden=YES;
            cell.driverMiddleView.hidden=YES;
            cell.driverOtherView.hidden=NO;
            
            if (indexPath.section>_mainInfoArr.count-2) {
                cell.driverOtherProfileImg.hidden=YES;
                cell.driverOtherContentLab.hidden=NO;
                
//                NSLog(@"哈哈：%d",indexPath.section);
                
                cell.addImgBtn.hidden=YES;
                
                if (isDriver==NO) {
                    if (indexPath.row==1) {
                        cell.driverOtherTitleLab.text=@"公司";
                    }
                }
                
                cell.getInformField.hidden=NO;
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
//                NSLog(@"123123");
                cell.addImgBtn.hidden=NO;
                
                cell.driverOtherProfileImg.hidden=NO;
                cell.driverOtherContentLab.hidden=YES;
                
                cell.getInformField.hidden=YES;
                
                switch (indexPath.section) {
                    case 2:
                        cell.addImgBtn.tag=1;
                        _tImg=cell.driverOtherProfileImg;
                        break;
                        
                    default:
                        cell.addImgBtn.tag=2;
                        _tImg2=cell.driverOtherProfileImg;
                        break;
                }
                
                [cell.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            break;
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self submitBtnAutoSize];
    if (indexPath.section>1) {
        return 30;
    }
    return 180;
}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.000001f;
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

#pragma mark - textField
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    for (id chooseField in _uploadFieldArr) {
        if ([chooseField isKindOfClass:[UITextField class]]) {
            UITextField *tField=chooseField;
            if (tField.text.length==0) {
                self.submitBtn.enabled=NO;return;
            }
        }else{
            self.submitBtn.enabled=NO;return;
        }
    }
    
    if (isDriver==NO) {
        if (_imgDic.count<2) {
            self.submitBtn.enabled=NO;
            return;
        }
    }else{
        if (_imgDic.count<1) {
            self.submitBtn.enabled=NO;
            return;
        }
    }
    
    
    self.submitBtn.enabled=YES;
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
//            [self.navigationController pushViewController:pickerImage animated:YES];
            [self presentViewController:pickerImage animated:YES completion:nil];
            [pickerImage release];
            break;
            
        default:
            
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
                if ([chooseField isKindOfClass:[UITextField class]]) {
                    UITextField *tField=chooseField;
                    if (tField.text.length==0) {
                        self.submitBtn.enabled=NO;return;
                    }
                }else{
                    self.submitBtn.enabled=NO;return;
                }
            }
            
            if (_imgDic.count<2) {
                self.submitBtn.enabled=NO;return;
            }
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(loginObject.url);
        }
    }failed:^(NSError *error){
//        NSLog(@"错误：%@",error);
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - 主要点击勾选
-(void)mainClick:(id)sender
{
    WARNING__ALERT(@"此项为必选")
//    UIButton *clickBtn=(UIButton *)sender;
//    
//    if (isMainAllow==YES) {
//        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
//        
//        for (UIButton *chooseBtn in _topBtnArr) {
//            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
//        }
//        
//        for (int i=0; i<_topArr.count; i++) {
//            [_topArr replaceObjectAtIndex:i withObject:@"0"];
//        }
//        
//        isMainAllow=NO;
//    }else{
//        for (UIButton *chooseBtn in _topBtnArr) {
//            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
//        }
//        
//        for (int i=0; i<_topArr.count; i++) {
//            [_topArr replaceObjectAtIndex:i withObject:@"1"];
//        }
//        
//        
//        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
//        
//        isMainAllow=YES;
//    }
}

-(void)mainMiddleClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if (isOthderAllow==YES) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        
        for (UIButton *chooseBtn in _middleBtnArr) {
            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        }
        
        for (int i=0; i<_middleArr.count; i++) {
            [_middleArr replaceObjectAtIndex:i withObject:@"0"];
        }
        
        isOthderAllow=NO;
    }else{
        for (UIButton *chooseBtn in _middleBtnArr) {
            [chooseBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        }
        
        for (int i=0; i<_middleArr.count; i++) {
            [_middleArr replaceObjectAtIndex:i withObject:@"1"];
        }
        
        
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        
        isOthderAllow=YES;
    }
}
#pragma mark - 其他点击勾选
-(void)otherBtnClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if ([[_topArr objectAtIndex:clickBtn.tag-1] isEqualToString:@"1"]) {
        
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        [_topArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"0"];
        
        int i=0;
        for (NSString *chooseStr in _topArr) {
            i+=1;
            if ([chooseStr isEqualToString:@"1"]) {
                break;
            }
            if (i==_topArr.count) {
                WARNING__ALERT(@"此项至少选择一项")
                [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
                [_topArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"1"];
            }
        }
        
    }else{
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        [_topArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"1"];
        
        [_tempTopBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        isMainAllow=YES;
    }
}

-(void)otherMiddleBtnClick:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    
    if ([[_middleArr objectAtIndex:clickBtn.tag-1] isEqualToString:@"1"]) {
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
        [_middleArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"0"];
        
        int i=0;
        for (NSString *chooseStr in _middleArr) {
            i+=1;
            if ([chooseStr isEqualToString:@"1"]) {
                break;
            }
            
            if (i==_middleArr.count) {
                [_tempMiddleBtn setImage:[UIImage imageNamed:@"chooseTab1.png"] forState:UIControlStateNormal];
                isOthderAllow=NO;
            }
            
        }
    }else{
        [clickBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        [_middleArr replaceObjectAtIndex:clickBtn.tag-1 withObject:@"1"];
        
        [_tempMiddleBtn setImage:[UIImage imageNamed:@"chooseTab2.png"] forState:UIControlStateNormal];
        isOthderAllow=YES;
    }
}
#pragma mark -选择驾车
- (IBAction)choosePersonalCar:(id)sender {
    [self.carBtn setBackgroundImage:[UIImage imageNamed:@"carBtn.png"] forState:UIControlStateNormal];
    [self.carBtn setTitle:@"" forState:UIControlStateNormal];
    [self.publicCarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.publicCarBtn setTitle:@"的士" forState:UIControlStateNormal];
    [self.publicCarBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn.png"] forState:UIControlStateNormal];
    
//    carBtn2.png
    isFirst=YES;
    
    [_mainInfoArr release];
    _mainInfoArr=nil;
    NSDictionary *_mainDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"DriverRabbit"]];
    _mainInfoArr=[[NSMutableArray alloc] initWithArray:[_mainDic objectForKey:@"infor"]];
    [self.detailTableView reloadData];
    
    self.detailTableView.contentOffset=CGPointMake(0.0, 0.0);
    
    isMainAllow=YES;
    isOthderAllow=YES;
    
    isDriver=YES;
    
    [self reloadInform];
    
//    [self mainMiddleClick:nil];
}

#pragma mark -选择的士
- (IBAction)chooserPublicCar:(id)sender {
    [self.publicCarBtn setBackgroundImage:[UIImage imageNamed:@"carBtn2.png"] forState:UIControlStateNormal];
    [self.publicCarBtn setTitle:@"" forState:UIControlStateNormal];
    [self.carBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.carBtn setTitle:@"车辆" forState:UIControlStateNormal];
    [self.carBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn.png"] forState:UIControlStateNormal];
    
    isFirst=YES;
    
    [_mainInfoArr release];
    _mainInfoArr=nil;
    NSDictionary *_mainDic=[[NSDictionary alloc] initWithDictionary:[PSSFileOperations getMainBundlePlist:@"DriverRabbitPublic"]];
    _mainInfoArr=[[NSMutableArray alloc] initWithArray:[_mainDic objectForKey:@"infor"]];
    [self.detailTableView reloadData];
    
    self.detailTableView.contentOffset=CGPointMake(0.0, 0.0);
    
    isMainAllow=YES;
    isOthderAllow=YES;
    
    isDriver=NO;
    
    [self reloadInform];
    
//    [self mainMiddleClick:nil];
}

#pragma mark -自动调整submitBtn的frame
-(void)submitBtnAutoSize
{
    self.detailTableView.contentSize=CGSizeMake(300, 650);
    CGRect tabRect=self.submitBtn.frame;
    tabRect.origin.y=600;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        tabRect.origin.x=0;
    }else{
        tabRect.origin.x=10;
    }
    
    self.submitBtn.frame=tabRect;
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    //定义Cates
    NSMutableArray *getCatesArr=[[NSMutableArray alloc] init];
    int i=0;
    for (NSString *catesStr in _topArr) {
        switch (i) {
            case 0:
                if ([catesStr intValue]==1) {
                    [getCatesArr addObject:@"140"];
                }
                break;
                
            case 1:
                if ([catesStr intValue]==1) {
                    [getCatesArr addObject:@"141"];
                }
                break;
                
            case 2:
                if ([catesStr intValue]==1) {
                    [getCatesArr addObject:@"142"];
                }
                break;
                
            case 3:
                if ([catesStr intValue]==1) {
                    [getCatesArr addObject:@"143"];
                }
                break;
                
            default:
                break;
        }
        i+=1;
    }
    i=0;
    for (NSString *catesStrs in _middleArr) {
        switch (i) {
            case 0:
                if ([catesStrs intValue]==1) {
                    [getCatesArr addObject:@"110,111,112,113,114"];
                }
                break;
                
            case 1:
                if ([catesStrs intValue]==1) {
                    [getCatesArr addObject:@"120,121,122,123"];
                }
                break;
                
            case 2:
                if ([catesStrs intValue]==1) {
                    [getCatesArr addObject:@"130,131,132"];
                }
                break;
                
            default:
                break;
        }
        i+=1;
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
    //根据类型重组发送数据类型
    if (isDriver==YES) {
        [uploadDic setObject:[_imgDic objectForKey:@"firstImg"] forKey:@"driver_cert"];
//        [uploadDic setObject:[_imgDic objectForKey:@"secondImg"] forKey:@"driving_cert"];
        [uploadDic setObject:_uploadText1.text forKey:@"car_type"];
        [uploadDic setObject:_uploadText2.text forKey:@"car_color"];
        [uploadDic setObject:_uploadText3.text forKey:@"plate_number"];
        [uploadDic setObject:_uploadText4.text forKey:@"experience"];
        [uploadDic setObject:@"1" forKey:@"car_style"];
    }else{
        [uploadDic setObject:[_imgDic objectForKey:@"firstImg"] forKey:@"driver_cert"];
        [uploadDic setObject:[_imgDic objectForKey:@"secondImg"] forKey:@"driving_cert"];
        [uploadDic setObject:_uploadText1.text forKey:@"car_type"];
        [uploadDic setObject:_uploadText2.text forKey:@"company"];
        [uploadDic setObject:_uploadText3.text forKey:@"plate_number"];
        [uploadDic setObject:_uploadText4.text forKey:@"experience"];
        [uploadDic setObject:@"2" forKey:@"car_style"];
    }
    
    [_submitRabbit submitType:[registInfo objectForKey:@"usercode"] userkey:[registInfo objectForKey:@"userkey"] type:@"2" level:@"1" cates:submitString otherDic:uploadDic success:^(id responseData){
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_detailTableView release];
    [_submitBtn release];
    [_carBtn release];
    [_publicCarBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDetailTableView:nil];
    [self setSubmitBtn:nil];
    [self setCarBtn:nil];
    [self setPublicCarBtn:nil];
    [super viewDidUnload];
}
@end
