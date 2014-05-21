//
//  RegistrationCertificateViewController.m
//  rabbitSister
//
//  Created by Jahnny on 14-3-4.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import "RegistrationCertificateViewController.h"
#import "DriverRabbitCell.h"
#import "SetCateInfo.h"

#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "HelperRabbitDetailCell.h"

@interface RegistrationCertificateViewController ()
{
    SDWebImageManager *manager;
}
@end

@implementation RegistrationCertificateViewController
static bool AllowEdit=NO;
static bool isInTextViewEdit=NO;

static int  chooseImgLocal=1;       //选择图片定位

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithArray:(NSMutableArray *)getArray allInfo:(NSDictionary *)allInfo isAllowEdit:(BOOL)isAllowEdit
{
    self=[super init];
    
    if (self) {
        AllowEdit=isAllowEdit;
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:getArray];
//        NSLog(@"呵呵：%@",_mainInfoArr);
        _typeOneArr=[[NSMutableArray alloc] init];
        _typeTwoArr=[[NSMutableArray alloc] init];
        
        _allInfo=[[NSMutableDictionary alloc] initWithDictionary:allInfo];
        
//        NSLog(@"哈哈：%@",_allInfo);
        
        for (NSDictionary *dic in _mainInfoArr) {
            if ([[dic objectForKey:@"type"] intValue]==1) {
                [_typeOneArr addObject:dic];
            }else{
                [_typeTwoArr addObject:dic];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"注册资质";
    NAVIGATION_BACK(@"   返回");
    
    self.mainListTable.dataSource=self;
    self.mainListTable.delegate=self;
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _typeOneArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==_typeOneArr.count) {
        return _typeTwoArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RegistViewCell *cell = (RegistViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"RegistViewCell" owner:self options:nil] lastObject];
    
    if ([[_allInfo objectForKey:@"tuzi_type"] intValue]==3) {
        HelperRabbitDetailCell *cell = (HelperRabbitDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"HelperRabbitDetailCell" owner:self options:nil] lastObject];
        
        cell.selectionStyle = UITableViewScrollPositionNone;
        UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.chooseView.hidden=YES;
        cell.titleView.hidden=NO;
        
        if (AllowEdit==YES) {
            cell.mustImg.hidden=NO;
        }else{
            cell.mustImg.hidden=YES;
        }
        
        if (indexPath.section==_typeOneArr.count) {
            cell.chooseTitleLab.text=[[_typeTwoArr objectAtIndex:indexPath.row] objectForKey:@"cert_info"];
            cell.uploadImg.hidden=YES;
            cell.writeInTextView.hidden=NO;
            
            cell.writeInTextView.delegate=self;
            cell.writeInTextView.text=[[_typeTwoArr objectAtIndex:indexPath.row] objectForKey:@"content"];
            
            _cellBackgroundImage=cell.bgImg;
            if (cell.writeInTextView.text.length>0) {
                isInTextViewEdit=YES;
                //    [self.mainListTable reloadData];
                CGRect bgRect=_cellBackgroundImage.frame;
                bgRect.size.height=90;
                _cellBackgroundImage.frame=bgRect;
            }
            
            [cell.writeInTextView addPreviousNextDoneOnKeyboardWithTarget:self
                                                           previousAction:nil
                                                               nextAction:nil
                                                               doneAction:@selector(doneClicked:)];
            [cell.writeInTextView setEnablePrevious:NO next:YES];
        }else{
            cell.chooseTitleLab.text=[[_typeOneArr objectAtIndex:indexPath.section] objectForKey:@"cert_info"];
            if (AllowEdit==YES) {
                cell.addImgBtn.hidden=NO;
            }else{
                cell.addImgBtn.hidden=YES;
            }
            
            [manager downloadWithURL:[[_typeOneArr objectAtIndex:indexPath.section] objectForKey:@"content"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                cell.uploadImg.image=image;
            }];
            
            cell.addImgBtn.tag=indexPath.section;
            [cell.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }else{
        DriverRabbitCell *cell = (DriverRabbitCell *)[[[NSBundle mainBundle] loadNibNamed:@"DriverRabbitCell" owner:self options:nil] lastObject];
        cell.driverTopView.hidden=YES;
        cell.driverMiddleView.hidden=YES;
        cell.driverOtherView.hidden=NO;
        //    cell.getInformField.hidden=NO;
        
        
        cell.selectionStyle = UITableViewScrollPositionNone;
        UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
        
        
        if (AllowEdit==YES) {
            cell.mustImg.hidden=NO;
            cell.tileLabel.hidden=YES;
            cell.getInformField.hidden=NO;
            cell.addImgBtn.hidden=YES;
        }else{
            cell.mustImg.hidden=YES;
            cell.tileLabel.hidden=NO;
            cell.getInformField.hidden=YES;
        }
        
        if (indexPath.section==_typeOneArr.count) {
            cell.addImgBtn.hidden=YES;
            cell.driverOtherTitleLab.text=[[_typeTwoArr objectAtIndex:indexPath.row] objectForKey:@"cert_info"];
            cell.driverOtherProfileImg.hidden=YES;
            //        NSLog(@"呵呵：%@",_typeTwoArr);
            cell.tileLabel.text=[[_typeTwoArr objectAtIndex:indexPath.row] objectForKey:@"content"];
            cell.getInformField.text=[[_typeTwoArr objectAtIndex:indexPath.row] objectForKey:@"content"];
            
//            if (cell.getInformField.text.length>0) {
//                isInTextViewEdit=YES;
//                //    [self.mainListTable reloadData];
//                CGRect bgRect=_cellBackgroundImage.frame;
//                bgRect.size.height=90;
//                _cellBackgroundImage.frame=bgRect;
//            }
            
            
            cell.getInformField.tag=indexPath.row;
            cell.getInformField.delegate=self;
            [cell.getInformField addPreviousNextDoneOnKeyboardWithTarget:self
                                                          previousAction:nil
                                                              nextAction:nil
                                                              doneAction:@selector(doneClicked:)];
            [cell.getInformField setEnablePrevious:NO next:YES];
        }else{
            if (AllowEdit==YES) {
                cell.addImgBtn.hidden=NO;
            }else{
                cell.addImgBtn.hidden=YES;
            }
            
            cell.tileLabel.hidden=YES;
            cell.getInformField.hidden=YES;
            cell.driverOtherTitleLab.text=[[_typeOneArr objectAtIndex:indexPath.section] objectForKey:@"cert_info"];
            
            cell.driverOtherProfileImg.hidden=NO;
            [manager downloadWithURL:[[_typeOneArr objectAtIndex:indexPath.section] objectForKey:@"content"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                cell.driverOtherProfileImg.image=image;
            }];
            
            
            cell.addImgBtn.tag=indexPath.section;
            [cell.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_allInfo objectForKey:@"tuzi_type"] intValue]==3&&indexPath.section==_typeOneArr.count) {
        return 90;
    }
    return 30;
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

#pragma mark - textField
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableDictionary *dic=[_typeTwoArr objectAtIndex:textField.tag];
    [dic setObject:textField.text forKey:@"content"];
    [_typeTwoArr replaceObjectAtIndex:textField.tag withObject:dic];
    
    SHOW__LOADING
    SetCateInfo *setCate=[[SetCateInfo alloc] init];
    [setCate setCate:@{[dic objectForKey:@"cert_name"]:[dic objectForKey:@"content"]} success:^(id responseData) {
//        NSLog(@"错误：%@",responseData);
        NSMutableArray *tArr=[[NSMutableArray alloc] initWithArray:_typeOneArr];
        for (NSDictionary *dic in _typeTwoArr) {
            [tArr addObject:dic];
        }
        
        [_allInfo setObject:tArr forKey:@"certs"];
        
        HIDE__LOADING
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        [writeOperation writeToPlist:WRITELOGIN plistContent:_allInfo];
        
        
        [_mainInfoArr release];
        _mainInfoArr=nil;
        _mainInfoArr=[[NSMutableArray alloc] initWithArray:tArr];
        WARNING__ALERT(@"修改成功");
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"请检查网络连接");
        return;
    }];
    
    
//    NSLog(@"哈哈：%@",_allInfo);
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
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[_typeOneArr objectAtIndex:chooseImgLocal]];
            [dic setObject:[NSString stringWithFormat:@"http://img.tojie.com%@",loginObject.url] forKey:@"content"];
            [_typeOneArr replaceObjectAtIndex:chooseImgLocal withObject:dic];
//            NSLog(@"嘻嘻：%@",dic);
            
            SetCateInfo *setCate=[[SetCateInfo alloc] init];
            [setCate setCate:@{[dic objectForKey:@"cert_name"]:[dic objectForKey:@"content"]} success:^(id responseData) {
                //        NSLog(@"错误：%@",responseData);
                NSMutableArray *tArr=[[NSMutableArray alloc] initWithArray:_typeTwoArr];
                for (NSDictionary *dic in _typeOneArr) {
                    [tArr addObject:dic];
                }
                
//                NSLog(@"呵呵：%@",tArr);
                
                [_allInfo setObject:tArr forKey:@"certs"];
                
                HIDE__LOADING
                PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
                [writeOperation writeToPlist:WRITELOGIN plistContent:_allInfo];
                
                
                [_mainInfoArr release];
                _mainInfoArr=nil;
                _mainInfoArr=[[NSMutableArray alloc] initWithArray:tArr];
                WARNING__ALERT(@"修改成功");
                
                [self.mainListTable reloadData];
            } failed:^(NSError *error) {
                HIDE__LOADING
                WARNING__ALERT(@"请检查网络连接");
                return;
            }];
//            HIDE__LOADING;
//            WARNING__ALERT(@"上传成功");
            
            
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(loginObject.url);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    isInTextViewEdit=YES;
//    [self.mainListTable reloadData];
    CGRect bgRect=_cellBackgroundImage.frame;
    bgRect.size.height=90;
    _cellBackgroundImage.frame=bgRect;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
     NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[_typeTwoArr objectAtIndex:0]];
    [dic setObject:textView.text forKey:@"content"];
//    NSLog(@"呵呵：%@",dic);
//    NSLog(@"哈哈：%@",_typeTwoArr);
    SHOW__LOADING
    SetCateInfo *setCate=[[SetCateInfo alloc] init];
    [setCate setCate:@{[dic objectForKey:@"cert_name"]:[dic objectForKey:@"content"]} success:^(id responseData) {
        HIDE__LOADING
        if ([[responseData objectForKey:@"error"] intValue]==0) {
            [_typeTwoArr replaceObjectAtIndex:0 withObject:dic];
            NSMutableArray *tArr=[[NSMutableArray alloc] initWithArray:_typeOneArr];
            for (NSDictionary *dics in _typeTwoArr) {
                [tArr addObject:dics];
            }
            
            NSLog(@"哈哈：%@",dic);
            
            NSLog(@"呵呵：%@",_typeTwoArr);
            
            [_allInfo setObject:tArr forKey:@"certs"];
            NSLog(@"嘻嘻：%@",_allInfo);
            PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
            [writeOperation writeToPlist:WRITELOGIN plistContent:_allInfo];
            
            
            [_mainInfoArr release];
            _mainInfoArr=nil;
            _mainInfoArr=[[NSMutableArray alloc] initWithArray:tArr];
            WARNING__ALERT(@"修改成功");
        }else{
            WARNING__ALERT([responseData objectForKey:@"res"]);
        }
    } failed:^(NSError *error) {
        HIDE__LOADING
        WARNING__ALERT(@"请检查网络连接");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [super viewDidUnload];
}
@end
