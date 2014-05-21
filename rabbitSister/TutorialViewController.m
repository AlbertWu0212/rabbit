//
//  TutorialViewController.m
//  rabbitSister
//
//  Created by Jahnny on 13-10-23.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "TutorialViewController.h"
#import "PSSFileOperations.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    PSSFileOperations *operations=[[PSSFileOperations alloc] init];
    NSMutableDictionary *mainInfoDic=[operations publicFilePerform:PSSFileOperationsPlist infoStr:nil extension:nil];
    
    NSArray *imgArr=[mainInfoDic objectForKey:@"TutorialImages"];
    self.mainScrollView.contentSize=CGSizeMake(320*imgArr.count, self.view.frame.size.height);
    self.mainScrollView.pagingEnabled=YES;
    self.mainScrollView.bounces=NO;
    
    for (int i=0; i<imgArr.count; i++) {
        UIImageView *addImg;
        if (IS_IPHONE_5) {
            addImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tutorial%d.png",i]]];
            addImg.frame=CGRectMake(320*i, 0, 320, 568);
        }else{
            addImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Tutorial%dPhone4.png",i]]];
            addImg.frame=CGRectMake(320*i, 0, 320, 480);
        }
        
        [self.mainScrollView addSubview:addImg];
        
        if (i==imgArr.count-1) {
            UIButton *clickBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            if (IS_IPHONE_5) {
                clickBtn.frame=CGRectMake(320*i+60, 478, 200,30 );
            }else{
                clickBtn.frame=CGRectMake(320*i+50, 410, 200,30 );
            }
            
            [clickBtn addTarget:self action:@selector(over) forControlEvents:UIControlEventTouchUpInside];
            [self.mainScrollView addSubview:clickBtn];
        }
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)over
{
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x>scrollView.contentSize.width-320+80) {
//        
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mainScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainScrollView:nil];
    [super viewDidUnload];
}
@end
