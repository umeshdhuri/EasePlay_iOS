//
//  PlayMediaSong.h
//  EasePlay
//
//  Created by Umesh Dhuri on 4/8/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@interface PlayMediaSong : NSObject

+ (void)playAudio ;
+ (void)pauseAudio ;
+(NSString*)timeFormat:(float)value;
+ (void)setCurrentAudioTime:(float)value ; 
+ (NSTimeInterval)getCurrentAudioTime ;
+ (float)getAudioDuration ;
+(Song *) getSongsData:(int) index ;
@end
