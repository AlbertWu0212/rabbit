//
//  XMPPManager.m
//  ChatClient
//
//  Created by Zhou.Bin on 12-12-27.
//  Copyright (c) 2012年 Zhou.Bin. All rights reserved.
//

#import "XMPPManager.h"

#import "GTMBase64.h"
#import "GTMDefines.h"

@implementation XMPPManager

-(NSString *)description
{
    NSString *des = [NSString stringWithFormat:@"\
                     \n**\
                     \n* userID:%@\
                     \n* password:%@\
                     \n* server:%@\
                     \n**",_userID,_password,_serverStr];
    
    return des;
}

-(id)init
{
    self = [super init];
    if (self) {
        _rosters = [NSMutableDictionary new];
        _chatDelegates = (NSMutableArray<XMPPChatDelegate> *)[NSMutableArray new];
    }
    return self;
}

-(void)dealloc
{
    [_userID release];
    [_password release];
    [_serverStr release];
    [_rosters release];
    [_chatDelegates release];
    [_xmppReconnect release];
    [super dealloc];
}

#pragma mark -
#pragma mark properties
-(BOOL)isConnected
{
    NSLog(@"%s",__func__);
    return _xmppStream.isConnected;
}

+ (id)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

#pragma mark - 
#pragma mark registe new account
-(void)registerNewAccountWithPassword:(NSString *)password
{
    [self disconnect];
    [self anonymousConnect];
}

#pragma mark -
#pragma mark Change Status Methods

-(void)setupStream
{
    if (!_xmppStream)
    {
        _xmppStream = [[XMPPStream alloc] init];
        
#if !TARGET_IPHONE_SIMULATOR
        
        _xmppStream.enableBackgroundingOnSocket = YES;
        
#endif
        
        //激活重连功能
        _xmppReconnect = [[XMPPReconnect alloc] init];
        
        [_xmppReconnect activate:_xmppStream];
    
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    }
    
}

/**
 * 设置相关参数
 * 用户id、服务器地址、服务器端口
 * 
 * 在注册新用户时，需要预先设置
 */
-(void)setUserID:(NSString *)userID server:(NSString *)server password:(NSString *)password
{
    _userID = [userID copy];
    _password = [password copy];
    _serverStr = [server copy];
    
    //设置用户
    [_xmppStream setMyJID:[XMPPJID jidWithString:userID]];
    
    //设置服务器
    [_xmppStream setHostName:server];
    
    [_xmppStream setHostPort:5222];
    
    //密码
    _password = password;

}

/**
 * 用于注册时的匿名连接服务器
 */
-(BOOL)anonymousConnect
{
    [self setupStream];
    
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    [self setUserID:@"anonymous@163.com" server:@"127.0.0.1" password:@""];
    
    //连接服务器
    NSError *error = nil;
    if (![_xmppStream connect:&error]) {
        return NO;
    }
    
    return YES;

}

-(BOOL)connect:(NSString *)userID password:(NSString *)password server:(NSString *)server
{
    
    [self setupStream];
    
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    if (userID == nil || password == nil) {
        return NO;
    }
    
    [self setUserID:userID server:server password:password];
        
    //连接服务器
    NSError *error = nil;
    if (![_xmppStream connect:&error]) {
        NSLog(@"\ncant connect %@\nerror:%@", server,error);
        return NO;
    }
    
    return YES;
}

-(void)disconnect
{
    [self goOffline];
    [_xmppStream disconnect];
}


-(void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

-(void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

-(void)sendMessageTo:(NSString *)jid message:(NSString *)message type:(NSString *)type voice:(NSString *)voice img:(NSString *)img BNumber:(NSString *)BNumber status:(NSString *)status from:(NSString *)from
{
//    if (message.length > 0) {
    
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        //        [body setStringValue:message];
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:type];
        [mes addAttributeWithName:@"to" stringValue:jid];
        [mes addAttributeWithName:@"from" stringValue:from];
//        [mes addAttributeWithName:@"from" stringValue:@"500000001@task.tojie.com"];
        [mes addChild:body];
    
    //状态
        NSXMLElement *Status = [NSXMLElement elementWithName:@"Status"];
        [Status setStringValue:status];
    
        //订单编号
        NSXMLElement *BNumbers = [NSXMLElement elementWithName:@"bnumber"];
        [BNumbers setStringValue:BNumber];
//        [body addChild:BNumber];

        //内容文字
        NSXMLElement *Info = [NSXMLElement elementWithName:@"Info"];
        if (message.length==0) {
            [Info setStringValue:@"-1"];
        }else{
            [Info setStringValue:message];
        }
//        [body addChild:Info];
    
        
        //时间
        //获得系统时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        //        [dateformatter setDateFormat:@"HH:mm"];
        //        NSString *  locationString=[dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *  morelocationString=[dateformatter stringFromDate:senddate];
//        NSLog(@"时间是：%@",morelocationString);
    
        NSXMLElement *DataTime = [NSXMLElement elementWithName:@"DataTime"];
        [DataTime setStringValue:morelocationString];
//        [body addChild:DataTime];
    
        //声音
        NSXMLElement *Voice = [NSXMLElement elementWithName:@"Voice"];
        if (voice.length>0) {
            [Voice setStringValue:voice];
        }else{
            [Voice setStringValue:@"-1"];
        }
//        [body addChild:Voice];
    
        //图片
        NSXMLElement *Img = [NSXMLElement elementWithName:@"Img"];
        if (img.length>0) {
            [Img setStringValue:img];
        }else{
            [Img setStringValue:@"-1"];
        }
//        [body addChild:Img];
    
    
        NSString *postStr=[NSString stringWithFormat:@"%@%@%@%@%@%@",BNumbers,Info,DataTime,Voice,Img,Status];
    
    
    //加密
//    NSData *plainData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
//    postStr = [plainData base64EncodedStringWithOptions:0];
    
    
        [body setStringValue:postStr];
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    
//    NSString *abc=[NSString stringWithFormat:@"<BNumber>123456</BNumber>"];
//    message=[NSString stringWithFormat:@"%@%@",message,abc];
//    
//    [body setStringValue:message];
//    
//    
////    NSXMLElement *BNumber = [NSXMLElement elementWithName:@"BNumber"];
////    [BNumber setStringValue:@"123456"];
////    [mes addChild:BNumber];
//    
//    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
//    
//    //消息类型
//    [mes addAttributeWithName:@"type" stringValue:@"chat"];
//    [mes addAttributeWithName:@"to" stringValue:jid];
//    //自定义属性
//    [mes addAttributeWithName:@"subtype" stringValue:@"chat"];
//    //////////////////////////////////////////////////////////
//    [mes addAttributeWithName:@"from" stringValue:@""];
//    
//    [mes addChild:body];
//    
//    //发送消息
//    [[self xmppStream] sendElement:mes];
//    
    NSLog(@"发送数据是：%@",mes);
        //发送消息
        [[self xmppStream] sendElement:mes];
    
//    }
}

#pragma mark -
#pragma mark XMPPStream Delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s",__func__);
    _isOpen = YES;
    NSError *error = nil;
    switch (_currentStatus) {
        case CurrentStatusLogin:
            //验证密码
            [_xmppStream authenticateWithPassword:_password error:&error];
            if (error) {
                NSLog(@"\n%s \nerror:%@",__func__,error);
            }
            break;
        case CurrentStatusRegister:
            [_xmppStream registerWithPassword:@"123456" error:&error];
            if (!error)
            {
                NSLog(@"注册成功!");
                [self disconnect];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }

            break;
            
        default:
            break;
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"%s",__func__);
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s",__func__);
    [self.loginDelegate loginStatusCallBack:YES error:nil];
    [self goOnline];
}

//验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%s",__func__);
    //[self disconnect];
    [self.loginDelegate loginStatusCallBack:NO error:error];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
//    NSLog(@"哈哈：%@",message);
    
    NSLog(@"%s",__func__);
    
    NSString *type = [[message attributeForName:@"type"] stringValue];
    
    
    NSDictionary *postDic=[[NSDictionary alloc] initWithObjectsAndKeys:message,@"message", nil];
    
    
    NSLog(@"收到消息是：%@",postDic);
    //判断发来的类型
    if ([type isEqualToString:@"chat"]) {
        Notification__POST(SPEAKERSNOTICE, postDic);
    }else if ([type isEqualToString:@"normal"]){
        Notification__POST(NOMARLNOTICE, postDic);
    }
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    ///消息实体
    [dict setObject:msg forKey:@"msg"];
    ///发送者
    [dict setObject:from forKey:@"sender"];
    ///类型
    [dict setObject:type forKey:@"type"];
    
    for (id<XMPPChatDelegate> delegate in _chatDelegates) {
        [delegate didRecieveMessage:message];
    }
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    NSLog(@"%s",__func__);
    
    //当前用户
    NSString *userId = [[sender myJID] user];
    //NSLog(@"自己的ID:%@",userId);
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    NSLog(@"草草草wtf：%@:%@",presenceFromUser,presenceType);
    
    [_rosters setObject:presenceType forKey:presenceFromUser];
    
    [_rosterDelegate rosterStatusChanged:presenceFromUser status:presenceType];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            /**
            *用户列表委托(后面讲)
            **/
            //[chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            //[chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
        }
        
    }
    
}

#pragma mark -
#pragma mark TURNSocket 
-(void)sendDataToJid:(XMPPJID *)jid
{
    NSLog(@"%s",__func__);
    TURNSocket *socket = [[TURNSocket alloc] initWithStream:_xmppStream toJID:jid];
    [socket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    /**
     *成功建立连接后会调用TURNSocket代理方法
     **/
}
#pragma mark -
#pragma mark TURNSocket Delegates
- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    NSLog(@"%s",__func__);
    [socket writeData:nil withTimeout:100.0 tag:random()];
}

- (void)turnSocketDidFail:(TURNSocket *)sender
{
    NSLog(@"%s",__func__);
}

@end
