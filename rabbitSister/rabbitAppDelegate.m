//
//  rabbitAppDelegate.m
//  rabbitSister
//
//  Created by Jahnny on 13-8-28.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "rabbitAppDelegate.h"
#import "AFNetworking.h"
#import "Base64.h"
#import "PSSFileOperations.h"

#import <MAMapKit/MAMapKit.h>

//服务器崩溃
#import "ChatViewController.h"

@implementation rabbitAppDelegate
static bool isLogin=NO;

@synthesize speakerTimeArr=_speakerTimeArr;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
    OSStatus securityError = errSecSuccess;
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"123456" forKey:(id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"Get document path:%@",[documentsPaths objectAtIndex:0]);
    
    [MAMapServices sharedServices].apiKey = @"df653578c0349768e7c43c866a95c448";
    
    PSSFileOperations *operations=[[PSSFileOperations alloc] init];
    
    NSMutableDictionary *mainInfoDic=[operations publicFilePerform:PSSFileOperationsPlist infoStr:nil extension:nil];
    //    RabbitSisterPlist
    self.window.backgroundColor = [UIColor whiteColor];
    //    int a=sqrt(4);
    //    NSLog(@"呵呵：%d",a);
    _rabbitLoginVC=[[LoginViewController alloc] init];
    
    if ([[mainInfoDic objectForKey:@"isFirst"] intValue]==0) {
        [mainInfoDic setObject:@"1" forKey:@"isFirst"];
        
        [operations publicFilePerform:PSSFileOperationsPlistExecute infoStr:nil extension:mainInfoDic];
        
        _tutorialVC=[[TutorialViewController alloc] init];
        _navC=[[UINavigationController alloc] initWithRootViewController:_tutorialVC];
    }else{
        _navC=[[UINavigationController alloc] initWithRootViewController:_rabbitLoginVC];
    }
    
    _speakerTimeArr=[[NSMutableArray alloc] init];
    //服务器崩溃
//    ChatViewController *chatVC=[[ChatViewController  alloc] init];
//    _navC=[[UINavigationController alloc] initWithRootViewController:chatVC];
    
    
    //将post数据转换为 NSASCIIStringEncoding 编码格式
//    NSString *postString=@"initWithMethod=user.Login&password=ownerblood&useRpc=1&userkey=0bb2cb1f2a52&username=forbid10";
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//    
//    [request setURL:[NSURL URLWithString:@"http://api.tojie.com/user.php"]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postData];
//    NSURLResponse** response = NULL;
//    NSData* data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:response error:nil];
//    NSString* strRet = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"strRet=%@",strRet);
    
    
    
    //黑色navigation
    _navC.navigationBar.barStyle=UIBarStyleBlack;
    
    
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationTitle.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    self.window.rootViewController=_navC;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _navC.navigationBar.translucent = NO;
        _navC.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    //创建声音下载类目
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *voiceDirectory = [documentsDirectory stringByAppendingPathComponent:@"downloadVoice"];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:voiceDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:voiceDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    //聊天类目
    NSString *chatDirectory = [documentsDirectory stringByAppendingPathComponent:@"Chat"];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:chatDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:chatDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    Notification__CREATE(NotificationChangeLogin,CHANGESTATUS);
    _xmppManager = [XMPPManager sharedManager];
    
    return YES;
}

#pragma mark - 监听事件(刷新)
- (void)NotificationChangeLogin:(NSNotification *) notification
{
    isLogin=YES;
}

#pragma mark --- 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    int systemVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    if (systemVersion < 5) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送"
//                                                            message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确认"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
        
    }
    
	int iv =  [[userInfo objectForKey:@"badge"] intValue] ;
    if(iv >0)[application setApplicationIconBadgeNumber:iv ];

}
//--@jia

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    
    
    token =[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token =[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token =[token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"token %@", token) ; // @jia
    
    NSMutableDictionary     *tokenDic=[[NSMutableDictionary alloc] init];
    [tokenDic setObject:token forKey:@"token"];
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    [writeOperation writeToPlist:DEVICETOKEN plistContent:tokenDic];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.window endEditing:YES];
    [_xmppManager disconnect];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    if (isLogin==NO) {
        return;
    }
    //回来重新连接
    //获取个人信息
    PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
    NSMutableDictionary *loginInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    
    
    if (!_xmppManager.isConnected)
    {
        _xmppManager.currentStatus = CurrentStatusLogin;
        
        [_xmppManager connect:[[loginInfo objectForKey:@"usercode"] stringByAppendingString:@"@task.tojie.com"] password:[loginInfo objectForKey:@"password"] server:@"114.80.101.110"];
        _xmppManager.loginDelegate = self;
    }
    else
    {
        
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark - XMPP
-(void)loginStatusCallBack:(BOOL)successed error:(NSXMLElement *)error
{
    NSLog(@"\n%s %@\nerror:%@",__func__,successed?@"登录成功":@"登录失败",successed?@"nil":error);
    [_xmppManager.chatDelegates addObject:self];
}

#pragma mark XMPPChatDelegate
-(void)didRecieveMessage:(XMPPMessage *)message
{
    NSLog(@"%s",__func__);
    NSString *bodyStr=[[message elementForName:@"body"] stringValue];
    NSLog(@"获取信息是：%@",bodyStr);
}

#pragma mark - 截取字符串
-(NSString *)cutStr:(NSString *)cutOrign cutStrs:(NSString *)cutStrs page:(int)page
{
    NSArray  *tempArray = [cutOrign componentsSeparatedByString:cutStrs];
    return [tempArray objectAtIndex:page];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
