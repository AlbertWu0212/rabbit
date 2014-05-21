//
//  HelperRabbitViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperRabbitCell.h"
#import "HelperRabbitDetailViewController.h"

@interface HelperRabbitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_mainInfoArr;
    
    HelperRabbitDetailViewController    *_helperRabbitDetailVC;
    
    NSMutableArray      *_pricesArr;
}
@property (retain, nonatomic) IBOutlet UITableView *mianListTable;

@end
