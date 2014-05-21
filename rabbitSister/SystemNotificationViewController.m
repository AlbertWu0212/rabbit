//
//  SystemNotificationViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "SystemNotificationViewController.h"

@interface SystemNotificationViewController ()

@end

@implementation SystemNotificationViewController

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
    self.navigationItem.title=@"系统通知";
    
    self.mainListTable.bounces=NO;
    self.mainListTable.backgroundView=nil;
    self.mainListTable.backgroundColor=[UIColor clearColor];
    [self.mainListTable setSeparatorColor:[UIColor clearColor]];
    
    NAVIGATION_BACK(@"   返回");
    // Do any additional setup after loading the view from its nib.
}

BACK_ACTION

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mainListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return 2;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        unwindCell *cell = (unwindCell *)[[[NSBundle mainBundle] loadNibNamed:@"unwindCell" owner:self options:nil] lastObject];
        
        cell.selectionStyle = UITableViewScrollPositionNone;
        UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
    MyAccountCell *cell = (MyAccountCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyAccountCell" owner:self options:nil] lastObject];
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    
    UIView *tempView = [[[UIView alloc] init] autorelease]; [cell setBackgroundView:tempView]; [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.titleLab.text=[_mainListArray objectAtIndex:indexPath.section];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen) {
        if (self.selectIndex.section == indexPath.section) {
            return 150;
        }
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
//    MyAccountCell *cell = (MyAccountCell *)[self.mainListTable cellForRowAtIndexPath:self.selectIndex];
//    [cell changeArrowWithUp:firstDoInsert];
    
    [self.mainListTable beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = 1;
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {
        [self.mainListTable insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.mainListTable deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[rowToInsert release];
	
	[self.mainListTable endUpdates];
//    if (nextDoInsert) {
//        self.isOpen = YES;
//        self.selectIndex = [self.mainListTable indexPathForSelectedRow];
//        [self didSelectCellRowFirstDo:YES nextDo:NO];
//    }
//    if (self.isOpen) [self.mainListTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0.000001f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    return 0.0000001f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
//{
//    return 0.0000001f;
//}

#pragma mark - section间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return [view autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainListTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainListTable:nil];
    [super viewDidUnload];
}
@end
