//
//  SoundPlayer.m
//  PBLSTOP
//
//  Created by Jahnny on 13-12-23.
//  Copyright (c) 2013年 ownerblood. All rights reserved.
//

#import "SoundPlayer.h"

@implementation SoundPlayer

-(void)playSound:(NSString *)soundPath
{
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:soundPath ofType:@"mp3"];       //创建音乐文件路径
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (
                             kAudioSessionProperty_AudioCategory,
                             sizeof (sessionCategory),
                             &sessionCategory
                             );
    AudioSessionSetActive(true);
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];
    
    self.soundsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    [self.soundsPlayer prepareToPlay];
    [self.soundsPlayer setVolume:0.5f];
    self.soundsPlayer.numberOfLoops=0;
    [self.soundsPlayer play];
}

@end
