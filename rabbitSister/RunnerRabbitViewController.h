//
//  RunnerRabbitViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-8.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RunnerRabbitCell.h"

@interface RunnerRabbitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_mainInfoArr;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTab;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;

@end
