//
//  MyAccountCell.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-16.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UIImageView *chooseImg;

- (void)changeArrowWithUp:(BOOL)up;

@end
