//
//  NewMessageViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "NewMessageViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import "openCloseNotifaction.h"

@interface NewMessageViewController ()

@end

@implementation NewMessageViewController
static int push_switch=0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        PSSFileOperations *writeOperation=[[PSSFileOperations alloc] init];
        NSMutableDictionary *registInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:[writeOperation mainPath:[NSString stringWithFormat:@"%@.plist",WRITELOGIN]]];
        push_switch=[[registInfo objectForKey:@"push_switch"] intValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainListTable.backgroundColor=[UIColor clearColor];
    self.mainListTable.backgroundView=nil;
    
    NAVIGATION_BACK(@"   返回");
    self.navigationItem.title=@"新消息通知";
    
    //震动
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMessageCell *cell = (NewMessageCell *)[[[NSBundle mainBundle] loadNibNamed:@"NewMessageCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
//    switch (indexPath.section) {
//        case 0:
//            cell.titleLab.text=@"接收新消息通知";
//            cell.openLab.hidden=NO;
//            cell.menuSwich.hidden=YES;
//            break;
//            
//        case 1:
//            cell.titleLab.text=@"通知不显示消息详情";
//            break;
//            
//        case 2:
//            cell.titleLab.text=@"功能消息免打扰";
//            cell.menuSwich.hidden=YES;
//            break;
//            
//        case 3:
//            if (indexPath.row==0) {
//                cell.titleLab.text=@"声音";
//            }else{
//                cell.titleLab.text=@"振动";
//            }
//            break;
//            
//        case 4:
//            cell.titleLab.text=@"朋友圈照片更新";
//            break;
//            
//        default:
//            break;
//    }
    [cell.menuSwich addTarget:self action:@selector(chooseing:) forControlEvents:UIControlEventTouchUpInside];
    switch (indexPath.section) {
        case 0:
            cell.titleLab.text=@"通知显示消息详情";
            cell.menuSwich.tag=0;
            if (push_switch==0) {
                [cell.menuSwich setOn:NO];
            }else{
                [cell.menuSwich setOn:YES];
            }
            break;
            
        case 1:
            if (indexPath.row==0) {
                cell.titleLab.text=@"声音";
                cell.menuSwich.tag=1;
            }else{
                cell.titleLab.text=@"振动";
                cell.menuSwich.tag=2;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (void) chooseing:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    int switchType=0;
    if (control.isOn==YES) {
        switchType=1;
    }else{
        switchType=0;
    }
    
    openCloseNotifaction *notifaction=[[openCloseNotifaction alloc] init];
    switch (control.tag) {
        case 0:
            //调用禁用推送接口
            [notifaction notifactionSet:[NSString stringWithFormat:@"%d",switchType] success:^(id responseData) {
                
            } failed:^(NSError *error) {
                
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
    [_mainListTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [super viewDidUnload];
}
@end

//[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
