//
//  MyAccountViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountCell.h"
#import "ServiceSettlementViewController.h"
#import "MarginViewController.h"
#import "MyBankCardViewController.h"

@interface MyAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    ServiceSettlementViewController *_serviceSettlementVC;
    MarginViewController            *_marginVC;
    MyBankCardViewController        *_myBankCardVC;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;

@end
