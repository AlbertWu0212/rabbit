//
//  ChatViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-22.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "ChatViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "AnimationEffects.h"

#import "UploadNetWork.h"
#import "UploadInfo.h"

#import "SoundPlayer.h"

@interface ChatViewController () <RecordingDelegate, PlayingDelegate>
{
    NSMutableArray *_bubbleData;
    
    SDWebImageManager *manager;
    
    SoundPlayer *_soundPlayer;
}
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *filename;

@end

@implementation ChatViewController
static bool isSound=YES;
static int btnTag=0;
static int imgBtnTag=0;

static bool isLoading=NO;

//static int isInSpeaking=notInSpeak;

static int page=1;          //读取历史记录

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imgBtnTag=0;
        btnTag=0;
        [_bubbleData removeAllObjects];
        _bubbleData = [NSMutableArray new];
        _xmppManager = [XMPPManager sharedManager];
        self.voiceUrlArr=[[NSMutableArray alloc] init];
        self.imgUrlArr=[[NSMutableArray alloc] init];
        [_xmppManager.chatDelegates addObject:self];
        
        //聊天记录
        self.speakArr=[[NSMutableArray alloc] init];
        
        //配置本地头像
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
        //        self.accountImg=[NSString stringWithFormat:@"http://img.tojie.com%@",[registInfo objectForKey:@"image"]];
        self.accountImg=[NSString stringWithFormat:@"%@",[registInfo objectForKey:@"image"]];
        
        [self release];
        
        Notification__CREATE(NotificationRefresh,GETHISTORYSPEAK);
        Notification__CREATE(NotificationOverRefresh,OVERGETSPEAK);
    }
    return self;
}

-(void)refresh
{
//    NSLog(@"123");
    [self speakingCacheOpen];
    
    rs=[db executeQuery:[NSString stringWithFormat:@"select * from UsersCache where usercode='%@@task.tojie.com' and BNumber=%@ ORDER BY id ASC",self.currentJIDComunicateWith,self.BNumber]];
    
    APPDELEGATEING
    [delegates.speakerTimeArr removeAllObjects];
    
    while ([rs next]) {
        [delegates.speakerTimeArr addObject:[rs stringForColumn:@"time"]];
        NSBubbleData *data;
        int bubbType;
        if ([[rs stringForColumn:@"respondType"] intValue]==0) {
            bubbType=BubbleTypeMine;
        }else{
            bubbType=BubbleTypeSomeoneElse;
        }
        
        NSURL *imgIcon;
        UIButton *sonundBtn;
        switch ([[rs stringForColumn:@"type"] intValue]) {
            case speakMessageType:
                data = [NSBubbleData dataWithText:[rs stringForColumn:@"Message"] date:[NSDate date] type:bubbType];
                //设置头像
                if (bubbType==BubbleTypeSomeoneElse) {
                    imgIcon=[NSURL URLWithString:self.customerImg];
                }else{
                    imgIcon=[NSURL URLWithString:self.accountImg];
                }
                
                
                [manager downloadWithURL:imgIcon options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                    
                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                    data.avatar=image;
//                    NSLog(@"下载图片");
                    [_bubbleTableView reloadData];
                }];
                
                
                [_bubbleData addObject:data];
                //[data release];
                
                [_bubbleTableView reloadData];
                
                [self scrollTableViewToButtom:_bubbleTableView];
                
                
                
                break;
                
            case speakVoiceType:
                sonundBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                sonundBtn.frame=CGRectMake(0, 0, 56, 26);
                if (bubbType==BubbleTypeMine) {
                    [sonundBtn setImage:[UIImage imageNamed:@"talkBackOwner.png"] forState:UIControlStateNormal];
                }else{
                    [sonundBtn setImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
                }
                
                [sonundBtn addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
                sonundBtn.tag=btnTag;
                btnTag+=1;
                data = [NSBubbleData dataWithView:sonundBtn date:[NSDate date] type:bubbType insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
                
                [self getVoice:[rs stringForColumn:@"Message"]];
                //设置头像
                if (bubbType==BubbleTypeSomeoneElse) {
                    imgIcon=[NSURL URLWithString:self.customerImg];
                }else{
                    imgIcon=[NSURL URLWithString:self.accountImg];
                }
                [manager downloadWithURL:imgIcon options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                    
                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                    data.avatar=image;
                    [_bubbleTableView reloadData];
                }];
                
                [_bubbleData addObject:data];
                //[data release];
                
                [_bubbleTableView reloadData];
                
                [self scrollTableViewToButtom:_bubbleTableView];
                
                break;
                
            case speakImgType:
                self.imgUrl=[rs stringForColumn:@"Message"];
                
                UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                imageBtn.frame=CGRectMake(0, 0, 56, 56);
                UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]];
                
                
                
                [imageBtn setImage:image forState:UIControlStateNormal];
                if (image!=nil) {
                    [self.imgUrlArr addObject:image];
                }
                
                
                
                imageBtn.tag=imgBtnTag;
                [imageBtn addTarget:self action:@selector(bigImg:) forControlEvents:UIControlEventTouchUpInside];
                
                NSBubbleData *data = [NSBubbleData dataWithView:imageBtn date:[NSDate date] type:bubbType insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
                imgBtnTag+=1;
                
                
                //设置头像
                if (bubbType==BubbleTypeSomeoneElse) {
                    [manager downloadWithURL:[NSURL URLWithString:self.customerImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                        
                    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                        data.avatar=image;
                    }];
                }else{
                    [manager downloadWithURL:[NSURL URLWithString:self.accountImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                        
                    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                        data.avatar=image;
                        [_bubbleTableView reloadData];
                    }];
                }
                [_bubbleData addObject:data];
                
                [self.bubbleTableView reloadData];
                [self scrollTableViewToButtom:_bubbleTableView];
                [self.mainTextField resignFirstResponder];
                
//                [manager downloadWithURL:[NSURL URLWithString:self.imgUrl] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
//                    
//                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
//                    UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//                    imageBtn.frame=CGRectMake(0, 0, 56, 56);
//                    [imageBtn setImage:image forState:UIControlStateNormal];
//                    [self.imgUrlArr addObject:image];
//                    imageBtn.tag=imgBtnTag;
//                    [imageBtn addTarget:self action:@selector(bigImg:) forControlEvents:UIControlEventTouchUpInside];
//                    NSBubbleData *data = [NSBubbleData dataWithView:imageBtn date:[NSDate date] type:bubbType insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
//                    imgBtnTag+=1;
//                    
//                    
//                    //设置头像
//                    if (bubbType==BubbleTypeSomeoneElse) {
//                        [manager downloadWithURL:[NSURL URLWithString:self.customerImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
//                            
//                        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
//                            data.avatar=image;
//                        }];
//                    }else{
//                        [manager downloadWithURL:[NSURL URLWithString:self.accountImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
//                            
//                        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
//                            data.avatar=image;
//                        }];
//                    }
//                    
//                    
//                    //                NSBubbleData *data=[NSBubbleData dataWithImage:image date:[NSDate date] type:BubbleTypeSomeoneElse];
//                    
//                    [_bubbleData addObject:data];
//                    
//                    [self.bubbleTableView reloadData];
//                    [self scrollTableViewToButtom:_bubbleTableView];
//                    [self.mainTextField resignFirstResponder];
//                    
//                }];
                break;
                
                
            default:
                break;
        }
    }
//    NSLog(@"呵呵：%d",_bubbleData.count);
//    [self.bubbleTableView reloadData];
//    [self scrollTableViewToButtom:_bubbleTableView];
//    [self.mainTextField resignFirstResponder];
    
    self.mainTextField.text=@"";
    
    [self speakingCacheClose];
    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = CGRectMake(0, 200, _mainDownView.frame.size.width, _mainDownView.frame.size.height);
        
        //        _mainDownView.frame = frame;
        
        frame = CGRectMake(0, 0, _bubbleTableView.frame.size.width, self.view.frame.size.height - _mainDownView.frame.size.height);
        
        _bubbleTableView.frame = frame;
        
        _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
    }];
}
#pragma mark - 监听事件(刷新)
- (void)NotificationRefresh:(NSNotification *) notification
{
    return;
    if (isLoading==NO) {
        isLoading=YES;
    }else{
        return;
    }
    
}

- (void)NotificationOverRefresh:(NSNotification *) notification
{
    isLoading=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    NAVIGATION_BACK(@"   返回");
    
    _soundPlayer=[[SoundPlayer alloc] init];
    //尝试新方法
    _bubbleTableView.snapInterval = 1800;
    _bubbleTableView.showAvatars = YES;
    // Keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.bubbleTableView addGestureRecognizer:tap];
    [tap release];
    
    /***************SDWebImage***************/
    manager=[SDWebImageManager sharedManager];
    /***************SDWebImage***************/
    
    //本地测试
//    self.currentJIDComunicateWith=@"200000001";
//    self.currentJIDComunicateWith=@"500000001";
    
    //用户缓存文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *customDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Chat/%@",self.currentJIDComunicateWith]];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:customDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:customDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    [self refresh];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@",self.enuserName];
    
    // Do any additional setup after loading the view from its nib.
}

//BACK_ACTION
-(void)backAction{
    self.isPlaying = NO;
    [[PlayerManager sharedManager] stopPlaying];
    [self.navigationController popViewControllerAnimated:YES];
    Notification__POST(HIDENAV, nil);
//    self.navigationController.navigationBar.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)voiceBegin:(id)sender {
    if (self.isPlaying) {
        WARNING__ALERT(@"正在播放声音");
        return;
    }
//    NSLog(@"123");
    self.isRecording = YES;
    [RecorderManager sharedManager].delegate = self;
    [[RecorderManager sharedManager] startRecording];
}
- (IBAction)voiceEnd:(id)sender {
//    NSLog(@"456");
    if (self.isPlaying) {
        WARNING__ALERT(@"正在播放声音");
        return;
    }
    
    self.isRecording = NO;
    [[RecorderManager sharedManager] stopRecording];
}

#pragma mark - 按住说话
- (IBAction)clickBtn:(id)sender {
    self.voiceLab.text=@"点击   发送";
    if ( ! self.isRecording) {
        self.isRecording = YES;
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecording];
    }
    else {
        self.isRecording = NO;
        [[RecorderManager sharedManager] stopRecording];
    }
}

#pragma mark - 播放声音
-(void)playSound:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
//    NSLog(@"地址是：%@",self.voiceUrlArr);
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        
        self.isPlaying = YES;
        //        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
        [[PlayerManager sharedManager] playAudioWithFileName:[self.voiceUrlArr objectAtIndex:clickBtn.tag] delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}

- (IBAction)record:(id)sender {
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        
        self.isPlaying = YES;
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}

#pragma mark - Recording & Playing Delegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    self.filename = filePath;
    self.voiceUrl=@"";
    
    SHOW__LOADING
    
    NSData *voiceData=[NSData dataWithContentsOfFile:self.filename];
    NSString *voicePath=[NSString stringWithFormat:@"%@/%@.spx",[self nowCustomerPath],[self nowTimeCode]];
    //添加声音数组
    [self.voiceUrlArr addObject:[NSString stringWithFormat:@"%@/%@.spx",[self nowCustomerPath],[self nowTimeCode]]];
    //    [self.voiceUrlArr addObject:@"123"];
    
    //将声音存入本地缓存文件夹
    [self speakingCacheOpen];
    [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@@task.tojie.com','%d','%@','%@','%@',0)",self.currentJIDComunicateWith,speakVoiceType,voicePath,[self getNowTime],self.BNumber]];
    [self speakingCacheClose];
    //将声音缓存入本地
    if (voiceData != nil){
        if ([voiceData writeToFile:[NSString stringWithFormat:@"%@/%@.spx",[self nowCustomerPath],[self nowTimeCode]] atomically:YES]) {
        }
        else
        {
            WARNING__ALERT(@"保存声音失败，请检查您的硬盘容量");
        }
    } else {
        WARNING__ALERT(@"声音存储失败");
    }
    
    UploadNetWork *uploadNet=[[UploadNetWork alloc] init];
    [uploadNet upload:@"5" data:filePath success:^(id responseData){
        UploadInfo *loginObject=[[UploadInfo alloc]initWithStatus:responseData];
        
        if (loginObject.success==YES) {
            self.voiceUrl=loginObject.url;
            
            UIButton *sonundBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            sonundBtn.frame=CGRectMake(0, 0, 56, 26);
            [sonundBtn setImage:[UIImage imageNamed:@"talkBackOwner.png"] forState:UIControlStateNormal];
            sonundBtn.tag=btnTag;
            [sonundBtn addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
            NSBubbleData *data = [NSBubbleData dataWithView:sonundBtn date:[NSDate date] type:BubbleTypeMine insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
            btnTag+=1;
            //设置头像
            [manager downloadWithURL:[NSURL URLWithString:self.accountImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                data.avatar=image;
            }];
            
            [_bubbleData addObject:data];
            
            [self sendMessage:@"" type:@"chat"];
            [self.bubbleTableView reloadData];
            [self scrollTableViewToButtom:_bubbleTableView];
            [self.mainTextField resignFirstResponder];
            
            self.mainTextField.text=@"";
            HIDE__LOADING;
            
            self.voiceLab.text=@"点击   说话";
        }else{
            
            HIDE__LOADING;
            WARNING__ALERT(loginObject.url);
        }
    }failed:^(NSError *error){
        HIDE__LOADING;
        WARNING__ALERT(@"上传失败，请您检查网络连接是否通常");
    }];
}

- (void)recordingTimeout {
//    self.isRecording = NO;
    self.isRecording = NO;
    [[RecorderManager sharedManager] stopRecording];
    WARNING__ALERT(@"录音超过2分钟，自动上传");
    NSLog(@"录音超时");
}

- (void)recordingStopped {
    self.isRecording = NO;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    NSLog(@"录音失败");
}

- (void)levelMeterChanged:(float)levelMeter {
    
}

- (void)playingStoped {
    self.isPlaying = NO;
    NSLog(@"播放完成");
}

#pragma mark - 选择键盘/声音
- (IBAction)changeChoose:(id)sender {
    if (isSound==YES) {
        
        [self.soundKeywordBtn setImage:[UIImage imageNamed:@"speak.png"] forState:UIControlStateNormal];
        self.soundView.hidden=YES;
        self.textView.hidden=NO;
        isSound=NO;
    }else{
        [self.view endEditing:YES];
        [self.soundKeywordBtn setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        self.soundView.hidden=NO;
        self.textView.hidden=YES;
        isSound=YES;
    }
}

#pragma mark - textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSLog(@"789");
    CGRect textRect;
    textRect=self.mainDownView.frame;
    textRect.origin.y-=218;
    [AnimationEffects MainAnimation:self.mainDownView Animations:moving endEffectMoving:textRect endEffectAlpha:1 time:0.4 overFunction:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"哈哈哈");
    CGRect textRect;
    textRect=self.mainDownView.frame;
    textRect.origin.y+=218;
    [AnimationEffects MainAnimation:self.mainDownView Animations:moving endEffectMoving:textRect endEffectAlpha:1 time:0.3 overFunction:nil];
}

//#pragma mark - 判断输入
//-(BOOL)isValidateMessage:(NSString *)phone {  //正则验证
//    NSString *phoneRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]+";
//    
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    return [phoneTest evaluateWithObject:phone];
//}

#pragma mark - 发送数据
- (IBAction)send:(id)sender {
    if ([self.mainTextField.text isEqualToString:@""]) {
        return;
    }
    
    if ([self dealToCharacter:self.mainTextField.text]==YES) {
        NSLog(@"成功");
    }else{
        WARNING__ALERT(@"聊天内容不能输入特殊字符");
        return;
    }
    
    NSBubbleData *data = [NSBubbleData dataWithText:self.mainTextField.text date:[NSDate date] type:BubbleTypeMine];
    
    //设置头像
    [manager downloadWithURL:[NSURL URLWithString:self.accountImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
        
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
        data.avatar=image;
        _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
//        NSLog(@"下载到图片");
        [_bubbleTableView reloadData];
        [self scrollTableViewToButtom:_bubbleTableView];
    }];
    [_bubbleData addObject:data];
    
    [self sendMessage:self.mainTextField.text type:@"chat"];
    
    [self.mainTextField resignFirstResponder];
    
    [_bubbleTableView reloadData];
    [self scrollTableViewToButtom:_bubbleTableView];
    
    self.mainTextField.text=@"";
    
    
    _bubbleTableView.showsVerticalScrollIndicator=YES;
    
    
    if ([_bubbleData count]>5) {
        _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
    }else{
        _bubbleTableView.contentOffset=CGPointMake(0, 0);
    }
    
    
//    _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
    
//    NSLog(@"草：%d",52*[_bubbleData count]+28*[_bubbleData count]);
//    NSLog(@"日：%d",[_bubbleData count]);
//    _bubbleTableView.contentOffset=CGPointMake(0, 52*[_bubbleData count]+28*[_bubbleData count]);
    
}

#pragma mark - 判断特殊字符
-(BOOL)dealToCharacter:(NSString *)string
{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if ((ch == 0x0)||(ch == 0x9) ||
            (ch == 0xA) ||
            (ch == 0xD) ||
            ((ch >= 0x20) && (ch <= 0xD7FF)) ||
            ((ch >= 0xE000) && (ch <= 0xFFFD))) {
            
        }else{
            
            return false;
        }
    }
    return YES;
}

//-(void)exChangeStr:(NSString *)star
//{
//    NSMutableString *string=[[NSMutableString alloc] initWithString:star];
//    for (int i=0; i<string.length; i++) {
//        unichar ch = [string characterAtIndex:i];
//        if ((ch == 0x0)||(ch == 0x9) ||
//            (ch == 0xA) ||
//            (ch == 0xD) ||
//            ((ch >= 0x20) && (ch <= 0xD7FF)) ||
//            ((ch >= 0xE000) && (ch <= 0xFFFD))) {
//            
//        }else{
////            [string replaceCharactersInRange:NSMakeRange(i, i+1) withString:@" "];
//            
//            NSRange lineRange = [string lineRangeForRange:NSMakeRange(i, i+1)];
//            NSString *lineString = [string substringWithRange:lineRange];
//            NSLog(@"哈哈：%@",lineString);
//        }
//    }
//}

-(void)sendMessage:(NSString *)data type:(NSString *)type
{
    //回话存储字典
    //    NSMutableDictionary *speakDic=[[NSMutableDictionary alloc] init];
    APPDELEGATEING
    
    [delegates.speakerTimeArr addObject:[self getNowTime]];
    
    [self speakingCacheOpen];
    if (data.length>0) {
        
        
        self.imgUrl=@"";
        self.voiceUrl=@"";
        [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@@task.tojie.com','%d','%@','%@','%@',0)",self.currentJIDComunicateWith,speakMessageType,data,[self getNowTime],self.BNumber]];
    }else if (self.voiceUrl.length>0){
        self.imgUrl=@"";
    }else if (self.imgUrl.length>0){
        self.voiceUrl=@"";
        [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@@task.tojie.com','%d','%@','%@','%@',0)",self.currentJIDComunicateWith,speakImgType,self.imgUrl,[self getNowTime],self.BNumber]];
    }
    [self speakingCacheClose];
//    NSLog(@"状态是：%@",self.Status);
    
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    [_xmppManager sendMessageTo:[self.currentJIDComunicateWith stringByAppendingString:@"@task.tojie.com"] message:data type:type voice:self.voiceUrl img:self.imgUrl BNumber:self.BNumber status:self.Status from:[NSString stringWithFormat:@"%@@task.tojie.com",[registInfo objectForKey:@"usercode"]]];
    
    self.voiceUrl=@"";
    self.imgUrl=@"";
    
    [self scrollTableViewToButtom:_bubbleTableView];

//    [_bubbleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_bubbleData count]inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark -
#pragma mark XMPPChatDelegate
-(void)didRecieveMessage:(XMPPMessage *)message
{
    [_soundPlayer playSound:@"info_come"];
    //    NSBubbleData *data=[NSBubbleData dataWithText:@"doasjdoisajdoisajdos" date:[NSDate date] type:BubbleTypeSomeoneElse];
    //    //设置头像
    //    [manager downloadWithURL:[NSURL URLWithString:self.customerImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
    //
    //    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
    //        data.avatar=image;
    //    }];
    //
    //    [_bubbleData addObject:data];
    //    //[data release];
    //
    //    [_bubbleTableView reloadData];
    //
    //    [self scrollTableViewToButtom:_bubbleTableView];
    //    return;
    
    NSLog(@"%s",__func__);
    //    NSString *type = [[message attributeForName:@"type"] stringValue];
    //    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    from=[self cutStr:from cutStrs:@"/" page:0];
    //
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    ///消息实体
    //    [dict setObject:msg forKey:@"msg"];
    //    ///发送者
    //    [dict setObject:from forKey:@"sender"];
    //    ///类型
    //    [dict setObject:type forKey:@"type"];
    ////    NSXMLElement *abc=[message elementForName:@"body"];
    //
    //    NSXMLElement *msgpp=[message elementForName:@"body"] ;
    
//    NSXMLElement *body=[message elementForName:@"body"];
    
    NSString *bodyStr=[[message elementForName:@"body"] stringValue];
//    NSLog(@"嘻嘻：%@",[[message elementForName:@"body"] stringValue]);
//    NSLog(@"message是：%@",[self cutStr:[self cutStr:bodyStr cutStrs:@"</Info>" page:0] cutStrs:@"<Info>" page:1]);
//    NSLog(@"voice是：%@",[[body elementForName:@"Voice"] stringValue]);
//    NSLog(@"image是：%@",[[body elementForName:@"Img"] stringValue]);
    
//    BNumber
    if (![[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1] isEqualToString:self.BNumber]) {
        return;
    }
    
    
    APPDELEGATEING
    [delegates.speakerTimeArr addObject:[self getNowTime]];
    
    
    [self speakingCacheOpen];
    
    //文字信息
    NSBubbleData *data;
    if (![[self cutStr:[self cutStr:bodyStr cutStrs:@"</Info>" page:0] cutStrs:@"<Info>" page:1] isEqualToString:@"-1"]) {
        data = [NSBubbleData dataWithText:[self cutStr:[self cutStr:bodyStr cutStrs:@"</Info>" page:0] cutStrs:@"<Info>" page:1] date:[NSDate date] type:BubbleTypeSomeoneElse];
        
//        [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@','%d','%@','%@','%@',1)",from,speakMessageType,[self cutStr:[self cutStr:bodyStr cutStrs:@"</Info>" page:0] cutStrs:@"<Info>" page:1],[self getNowTime],self.BNumber]];
    }else {
        if ([[self cutStr:[self cutStr:bodyStr cutStrs:@"</Voice>" page:0] cutStrs:@"<Voice>" page:1] isEqualToString:@"-1"]) {
            self.imgUrl=[self cutStr:[self cutStr:bodyStr cutStrs:@"</Img>" page:0] cutStrs:@"<Img>" page:1];
            
            
//            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@','%d','%@','%@','%@',1)",from,speakImgType,self.imgUrl,[self getNowTime],self.BNumber]];
            
            [manager downloadWithURL:[NSURL URLWithString:self.imgUrl] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                imageBtn.frame=CGRectMake(0, 0, 56, 56);
                [imageBtn setImage:image forState:UIControlStateNormal];
                [self.imgUrlArr addObject:image];
                imageBtn.tag=imgBtnTag;
                [imageBtn addTarget:self action:@selector(bigImg:) forControlEvents:UIControlEventTouchUpInside];
                NSBubbleData *data = [NSBubbleData dataWithView:imageBtn date:[NSDate date] type:BubbleTypeSomeoneElse insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
                imgBtnTag+=1;
                
                //                NSBubbleData *data=[NSBubbleData dataWithImage:image date:[NSDate date] type:BubbleTypeSomeoneElse];
                
                
                [manager downloadWithURL:[NSURL URLWithString:self.customerImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                    
                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                    data.avatar=image;
                    
                    
                    
                    [_bubbleData addObject:data];
                    
                    [self.bubbleTableView reloadData];
                    [self scrollTableViewToButtom:_bubbleTableView];
                    [self.mainTextField resignFirstResponder];
                    
                    self.mainTextField.text=@"";
                    
                }];
                
            }];
        }else{
            
            UIButton *sonundBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            sonundBtn.frame=CGRectMake(0, 0, 56, 26);
            [sonundBtn setImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
            [sonundBtn addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
            sonundBtn.tag=btnTag;
            btnTag+=1;
            data = [NSBubbleData dataWithView:sonundBtn date:[NSDate date] type:BubbleTypeSomeoneElse insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
            
            //            [self getVoice:[NSString stringWithFormat:@"http://img.tojie.com%@",[[body elementForName:@"Voice"] stringValue]]];
            [self getVoice:[NSString stringWithFormat:@"%@",[self cutStr:[self cutStr:bodyStr cutStrs:@"</Voice>" page:0] cutStrs:@"<Voice>" page:1]]];
            
            
//            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO UsersCache (usercode,type,Message,time,BNumber,respondType) VALUES ('%@','%d','%@','%@','%@',1)",from,speakVoiceType,self.voiceUrl,[self getNowTime],self.BNumber]];
        }
        
    }
    
    [self speakingCacheClose];
    
    if ([[self cutStr:[self cutStr:bodyStr cutStrs:@"</Img>" page:0] cutStrs:@"<Img>" page:1] isEqualToString:@"-1"]) {
        //设置头像
        [manager downloadWithURL:[NSURL URLWithString:self.customerImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
            
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
            data.avatar=image;
            
        }];
        
        [_bubbleData addObject:data];
        //[data release];
        
        [_bubbleTableView reloadData];
        
        [self scrollTableViewToButtom:_bubbleTableView];
    }
    
//    NSLog(@"呵呵：%@",_bubbleData);
    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = CGRectMake(0, 200, _mainDownView.frame.size.width, _mainDownView.frame.size.height);
        
        //        _mainDownView.frame = frame;
        frame = CGRectMake(0, 0, _bubbleTableView.frame.size.width, self.view.frame.size.height - _mainDownView.frame.size.height);
        
        _bubbleTableView.frame = frame;
    }];
}

#pragma mark - 截取字符串
-(NSString *)cutStr:(NSString *)cutOrign cutStrs:(NSString *)cutStrs page:(int)page
{
    NSArray  *tempArray = [cutOrign componentsSeparatedByString:cutStrs];
    if (tempArray.count>0) {
        return [tempArray objectAtIndex:page];
    }else{
        return @"";
    }
}

#pragma mark - 添加图片
- (IBAction)addImage:(id)sender {
    [self.view endEditing:YES];
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
            self.imgUrl=loginObject.url;
            
            self.imgUrl=[NSString stringWithFormat:@"http://img.tojie.com%@",self.imgUrl];
            self.voiceUrl=@"";
            //            self.imgUrl=[NSString stringWithFormat:@"%@",self.imgUrl];
            
            //设置头像
            [manager downloadWithURL:[NSURL URLWithString:self.imgUrl] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                imageBtn.frame=CGRectMake(0, 0, 56, 56);
                [imageBtn setImage:image forState:UIControlStateNormal];
                [self.imgUrlArr addObject:image];
                imageBtn.tag=imgBtnTag;
                [imageBtn addTarget:self action:@selector(bigImg:) forControlEvents:UIControlEventTouchUpInside];
                NSBubbleData *data = [NSBubbleData dataWithView:imageBtn date:[NSDate date] type:BubbleTypeMine insets:UIEdgeInsetsMake(-50, 0, 0, 0)];
                imgBtnTag+=1;
                
                //                NSBubbleData *data=[NSBubbleData dataWithImage:image date:[NSDate date] type:BubbleTypeMine];
                
                //设置头像
                [manager downloadWithURL:[NSURL URLWithString:self.accountImg] options:0 progress:^(NSUInteger receivedSize, long long expectedSize){
                    
                }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                    data.avatar=image;
                }];
                
                [_bubbleData addObject:data];
                
                [self sendMessage:@"" type:@"chat"];
                [self.bubbleTableView reloadData];
                [self scrollTableViewToButtom:_bubbleTableView];
                [self.mainTextField resignFirstResponder];
                
                self.mainTextField.text=@"";
                HIDE__LOADING;
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

#pragma mark -
#pragma mark UIBubbleTableViewDataSource implementation
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    
    return [_bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    
    return [_bubbleData objectAtIndex:row];
}

/**
 *滚动聊天信息至底部
 **/
-(void)scrollTableViewToButtom:(id)sender
{
    //导致位移错误
//    UITableView *tableView = (UITableView *)sender;
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_bubbleData count]inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if ([_bubbleData count]>5) {
        _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
    }else{
        _bubbleTableView.contentOffset=CGPointMake(0, 0);
    }
    
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
//    NSLog(@"123");
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"kbSize:(%f,%f)",kbSize.width,kbSize.height);
    
    [UIView animateWithDuration:0.25f animations:^{
        
        CGRect frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - _mainDownView.frame.size.height, _mainDownView.frame.size.width, _mainDownView.frame.size.height);
        
//        _mainDownView.frame = frame;
        
        
        frame = CGRectMake(0, 0 , _bubbleTableView.frame.size.width, self.view.frame.size.height - kbSize.height-self.mainDownView.frame.size.height);
        
        _bubbleTableView.frame = frame;
        
        _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
//        _bubbleTableView.contentOffset=CGPointMake(0, 1024);
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    NSLog(@"456");
//    NSLog(@"哈哈：%@",self.speakArr);
    
    [UIView animateWithDuration:0.25f animations:^{
    
        CGRect frame = CGRectMake(0, 200, _mainDownView.frame.size.width, _mainDownView.frame.size.height);
    
//        _mainDownView.frame = frame;
    
        frame = CGRectMake(0, 0, _bubbleTableView.frame.size.width, self.view.frame.size.height - _mainDownView.frame.size.height);
        
        _bubbleTableView.frame = frame;
        
        if ([_bubbleData count]>5) {
            _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
        }else{
            _bubbleTableView.contentOffset=CGPointMake(0, 0);
        }
        
//        NSLog(@"h:%f",_bubbleTableView.frame.size.height);
//        NSLog(@"y:%f",_bubbleTableView.frame.origin.y);
//        _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
        
    }];
}

-(void)endEditing
{
    [self.view endEditing:YES];
//    _bubbleTableView.contentOffset=CGPointMake(0, _bubbleTableView.contentSize.height-_bubbleTableView.frame.size.height);
}

#pragma mark - 用户聊天缓存
-(void)speakingCacheOpen
{
    NSString *dbPath=[self mainPath:@"SpeakDatabase.db"];
    db=[FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"error");
    }
    rs=[db executeQuery:@"select id from UsersCache limit(0,1)"];
    
    
    
    if(![rs next]){
        [db executeUpdate:@"CREATE TABLE UsersCache (id integer primary key autoincrement,usercode text,type text,Message text,time text,respondType text,BNumber text)"];
    }
}

-(void)speakingCacheClose
{
    if (db) {
        [db close];
    }
    if (rs) {
        [rs close];
    }
}

#pragma mark - 图片放大
-(void)bigImg:(id)sender
{
    UIButton *clickBtn=(UIButton *)sender;
    self.bigImgView.hidden=NO;
    self.bigImgs.image=[self.imgUrlArr objectAtIndex:clickBtn.tag];
}

#pragma mark - 图片缩小
- (IBAction)returnSmall:(id)sender {
    self.bigImgView.hidden=YES;
}

#pragma mark - 获得当前时间戳
-(NSString *)nowTimeCode
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];//时间戳的值
    
    return timeSp;
}

#pragma mark - 获得系统时间
-(NSString *)getNowTime
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //        [dateformatter setDateFormat:@"HH:mm"];
    //        NSString *  locationString=[dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    return morelocationString;
}

#pragma mark 获取Document路径下的文件/文件夹
-(NSString *)mainPath:(NSString *)path
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *returnPath=[documentDirectory stringByAppendingPathComponent:path];
    return returnPath;
}

-(NSString *)nowCustomerPath
{
    return [self mainPath:[NSString stringWithFormat:@"Chat/%@",self.currentJIDComunicateWith]];
}

#pragma mark - 获取声音并保存路径
-(void)getVoice:(NSString *)urlPath
{
    NSString *urlAsString = urlPath;
    NSURL    *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:&error];
    
    //    [self.voiceUrlArr addObject:[NSString stringWithFormat:@"%@/doasjdosajdosajdo.spx",[self nowCustomerPath]]];
    /* 下载的数据 */
    if (data != nil){
        if ([data writeToFile:[NSString stringWithFormat:@"%@/%@.spx",[self nowCustomerPath],[self nowTimeCode]] atomically:YES]) {
            //        if ([data writeToFile:[NSString stringWithFormat:@"%@/doasjdosajdosajdo.spx",[self nowCustomerPath]] atomically:YES]) {
            self.voiceUrl=[NSString stringWithFormat:@"%@/%@.spx",[self nowCustomerPath],[self nowTimeCode]];
            
            //添加声音进入本地声音数组
            [self.voiceUrlArr addObject:[NSString stringWithFormat:@"%@/%@.spx",[self nowCustomerPath],[self nowTimeCode]]];
        }
        else
        {
            WARNING__ALERT(@"保存声音失败，请检查您的硬盘容量");
        }
    } else {
        //添加声音进入本地声音数组
        [self.voiceUrlArr addObject:urlPath];
//        WARNING__ALERT(@"声音下载失败");
    }
}

- (void)dealloc {
    [_soundKeywordBtn release];
    [_soundView release];
    [_textView release];
    [_mainDownView release];
    [_mainTextField release];
    [_speakBackground release];
    [_speakLabel release];
    [_respondLabel release];
    [_respondImg release];
    [_bubbleTableView release];
    [_voiceLab release];
    [_bigImgView release];
    [_bigImgs release];
    [_testLab release];
    [_addVoiceBtn release];
    [_testVoiceImg release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSoundKeywordBtn:nil];
    [self setSoundView:nil];
    [self setTextView:nil];
    [self setMainDownView:nil];
    [self setMainTextField:nil];
    [self setSpeakBackground:nil];
    [self setSpeakLabel:nil];
    [self setRespondLabel:nil];
    [self setRespondImg:nil];
    [self setBubbleTableView:nil];
    [self setVoiceLab:nil];
    [self setBigImgView:nil];
    [self setBigImgs:nil];
    [self setTestLab:nil];
    [self setAddVoiceBtn:nil];
    [self setTestVoiceImg:nil];
    [super viewDidUnload];
}
@end
