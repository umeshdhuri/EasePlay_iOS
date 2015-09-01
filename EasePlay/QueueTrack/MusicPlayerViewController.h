//
//  MusicPlayerViewController.h
//  EasePlay
//
//  Created by Umesh Dhuri on 4/6/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetImage.h"
#import "Song.h"
#import "NowSongsPlay.h"
@interface MusicPlayerViewController : UIViewController {
  //  AVAudioPlayer *audioPlayer;
    NSTimer *autoTimer;
    int totalSongsCount ;
    Song *songsObj ;
    NSUserDefaults *userDefault ;
    NowSongsPlay *nowPlayObj ;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, weak) IBOutlet UISlider *progressSlider ;

@property (nonatomic, weak) IBOutlet UIButton *playBtn ;
@property (nonatomic, weak) IBOutlet UILabel *songName;
@property (nonatomic, weak) IBOutlet UILabel *songDesc;
@property (nonatomic, weak) IBOutlet UILabel *timeLbl;
@property (nonatomic, weak) IBOutlet UIButton *nextBtnObj, *previousBtn, *repeatBtnClick, *shaffleBtnClick ;
@property (nonatomic, weak) IBOutlet UIImageView *repeatImageView, *shaffleImageView;

@property (nonatomic, weak) IBOutlet UIImageView *songImgView ;
@property (nonatomic, weak) IBOutlet UIView *controlView ;

- (void)playAudio;
- (void)pauseAudio;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;
-(IBAction)nextSongs:(id)sender ;
-(void)nextSongsFromApp:(int) indexVal ;
-(IBAction)previousSong:(id)sender ;
@end
