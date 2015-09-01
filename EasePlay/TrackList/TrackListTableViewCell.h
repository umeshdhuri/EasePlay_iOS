//
//  TrackListTableViewCell.h
//  EasePlay
//
//  Created by AppKnetics on 20/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetImage.h"
#import "SWTableViewCell.h"

@interface TrackListTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *trackimage;

@property (weak, nonatomic) IBOutlet UILabel *tracktitle;

@property (weak, nonatomic) IBOutlet UILabel *tracksubtitle;

@property (weak, nonatomic) IBOutlet UILabel *tracktime;

@property (weak, nonatomic) IBOutlet UIButton *addtrackbtn;

@property (weak, nonatomic) IBOutlet UIButton *delettrackbtn;

@property (weak, nonatomic) IBOutlet UIButton *edittrackbtn;

@property (weak, nonatomic) IBOutlet UITextField *tracknmtf;
@property (weak, nonatomic) IBOutlet UITextField *edittrcktf;
@property (nonatomic, assign) BOOL isPlaying;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator ;

@property (weak, nonatomic) IBOutlet UIImageView *playPlaceHolder ;
@property (nonatomic, readwrite) BOOL isPlayingVal;

@end
