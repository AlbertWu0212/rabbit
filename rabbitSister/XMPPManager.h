//
//  XMPPManager.h
//  ChatClient
//
//  Created by Zhou.Bin on 12-12-27.
//  Copyright (c) 2012年 Zhou.Bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "TURNSocket.h"

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Delegates
@protocol XMPPLoginDelegate <NSObject>
@required
///登录成功or失败
-(void)loginStatusCallBack:(BOOL)successed error:(NSXMLElement *)error;
@end

@protocol XMPPRosterDelegate <NSObject>
///联系人状态发生改变
-(void)rosterStatusChanged:(NSString *)rosterName status:(NSString *)status;
@end

@protocol XMPPChatDelegate <NSObject>
///收到消息
-(void)didRecieveMessage:(XMPPMessage *)message; 
@end
//------------------------------------------------------------------------------

#pragma mark -
#pragma mark Interface

enum CurrentStatus {
    CurrentStatusNone = 0,
    CurrentStatusLogin = 1,
    CurrentStatusRegister = 2
    };

@interface XMPPManager : NSObject<XMPPStreamDelegate,TURNSocketDelegate>
{
    NSString *_password;
    NSString *_userID;
    NSString *_serverStr;
    BOOL _isOpen;
    
}
///xmpp主要操作
@property(nonatomic,assign)XMPPStream *xmppStream;

///断线重新连接扩展
@property(nonatomic,readonly)XMPPReconnect *xmppReconnect;

///是否与xmpp服务器连接
@property(readonly,nonatomic) BOOL isConnected;

///联系人
@property(readonly,nonatomic) NSMutableDictionary *rosters;

/**
 * 当前操作状态
 * 由于注册要进行匿名连接，必须等到- (void)xmppStreamDidConnect 执行到才可以发送注册请求
 * 所以在函数内进行了状态判断
 * 目前两种状态  登录 和 注册（匿名登录）
 */
@property(readwrite)enum CurrentStatus currentStatus;

///登录代理
@property(assign, nonatomic) id<XMPPLoginDelegate> loginDelegate;

///联系人代理，主要是状态更新
@property(assign, nonatomic) id<XMPPRosterDelegate> rosterDelegate;

//聊天代理(多) 用于接受-(void)didRecieveMessage
@property(retain, nonatomic) NSMutableArray<XMPPChatDelegate> *chatDelegates; 

+ (id)sharedManager;

///连接服务器
-(BOOL)connect:(NSString *)userID password:(NSString *)password server:(NSString *)server;

///断开连接
-(void)disconnect;

///初始化
-(void)setupStream;

///上线
-(void)goOnline;

///下线
-(void)goOffline;

///匿名连接服务器
-(BOOL)anonymousConnect;

///发送消息
-(void)sendMessageTo:(NSString *)jid message:(NSString *)message type:(NSString *)type voice:(NSString *)voice img:(NSString *)img BNumber:(NSString *)BNumber status:(NSString *)status from:(NSString *)from;

/**
 * 数据传输 - （预留）
 * 用于实现turnSocket传输协议
 */
-(void)sendDataToJid:(XMPPJID *)jid;

///注册新帐号
-(void)registerNewAccountWithPassword:(NSString *)password;

///设置账户信息及服务器地址
-(void)setUserID:(NSString *)userID server:(NSString *)server password:(NSString *)password;
@end
