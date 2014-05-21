//
//  VersionUpload.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-24.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "PSSBaseRequester.h"

@interface VersionUpload : PSSBaseRequester

-(void)getVerson:(requesterSuccess)success
          failed:(requesterFailed)failed;

@end
