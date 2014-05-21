//
//  MarginList.h
//  rabbitSister
//
//  Created by Jahnny on 13-12-5.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "RabbitBaseRequester.h"

@interface MarginList : RabbitBaseRequester
-(void)MargList:(NSString *)page
          success:(requesterSuccess)success
           failed:(requesterFailed)failed;
@end
