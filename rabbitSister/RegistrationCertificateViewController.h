//
//  RegistrationCertificateViewController.h
//  rabbitSister
//
//  Created by Jahnny on 14-3-4.
//  Copyright (c) 2014年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationCertificateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    NSMutableArray          *_mainInfoArr;
    
    NSMutableArray          *_typeOneArr;
    NSMutableArray          *_typeTwoArr;
    
    NSMutableDictionary     *_allInfo;
    
    UIImageView             *_cellBackgroundImage;
}

- (id)initWithArray:(NSMutableArray *)getArray allInfo:(NSDictionary *)allInfo isAllowEdit:(BOOL)isAllowEdit;
@property (retain, nonatomic) IBOutlet UITableView *mainListTable;

@end
