//
//  PSSFileOperations.m
//  PSS
//
//  Created by Jahnny on 13-5-29.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSFileOperations.h"

@implementation PSSFileOperations

#pragma mark 获取Document路径下的文件/文件夹
-(NSString *)mainPath:(NSString *)path
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *returnPath=[documentDirectory stringByAppendingPathComponent:path];
    return returnPath;
}

#pragma mark 获取mainBundle下的配置文件
+(NSMutableDictionary *)getMainBundlePlist:(NSString *)plistName
{
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSMutableDictionary *mainInfoDic=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    return mainInfoDic;
}

#pragma mark 获取Document路径下的文件的数据，包括数据库操作
-(id)publicFilePerform:(FilePerformType)fileType infoStr:(NSString *)infoStr extension:(id)extension
{
//    NSMutableDictionary *tempDic=nil;
//    NSDictionary        *compareDic=nil;
    id data=nil;
    
    switch (fileType) {
        case PSSFileOperationsPlist:
            data=[self plistInfo];
            break;
            
        case PSSFileOperationsPlistExecute:
            [self writePlist:extension];
            break;
            
        case PSSFileOperationsDatabaseSelect:
            [self dbStart];
            data=[self dbSelect:infoStr selectField:extension];
            [self dbClose];
            break;
            
        case PSSFileOperationsDatabaseExecute:
            [self dbStart];
            data=[NSNumber numberWithBool:[self dbExecute:infoStr]];
            [self dbClose];
            break;
            
        default:
            break;
    }
    return data;
}

#pragma mark 写入指定plistName的配置文件，内容为plistContent
-(void)writeToPlist:(NSString *)plistName plistContent:(NSMutableDictionary *)plistContent
{
    [plistContent writeToFile:[self mainPath:[NSString stringWithFormat:@"%@.plist",plistName]] atomically:YES];
    
}

#pragma mark 获取配置文件数据，PSSFileOperationsPlist
-(NSMutableDictionary *)plistInfo
{
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithContentsOfFile:[self mainPath:@"RabbitSisterPlist.plist"]];
    if (tempDic.count==0) {
        [tempDic release];
        tempDic=nil;
        tempDic=[[NSMutableDictionary alloc] init];
        [tempDic setObject:@"0" forKey:@"isFirst"];
        
        NSArray *imgArr=[[NSArray alloc] initWithObjects:@"Tutorial0",@"Tutorial1",@"Tutorial2",@"Tutorial3",@"Tutorial4", nil];
        
        [tempDic setObject:imgArr forKey:@"TutorialImages"];
        
        [tempDic writeToFile:[self mainPath:@"RabbitSisterPlist.plist"] atomically:YES];
    }
    return tempDic;
}

#pragma mark 将数据写入配置文件，PSSFileOperationsPlistExecute
-(void)writePlist:(NSDictionary *)extension
{
    NSDictionary  *compareDic=[[NSDictionary alloc] initWithDictionary:extension];
    
    if (compareDic==nil||compareDic.count==0) {
        return;
    }
    
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] initWithContentsOfFile:[self mainPath:@"RabbitSisterPlist.plist"]];
    
    if (tempDic.count==0) {
        [self publicFilePerform:PSSFileOperationsPlist infoStr:nil extension:nil];
        [self publicFilePerform:PSSFileOperationsPlistExecute infoStr:nil extension:nil];
    }else{
        for (int i=0; i<compareDic.allKeys.count; i++) {
            [tempDic setObject:[compareDic objectForKey:[compareDic.allKeys objectAtIndex:i]] forKey:[compareDic.allKeys objectAtIndex:i]];
        }
        
        [tempDic writeToFile:[self mainPath:@"RabbitSisterPlist.plist"] atomically:YES];
        [compareDic release];
        compareDic=nil;
        [tempDic release];
        tempDic=nil;
    }
}

#pragma mark 数据库操作
#pragma mark 开启数据库
-(void)dbStart
{
//    NSString *dbPath=[self mainPath:@"plists.db"];
    NSString *dbPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"plists.db"];;
    db=[FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"error");
    }
}

#pragma mark 查询数据
-(NSMutableArray *)dbSelect:(NSString *)sql selectField:(NSMutableArray *)selectField;
{
    rs=[db executeQuery:sql];
    
    NSMutableArray *tempResult=[[NSMutableArray alloc]init];
   
    while ([rs next]) {
        NSMutableDictionary *getInfoDic=[[NSMutableDictionary alloc] init];
        for (int i=0; i<selectField.count; i++) {
            [getInfoDic setObject:[rs stringForColumn:[selectField objectAtIndex:i]] forKey:[selectField objectAtIndex:i]];
            
        }
        [tempResult addObject:getInfoDic];
        [getInfoDic release];
        getInfoDic=nil;
    }
    
    return tempResult;
}

#pragma mark 数据其他操作(增删改)
-(BOOL)dbExecute:(NSString *)sql
{
    
    if ([db executeUpdate:sql]) {
        
        return YES;
    }else{
        
        return NO;
    }
}

#pragma mark 关闭数据库
-(void)dbClose
{
    if (db) {
        [db close];
    }
    if (rs) {
        [rs close];
    }
}

@end
