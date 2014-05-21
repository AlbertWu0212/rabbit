//
//  functionIntroduceViewController.m
//  employers
//
//  Created by wzb on 13-10-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "functionIntroduceViewController.h"

@interface functionIntroduceViewController ()

@end

@implementation functionIntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mainListArray=[[NSMutableArray alloc] initWithObjects:@"跟雇主实时对讲",@"跟雇主实时通话",@"兔子如何接任务",@"关于保证金",@"记录生活与分享",@"使用流量问题",@"1.0版本功能特性", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    myCollapseClick.CollapseClickDelegate = self;
    [myCollapseClick reloadCollapseClick];
    
    self.navigationItem.title=@"系统通知";
    NAVIGATION_BACK(@"   返回");
}

BACK_ACTION

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfCellsForCollapseClick
{
    return _mainListArray.count;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    return [_mainListArray objectAtIndex:index];
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    
    return nil;
    switch (index) {
        case 0:
            return view1;
            break;
        case 1:
            return view2;
            break;
        case 2:
            return view3;
            break;
            
        default:
            return view1;
            break;
    }
}

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor clearColor];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor blackColor];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
}

//- (void)dealloc {
//    [view1 release];
//    [super dealloc];
//}
- (void)viewDidUnload {
    [view1 release];
    view1 = nil;
    [view2 release];
    view2 = nil;
    [view3 release];
    view3 = nil;
    [super viewDidUnload];
}
- (void)dealloc {
    [view2 release];
    [view3 release];
    [super dealloc];
}
@end
