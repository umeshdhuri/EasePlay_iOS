//
//  MusicPlayerViewController.m
//  EasePlay
//
//  Created by Umesh Dhuri on 4/6/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "HCYoutubeParser.h"
#import "Song.h"
#import "UIImageView+WebCache.h"

@interface MusicPlayerViewController ()

@end

@implementation MusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
     [userDefault setValue:@"0" forKey:@"nextPress"];
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    [self setupAppearance] ;
    
    if(isPhone480) {
     
        CGRect songImgViewFrame = self.songImgView.frame ;
        songImgViewFrame.size.height = self.songImgView.frame.size.height - 88 ;
        self.songImgView.frame = songImgViewFrame ;
        
        CGRect controlViewFrame = self.controlView.frame ;
        controlViewFrame.origin.y = songImgViewFrame.origin.y + songImgViewFrame.size.height ;
        self.controlView.frame = controlViewFrame ;
    }
    
    //NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    userDefault = [NSUserDefaults standardUserDefaults];
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }else if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused){
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
    
   // Song *songsObj = [self.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]] ;
    songsObj = nil;
    if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]){
        NSArray *songsList = [DatabaseController getSongsData] ;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [songsList count]; i++) {
            Song *songObj = [songsList objectAtIndex:i];
            NowSongsPlay *nowPlay = [[NowSongsPlay alloc] init];
            nowPlay.musicTypeVal = songObj.musictype;
            nowPlay.descriptionVal = songObj.subtitle;
            nowPlay.thumbVal = songObj.thumburl;
            nowPlay.titleVal = songObj.title;
            nowPlay.musicURLVal = songObj.url;
            nowPlay.indexVal = songObj.ordernumber ;
            [list addObject:nowPlay];
        }
        appDelegate.songsList = list ;
        appDelegate.queuedSongsList = appDelegate.songsList ;
        appDelegate.tmpSongsList = appDelegate.songsList ;
        NSLog(@"appDelegate.songsList === %@", appDelegate.songsList) ;
        NSLog(@"val === %d", [[userDefault valueForKey:@"playIndex"] integerValue]);
        if([[userDefault valueForKey:@"playIndex"] integerValue] < [songsList count]) {
            nowPlayObj = [appDelegate.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]];
            
        }
        totalSongsCount = [DatabaseController checkSongsCount];
        //[PlayMediaSong getSongsData:[[userDefault valueForKey:@"playIndex"] integerValue]];
    }else{
        NSLog(@"appDelegate.songsList === %@", appDelegate.songsList) ;
        NSLog(@"val === %d", [[userDefault valueForKey:@"playIndex"] integerValue]);
        nowPlayObj = [[NowSongsPlay alloc] init];
        nowPlayObj = [appDelegate.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]];
    }
    NSLog(@"musicURLVal === %@", nowPlayObj.musicURLVal) ;
    NSLog(@"nowPlayObj.titleVal === %@", nowPlayObj.titleVal) ;
    NSLog(@"nowPlayObj.titleVal === %@", nowPlayObj.descriptionVal) ;
    NSLog(@"music type value === %@", nowPlayObj.musicTypeVal) ;
    if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
        [self.songName setText:nowPlayObj.titleVal];
    } else {
        NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
        [self.songName setText:[songNameVal1 objectAtIndex:0]];
    }
    [self.songDesc setText:nowPlayObj.descriptionVal];
   // [self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    
    
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(setTimer) userInfo:nil repeats:YES];
    
    [self.nextBtnObj setEnabled:YES];
    [self.previousBtn setEnabled:YES];
    [self.playBtn setEnabled:YES];
    [self.repeatBtnClick setEnabled:YES];
    [self.shaffleBtnClick setEnabled:YES];
    
    NSString *notificationName = @"CategoryChangeNotification";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotificationWithString:)
     name:notificationName
     object:nil];
    
    NSString *notificationNameDisable = @"disablePlayButtons";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(stopSongs:)
     name:notificationNameDisable
     object:nil];
    
    NSString *notificationNameStart = @"startPlay";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startPlaySongs:)
     name:notificationNameStart
     object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void) startPlaySongs:(NSNotification *)notification {
    if (appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
       // [autoTimer invalidate];
       // autoTimer = nil ;
       /* if(self.timeLbl) {
            [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
        }
        if(self.playBtn) {
            [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        }*/
        
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                   selector:@selector(setTimer) userInfo:nil repeats:YES];
        
        if(autoTimer) {
        
        }
        
        
    }
    
    
    
    //[appDelegate pauseMusic] ;
    
}

-(void) stopSongs:(NSNotification *)notification {
    //[autoTimer invalidate];
    //autoTimer = nil ;
    /*if(self.tim     Lbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    }*/
    
   // [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    //[appDelegate pauseMusic] ;
    
    
    
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)useNotificationWithString:(NSNotification *)notification
{
    if([[DatabaseController getSongsData] count]) {
    nowPlayObj = [[NowSongsPlay alloc] init];
    NSLog(@"Count ==== %d", [[userDefault valueForKey:@"playIndex"] integerValue]) ;
    //Song *songsObj = [PlayMediaSong getSongsData:[[userDefault valueForKey:@"playIndex"] integerValue]] ;
    nowPlayObj = [appDelegate.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]] ;
        if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
            [self.songName setText:nowPlayObj.titleVal];
        } else {
            NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
            [self.songName setText:[songNameVal1 objectAtIndex:0]];
        }
    [self.songDesc setText:nowPlayObj.descriptionVal];
    //[self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CategoryChangeNotification" object:nil];
    }else{
        nowPlayObj = [[NowSongsPlay alloc] init];
        NSLog(@"Count ==== %d", [[userDefault valueForKey:@"playIndex"] integerValue]) ;
        //Song *songsObj = [PlayMediaSong getSongsData:[[userDefault valueForKey:@"playIndex"] integerValue]] ;
        nowPlayObj = [appDelegate.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]] ;
        if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
            [self.songName setText:nowPlayObj.titleVal];
        } else {
            NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
            [self.songName setText:[songNameVal1 objectAtIndex:0]];
        }
        [self.songDesc setText:nowPlayObj.descriptionVal];
        //[self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    }
    
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    //[appDelegate.moviePlayer play];
    //[appDelegate.moviePlayer.moviePlayer setContentURL:url] ;
    //[mp.moviePlayer prepareToPlay];
    [appDelegate.moviePlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [appDelegate.moviePlayer pause];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
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
- (void)setCurrentAudioTime:(float)value {
    [appDelegate.moviePlayer setCurrentPlaybackTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [appDelegate.moviePlayer currentPlaybackTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [appDelegate.moviePlayer duration];
}


-(void) setTimer {
    //NSLog(@"setTimer ====") ;
    
    //[self.progressSlider setMinimumValue:allTime];
    
    [self.progressSlider setMaximumValue:[self getAudioDuration]];
    [self.progressSlider setValue:[self getCurrentAudioTime] animated:YES] ;
    
    NSString *totTime =  [NSString stringWithFormat:@"%@", [self timeFormat:[self getAudioDuration]]];
    NSString *currentTime =  [NSString stringWithFormat:@"%@", [self timeFormat:[self getCurrentAudioTime]]];
    if([currentTime integerValue] < 0) {
        [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    }else if([currentTime integerValue] >= 0){
        [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", currentTime, totTime]] ;
    }
    
   // [userDefault setValue:@"0" forKey:@"nextPress"];
}


-(IBAction)changeSliderVal:(id)sender {
    [autoTimer invalidate];
    autoTimer = nil ;
    [appDelegate.moviePlayer setCurrentPlaybackTime:self.progressSlider.value];
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                               selector:@selector(setTimer) userInfo:nil repeats:YES];
    
    [userDefault setValue:@"0" forKey:@"nextPress"];
    //[appDelegate.moviePlayer setCurrentAudioTime:self.progressSlider.value];
}

-(void)setupAppearance {
    UIImage *minImage = [UIImage imageNamed: @"progress-bar-default.png"];
    UIImage *maxImage = [UIImage imageNamed: @"progress-bar-active.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:nil forState:UIControlStateNormal];
}

-(void) viewWillAppear:(BOOL)animated {
    if([[userDefault valueForKey:@"setRepeat"] isEqualToString:@"1"]) {
        [userDefault setValue:@"1" forKey:@"setRepeat"];
        [self.repeatImageView setImage:[UIImage imageNamed:@"replay_active.png"]];
        
    }else{
        [userDefault setValue:@"0" forKey:@"setRepeat"];
        [self.repeatImageView setImage:[UIImage imageNamed:@"replay.png"]];
    }
    
    if([[userDefault valueForKey:@"setShuffled"] isEqualToString:@"1"]) {
        [userDefault setValue:@"1" forKey:@"setShuffled"];
        [self.shaffleImageView setImage:[UIImage imageNamed:@"shuffle_active.png"]];
        
    }else{
        [userDefault setValue:@"0" forKey:@"setShuffled"];
        [self.shaffleImageView setImage:[UIImage imageNamed:@"shuffle.png"]];
    }
}

-(IBAction) backRedirect:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)play:(id)sender {
    NSLog(@"appDelegate.moviePlayer.playbackState === %d", appDelegate.moviePlayer.playbackState) ;
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [userDefault setValue:@"1" forKey:@"presspause"] ;
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [appDelegate pauseMusic] ;
        [autoTimer invalidate];
       // autoTimer = nil ;
    }else if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused){
        [userDefault setValue:@"0" forKey:@"presspause"] ;
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [appDelegate playMusicVal] ;
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                   selector:@selector(setTimer) userInfo:nil repeats:YES];
    }else{
        //[self.playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
    
  /*  if ([[self.playBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"pause.png"]]){
        // Button has a background image named 'uncheck.png'
        [PlayMediaSong pauseAudio] ;
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [autoTimer invalidate];
        autoTimer = nil ;
        
    } else{
        // Button has not a background image named 'uncheck.png'
        [PlayMediaSong playAudio] ;
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                   selector:@selector(setTimer) userInfo:nil repeats:YES];
    }*/
    
}


-(IBAction)nextSongs:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [autoTimer invalidate];
    //autoTimer = nil;
    [self.progressSlider setValue:0 animated:YES];
    [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [userDefault setValue:@"1" forKey:@"nextPress"];
    
    int nextVal ;
    NSLog(@"playindex === %d", [[userDefault valueForKey:@"playIndex"] integerValue]) ;
    NSLog(@"total songs === %d", totalSongsCount) ;
    nextVal = [[userDefault valueForKey:@"playIndex"] integerValue] + 1 ;
    /*if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]){
        if(nextVal >= [DatabaseController checkSongsCount]) {
            nextVal = 0 ;
        }
    }else{*/
    
    if(nextVal >= [appDelegate.songsList count]) {
        nextVal = 0 ;
    }

    NSLog(@"Int nextVal === %d", nextVal) ;
  //  NSLog(@"self.songsList === %@", self.songsList) ;
    //Song *songsObj = [PlayMediaSong getSongsData:nextVal] ;
    nowPlayObj = nil;
    nowPlayObj = [appDelegate.songsList objectAtIndex:nextVal] ;
    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playIndex"];
    
    if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
        [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playQueuedIndex"];
        
        [userDefault setValue:nowPlayObj.titleVal forKey:@"ququedTrackTitle"];
        [userDefault setValue:nowPlayObj.musicURLVal forKey:@"ququedTrackURL"];
        
    }
    [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    if([nowPlayObj.musicTypeVal isEqualToString:@"Youtube"]) {
        
        [self getYouTubeURL:nowPlayObj.musicURLVal indexVal:nextVal] ;
        [appDelegate showSongTitle:nowPlayObj.titleVal];
    }else{
        //[appDelegate.moviePlayer stop];
        //[appDelegate.moviePlayer setContentURL:[NSURL URLWithString:nowPlayObj.musicURLVal]] ;
        //[appDelegate.moviePlayer play] ;
        
        if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
            [self.songName setText:nowPlayObj.titleVal];
        } else {
            NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
            [self.songName setText:[songNameVal1 objectAtIndex:0]];
        }
        [self.songDesc setText:nowPlayObj.descriptionVal];
       // [self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [appDelegate playMusic:[NSURL URLWithString:nowPlayObj.musicURLVal]];
        [appDelegate showSongTitle:nowPlayObj.titleVal];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
       // autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimer) userInfo:nil repeats:YES];
        [self.progressSlider setValue:0 animated:YES];
        
    }
    
    NSLog(@"nextplay === %@", [userDefault valueForKey:@"nextPress"]) ;
    
}

-(void)nextSongsFromApp:(int) indexVal {
    NSLog(@"indexVal -=== %d", indexVal) ;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [autoTimer invalidate];
    
    [userDefault setValue:@"queuedtrack" forKey:@"songRedirectionType"] ;
    [userDefault setValue:@"queued" forKey:@"songRedirectionTypeSubType"] ;
    NSLog(@"userDefault === %@", [userDefault valueForKey:@"songRedirectionType"]) ;
    NSLog(@"userDefault === %@", [userDefault valueForKey:@"songRedirectionTypeSubType"]) ;
    
   // autoTimer = nil;
    [self.progressSlider setValue:0 animated:YES];
    [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [userDefault setValue:@"0" forKey:@"setRepeat"];
    [userDefault setValue:@"0" forKey:@"nextPress"];
    //  NSLog(@"self.songsList === %@", self.songsList) ;
    //Song *songsObj = [PlayMediaSong getSongsData:indexVal] ;
    nowPlayObj  = nil;
    nowPlayObj = [appDelegate.songsList objectAtIndex:indexVal] ;
    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)indexVal] forKey:@"playIndex"];
    [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    
    [userDefault setValue:nowPlayObj.titleVal forKey:@"ququedTrackTitle"];
    [userDefault setValue:nowPlayObj.musicURLVal forKey:@"ququedTrackURL"];
    
    
    if([nowPlayObj.musicTypeVal isEqualToString:@"Youtube"]) {
        
        [self getYouTubeURL:nowPlayObj.musicURLVal indexVal:indexVal] ;
        [appDelegate showSongTitle:nowPlayObj.titleVal];
    }else{
        //[appDelegate.moviePlayer stop];
       // [appDelegate.moviePlayer setContentURL:[NSURL URLWithString:nowPlayObj.musicURLVal]] ;
        //[appDelegate.moviePlayer play] ;
        [appDelegate playMusic:[NSURL URLWithString:nowPlayObj.musicURLVal]];
        [appDelegate showSongTitle:nowPlayObj.titleVal];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
       // autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimer) userInfo:nil repeats:YES];
        
        if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
            [self.songName setText:nowPlayObj.titleVal];
        } else {
            NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
            [self.songName setText:[songNameVal1 objectAtIndex:0]];
        }
        
        [self.songDesc setText:nowPlayObj.descriptionVal];
        //[self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    }
    
}



-(void) getYouTubeURL:(NSString *) youTubeURLVal indexVal:(int) index {
    
       /* NSString* videoId = nil;
        NSArray *queryComponents = [youTubeURLVal componentsSeparatedByString:@"&"];
        for (NSString* pair in queryComponents) {
            NSArray* pairComponents = [pair componentsSeparatedByString:@"="];
            if ([pairComponents[1] length] > 0) {
                videoId = pairComponents[1];
                break;
            }
        }
        
        if (!videoId) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video ID not found in video URL" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil]show];
            return;
        }*/
    
    NSString *url1= youTubeURLVal; //[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
        /*lbYoutubePlayerVC = [[LBYouTubePlayerViewController alloc]initWithYouTubeURL:[NSURL URLWithString:url]  quality:LBYouTubeVideoQualityLarge];
         lbYoutubePlayerVC.delegate=self;*/
        
        NSURL *url = [NSURL URLWithString:url1];
        // _activityIndicator.hidden = NO;
        [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
            
            if (!error) {
                // [_playButton setBackgroundImage:image forState:UIControlStateNormal];
                
                [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                    
                    // _playButton.hidden = NO;
                    // _activityIndicator.hidden = YES;
                    
                    NSDictionary *qualities = videoDictionary;
                    
                    NSString *URLString = nil;
                    if ([qualities objectForKey:@"small"] != nil) {
                        URLString = [qualities objectForKey:@"small"];
                    }
                    else if ([qualities objectForKey:@"live"] != nil) {
                        URLString = [qualities objectForKey:@"live"];
                    }
                    else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                        return;
                    }
                    NSURL *videoURL = [NSURL URLWithString:URLString];
                    
                    [self playYouTubeVideo:videoURL indexVal:index] ;
                    
                    //[self playYouTubeVideo:_urlToLoad];
                    //[self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                    
                }];
            }
            else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
        
    
}

-(void) playYouTubeVideo:(NSURL *) url indexVal:(int) index {
    
   // [autoTimer invalidate];
   // autoTimer = nil;
    [appDelegate playMusic:url];
    
    NSLog(@"nextplay === %@", [userDefault valueForKey:@"nextPress"]) ;
    if([[userDefault valueForKey:@"nextPress"] isEqualToString:@"1"]) {
        //Song *songsObj = [PlayMediaSong getSongsData:index] ;
        nowPlayObj = nil ;
        nowPlayObj = [appDelegate.songsList objectAtIndex:index] ;
        if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
            [self.songName setText:nowPlayObj.titleVal];
        } else {
            NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
            [self.songName setText:[songNameVal1 objectAtIndex:0]];
        }
        
        [self.songDesc setText:nowPlayObj.descriptionVal];
        //[self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    }
   // autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimer) userInfo:nil repeats:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void) changeData:(int) indexValue {
    /*Song *songsObj = [PlayMediaSong getSongsData:1] ;
    [self.songName setText:@"asdasd"];
    [self.songDesc setText:@"sa"];
    [self.songImgView startImageDownloadingWithUrl:songsObj.thumburl placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];*/
}


-(IBAction)previousSong:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [autoTimer invalidate];
   // autoTimer = nil;
    [self.progressSlider setValue:0 animated:YES];
    [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    
    [userDefault setValue:@"1" forKey:@"nextPress"];
    int nextVal = [[userDefault valueForKey:@"playIndex"] integerValue] - 1 ;
    
    if(nextVal < 0) {
        nextVal = [appDelegate.songsList count] - 1 ;
    }
    nowPlayObj = nil ;
    nowPlayObj = [appDelegate.songsList objectAtIndex:nextVal];
    //songsObj = [PlayMediaSong getSongsData:nextVal] ;
    [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playIndex"];
    if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
        [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playQueuedIndex"];
    }
    
    if([nowPlayObj.musicTypeVal isEqualToString:@"Youtube"]) {
        [self getYouTubeURL:nowPlayObj.musicURLVal indexVal:nextVal] ;
        [appDelegate showSongTitle:nowPlayObj.titleVal];
    }else{
        [appDelegate playMusic:[NSURL URLWithString:nowPlayObj.musicURLVal]];
        [appDelegate showSongTitle:nowPlayObj.titleVal];
       // [appDelegate.moviePlayer setContentURL:[NSURL URLWithString:nowPlayObj.musicURLVal]] ;
       // [appDelegate.moviePlayer play] ;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.timeLbl setText:[NSString stringWithFormat:@"%@/%@", @"--", @"--"]] ;
        
       // autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimer) userInfo:nil repeats:YES];
        if ([nowPlayObj.titleVal rangeOfString:@"###$$"].location == NSNotFound) {
            [self.songName setText:nowPlayObj.titleVal];
        } else {
            NSArray *songNameVal1 = [nowPlayObj.titleVal componentsSeparatedByString:@"###$$"];
            [self.songName setText:[songNameVal1 objectAtIndex:0]];
        }
        [self.songDesc setText:nowPlayObj.descriptionVal];
        //[self.songImgView startImageDownloadingWithUrl:nowPlayObj.thumbVal placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [self.songImgView sd_setImageWithURL:[NSURL URLWithString:nowPlayObj.thumbVal] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    }
    
}

-(IBAction)repeatSongs:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    
    if([[userDefault valueForKey:@"setRepeat"] isEqualToString:@"1"]) {
        [userDefault setValue:@"0" forKey:@"setRepeat"];
        hud.labelText = @"”Reapet Off”";
        [self.repeatImageView setImage:[UIImage imageNamed:@"replay.png"]];
    }else{
        [userDefault setValue:@"1" forKey:@"setRepeat"];
        hud.labelText = @"”Reapet On”";
        [self.repeatImageView setImage:[UIImage imageNamed:@"replay_active.png"]];
    }
    
    hud.margin = 10.f;
    if(isPhone480) {
        hud.yOffset = 150.f;
    }else{
        hud.yOffset = 200.f;
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(IBAction)shuffleSongsList:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    NSLog(@"appDelegate.tmpSongsList === %@", appDelegate.tmpSongsList) ;
    if([[userDefault valueForKey:@"setShuffled"] isEqualToString:@"1"]) {
        [userDefault setValue:@"0" forKey:@"setShuffled"];
        hud.labelText = @"”Shuffle Off”";
        appDelegate.songsList = appDelegate.tmpSongsList ;
        [self.shaffleImageView setImage:[UIImage imageNamed:@"shuffle.png"]];
    }else{
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[appDelegate.songsList count]];
        
        for (id anObject in appDelegate.songsList)
        {
            NSUInteger randomPos = arc4random()%([tmpArray count]+1);
            [tmpArray insertObject:anObject atIndex:randomPos];
        }
        
        /*int count = [tmpArray count] * 5; // number of iterations
        
        for (int i = 0; i < count; i++) {
            
            int index1 = i % [tmpArray count];
            int index2 = arc4random() % [tmpArray count];
            
            if (index1 != index2) {
                [tmpArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
            }
            
        }*/
        
        
        NSArray *songsShuffleList = [NSArray arrayWithArray:tmpArray];
        
        [userDefault setValue:@"1" forKey:@"setShuffled"];
        hud.labelText = @"”Shuffle On”";
        appDelegate.songsList = songsShuffleList ;
        [self.shaffleImageView setImage:[UIImage imageNamed:@"shuffle_active.png"]];
    }
    
    NSLog(@"appDelegate.songsList === %@", appDelegate.songsList) ;
    hud.margin = 10.f;
    if(isPhone480) {
        hud.yOffset = 150.f;
    }else{
        hud.yOffset = 250.f;
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
