//
//  RabbitMainViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitMainViewController.h"
#import "PublicDefine.h"

#import "AFNetworking.h"

#import "RabbitMKNetwork.h"
#import "MKNetworkEngine.h"
#import "WPXMLRPCEncoder.h"
#import "WPXMLRPCDecoder.h"

#import "XMPPMessage.h"

@interface RabbitMainViewController ()

@end

@implementation RabbitMainViewController
static bool hideNavigation=NO;

static bool isInEva=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isInEva=NO;
        // Custom initialization
        Notification__CREATE(NotificationFun,FINDWORKBACK);
        Notification__CREATE(NotificationFun,PERSONALPUSH);
        Notification__CREATE(NotificationFun,CREDITPUSH);
        Notification__CREATE(NotificationFun,MYACCOUNT);
        Notification__CREATE(NotificationFun,SETUP);
        Notification__CREATE(NotificationFun, NAVIGATIONBARHIDE);
        Notification__CREATE(NotificationFun, SPEAKER);
        Notification__CREATE(NotificationFun, SUBMITINFO);
        
        Notification__CREATE(NotificationFun, MATTERDETAIL);
        Notification__CREATE(NotificationFun, EVABACKMAIN);
        
        Notification__CREATE(NotificationNoticeSpeak,SPEAKERSNOTICE);
        Notification__CREATE(NotificationNoticeSpeak,OVERNOTICE);
        
        //公共通知
        Notification__CREATE(NotificationNomalNotice, NOMARLNOTICE);
        
        
        Notification__CREATE(NotificationHideNav, HIDENAV);
        Notification__CREATE(NotificationShowNav, SHOWNAV);
        
//        Notification__CREATE(NotificationBack, NOLOCATION);
    }
    return self;
}

#pragma mark - 监听事件
- (void)NotificationNoticeSpeak:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:SPEAKERSNOTICE])
    {
        [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@""]];
    }else{
        [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:nil];
    }
    
}

- (void)NotificationHideNav:(NSNotification *) notification
{
    self.navigationController.navigationBarHidden=YES;
}

- (void)NotificationShowNav:(NSNotification *) notification
{
    self.navigationController.navigationBarHidden=NO;
}

#pragma mark - 公共推送
- (void)NotificationNomalNotice:(NSNotification *) notification
{
    XMPPMessage *message=[notification.userInfo objectForKey:@"message"];
    NSString *bodyStr=[[message elementForName:@"body"] stringValue];
    
    //获取ID号
    NSDictionary *postDic=[[NSDictionary alloc] initWithObjectsAndKeys:[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1],@"bnumber", nil];
    
    
    switch ([[self cutStr:[self cutStr:bodyStr cutStrs:@"</action>" page:0] cutStrs:@"<action>" page:1] intValue]) {
        case 1:
            if (_mainTabBar.selectedIndex!=0) {
                [[[[_mainTabBar tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@""]];
            }
            [postDic release];
            postDic=nil;
            postDic=[[NSDictionary alloc] initWithObjectsAndKeys:[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1],@"bnumber",[self cutStr:[self cutStr:bodyStr cutStrs:@"</booktype>" page:0] cutStrs:@"<booktype>" page:1],@"booktype", nil];
            Notification__POST(PUBLISHMISSION, postDic);
            break;
            
        case 4:
            Notification__POST(CANCELMISSION, postDic);
            if (_mainTabBar.selectedIndex!=1) {
                [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@""]];
            }
            break;
            
        case 6:
            Notification__POST(CHOOSERABBIT, postDic);
            if (_mainTabBar.selectedIndex!=1) {
                [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@""]];
            }
            break;
            
        case 8:
            Notification__POST(EMPOLYERCANCELMISSION, postDic);
            break;
            
        case 13:
            Notification__POST(CANCELMISSION, postDic);
            if (_mainTabBar.selectedIndex!=1) {
                [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@""]];
            }
            break;
            
        default:
            break;
    }

//    switch ([[self cutStr:[self cutStr:bodyStr cutStrs:@"</status>" page:0] cutStrs:@"<status>" page:1] intValue]) {
//        case 1:
//            if (_mainTabBar.selectedIndex!=0) {
//                [[[[_mainTabBar tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@""]];
//            }
//            [postDic release];
//            postDic=nil;
//            postDic=[[NSDictionary alloc] initWithObjectsAndKeys:[self cutStr:[self cutStr:bodyStr cutStrs:@"</bnumber>" page:0] cutStrs:@"<bnumber>" page:1],@"bnumber",[self cutStr:[self cutStr:bodyStr cutStrs:@"</booktype>" page:0] cutStrs:@"<booktype>" page:1],@"booktype", nil];
//            Notification__POST(PUBLISHMISSION, postDic);
//            break;
//            
//        case 3:
//            Notification__POST(CANCELMISSION, postDic);
//            if (_mainTabBar.selectedIndex!=1) {
//                [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@""]];
//            }
//            break;
//            
//        case 4:
//            if ([[self cutStr:[self cutStr:bodyStr cutStrs:@"</action>" page:0] cutStrs:@"<action>" page:1] intValue]==5) {
//                Notification__POST(CHOOSERABBIT, postDic);
//            }
//            if (_mainTabBar.selectedIndex!=1) {
//                [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@""]];
//            }
//            break;
//            
//        case 6:
//            Notification__POST(EMPOLYERCANCELMISSION, postDic);
//            break;
//            
//        default:
//            break;
//    }
    
//    notification.userInfo
}

- (void)NotificationFun:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:FINDWORKBACK])
    {
        _findWorkDetailVC=[[FindWorkDetailViewController alloc] initWithTitle:[notification.userInfo objectForKey:@"title"] isHidden:[notification.userInfo objectForKey:@"isHidden"]];
        
        [_findWorkDetailVC getMainInfo:[notification.userInfo objectForKey:@"MainInfo"] local:[notification.userInfo objectForKey:@"location"]];
        
        [self.navigationController pushViewController:_findWorkDetailVC animated:YES];
    }else if ([[notification name] isEqualToString:PERSONALPUSH])
    {
        _personalInforVC=[[PersonalInforViewController alloc] init];
        [self.navigationController pushViewController:_personalInforVC animated:YES];
    }else if ([[notification name] isEqualToString:CREDITPUSH])
    {
        _creditVC=[[CreditViewController alloc] init];
        [self.navigationController pushViewController:_creditVC animated:YES];
    }else if ([[notification name] isEqualToString:MYACCOUNT])
    {
        _myAccountVC=[[MyAccountViewController alloc] init];
        [self.navigationController pushViewController:_myAccountVC animated:YES];
    }else if ([[notification name] isEqualToString:SETUP])
    {
        _setupVC=[[SetUpViewController alloc] init];
        [self.navigationController pushViewController:_setupVC animated:YES];
    }else if ([[notification name] isEqualToString:NAVIGATIONBARHIDE])
    {
        isInEva=YES;
        
        self.navigationItem.title=@"评价";
        self.navigationController.navigationBarHidden=NO;
        self.navigationItem.hidesBackButton=NO;
        
        
        //左侧返回
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"navigationBackBtn.png"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(evaBack)
         forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:12];
        [button setTitle:@" 返回" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 50, 25);
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = menuButton;
        
        
        //右侧分享
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"share.png"]
                          forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(evaShare)
         forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(0, 0, 24, 20);
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = shareButton;
    }else if ([[notification name] isEqualToString:SPEAKER]){
//        if (isInEva==YES) {
//            NSLog(@"YES");
//        }else{
//            NSLog(@"NO");
//        }
        self.navigationController.navigationBarHidden=NO;
        _chatVC=[[ChatViewController alloc] init];
        _chatVC.currentJIDComunicateWith=[notification.userInfo objectForKey:@"JID"];
        _chatVC.BNumber=[notification.userInfo objectForKey:@"BNumber"];
        _chatVC.Status=[notification.userInfo objectForKey:@"Status"];
        _chatVC.customerImg=[notification.userInfo objectForKey:@"image"];
        _chatVC.enuserName=[notification.userInfo objectForKey:@"eusername"];
        [self.navigationController pushViewController:_chatVC animated:YES];
        
    }else if ([[notification name] isEqualToString:SUBMITINFO]){
//        self.navigationController.navigationBar.hidden=YES;
        [self.navigationController popViewControllerAnimated:YES];
        _mainTabBar.selectedIndex=1;
    }else if ([[notification name] isEqualToString:MATTERDETAIL]){
        _matterDetailVC=[[MatterDetailViewController alloc] initWithTitle:[notification.userInfo objectForKey:@"title"] isHidden:[notification.userInfo objectForKey:@"isHidden"]];
        [_matterDetailVC getMainInfo:[notification.userInfo objectForKey:@"MainInfo"] local:[notification.userInfo objectForKey:@"location"]];
        [self.navigationController pushViewController:_matterDetailVC animated:YES];
    }else if ([[notification name] isEqualToString:EVABACKMAIN]){
        isInEva=NO;
        self.navigationController.navigationBarHidden=YES;
        self.navigationItem.hidesBackButton=YES;
    }
}


//- (void)NotificationBack:(NSNotification *) notification
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
#pragma mark - 监听事件

#pragma mark - 截取字符串
-(NSString *)cutStr:(NSString *)cutOrign cutStrs:(NSString *)cutStrs page:(int)page
{
    NSArray  *tempArray = [cutOrign componentsSeparatedByString:cutStrs];
    if (tempArray.count>0) {
        return [tempArray objectAtIndex:page];
    }
    return @"";
}

#pragma mark - 评价分享
-(void)evaShare
{
    //取得本地通信录名柄
    
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreate();
    }
    //取得本地所有联系人记录
    
    
    if (tmpAddressBook==nil) {
        return ;
    };
    NSArray* tmpPeoples = (NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    NSMutableArray  *_allTeleArr=[[NSMutableArray alloc] init];
    
    for(id tmpPerson in tmpPeoples)
        
    {
//        
//        //获取的联系人单一属性:First name
//        
//        NSString* tmpFirstName = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonFirstNameProperty);
//        
//        NSLog(@"First name:%@", tmpFirstName);
//        
//        [tmpFirstName release];
//        
//        //获取的联系人单一属性:Last name
//        
//        NSString* tmpLastName = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonLastNameProperty);
//        
//        NSLog(@"Last name:%@", tmpLastName);
//        
//        [tmpLastName release];
//        
//        //获取的联系人单一属性:Nickname
//        
//        NSString* tmpNickname = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonNicknameProperty);
//        
//        NSLog(@"Nickname:%@", tmpNickname);
//        
//        [tmpNickname release];
//        
//        //获取的联系人单一属性:Company name
//        
//        NSString* tmpCompanyname = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonOrganizationProperty);
//        
//        NSLog(@"Company name:%@", tmpCompanyname);
//        
//        [tmpCompanyname release];
//        
//        //获取的联系人单一属性:Job Title
//        
//        NSString* tmpJobTitle= (NSString*)ABRecordCopyValue(tmpPerson, kABPersonJobTitleProperty);
//        
//        NSLog(@"Job Title:%@", tmpJobTitle);
//        
//        [tmpJobTitle release];
//        
//        //获取的联系人单一属性:Department name
//        
//        NSString* tmpDepartmentName = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonDepartmentProperty);
//        
//        NSLog(@"Department name:%@", tmpDepartmentName);
//        
//        [tmpDepartmentName release];
//        
//        //获取的联系人单一属性:Email(s)
//        
//        ABMultiValueRef tmpEmails = ABRecordCopyValue(tmpPerson, kABPersonEmailProperty);
//        
//        for(NSInteger j = 0; ABMultiValueGetCount(tmpEmails); j++)
//            
//        {
//            
//            NSString* tmpEmailIndex = (NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
//            
//            NSLog(@"Emails%d:%@", j, tmpEmailIndex);
//            
//            [tmpEmailIndex release];
//            
//        }
//        
//        CFRelease(tmpEmails);
//        
//        //获取的联系人单一属性:Birthday
//        
//        NSDate* tmpBirthday = (NSDate*)ABRecordCopyValue(tmpPerson, kABPersonBirthdayProperty);
//        
//        NSLog(@"Birthday:%@", tmpBirthday);
//        
//        [tmpBirthday release];
//        
//        //获取的联系人单一属性:Note
//        
//        NSString* tmpNote = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonNoteProperty);
//        
//        NSLog(@"Note:%@", tmpNote);
//        
//        [tmpNote release];
//        
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue(tmpPerson, kABPersonPhoneProperty);
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            
        {
            
            NSString* tmpPhoneIndex = (NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            
//            NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
            
            [_allTeleArr addObject:tmpPhoneIndex];
            
            [tmpPhoneIndex release];
            
        }
        
        CFRelease(tmpPhones);
        
    }
    
    //释放内存
    
    [tmpPeoples release];
    
    CFRelease(tmpAddressBook);
    
//    NSLog(@"呵呵：%@",_allTeleArr);
    NSString *tele;
    for (NSString *telePhone in _allTeleArr) {
        tele=[NSString stringWithFormat:@"%@、sms://%@",tele,telePhone];
    }
//    NSLog(@"哈哈：%@",tele);
    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://18817468745,18717711265"]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://"]];
    
//    [self displaySMSComposerSheet];

}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker =[[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    
    NSMutableString* absUrl =[[NSMutableString alloc] initWithString:@"哈哈"];
    [absUrl replaceOccurrencesOfString:@"http://i.aizheke.com"withString:@"http://m.aizheke.com"options:NSCaseInsensitiveSearch range:NSMakeRange(0, [absUrl length])];
    
    picker.body=[NSString stringWithFormat:@"测试短信能否发送！"];
    [absUrl release];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch(result)
    {
        caseMessageComposeResultCancelled:
            NSLog(@"取消");
            break;
        caseMessageComposeResultSent:
            NSLog(@"成功");
            break;
        caseMessageComposeResultFailed:
            NSLog(@"失败");
            break;
        default:
            NSLog(@"失败");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 评价返回
-(void)evaBack
{
    isInEva=NO;
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    Notification__POST(EVABACKMAIN,nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (hideNavigation) {
        self.navigationController.navigationBarHidden=YES;
    }
    if (isInEva==YES) {
        self.navigationController.navigationBarHidden=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"兔子首页";

    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.hidesBackButton=YES;
    
    UIImage *image=nil;
    UITabBarItem *Item=nil;
    
    _rabbitPersonalVC=[[RabbitPersonalViewController alloc]init];
    image = [UIImage imageNamed:@"mine.png"];
    Item = [[UITabBarItem alloc]initWithTitle:@"我的" image:image tag:0];
    _rabbitPersonalVC.tabBarItem=Item;
    
    _matterVC=[[MatterViewController alloc] init];
    image = [UIImage imageNamed:@"things.png"];
//    image = [UIImage imageNamed:@"changeTings2.png"];
    Item = [[UITabBarItem alloc]initWithTitle:@"事项" image:image tag:1];
    _matterVC.tabBarItem=Item;
    
    _findWorkVC=[[FindWorkViewController alloc] init];
    image = [UIImage imageNamed:@"findworkLogo.png"];
    Item = [[UITabBarItem alloc]initWithTitle:@"找活" image:image tag:2];
    
    _findWorkVC.tabBarItem=Item;
    
    _mainTabBar=[[UITabBarController alloc] init] ;
    _mainTabBar.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    _mainTabBar.delegate=self;
    
    //纯黑色tabbar
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _mainTabBar.tabBar.translucent=NO;
        [UITabBar appearance].barStyle=UIBarStyleBlack;
    }
    
    _mainTabBar.viewControllers=[NSArray arrayWithObjects:_findWorkVC,_matterVC,_rabbitPersonalVC, nil];
    _mainTabBar.selectedIndex=0;
    
    
    [self.view addSubview:_mainTabBar.view];
    
    [_findWorkVC release];
    [_matterVC release];
    [_rabbitPersonalVC release];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tabbar协议
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    hideNavigation=NO;
    if (viewController==_matterVC) {
//        [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        [[[[_mainTabBar tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        hideNavigation=YES;
        self.navigationController.navigationBarHidden=YES;
        if (isInEva==YES) {
            self.navigationController.navigationBarHidden=NO;
            
            //左侧返回
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"navigationBackBtn.png"]
                              forState:UIControlStateNormal];
            [button addTarget:self action:@selector(evaBack)
             forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:12];
            [button setTitle:@" 返回" forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 50, 25);
            UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = menuButton;
            
            
            //右侧分享
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"share.png"]
                                   forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(evaShare)
                  forControlEvents:UIControlEventTouchUpInside];
            rightButton.frame = CGRectMake(0, 0, 24, 20);
            UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem = shareButton;
        }
    }else{
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.hidesBackButton=YES;
        
        self.navigationController.navigationBarHidden=NO;
//        self.navigationController.navigationBarHidden=YES;
        
        if (viewController==_rabbitPersonalVC) {
            self.navigationItem.title=@"我的";
        }else{
            [[[[_mainTabBar tabBar] items] objectAtIndex:0] setBadgeValue:nil];
            self.navigationItem.title=@"兔子首页";
        }
    }
}

#pragma mark - 公共返回按钮
-(void)calledPublicBack
{
    self.navigationItem.hidesBackButton=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    Notification__REMOVE
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
