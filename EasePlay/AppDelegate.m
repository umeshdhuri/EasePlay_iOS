
//
//  AppDelegate.m
//  EasePlay
//
//  Created by AppKnetics on 13/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchSongsViewController.h"
#import "SettingViewController.h"
#import "BrowseViewController.h"
#import "QueueTrackViewController.h"
#import "PlayListViewController.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SignInViewController.h"
#import "CustomTabBarItem.h"
#import "NowSongsPlay.h"
#import "HCYoutubeParser.h"
@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    musicPlayer = [[MusicPlayerViewController alloc] init];
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    self.moviePlayer.ShouldAutoplay = true;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    self.songsList = [[NSArray alloc] init];
    self.tmpSongsList = [[NSArray alloc] init];
    [user setValue:@"0" forKey:@"presspause"] ;
    self.songInNowPlaying = NO ;
    self.stopCountVal = 0 ;
    self.inSongFinished = YES ;
   /* appDelegate.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    appDelegate.moviePlayer.view.backgroundColor=[UIColor clearColor];
    appDelegate.moviePlayer.initialPlaybackTime = 0;
    [appDelegate.moviePlayer setScalingMode:MPMovieScalingModeFill];
    // appDelegate.moviePlayer.view.frame = CGRectMake(0, 0, 0.5, 0.5);
    // [self.view addSubview:_moviePlayer.view];
    [appDelegate.moviePlayer play];
    [appDelegate.moviePlayer setFullscreen:NO animated:YES];*/
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [self addTab];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) playMusic:(NSURL *) urlVal {
    
    [self.moviePlayer setContentURL:urlVal];
    //[self.moviePlayer setShouldAutoplay:NO];
    //[self.moviePlayer setControlStyle: MPMovieControlStyleEmbedded];
    //self.moviePlayer.view.hidden = YES;
    //[self.moviePlayer prepareToPlay];
    [self.moviePlayer play];
    self.moviePlayer.AllowsAirPlay = true;
    //self.moviePlayer.airPlayVideoActive = true ;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"111 === %@", [userDefault valueForKey:@"songRedirectionType"]);
    NSLog(@"122 === %@", [userDefault valueForKey:@"songRedirectionTypeSubType"]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
}

#pragma mark - remote control events
-(void) showSongTitle:(NSString *) songTitle {
    if([songTitle length] > 0) {
    NSMutableDictionary *info=[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"EasyPlay",songTitle,nil] forKeys:[NSArray arrayWithObjects: MPMediaItemPropertyTitle,MPMediaItemPropertyArtist,nil]];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    }
}


- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"remoteControlReceivedWithEvent === %d", receivedEvent.subtype) ;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if(receivedEvent.subtype == UIEventSubtypeRemoteControlNextTrack) {
        /*NowSongsPlay *nowPlayObj = nil ;
        int nextVal = [[userDefault valueForKey:@"playIndex"] integerValue] + 1 ;
        NSLog(@"appDelegate.songsList === %@", appDelegate.songsList) ;
        if([appDelegate.songsList count] < nextVal) {
            nowPlayObj = [appDelegate.songsList objectAtIndex:nextVal] ;
            [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playIndex"];
           [musicPlayer nextSongsFromApp:nextVal];
            [self showSongTitle:nowPlayObj.titleVal];
        }*/
        if([appDelegate.songsList count]) {
           [musicPlayer nextSongs:nil] ;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            NSString *notificationName = @"CategoryChangeNotification";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
        }
        
        
    }else if(receivedEvent.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
        NowSongsPlay *nowPlayObj = nil ;
        /*if([[userDefault valueForKey:@"playIndex"] integerValue] >= 2) {
            int nextVal = [[userDefault valueForKey:@"playIndex"] integerValue] - 1 ;
            if(nextVal > 0) {
                nowPlayObj = [appDelegate.songsList objectAtIndex:nextVal] ;
                [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playIndex"];
                [musicPlayer nextSongsFromApp:nextVal];
                [self showSongTitle:nowPlayObj.titleVal];
            }
        }else{
            //[self.moviePlayer stop] ;
        }*/
        if([appDelegate.songsList count]) {
            [musicPlayer previousSong:nil] ;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            NSString *notificationName = @"CategoryChangeNotification";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
        }
        
    }else if(receivedEvent.subtype == UIEventSubtypeRemoteControlPause) {
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        [self resignFirstResponder];
        [[self moviePlayer] stop] ;
        appDelegate.songsList = appDelegate.tmpSongsList ;
        int nextVal = [[userDefault valueForKey:@"playIndex"] integerValue];
        [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playIndex"];
        
        NSLog(@"111 === %@", [userDefault valueForKey:@"songRedirectionType"]);
        NSLog(@"122 === %@", [userDefault valueForKey:@"songRedirectionTypeSubType"]);
        
        [userDefault setValue:[userDefault valueForKey:@"songRedirectionType"] forKey:@"songRedirectionType"];
        [userDefault setValue:[userDefault valueForKey:@"songRedirectionTypeSubType"] forKey:@"songRedirectionTypeSubType"];
        NSLog(@"appDelegate.songsList === %@===%d", appDelegate.songsList, nextVal) ;
    }else if(receivedEvent.subtype == UIEventSubtypeRemoteControlPlay) {
        /*NowSongsPlay *nowPlayObj = nil ;
        int nextVal = [[userDefault valueForKey:@"playIndex"] integerValue]  ;
        nowPlayObj = [appDelegate.songsList objectAtIndex:nextVal] ;
        [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)nextVal] forKey:@"playIndex"];
        if([nowPlayObj.musicTypeVal isEqualToString:@"Youtube"]) {
            
            [self getYouTubeURLVal:nowPlayObj.musicURLVal indexVal:nextVal] ;
        }else{
            [self playMusic:[NSURL URLWithString:nowPlayObj.musicURLVal]];
        }*/
        NSLog(@"appDelegate.songsList === %@===%d", appDelegate.songsList, [[userDefault valueForKey:@"playIndex"] integerValue]) ;
        [self.moviePlayer play] ;
    }
   // [self.moviePlayer remote]
    //[self.moviePlayer remoteControlReceivedWithEvent:receivedEvent];
}

-(void) getYouTubeURLVal:(NSString *) youTubeURLVal indexVal:(int) index {
    
    NSString *url1= youTubeURLVal;
    
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
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                    return;
                }
                NSURL *videoURL = [NSURL URLWithString:URLString];
                [self playMusic:videoURL];
               // [self playYouTubeVideo:videoURL indexVal:index] ;
                
                //[self playYouTubeVideo:_urlToLoad];
                //[self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
    
}

-(void) playMusicVal {
    [self.moviePlayer play] ;
    
}

-(void) pauseMusic {
    //[self.moviePlayer setContentURL:urlVal];
    [self.moviePlayer pause];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerPlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
}

-(NSString*)timeFormatValue:(float)value{
    
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

-(void) MPMoviePlayerPlaybackStateFinished:(NSNotification *) notification {
    NSLog(@"innnnnn MPMoviePlayerPlaybackStateFinished") ;
    self.songInNowPlaying = NO ;
    self.inSongFinished = YES ;
    self.stopCountVal = 0 ;
    NSString *notificationName12 = @"disablePlayButtons";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName12 object:nil userInfo:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"] && [[userDefault valueForKey:@"setRepeat"] isEqualToString:@"0"]) {
        NSLog(@"Delete Index === %d", [[userDefault valueForKey:@"playIndex"] integerValue]) ;
        if([appDelegate.songsList count] > 0) {
            NowSongsPlay *nowPlayObj = [appDelegate.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]];
            [DatabaseController deletePlayTrackVal:nowPlayObj.titleVal urlVal:nowPlayObj.musicURLVal];
            
            NSString *notificationName11 = @"deletePlayedTracks";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName11 object:nil userInfo:nil];
        }
        
    }
    
    
    int val ;
    if ([[userDefault valueForKey:@"setRepeat"] isEqualToString:@"1"]) {
        val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
    }else{
        if(![[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
            if([[DatabaseController getSongsData] count]) {
                val = 0 ;
                [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playQueuedIndex"];
                appDelegate.songsList = nil ;
                appDelegate.songsList = appDelegate.queuedSongsList ;
            }else{
                val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
                //[userDefault setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playQueuedIndex"];
            }
            
        }else{
            val = [[userDefault valueForKey:@"playQueuedIndex"] integerValue] ;
            if([[DatabaseController getSongsData] count] <= val) {
                 val = 0 ;
            }
            appDelegate.songsList = nil ;
            appDelegate.songsList = appDelegate.queuedSongsList ;
        }
        
        
        /*if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
            val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
        }else{
            val = [[userDefault valueForKey:@"playIndex"] integerValue] + 1 ;
        }*/
        
        
    }
    
    if ([[userDefault valueForKey:@"setRepeat"] isEqualToString:@"0"]) {
        if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
            if(val >= [[DatabaseController getSongsData] count]) {
                val = 0 ;
            }
        }else{
            if([[DatabaseController getSongsData] count]) {
                val = 0 ;
            }else{
                val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
            }
            /*if(val >= [self.songsList count]) {
                val = 0 ;
            }*/
        }
        
        if([[DatabaseController getSongsData] count] > 0) {
            [userDefault setValue:@"queuedtrack" forKey:@"songRedirectionType"] ;
            [userDefault setValue:@"queued" forKey:@"songRedirectionTypeSubType"] ;
        }
        
       // [user setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playIndex"];
        if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
            if([[DatabaseController getSongsData] count] > 0) {
                [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playQueuedIndex"];
                [musicPlayer nextSongsFromApp:val];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
                NSString *notificationName = @"CategoryChangeNotification";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
                
            }else{
                [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
                [self.moviePlayer pause];
            }
        }else{
            
            [musicPlayer nextSongs:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            NSString *notificationName = @"CategoryChangeNotification";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
        }
    }else{
        [musicPlayer nextSongsFromApp:val];
    }
    
    
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    //[musicPlayer nextSongs:nil];
    // [musicPlayer.songName setText:@"asdasd"];
    // [musicPlayer.songDesc setText:@"sa"];
    
    
    self.currentPlaySong = @"";
    NSString *notificationName1 = @"ChangePlyaImage";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName1 object:nil userInfo:nil];
}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    NSLog(@"reason === %d", reason) ;
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    { //playing
        //self.inSongFinished = YES ;
        NSLog(@"MPMoviePlaybackStatePlaying") ;
        NSString *notificationName = @"ChangePlyaImage";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
        
        NSString *notificationNameStartPlay = @"startPlay";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationNameStartPlay object:nil userInfo:nil];
        self.songInNowPlaying = YES ;
        self.stopCountVal = 0 ;
       
    }else if (self.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    { //stopped
        self.inSongFinished = YES ;
        self.currentPlaySong = @"";
        NSString *notificationName = @"ChangePlyaImage";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
        NSLog(@"MPMoviePlaybackStateStopped") ;
        
        
        NSString *totTime =  [NSString stringWithFormat:@"%@", [self timeFormatValue:[appDelegate.moviePlayer duration]]];
        NSString *currentTime =  [NSString stringWithFormat:@"%@", [self timeFormatValue:[appDelegate.moviePlayer currentPlaybackTime]]];
        
        if(![totTime isEqualToString:@"0:00"] && ![currentTime isEqualToString:@"0:00"] && [totTime isEqualToString:currentTime]) {
            self.inSongFinished = NO ;
            NSLog(@"Innnn currentTime") ;
            //checkSongStatus = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(nextSongsPlayProcess) userInfo:nil repeats:NO];
            [self performSelector:@selector(nextSongsPlayProcess) withObject:nil afterDelay:4.0];
        }
        
       // [self nextSongsPlayProcess] ;
       
    }else if (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused)
    { //paused
        if(self.appinBackground) {
            [self.moviePlayer play] ;
        }
       NSLog(@"MPMoviePlaybackStatePaused") ;
        
        NSString *totTime =  [NSString stringWithFormat:@"%@", [self timeFormatValue:[appDelegate.moviePlayer duration]]];
        NSString *currentTime =  [NSString stringWithFormat:@"%@", [self timeFormatValue:[appDelegate.moviePlayer currentPlaybackTime]]];
        NSLog(@"totTime == %@", totTime) ;
        NSLog(@"currentTime == %@", currentTime) ;
        if(![totTime isEqualToString:@"0:00"] && ![currentTime isEqualToString:@"0:00"] && [totTime isEqualToString:currentTime]) {
            self.inSongFinished = NO ;
            NSLog(@"Innnn currentTime") ;
            //checkSongStatus = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(nextSongsPlayProcess) userInfo:nil repeats:NO];
            [self performSelector:@selector(nextSongsPlayProcess) withObject:nil afterDelay:4.0];
        }
        
        
    }if (self.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
    { //interrupted
         NSLog(@"MPMoviePlaybackStateInterrupted") ;
        self.currentPlaySong = @"";
      /*  NSString *notificationName = @"ChangePlyaImage";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];*/
    }else if (self.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward)
    { //seeking forward
        NSLog(@"MPMoviePlaybackStateSeekingForward") ;
        self.currentPlaySong = @"";
        
    }else if (self.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    { //seeking backward
        NSLog(@"MPMoviePlaybackStateSeekingBackward") ;
        self.currentPlaySong = @"";
       
    }else{
       
    }
    
}

-(void) nextSongsPlayProcess {
    
    if(!self.inSongFinished) {
        NSLog(@"innnnnn nextSongsPlayProcess");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        self.songInNowPlaying = NO ;
        self.inSongFinished = YES ;
        self.stopCountVal = 0 ;
        NSString *notificationName12 = @"disablePlayButtons";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName12 object:nil userInfo:nil];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"] && [[userDefault valueForKey:@"setRepeat"] isEqualToString:@"0"]) {
            
            NSLog(@"Delete Song from NextSongs== %d", [[userDefault valueForKey:@"playIndex"] integerValue]) ;
            
            if([appDelegate.songsList count]) {
            NowSongsPlay *nowPlayObj = [appDelegate.songsList objectAtIndex:[[userDefault valueForKey:@"playIndex"] integerValue]];
            [DatabaseController deletePlayTrackVal:nowPlayObj.titleVal urlVal:nowPlayObj.musicURLVal];
            
            NSString *notificationName11 = @"deletePlayedTracks";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName11 object:nil userInfo:nil];
            }
            
        }
        
        
        int val ;
        if ([[userDefault valueForKey:@"setRepeat"] isEqualToString:@"1"]) {
            val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
        }else{
            if(![[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
                if([[DatabaseController getSongsData] count]) {
                    val = 0 ;
                    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playQueuedIndex"];
                    appDelegate.songsList = nil ;
                    appDelegate.songsList = appDelegate.queuedSongsList ;
                }else{
                    val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
                    //[userDefault setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playQueuedIndex"];
                }
                
            }else{
                val = [[userDefault valueForKey:@"playQueuedIndex"] integerValue] ;
                if([[DatabaseController getSongsData] count] <= val) {
                    val = 0 ;
                }
                appDelegate.songsList = nil ;
                appDelegate.songsList = appDelegate.queuedSongsList ;
            }
            
            
            /*if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
             val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
             }else{
             val = [[userDefault valueForKey:@"playIndex"] integerValue] + 1 ;
             }*/
            
            
        }
        
        if ([[userDefault valueForKey:@"setRepeat"] isEqualToString:@"0"]) {
            if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
                if(val >= [[DatabaseController getSongsData] count]) {
                    val = 0 ;
                }
            }else{
                if([[DatabaseController getSongsData] count]) {
                    val = 0 ;
                }else{
                    val = [[userDefault valueForKey:@"playIndex"] integerValue] ;
                }
                /*if(val >= [self.songsList count]) {
                 val = 0 ;
                 }*/
            }
            
            if([[DatabaseController getSongsData] count] > 0) {
                [userDefault setValue:@"queuedtrack" forKey:@"songRedirectionType"] ;
                [userDefault setValue:@"queued" forKey:@"songRedirectionTypeSubType"] ;
            }
            
            // [user setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playIndex"];
            if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
                if([[DatabaseController getSongsData] count] > 0) {
                    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)val] forKey:@"playQueuedIndex"];
                    [musicPlayer nextSongsFromApp:val];
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
                    NSString *notificationName = @"CategoryChangeNotification";
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
                    
                }else{
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
                    // [self.moviePlayer pause];
                }
            }else{
                [musicPlayer nextSongs:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
                NSString *notificationName = @"CategoryChangeNotification";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
        }else{
            [musicPlayer nextSongsFromApp:val];
        }
        
        
        //  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        
        //[musicPlayer nextSongs:nil];
        // [musicPlayer.songName setText:@"asdasd"];
        // [musicPlayer.songDesc setText:@"sa"];
        
        
        self.currentPlaySong = @"";
        NSString *notificationName1 = @"ChangePlyaImage";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName1 object:nil userInfo:nil];
    }
}

-(void) addTab
{
    UIViewController *viewController1 = [[PlayListViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    viewController1.tabBarItem = [[CustomTabBarItem alloc] initWithTitle:nil normalImage:[[UIImage imageNamed:@"playlist.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] highlightedImage:[[UIImage imageNamed:@"playlist-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    viewController1.tabBarItem.imageInsets  = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UIViewController *viewController2 = [[QueueTrackViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    viewController2.tabBarItem = [[CustomTabBarItem alloc] initWithTitle:nil normalImage:[[UIImage imageNamed:@"tracklist.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] highlightedImage:[[UIImage imageNamed:@"tracklist-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    viewController2.tabBarItem.imageInsets  = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UIViewController *viewController3 = [[SearchSongsViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
   // viewController3.tabBarItem = [[CustomTabBarItem alloc] initWithTitle:nil normalImage:[[UIImage imageNamed:@"search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] highlightedImage:[[UIImage imageNamed:@"search-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
     //viewController3.tabBarItem = [[CustomTabBarItem alloc] initWithTitle:nil normalImage:[UIImage imageNamed:@"search.png"] highlightedImage:[UIImage imageNamed:@"search-active.png"] tag:2];
    viewController3.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"search-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    viewController3.tabBarItem.imageInsets  = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UIViewController *viewController4 = [[BrowseViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    viewController4.tabBarItem = [[CustomTabBarItem alloc] initWithTitle:nil normalImage:[[UIImage imageNamed:@"browse.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] highlightedImage:[[UIImage imageNamed:@"browse-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:4];
    viewController4.tabBarItem.imageInsets  = UIEdgeInsetsMake(5, 0, -5, 0);
    
    
    UIViewController *viewController5 = [[SettingViewController alloc] init];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:viewController5];
    viewController5.tabBarItem = [[CustomTabBarItem alloc] initWithTitle:nil normalImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] highlightedImage:[[UIImage imageNamed:@"settings-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:5];
    viewController5.tabBarItem.imageInsets  = UIEdgeInsetsMake(5, 0, -5, 0);
    
    self.tabBarControllers = [[UITabBarController alloc] init];
    self.tabBarControllers.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
    
    self.window.rootViewController = self.tabBarControllers;
    self.tabBarControllers.delegate = self;
    
    [self.tabBarControllers.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarImag.png"]] ;
    
   /* if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        //iOS 5
        [self.tabBarControllers.tabBar insertSubview:imageView atIndex:1];
    }
    else {
        //iOS 4.whatever and below
        [self.tabBarControllers.tabBar insertSubview:imageView atIndex:0];
    }*/
    
    //[[UITabBar appearance] setTintColor:[UIColor colorWithRed:4.00/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    //self.tabBarControllers.tabBar.tintColor = [[UIColor alloc] initWithRed:4.00/255 green:36.0/255 blue:75.0/255 alpha:1.0];
    
    self.tabBarControllers.selectedIndex = 2;
    //MoreNavigationController End
    
    [self.window makeKeyAndVisible];
    
    
    
}


/*
-(void)addtabbar
{
    SearchSongsViewController *searchview=[[SearchSongsViewController alloc]init];
    
    SettingViewController *settingview=[[SettingViewController alloc]init];
    
    BrowseViewController *browseview=[[BrowseViewController alloc]init];
    
    QueueTrackViewController *queueview=[[QueueTrackViewController alloc]init];
    
    PlayListViewController *playlistview=[[PlayListViewController alloc]init];
    
    
    nav3=[[UINavigationController alloc]initWithRootViewController:searchview];
    // nav3.tabBarItem.title=@"Search";
    
    nav4=[[UINavigationController alloc]initWithRootViewController:browseview];
   // nav4.tabBarItem.title=@"Browse";
    
     nav5=[[UINavigationController alloc]initWithRootViewController:settingview];
  //  nav5.tabBarItem.title=@"Setting";
    
     nav2=[[UINavigationController alloc]initWithRootViewController:queueview];
   // nav2.tabBarItem.title=@"Queue";
     nav1=[[UINavigationController alloc]initWithRootViewController:playlistview];
   // nav1.tabBarItem.title=@"Playlist";
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    
    [tabViewControllers addObject:nav1];
    [tabViewControllers addObject:nav2];
    [tabViewControllers addObject:nav3];
    [tabViewControllers addObject:nav4];
     [tabViewControllers addObject:nav5];
    tab=[[UITabBarController alloc]init];

   // [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    tab.viewControllers=tabViewControllers;
    tab.delegate = self ;
   // [self.window addSubview:tab.view];
     self.window.rootViewController=tab;
    
    NSArray *tabbarItems = tab.tabBar.items;
    
    UITabBarItem *tabbarItem1=[tabbarItems objectAtIndex:0];
    UITabBarItem *tabbarItem2=[tabbarItems objectAtIndex:1];
    UITabBarItem *tabbarItem3=[tabbarItems objectAtIndex:2];
    UITabBarItem *tabbarItem4=[tabbarItems objectAtIndex:3];
    UITabBarItem *tabbarItem5=[tabbarItems objectAtIndex:4];
    
    
    [tabbarItem1 setImage:[UIImage imageNamed:@"playlist.png"]];
    [tabbarItem2 setImage:[UIImage imageNamed:@"tracklist.png"]];
    [tabbarItem3 setImage:[UIImage imageNamed:@"search.png"]];
    [tabbarItem4 setImage:[UIImage imageNamed:@"browse.png"]];
    [tabbarItem5 setImage:[UIImage imageNamed:@"settings.png"]];
    
    
    tab.selectedIndex = 2;

}*/


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    user=[NSUserDefaults standardUserDefaults];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *tempNavController=(UINavigationController *)viewController;
        UIViewController *temp=[[tempNavController viewControllers]objectAtIndex:0];
        NSLog(@"temp == %@",temp) ;
        if([temp isKindOfClass:[PlayListViewController class]])
        {
             int i=[[user valueForKey:@"status_flag"] intValue];
            NSLog(@"value=%@",[user valueForKey:@"status_flag"]);
            NSLog(@"loging user === %@", [user valueForKey:@"uid"]) ;
            if([user valueForKey:@"uid"]) {
                
                return YES ;
            }else{
                SignInViewController *signinview=[[SignInViewController alloc]init];
                //[self presentViewController:signinview animated:YES completion:nil];
                [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentModalViewController:signinview animated:YES];
                return NO;
            }
            
            SignInViewController *signinview=[[SignInViewController alloc]init];
            //[self presentViewController:signinview animated:YES completion:nil];
            [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentModalViewController:signinview animated:YES];
            return NO;
        }
        
        if([temp isKindOfClass:[SettingViewController class]])
        {
            int i=[[user valueForKey:@"status_flag"] intValue];
            NSLog(@"value=%@",[user valueForKey:@"status_flag"]);
            if([user valueForKey:@"uid"]) {
                return YES ;
            }else{
                SignInViewController *signinview=[[SignInViewController alloc]init];
                //[self presentViewController:signinview animated:YES completion:nil];
                [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentModalViewController:signinview animated:YES];
                return NO;
            }
            
            SignInViewController *signinview=[[SignInViewController alloc]init];
            //[self presentViewController:signinview animated:YES completion:nil];
            [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentModalViewController:signinview animated:YES];
            return NO;
        }

        
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *tempNavController=(UINavigationController *)viewController;
        UIViewController *temp=[[tempNavController viewControllers]objectAtIndex:0];
        NSLog(@"temp == %@",temp) ;
        if([temp isKindOfClass:[PlayListViewController class]])
        {
            [tempNavController popToRootViewControllerAnimated:YES] ;
        }
        
        
        
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   // [self.moviePlayer play] ;
    NSLog(@"applicationWillResignActive") ;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.appinBackground = YES ;
    [self.moviePlayer play] ;
    NSLog(@"applicationDidEnterBackground") ;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.appinBackground = NO ;
    NSLog(@"applicationWillEnterForeground") ;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.appinBackground = NO ;
   // [self.moviePlayer play] ;
    NSLog(@"applicationDidBecomeActive") ;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.appinBackground = NO ;
   // NSLog(@"applicationWillTerminate") ;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error {
    NSLog(@"Failed loading video due to error:%@", error);
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

/*
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}*/



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
