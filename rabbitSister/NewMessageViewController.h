//
//  NewMessageViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMessageCell.h"

@interface NewMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;

@end
