//
//  ZBAudioRecorder.m
//  ZBAudioRecorder
//
//  Created by Zhou.Bin on 13-1-9.
//  Copyright (c) 2013年 Zhou.Bin. All rights reserved.
//

#import "ZBAudioRecorder.h"
#import "GTMBase64.h"

/**
 *录音参数定义
 **/
static float const   SampleRate     = 48.0;
static int   const   EncoderBitRate = 16;
static int   const   Channels       = 2;


@implementation ZBAudioRecorder

-(BOOL)recording
{
    return _recorder.recording;
}

-(void)dealloc
{
    [_recorder release];
    [super dealloc];
}

-(id)initWithURL:(NSURL *)audioFileURL
{
    self = [super init];
    if (self) {
        //
        NSDictionary *recordSettings =  [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:EncoderBitRate],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: Channels],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:SampleRate],
                                        AVSampleRateKey,
                                        nil];
        
        NSError *error = nil;
        
        _recorder = [[AVAudioRecorder alloc]
                         initWithURL:audioFileURL
                         settings:recordSettings
                         error:&error];
        
        _recorder.delegate = self;
        
        void (^printError)(NSError *) = ^(NSError *error)
        {
            NSLog(@"error: %@",[error localizedDescription]);
        };
        
        error ? printError(error) : [_recorder prepareToRecord];
        
    }
    
    return self;
}

-(void)record
{
    if (!_recorder.recording)
    {
        [_recorder record];
    }
}

-(void)stop
{
    if (_recorder.recording)
    {
        [_recorder stop];
    } 
}

-(NSString *)audioBase64String
{
    NSData *data = [NSData dataWithContentsOfURL:_recorder.url];
    return [GTMBase64 stringByEncodingData:data];
}

#pragma mark - 
#pragma mark AVAudioRecorder Delegates

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"%s",__func__);
    [_delegate audioRecorderDidFinishRecording:recorder successfully:flag];
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"%s",__func__);
    [_delegate audioRecorderEncodeErrorDidOccur:recorder error:error];
}


@end
