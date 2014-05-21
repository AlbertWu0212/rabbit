//
//  functionIntroduceViewController.h
//  employers
//
//  Created by wzb on 13-10-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"

@interface functionIntroduceViewController : UIViewController <CollapseClickDelegate>
{
    __weak IBOutlet CollapseClick *myCollapseClick;
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    
    NSMutableArray          *_mainListArray;
}

@end
