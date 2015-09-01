//
//  SearchSongsViewController.h
//  EasePlay
//
//  Created by AppKnetics on 13/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoModel.h"
#import "LBYouTubePlayerViewController.h"
#import "Constant.h"
#import "Global.h"
#import "PlayListTableViewCell.h"
#import "MusicPlayerViewController.h"
#import "SWTableViewCell.h"

@interface SearchSongsViewController : UIViewController <AVAudioPlayerDelegate,LBYouTubePlayerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SWTableViewCellDelegate, UIImagePickerControllerDelegate>
{
     LBYouTubePlayerViewController *lbYoutubePlayerVC;
    //MPMoviePlayerViewController *mp ;
    int selectedIndexVal ;
    NSMutableArray *currentPlayList ;
    UITextField *currentTxt ;
    UIView *addplaylistview ;
    NSString *nextTokanVal ;
    int nextCloudVal ;
    //MusicPlayerViewController *musicPlayer ;
}

@property (weak, nonatomic) VideoModel* video;
@property (weak, nonatomic) IBOutlet UITableView *songlisttabl;

@property (weak, nonatomic) IBOutlet UIView *searchview;
@property (nonatomic, strong, readonly) MPMoviePlayerController* moviePlayer;
@property (nonatomic, weak) IBOutlet id <LBYouTubePlayerControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *betportbtn;

@property (weak, nonatomic) IBOutlet UIButton *grooveshrkbtn;

@property (weak, nonatomic) IBOutlet UIButton *souncloudbtn;
@property(nonatomic,retain)UIImage *playlistimage;

@property (weak, nonatomic) IBOutlet UIButton *youtubebtn;

@property (nonatomic, weak) IBOutlet UIImageView *youtubeImg, *grooveshrImg, *soundcloudImg, *betportImg ;
@property (nonatomic, weak) IBOutlet UILabel *noSongsLbl ;

@property (weak, nonatomic) IBOutlet UIButton *crossbtn;


- (IBAction)crossbtnclk:(id)sender;

- (IBAction)beatprtclk:(id)sender;

- (IBAction)youtbclk:(id)sender;
- (IBAction)soundcldclk:(id)sender;
- (IBAction)groovshrkclk:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *serchsongtf;
@property (weak, nonatomic) IBOutlet UIButton *nowPlayingBtn ;
@property (nonatomic, weak) IBOutlet UIButton *viewMore ;
@property (nonatomic, weak) IBOutlet UILabel *viewMoreSeperatore ;

@end
