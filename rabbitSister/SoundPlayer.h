//
//  SoundPlayer.h
//  PBLSTOP
//
//  Created by Jahnny on 13-12-23.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundPlayer : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, retain)AVAudioPlayer *soundsPlayer;

-(void)playSound:(NSString *)soundPath;

@end
