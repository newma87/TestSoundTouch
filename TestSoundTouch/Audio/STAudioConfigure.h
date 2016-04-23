//
//  STAudioConfigure.h
//  TestSoundTouch
//
//  Created by chenmianma on 4/11/16.
//  Copyright © 2016 newma. All rights reserved.
//

#ifndef STAudioConfigure_h
#define STAudioConfigure_h

typedef enum {
    emMono = 1,
    emStereo = 2
} STAUDIOCHANNAL;

typedef enum {
    em8Bit = 8,
    em16Bit = 16,
    em32Bit = 32
} STAUDIOBIT;

typedef struct {
    STAUDIOCHANNAL channal;     // 声道
    unsigned long sampleRate;       // 采样频率
    STAUDIOBIT bit;             // 样本大小
} STAudioConfigure;

#endif /* STAudioConfigure_h */
