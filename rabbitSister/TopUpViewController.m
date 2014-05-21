//
//  TopUpViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "TopUpViewController.h"
#import "XMLRPCResult.h"
#import "TopUpRequest.h"

//支付宝
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@interface TopUpViewController ()

@end

@implementation TopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithMoney:(NSString *)money
{
    self=[super init];
    if (self) {
        _moneyStr=money;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moneyLab.text=_moneyStr;
    NAVIGATION_BACK(@"   返回");
    
    self.navigationItem.title=@"充值";
    // Do any additional setup after loading the view from its nib.
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
            WARNING__ALERT(@"交易成功");
//            NSString* key = @"签约帐户后获取到的支付宝公钥";
//            NSLog(@"交易陈工");
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
            WARNING__ALERT(@"交易失败");
            //交易失败
        }
    }
    else
    {
        WARNING__ALERT(@"交易失败");
        //失败
    }
    
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

#pragma mark - 验证价格
-(BOOL)isValidateMoney:(NSString *)money {  //正则验证
    NSString *idCardRegex = @"^[1-9]\\d*$";
    
    NSPredicate *idCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
    if ([idCardTest evaluateWithObject:money]==YES) {
        return YES;
    }else{
        idCardRegex = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
        idCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
        return [idCardTest evaluateWithObject:money];
        
    }
    
}

#pragma mark - 提交保证金
- (IBAction)submitTopUp:(id)sender {
    [self.view endEditing:YES];
    if (self.topUpField.text.length==0) {
        WARNING__ALERT(@"金额不能为空");
        return;
    }
    
    if ([self isValidateMoney:self.topUpField.text]==NO) {
        WARNING__ALERT(@"填写价格格式不正确");
        return;
    }
    
    SHOW__LOADING
    
    TopUpRequest    *topup=[[TopUpRequest alloc] init];
    [topup topUp:[NSString stringWithFormat:@"%.2f",[self.topUpField.text floatValue]] user_note:@"兔子充值" success:^(id responseData) {
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
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
            order.tradeNO = [RPCResult.res objectForKey:@"pay_sn"]; //订单ID（由商家自行制定）
            order.productName = @"兔子充值"; //商品标题
            order.productDescription = @"兔子充值"; //商品描述
            order.amount = [NSString stringWithFormat:@"%.2f",[self.topUpField.text floatValue]]; //商品价格
            order.notifyURL =  @"http://pay.tojie.com/alipay/notify_url.php"; //回调URL
            NSString *orderInfo = [order description];
            NSString* signedStr = [self doRsa:orderInfo];
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderInfo, signedStr, @"RSA"];
            //模拟器
            [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        }else{
            HIDE__LOADING
            WARNING__ALERT(RPCResult.res);
        }
        NSLog(@"哈哈：%@",responseData);
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
    [_moneyLab release];
    [_topUpField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMoneyLab:nil];
    [self setTopUpField:nil];
    [super viewDidUnload];
}
@end
