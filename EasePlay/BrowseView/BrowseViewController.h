//
//  BrowseViewController.h
//  EasePlay
//
//  Created by AppKnetics on 31/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoModel.h"
#import "LBYouTubePlayerViewController.h"
#import "Constant.h"
#import "Global.h"
#import "NAPopoverView.h"
#import "SWTableViewCell.h"

@interface BrowseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,SWTableViewCellDelegate> {
    NSMutableArray *currentPlayList ;
    int nextCloudVal ;
}

@property (nonatomic, weak) IBOutlet UITableView *browseTbl ;
@property (nonatomic, weak) IBOutlet UIImageView *youtubeImg, *soundCloudImg, *grooveImg, *beatImg;
@property (nonatomic, weak) IBOutlet UILabel *noBrowseList ;
@property(nonatomic,retain)UIImage *playlistimage;

@property (nonatomic, strong, readonly) MPMoviePlayerController* moviePlayer;
@property (nonatomic, weak) IBOutlet id <LBYouTubePlayerControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *nowPlayingBtn ;


@end
