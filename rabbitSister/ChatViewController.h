//
//  ChatViewController.h
//  rabbitSister
//
//  Created by Jahnny on 13-10-22.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPPManager.h"
#import "ZBAudioRecorder.h"
#import "UIBubbleTableView.h"

//发送数据类型
typedef enum{
    speakMessageType= 0,  //文字
    speakVoiceType,       //声音
    speakImgType,         //图片
} speakType;

//聊天状态类型
typedef enum{
    post= 0,            //发送
    respond,            //收回
} inSpeakType;
//服务器崩溃
//XMPPLoginDelegate
@interface ChatViewController : UIViewController<UITextFieldDelegate,XMPPChatDelegate,ZBAudioRecorderDelegate,XMPPLoginDelegate,UIActionSheetDelegate>
{
    XMPPManager *_xmppManager;
    ZBAudioRecorder *_audioRecorder;
    
    FMDatabase      *db;//数据库
    FMResultSet     *rs;
}
@property (retain, nonatomic) IBOutlet UIButton *soundKeywordBtn;
@property (retain, nonatomic) IBOutlet UIView *soundView;
@property (retain, nonatomic) IBOutlet UIView *textView;
@property (retain, nonatomic) IBOutlet UIView *mainDownView;
@property (retain, nonatomic) IBOutlet UITextField *mainTextField;
@property (retain, nonatomic) IBOutlet UIImageView *speakBackground;
@property (retain, nonatomic) IBOutlet UILabel *speakLabel;
@property (retain, nonatomic) IBOutlet UILabel *respondLabel;
@property (retain, nonatomic) IBOutlet UIImageView *respondImg;
@property (retain, nonatomic) IBOutlet UILabel *voiceLab;
@property (retain, nonatomic) IBOutlet UIView *bigImgView;
@property (retain, nonatomic) IBOutlet UIImageView *bigImgs;


@property (copy,nonatomic) NSString *voiceUrl; //声音地址
@property (retain,nonatomic) NSMutableArray *voiceUrlArr; //声音地址数组
@property (copy,nonatomic) NSString *imgUrl; //图片地址
@property (retain,nonatomic) NSMutableArray *imgUrlArr; //图片地址数组
@property (copy,nonatomic) NSString *currentJIDComunicateWith; //当前对话id
@property (copy,nonatomic) NSString *BNumber; //任务ID号
@property (copy,nonatomic) NSString *customerImg; //用户头像
@property (copy,nonatomic) NSString *accountImg; //兔子头像
@property (copy,nonatomic) NSString *Status; //状态：1中标2结束
@property (copy,nonatomic) NSString *enuserName; //客户姓名


@property (retain,nonatomic) NSMutableArray *speakArr; //聊天记录

@property (retain, nonatomic) IBOutlet UIBubbleTableView *bubbleTableView;

@property (retain, nonatomic) IBOutlet UIButton *addVoiceBtn;
@property (retain, nonatomic) IBOutlet UIImageView *testVoiceImg;
@property (retain, nonatomic) IBOutlet UILabel *testLab;

@end
