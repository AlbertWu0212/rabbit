//
//  UploadInfo.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-31.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>

//上传文件返回数据
@interface UploadInfo : NSObject

@property(assign)BOOL success;
@property(assign)id url;

-(id)initWithStatus:(id)Status;

@end
