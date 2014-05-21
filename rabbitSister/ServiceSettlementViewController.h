//
//  ServiceSettlementViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitCreditCell.h"

@interface ServiceSettlementViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *_mainListArr;
    NSMutableArray      *_detailListArr;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;

@end
