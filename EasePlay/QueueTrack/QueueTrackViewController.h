//
//  QueueTrackViewController.h
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoModel.h"
#import "LBYouTubePlayerViewController.h"
#import "MusicPlayerViewController.h"
#import "SWTableViewCell.h"
#import "DragAndDropTableView.h"

@interface QueueTrackViewController : UIViewController <AVAudioPlayerDelegate,LBYouTubePlayerControllerDelegate,SWTableViewCellDelegate,DragAndDropTableViewDelegate,DragAndDropTableViewDelegate> {
    NSArray *songsListData ;
    NSMutableArray *songsListresult ;
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerController *player;
    int playIndex ;
    NSUserDefaults *userDefault ;
 //    MusicPlayerViewController *musicPlayer ;
}

@property (weak, nonatomic) IBOutlet UITableView *songtable;
@property (nonatomic, weak) IBOutlet UILabel *noQueuedLbl;

@property (weak, nonatomic) IBOutlet UIButton *playpausebtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardbtn;
@property (weak, nonatomic) IBOutlet UIButton *backwrdbtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatbtn;
@property (weak, nonatomic) IBOutlet UIButton *shufflebtn;

@property (weak, nonatomic) IBOutlet UILabel *remngtmlbl;
@property (weak, nonatomic) IBOutlet UILabel *timeplaybtn;
@property (weak, nonatomic) IBOutlet UILabel *songsubtitlelbl;
@property (weak, nonatomic) IBOutlet UILabel *songtitlelbl;
@property (weak, nonatomic) IBOutlet UIButton *nowPlayingBtn ;



//@property (nonatomic, strong, readonly) MPMoviePlayerController* moviePlayer;
@property (nonatomic, weak) IBOutlet id <LBYouTubePlayerControllerDelegate> delegate;



@end
