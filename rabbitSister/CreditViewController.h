//
//  CreditViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitCreditCell.h"

@interface CreditViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray      *_allCredInfo;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;
@property (retain, nonatomic) IBOutlet UIImageView *levelImg;

@end
