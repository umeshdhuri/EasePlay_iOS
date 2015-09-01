//
//  QueueTrackTableViewCell.h
//  EasePlay
//
//  Created by AppKnetics on 18/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetImage.h"
#import "SWTableViewCell.h"

@interface QueueTrackTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbimage;
@property (weak, nonatomic) IBOutlet UILabel *songtitle;
@property (weak, nonatomic) IBOutlet UILabel *songsubtitle;
@property (weak, nonatomic) IBOutlet UIButton *plaupausebtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn ;
@property (weak, nonatomic) IBOutlet UIButton *dragBtn ;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator ;
@property (weak, nonatomic) IBOutlet UIImageView *playPlaceHolder ;


@property (nonatomic, readwrite) BOOL isPlayingVal;
- (IBAction)playpauseclk:(id)sender;


@end
