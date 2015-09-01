//
//  AppDelegate.h
//  EasePlay
//
//  Created by AppKnetics on 13/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicPlayerViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaQuery.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    MusicPlayerViewController *musicPlayer ;
    NSUserDefaults *user;
    NSTimer *checkSongStatus ;
    NSString *currentSongPlayTime ;
}
@property (nonatomic, readwrite) BOOL appinBackground ;
@property (nonatomic, strong) MPMoviePlayerController* moviePlayer;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong) NSString * currentPlaySong;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarControllers;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSArray *songsList, *tmpSongsList, *queuedSongsList ;
@property (nonatomic, readwrite) BOOL songInNowPlaying, inSongFinished ;
@property (nonatomic, readwrite) int stopCountVal ;

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent ;
-(void) playMusic:(NSURL *) urlVal ;
- (void)saveContext;
-(void) pauseMusic ;
-(void) playMusicVal ;
- (NSURL *)applicationDocumentsDirectory;
-(void) showSongTitle:(NSString *) songTitle ;
@end
