//
//  LoginViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-8-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "LoginViewController.h"
#import "UserNetRequest.h"
#import "MKNetworkEngine.h"
#import "IQKeyBoardManager.h"

#import "LoginBack.h"
#import "LoginInfo.h"
#import "LoginNetWork.h"

#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"
#import "MainMapViewController.h"

//支付宝
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

#import "VersionUpload.h"


#import "Base64.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize result = _result;

static float timeings=0;
static int allTimeValue=0;

static bool loginSuccess=NO;

static bool isAllowRegist=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        Notification__CREATE(NotificationLoginSuccess,REGISTSUCCESS);
        
//        Notification__CREATE(NotificationNoLocation,NOLOCATION);
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    isAllowRegist=NO;
    
    if (IS_IPHONE_5) {
        self.warningView.image=[UIImage imageNamed:@"640x1139 loading-兔子.png"];
    }else{
        self.warningView.image=[UIImage imageNamed:@"640x960 loading-兔子.png"];
    }
    
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            
            break;
        default:
            errorString = @"An unknown error has occurred";
            
            break;
    }
    
    
    
    if (IS_IPHONE_5) {
        UIImageView *warningImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"640x1139 loading-兔子.png"]];
        
        warningImg.frame=self.view.frame;
        [self.view addSubview:warningImg];

    }else{
        UIImageView *warningImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"640x960 loading-兔子.png"]];
        
        warningImg.frame=self.view.frame;
        [self.view addSubview:warningImg];

    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"请开启定位服务";
    hud.margin = 10.f;
    hud.yOffset = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1000];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    
    [self.passwordTextField setSecureTextEntry:YES];
    
    
    //判断定位和网络连接
    if(![CLLocationManager locationServicesEnabled]) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请开启定位服务";
        hud.margin = 10.f;
        hud.yOffset = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1000];
        self.warningView.hidden=NO;
        return;
    }else{
        Reachability *reach=[Reachability reachabilityWithHostname:@"www.baidu.com"];
        BOOL isWeb=YES;
        switch ([reach currentReachabilityStatus]) {
            case NotReachable:
                isWeb=NO;
                // 没有网络连接
                break;
            case ReachableViaWWAN:
                // 使用3G网络
                break;
            case ReachableViaWiFi:
                // 使用WiFi网络
                break;
        }
        if (isWeb==NO) {
            self.warningView.hidden=NO;
            WARNING__ALERT(@"请检查网络连接是否正常");
            return;
        }else{
            VersionUpload *version=[[VersionUpload alloc] init];
            [version getVerson:^(id responseData) {
                XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
                
                if (RPCResult.success==YES) {
                    //有更新
                    self.warningView.hidden=NO;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本更新"
                                                                        message:@""
                                                                       delegate:self
                                                              cancelButtonTitle:@"确认"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                    
                }else{
                    //没更新
                    self.warningView.hidden=YES;
                }
            } failed:^(NSError *error) {
                self.warningView.hidden=NO;
                WARNING__ALERT(@"请检查网络连接是否正常");
                return;
            }];
            //            self.warningView.hidden=YES;
        }
    }
    self.warningView.hidden=NO;
    
    //返回按钮
    NAVIGATION_BACK(@"  上一步");
    
    [IQKeyBoardManager installKeyboardManager];
    for (id subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField=subView;
            textField.delegate=self;
            [textField addPreviousNextDoneOnKeyboardWithTarget:self
                                                previousAction:@selector(previousClicked:)
                                                    nextAction:@selector(nextClicked:)
                                                    doneAction:@selector(doneClicked:)];
            [textField setEnablePrevious:NO next:YES];
            
        }
    }
    

#pragma mark - 记住用户名密码
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *loginCache=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",LOGINCACHE]]];
    NSLog(@"嘻嘻：%@",loginCache);
    self.usernameTextField.text=[loginCache objectForKey:@"username"];
    self.passwordTextField.text=[loginCache objectForKey:@"password"];
    
    
#pragma mark - 支付宝
    _result = @selector(paymentResult:);
    NSString *appScheme = @"AlipaySdkDemo";
#if __has_feature(objc_arc)
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
#else
    AlixPayOrder *order = [[[AlixPayOrder alloc] init] autorelease];
#endif
    order.partner = PartnerID;
    order.seller = SellerID;
    
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.tradeNO = @"3841413365300-1"; //订单ID（由商家自行制定）
    order.productName = @"RC夜莺，尊贵高富帅的象征"; //商品标题
	order.productDescription = @"土豪金RC夜莺！！求抱走！"; //商品描述
	order.amount = @"0.01"; //商品价格
    order.notifyURL =  @"http://pay.tojie.com/alipay/notify_url.php"; //回调URL
    NSString *orderInfo = [order description];
    NSString* signedStr = [self doRsa:orderInfo];
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
//    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
    
    
    CLLocationManager *manager = [[CLLocationManager alloc] init];//初始化定位器
    [manager setDelegate: self];//设置代理
    [manager setDesiredAccuracy: kCLLocationAccuracyBest];//设置精确度
    [manager startUpdatingLocation];//开启位置更新
}

#pragma mark - 支付宝接口方法
//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = @"签约帐户后获取到的支付宝公钥";
            NSLog(@"交易陈工");
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
        }
        else
        {
            NSLog(@"交易失败");
            //交易失败
        }
    }
    else
    {
        NSLog(@"交易失败");
        //失败
    }
    
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    
    NSString *signedString = [signer signString:orderInfo];
    
    return signedString;
}
#pragma mark - 支付宝接口方法


BACK_ACTION

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
{
    
    NSLog(@"成功");
}

-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
    NSLog(@"失败");
}

-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    NSLog(@"123");
//    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag-1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    NSLog(@"456");
//    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag+1] becomeFirstResponder];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - 监听事件(注册成功)
- (void)NotificationLoginSuccess:(NSNotification *) notification
{
    //自动记录用户名和密码
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
    [writeOperation writeToPlist:WRITELOGIN plistContent:registInfo];
    self.usernameTextField.text=[registInfo objectForKey:@"username"];
    self.passwordTextField.text=@"";
    
    
    
    self.navigationController.navigationBar.hidden=YES;
    
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    NSString *deletePath=[NSString stringWithFormat:@"%@/WriteRegist.plist",documentsDirectory];
    
    //删除待删除的文件
    [fileManager removeItemAtPath:deletePath error:nil];
    
    WARNING__ALERT(@"注册成功，请登陆");
}

#pragma mark - 监听事件(没开启定位)
//- (void)NotificationNoLocation:(NSNotification *) notification
//{
//    WARNING__ALERT(@"请开启定位服务");
//    self.warningView.hidden=NO;
//}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    static CFArrayRef certs;
    if (!certs) {
        NSData*certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"]];
        SecCertificateRef rootcert =SecCertificateCreateWithData(kCFAllocatorDefault,CFBridgingRetain(certData));
        const void *array[1] = { rootcert };
        certs = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
        CFRelease(rootcert);    // for completeness, really does not matter
    }
    
    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
    int err;
    SecTrustResultType trustResult = 0;
    err = SecTrustSetAnchorCertificates(trust, certs);
    if (err == noErr) {
        err = SecTrustEvaluate(trust,&trustResult);
    }
    CFRelease(trust);
    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed)||(trustResult == kSecTrustResultConfirm) || (trustResult == kSecTrustResultUnspecified));
    
    if (trusted) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }else{
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)regist:(id)sender {
    _registClassifyVC=[[RegistClassifyViewController alloc] init];
    
//    //判断是否已经注册过用户
//    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
//    NSMutableDictionary *getInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITEREGIST]]];
//    
//    if (getInfo.count>0) {
//        [_registClassifyVC changeStatus:NO];
//    }
    if (isAllowRegist==YES) {
        [_registClassifyVC changeStatus:NO];
    }
    
    [self.navigationController pushViewController:_registClassifyVC animated:YES];
}

- (IBAction)forgetPassword:(id)sender {
    _forgetPasswordVC=[[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:_forgetPasswordVC animated:YES];
}

#pragma mark - XMPP
-(void)loginStatusCallBack:(BOOL)successed error:(NSXMLElement *)error
{
    HIDE__LOADING;
    NSLog(@"连接时间～～：%f",timeings);
    NSLog(@"\n%s %@\nerror:%@",__func__,successed?@"登录成功":@"登录失败",successed?@"nil":error);
    if (successed) {
        Notification__POST(CHANGESTATUS, nil);
        _rabbitMainVC=[[RabbitMainViewController alloc] init];
        
        //写入配置文件
        NSLog(@"数据是：%@",_loginDic);
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        [writeOperation writeToPlist:WRITELOGIN plistContent:_loginDic];
//        NSLog(@"嘻嘻：%@",_loginDic);
        allTimeValue=[[_loginDic objectForKey:@"gps_timer"] intValue];
        
        if (loginSuccess==NO) {
            loginSuccess=YES;
        }else{
            return;
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(add) userInfo:nil repeats:YES];
        
        [self.navigationController pushViewController:_rabbitMainVC animated:YES];
        
        Notification__POST(GETLOCATION, nil);
    }else
    {
        XMPPManager *manager = [XMPPManager sharedManager];
        [manager disconnect];
        WARNING__ALERT(@"聊天服务连接失败，如网络正常请和管理员联系");
    }
}

#pragma mark - 登陆
- (IBAction)login:(id)sender {
    Reachability *reach=[Reachability reachabilityWithHostname:@"www.baidu.com"];
    BOOL isWeb=YES;
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isWeb=NO;
            // 没有网络连接
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
    if (isWeb==NO) {
        WARNING__ALERT(@"请检查网络连接是否正常");
        return;
    }else{
        self.warningView.hidden=YES;
    }
    
    
    if (self.usernameTextField.text.length==0||self.passwordTextField.text.length==0) {
        WARNING__ALERT(@"请将信息填写完整");
        return;
    }
    
    SHOW__LOADING;
    
    LoginNetWork *_login=[[LoginNetWork alloc] init];
    [_login login:self.usernameTextField.text password:self.passwordTextField.text success:^(id responseData){
        
        /****************记录缓存用户名密码*******************/
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        NSMutableDictionary *loginCacheDic=[[NSMutableDictionary alloc] init];
        [loginCacheDic setObject:self.usernameTextField.text forKey:@"username"];
        [loginCacheDic setObject:self.passwordTextField.text forKey:@"password"];
        [writeOperation writeToPlist:LOGINCACHE plistContent:loginCacheDic];
        /****************记录缓存用户名密码*******************/
        
        LoginInfo *loginObject=[[LoginInfo alloc]initWithStatus:responseData];
        
        if (loginObject.success==YES) {
//            LoginBack *_loginBack=[LoginBack objectFromJSONObject:loginObject.res mapping:[LoginBack mapping]];
//            
//            NSMutableDictionary *writeDic=loginObject.res;
            if ([[loginObject.res objectForKey:@"serve_cates"] isEqualToString:@""]) {
                HIDE__LOADING;
                PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
                [writeOperation writeToPlist:WRITEREGIST plistContent:loginObject.res];
                isAllowRegist=YES;
                [self regist:nil];
                return;
            }
            
            _loginDic=loginObject.res;
            
//            SHOW__LOADING;
            
            XMPPManager *manager = [XMPPManager sharedManager];
            
            
            if (!manager.isConnected)
            {
//                NSLog(@"嘿嘿：%@",[_loginDic objectForKey:@"usercode"]);
                manager.currentStatus = CurrentStatusLogin;
                [manager connect:[[_loginDic objectForKey:@"usercode"] stringByAppendingString:@"@task.tojie.com"] password:[_loginDic objectForKey:@"password"] server:@"114.80.101.110"];
//                [manager connect:[[_loginDic objectForKey:@"usercode"] stringByAppendingString:@"@task.tojie.com"] password:@"c5ce8402cf1784e00dbecc515b2d3ce7" server:@"114.80.101.110"];
                manager.loginDelegate = self;
            }
            else
            {
//                HIDE__LOADING;
            }
            
            
//            HIDE__LOADING;
        }else{
            HIDE__LOADING;
            WARNING__ALERT(loginObject.res);
        }
    }failed:^(NSError *error){
//        NSLog(@"报错：%@",error);
        HIDE__LOADING;
        WARNING__ALERT(@"登陆失败，请检查网络是否连接正常");
    }];
}

-(void)add
{
    timeings+=1;
    if (timeings==allTimeValue) {
        timeings=0;
        Notification__POST(GETLOCATION, nil);
    }
}

- (void)dealloc {
    [_login release];
    [_usernameTextField release];
    [_passwordTextField release];
    [_warningView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLogin:nil];
    [self setWarningView:nil];
    [super viewDidUnload];
}
@end
