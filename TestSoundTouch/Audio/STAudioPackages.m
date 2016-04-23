//
//  STAudioPackages.m
//  TestSoundTouch
//
//  Created by chenmianma on 4/15/16.
//  Copyright © 2016 newma. All rights reserved.
//

#import "STAudioPackages.h"

@interface STAudioPackages()

@property (nonatomic, strong) NSData* data;

@end

@implementation STAudioPackages

- (instancetype)initWithData:(NSData*)data packageSize:(NSUInteger)packageSize {
    self = [self init];
    if (self) {
        self.data = data;
        _currentPackage = 0;
        [self setPackageSize:packageSize];
    }
    return self;
}

- (NSData*)getData {
    return self.data;
}

- (BOOL)validate {
    if (self.packageNum > 0 && self.currentPackage < self.packageNum) {
        return YES;
    }
    
    return NO;
}

- (NSData*)readNextPackage {
    if (![self validate]) {
        return NULL;
    }
    
    NSUInteger len = [self.data length] - _currentPackage * _packageSize;
    if (len >= _packageSize) {
        len = _packageSize;
    }
    
    return [self.data subdataWithRange:NSMakeRange(_currentPackage++ * _packageSize, len)];
}

- (void)setPackageSize:(NSUInteger)packageSize {
    _packageSize = packageSize;
    _currentPackage = 0;
    _packageNum = [self.data length] / packageSize;
    if ([self.data length] % packageSize != 0) {
        _packageNum++;
    }
}

- (void)rewind {
    _currentPackage = 0;
}

@end
