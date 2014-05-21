//
//  MarginViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitCreditCell.h"

@interface MarginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_mainMarginArr;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;
@property (retain, nonatomic) IBOutlet UILabel *moneyLab;

@end
