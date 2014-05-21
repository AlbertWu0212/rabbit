//
//  ZBAudioRecorder.h
//  ZBAudioRecorder
//
//  Created by Zhou.Bin on 13-1-9.
//  Copyright (c) 2013年 Zhou.Bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZBAudioRecorderDelegate <NSObject>

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error;

@end


@interface ZBAudioRecorder : NSObject<AVAudioRecorderDelegate>
{
    AVAudioRecorder *_recorder;
}
@property(assign,nonatomic)id<ZBAudioRecorderDelegate> delegate;
@property(readonly,nonatomic) BOOL recording;
-(id)initWithURL:(NSURL *)audioFileURL;
-(void)record;
-(void)stop;
-(NSString *)audioBase64String;
@end
