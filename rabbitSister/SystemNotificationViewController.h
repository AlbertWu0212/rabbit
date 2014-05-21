//
//  SystemNotificationViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountCell.h"
#import "unwindCell.h"

@interface SystemNotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray          *_mainListArray;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@end
