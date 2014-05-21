//
//  SetUpViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountCell.h"
#import "AboutRabbitViewController.h"
#import "NewMessageViewController.h"

@interface SetUpViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    AboutRabbitViewController   *_aboutRabbitVC;
    NewMessageViewController    *_newMessageVC;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;

@end
