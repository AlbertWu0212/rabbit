//监听事件汇总
//创建监听
#define Notification__CREATE(functionName,Notificat) [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(functionName:) name:Notificat object:nil]
//获取监听
#define Notification__POST(Notificat,userInfomation) [[NSNotificationCenter defaultCenter] postNotificationName:Notificat object:nil userInfo:userInfomation];
//去除监听
#define Notification__REMOVE [[NSNotificationCenter defaultCenter] removeObserver:self];

#define FINDWORKBACK @"FindWorkBack"
#define REGISTCHOOSEMENU @"RegistChooseMenu"
#define REGISTCHOOSEOVER @"RegistChooseOver"
#define REGISTSUCCESS @"RegistSuccess"
#define NOLOCATION @"NoLocation"

#define HIDENAV @"HideNav"
#define SHOWNAV @"ShowNav"

//兔子“我的”页面跳转监听
#define PERSONALPUSH @"PersonalPush"
#define CREDITPUSH @"CreditPush"
#define MYACCOUNT @"MyAccount"
#define SETUP @"SetUp"
#define SPEAKER @"Speak"

//隐藏NavBar
#define NAVIGATIONBARHIDE @"navigationBarHide"

//评论返回
#define EVABACKMAIN @"EvaBakMain"

//详情跳转
#define SUBMITINFO @"SubmitInfo"

#define MATTERDETAIL @"MatterDetail"

//帮帮兔逻辑
#define HELPERRABBIT @"HelperRabbit"
#define HELPERBACK @"HelperBack"

//聊天获取历史信息
#define GETHISTORYSPEAK @"GetHistorySpeak"
#define OVERGETSPEAK @"OverGetSpeak"

//改变登陆状态
#define CHANGESTATUS @"ChangeStatus"

//有信息通知
#define SPEAKERSNOTICE @"SpeakerNotice" 
#define OVERNOTICE @"OverNotice"

//获取定位
#define GETLOCATION @"GetLocation"

        //取消任务
#define NOMARLNOTICE @"NomrlNotice"
#define CANCELMISSION @"CancelMission"

        //取消任务
#define EMPOLYERCANCELMISSION @"EmpolyerCancelMission"

        //选定兔子
#define CHOOSERABBIT @"ChooseRabbit"

        //发布任务
#define PUBLISHMISSION @"PublishMission"

//动画特效数列
typedef enum{
	moving = 0,
    alpha,
} Animations;

//注册用户类型
typedef enum{
	runer = 0,
    driver,
    helper,
    hotHeart,
} RegisterType;

//帮帮兔类型
typedef enum{
    houseKeeping= 0,
    care,
    beauty,
    repair,
} helperRabbitType;

//任务类型
typedef enum{
    emergency= 0,
    today,
    subscribe,
} missionType;

//标的状态
typedef enum{
    bidding= 0,
    winning,
    finishing,
} missionStatusType;


//写入的配置文件名字
#define WRITEREGIST @"WriteRegist"  //注册
#define WRITELOGIN  @"WriteLogin"   //登陆
#define LOGINCACHE  @"LoginCache"   //登陆缓存（记住用户名和密码）
#define DEVICETOKEN @"DeviceToken"  //deviceToken

#pragma mark - section间隔
#define TABLESECTIONHEIGHT(heightRect) -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return heightRect;}- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{return 1;}- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {UIView *view=[[UIView alloc] initWithFrame:CGRectZero];return [view autorelease];}- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {UIView *view=[[UIView alloc] initWithFrame:CGRectZero];return [view autorelease];}


//临时设置
//#define RequestInterfaceTypeLogin "user.php?"
#define RequestInterfaceTypeLogin ""
#define BaseHTTPClient_GET 0        //判断get传送数据
#define BaseHTTPClient_POST 1       //判断post传送数据


//调用全局函数
#define APPDELEGATEING rabbitAppDelegate *delegates =(rabbitAppDelegate *)[UIApplication sharedApplication].delegate;

//返回按钮
//#define NAVIGATION_BACK(backString) UIBarButtonItem*backItem=[[UIBarButtonItem alloc]init];backItem.title=backString;self.navigationItem.backBarButtonItem=backItem;[backItem release];
#define NAVIGATION_BACK(backString) UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];[button setBackgroundImage:[UIImage imageNamed:@"navigationBackBtn.png"] forState:UIControlStateNormal];[button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];button.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Medium" size:12];[button setTitle:backString forState:UIControlStateNormal];button.frame = CGRectMake(0, 0, 55, 27);UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];self.navigationItem.leftBarButtonItem = menuButton;

#define BACK_ACTION -(void)backAction{[self.navigationController popViewControllerAnimated:YES];}


//小转子
#define SHOW__LOADING [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#define HIDE__LOADING [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


//Hud各类提示/警告框
#define WARNING__ALERT(warningText) BasePublicClient *basePublicClient=[[BasePublicClient alloc]init];[basePublicClient publicAlert:warningText view:self.view];[basePublicClient release];

//获取Document文件地址，都要首先声明字典plistDic
#define DOC__PLIST PSSFileOperations *_PSSFileOperations=[[PSSFileOperations alloc]init];plistDic=[[NSMutableDictionary alloc]initWithDictionary:[_PSSFileOperations publicFilePerform:0 infoStr:nil extension:nil]];[_PSSFileOperations release];

//综合SQL语句类，参数perform，2为查询，3为编辑
#define SQL__STATEMENT(perform,info,exten) publicFilePerform:perform infoStr:info extension:exten
