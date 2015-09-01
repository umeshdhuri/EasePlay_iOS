//
//  PlayMediaSong.m
//  EasePlay
//
//  Created by Umesh Dhuri on 4/8/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "PlayMediaSong.h"

@implementation PlayMediaSong

/*
 * Simply fire the play Event
 */
+ (void)playAudio {
    //[appDelegate.moviePlayer play];
    //[appDelegate.moviePlayer.moviePlayer setContentURL:url] ;
    //[mp.moviePlayer prepareToPlay];
    [appDelegate.moviePlayer play];
}

/*
 * Simply fire the pause Event
 */
+ (void)pauseAudio {
    [appDelegate.moviePlayer pause];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
+(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    if(time < 0) {
        return @"00" ;
    }
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
+ (void)setCurrentAudioTime:(float)value {
    [appDelegate.moviePlayer setCurrentPlaybackTime:value];
}

/*
 * Get the time where audio is playing right now
 */
+ (NSTimeInterval)getCurrentAudioTime {
    return [appDelegate.moviePlayer currentPlaybackTime];
}

/*
 * Get the whole length of the audio file
 */
+ (float)getAudioDuration {
    return [appDelegate.moviePlayer duration];
}

+(Song *) getSongsData:(int) index {
    
    Song *songObj = nil;
    
    NSArray *songsListresult = [DatabaseController getSongsData] ;
    
    songObj = [songsListresult objectAtIndex:index] ;
    
    return songObj ;
}

@end
