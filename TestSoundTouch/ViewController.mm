//
//  ViewController.m
//  TestSoundTouch
//
//  Created by chenmianma on 4/11/16.
//  Copyright © 2016 newma. All rights reserved.
//

#import "ViewController.h"
#import "STAudioPlayer.h"
#import "STAudioRecorder.h"

#import "SoundTouch.h"

#define NONE_RECORD ""
#define NONE_PLAY ""

#define BUFF_SIZE 6720

using namespace soundtouch;

@interface ViewController () <STAudioRecorderCallback, STAudioPlayCallback> {
    STAudioConfigure m_audioInfo;
    BOOL m_isRecording;
    BOOL m_isPlaying;
}
@property (weak, nonatomic) IBOutlet UILabel *labMessage;

@property (strong, nonatomic) STAudioRecorder* m_recorder;
@property (strong, nonatomic) STAudioPlayer* m_player;
@property (strong, nonatomic) NSMutableData* m_audioData;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

- (NSData*)voiceChange:(NSData*)data;
@end

@implementation ViewController

- (IBAction)onRecordTap:(id)sender {
    if (!m_isRecording) {
        [self.m_recorder start];
    } else {
        [self.m_recorder stop];
    }
}

- (IBAction)onPlayTap:(id)sender {
    if (!m_isPlaying) {
        [self.m_player startMusic:[self voiceChange:self.m_audioData] loop:NO];
    } else {
        [self.m_player stopQueue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    m_audioInfo.bit = em16Bit;
    m_audioInfo.channal = emMono;
    m_audioInfo.sampleRate = 8000;
    
    self.m_audioData = [[NSMutableData alloc]init];
    self.m_recorder = [[STAudioRecorder alloc]initWithAudioConfigure:m_audioInfo withBufferMaxSeconds:0.5];
    self.m_player = [[STAudioPlayer alloc]initWithAudioConfigure:m_audioInfo withBufferMaxSeconds:0.5];
    
    self.m_recorder.delegate = self;
    self.m_player.delegate = self;
    
    m_isPlaying = false;
    m_isRecording = false;
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.m_audioData length] > 0) {
        [self.btnPlay setEnabled:YES];
    } else {
        [self.btnPlay setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////
// delegate method

// Play
- (void)onPlayStart:(STAudioPlayer *)player {
    m_isPlaying = true;
    [self.btnPlay setTitle:@"Stop Play" forState:UIControlStateNormal];
    NSLog(@"play start!");
}

- (void)onPlayStop:(STAudioPlayer *)player {
    m_isPlaying = false;
    [self.btnPlay setTitle:@"Start Play" forState:UIControlStateNormal];
    NSLog(@"play stop!");
}

- (void)onPlayEnd:(STAudioPlayer *)player {
    NSLog(@"play end!");
}

// Record
- (void) onRecordStart:(STAudioRecorder *)recorder {
    [self.m_audioData setLength:0];   // clear last collect audio data
    m_isRecording = true;
    
    [self.btnRecord setTitle:@"Stop Record" forState:UIControlStateNormal];
    NSLog(@"start Recording!");
}

- (void)onRecordStop:(STAudioRecorder *)recorder {
    m_isRecording = false;
    
    [self.btnRecord setTitle:@"Start Record" forState:UIControlStateNormal];
    NSLog(@"stop Recording!");
}

- (void) onRecordData:(NSData *)data withRecorder:(STAudioRecorder *)recorder {
    [self.m_audioData appendData:data];
    NSLog(@"record data length %ld", (unsigned long)[data length]);
    
    [self.btnPlay setEnabled:YES];
}

- (NSData*)voiceChange:(NSData*)data {
    NSMutableData* retData = [[NSMutableData alloc]init];
    
    SAMPLETYPE sampleBuffer[BUFF_SIZE];
    NSUInteger sampleBufferSize = 0;
    NSUInteger nSample = 0;
    NSUInteger nRestSamples = [data length] / sizeof(SAMPLETYPE);
    
    NSUInteger nLocateBytes = 0;
    
    
    SoundTouch soundTouch;

    soundTouch.setSampleRate(m_audioInfo.sampleRate);
    soundTouch.setChannels(m_audioInfo.channal);
    soundTouch.setTempoChange(-3);
    soundTouch.setPitchSemiTones(10);
    soundTouch.setRateChange(0);
    soundTouch.setSetting(SETTING_USE_QUICKSEEK, false);
    soundTouch.setSetting(SETTING_USE_AA_FILTER, true);
    //soundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
    //soundTouch.setSetting(SETTING_SEEKWINDOW_MS, 15); //寻找帧长
    //soundTouch.setSetting(SETTING_OVERLAP_MS, 6);  //重叠帧长
    
    do {
        if (nRestSamples <= 0) {
            break;
        }
        
        sampleBufferSize =  nRestSamples < BUFF_SIZE ? nRestSamples : BUFF_SIZE;
        [self.m_audioData getBytes:sampleBuffer range:NSMakeRange(nLocateBytes, sampleBufferSize * sizeof(SAMPLETYPE))];
        
        soundTouch.putSamples(sampleBuffer, sampleBufferSize);
        nSample = soundTouch.receiveSamples(sampleBuffer, BUFF_SIZE);
        
        [retData appendBytes:sampleBuffer length:nSample * sizeof(SAMPLETYPE)];
        
        nRestSamples -= sampleBufferSize;
        nLocateBytes += sampleBufferSize * sizeof(SAMPLETYPE);
    } while(1);
    
    return retData;
}

@end
