//
//  UploadNetWork.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

//上传文件
@interface UploadNetWork : RabbitBaseRequester
-(void)upload:(NSString *)type
         data:(NSString *)data
        success:(requesterSuccess)success
        failed:(requesterFailed)failed;

@end
