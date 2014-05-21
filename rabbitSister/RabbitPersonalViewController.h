//
//  RabbitPersonalViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-9-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitPersonalCell.h"

@interface RabbitPersonalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray          *_mainInfoArr;
    
    NSMutableDictionary     *_personalDic;
}
@property (retain, nonatomic) IBOutlet UITableView *personalTableView;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImg;

@end
