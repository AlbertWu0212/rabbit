//
//  PSSFileOperations.h
//  PSS
//
//  Created by Jahnny on 13-5-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

typedef enum{
	PSSFileOperationsPlist = 0,
    PSSFileOperationsPlistExecute,
	PSSFileOperationsDatabaseSelect,
    PSSFileOperationsDatabaseExecute,
} FilePerformType;


@interface PSSFileOperations : NSObject
{
    FMDatabase      *db;//数据库
    FMResultSet     *rs;
}

-(void)writeToPlist:(NSString *)plistName plistContent:(NSMutableDictionary *)plistContent;

-(NSString *)mainPath:(NSString *)path;//获取Document路径下的文件/文件夹

+(NSMutableDictionary *)getMainBundlePlist:(NSString *)plistName;//获取mainBundle下的配置文件

-(id)publicFilePerform:(FilePerformType)fileType infoStr:(NSString *)infoStr extension:(id)extension;//文件操作处理，fileType字段：0为配置文件，1为数据库，infoStr为当涉及数据操作时的SQL语句，extension为附属扩展，可为任何类型

@end
