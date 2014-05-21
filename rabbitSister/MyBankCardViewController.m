//
//  MyBankCardViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "BankCardRequest.h"

@interface MyBankCardViewController ()

@end

@implementation MyBankCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //获取个人信息
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        _loginInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addCardView.hidden=YES;
    self.cardView.hidden=NO;
    
    self.navigationItem.title=@"我的银行卡";
    
    if ([[_loginInfo objectForKey:@"bank_account"] isEqualToString:@""]) {
        self.cardView.hidden=YES;
        self.addCardView.hidden=NO;
    }else{
        self.cardView.hidden=NO;
        self.addCardView.hidden=YES;
        
        self.bankCardLab.text=[_loginInfo objectForKey:@"bank_account"];
        self.bankNameLab.text=[_loginInfo objectForKey:@"bank_name"];
    }
    
    NAVIGATION_BACK(@"   返回");
    
    
    
    CGRect frameimgRight = CGRectMake(0, 0, 55, 27);
    UIButton *RightBtn = [[UIButton alloc] initWithFrame:frameimgRight];
    [RightBtn setBackgroundImage:[UIImage imageNamed:@"nextNavBtn.png"]
                       forState:UIControlStateNormal];
    RightBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Medium" size:12];
    [RightBtn setTitle:@"修改" forState:UIControlStateNormal];[RightBtn setBackgroundImage:Nil forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(changes) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc]initWithCustomView:RightBtn];self.navigationItem.rightBarButtonItem = btnRight;
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
//    NSLog(@"123123");
    [self.navigationController popViewControllerAnimated:YES];
}
//BACK_ACTION

- (IBAction)tempClick:(id)sender {
    self.addCardView.hidden=NO;
    self.cardView.hidden=YES;
}

-(void)changes
{
    self.cardView.hidden=YES;
    self.addCardView.hidden=NO;
}

- (IBAction)change:(id)sender {
    self.cardView.hidden=YES;
    self.addCardView.hidden=NO;
}

#pragma mark - 验证价格
-(BOOL)isValidateMoney:(NSString *)money {  //正则验证
    NSString *idCardRegex = @"^[0-9]$";
    
    NSPredicate *idCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
    return [idCardTest evaluateWithObject:money];
    
}

- (IBAction)submit:(id)sender {
    [self.view endEditing:YES];
    if (self.bankCardField.text.length==0||self.bankNameField.text.length==0) {
        WARNING__ALERT(@"请将信息填写完整");
        return;
    }
    
    if (self.bankCardField.text.length<10||self.bankCardField.text.length>25) {
        WARNING__ALERT(@"银行卡格式错误");
        return;
    }
    
    SHOW__LOADING
    BankCardRequest     *bankCard=[[BankCardRequest alloc] init];
    
    [bankCard binddingBank:self.bankCardField.text bank_name:self.bankNameField.text success:^(id responseData) {
        
        XMLRPCResult *RPCResult=[[XMLRPCResult alloc]initWithStatus:responseData];
        if (RPCResult.success==YES) {
            HIDE__LOADING
//            WARNING__ALERT([RPCResult.res objectForKey:@"res"]);
            WARNING__ALERT(@"修改成功");
            self.cardView.hidden=NO;
            self.bankCardLab.text=[RPCResult.res objectForKey:@"bank_account"];
            self.bankNameLab.text=self.bankNameField.text;
            self.addCardView.hidden=YES;
            
            [_loginInfo setObject:[RPCResult.res objectForKey:@"bank_account"] forKey:@"bank_account"];
            [_loginInfo setObject:self.bankNameField.text forKey:@"bank_name"];
            PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
            [writeOperation writeToPlist:WRITELOGIN plistContent:_loginInfo];
        }else{
            HIDE__LOADING
            WARNING__ALERT(RPCResult.res);
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
    [_cardView release];
    [_addCardView release];
    [_bankCardField release];
    [_bankNameField release];
    [_bankNameLab release];
    [_bankCardLab release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCardView:nil];
    [self setAddCardView:nil];
    [self setBankCardField:nil];
    [self setBankNameField:nil];
    [self setBankNameLab:nil];
    [self setBankCardLab:nil];
    [super viewDidUnload];
}
@end
