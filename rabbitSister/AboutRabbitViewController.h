//
//  AboutRabbitViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountCell.h"
#import "SystemNotificationViewController.h"
#import "functionIntroduceViewController.h"
#import "HelpAndFeedbackViewController.h"

@interface AboutRabbitViewController : UIViewController
{
    SystemNotificationViewController    *_systemNotificationVC;
    
    functionIntroduceViewController     *_functionIntroduceVC;
    
    HelpAndFeedbackViewController      *_helperFeed;
}
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;

@end
