//
//  STAudioPackages.h
//  TestSoundTouch
//
//  Created by chenmianma on 4/15/16.
//  Copyright © 2016 newma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAudioPackages : NSObject

@property (nonatomic, assign) NSUInteger currentPackage;
@property (nonatomic, assign) NSUInteger packageSize;
@property (nonatomic, readonly) NSUInteger packageNum;

- (instancetype)initWithData:(NSData*)data packageSize:(NSUInteger)packageSize;

- (NSData*)getData;

- (BOOL)validate;
- (NSData*)readNextPackage;

- (void)setPackageSize:(NSUInteger)packageSize;
- (void)rewind;

@end
