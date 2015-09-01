//
//  SearchSongTableViewCell.h
//  EasePlay
//
//  Created by AppKnetics on 13/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetImage.h"
#import "SWTableViewCell.h"

@interface SearchSongTableViewCell : SWTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *songtitlelbl;
@property (weak, nonatomic) IBOutlet UILabel *songsubtitlelbl;

@property (weak, nonatomic) IBOutlet UIImageView *thumbimage;
@property (weak, nonatomic) IBOutlet UIButton *playpausebtn;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;
@property (weak, nonatomic) IBOutlet UIButton *addsongbtn;
@property (weak, nonatomic) IBOutlet UIImageView *playPlaceHolder ;
@property (weak, nonatomic) IBOutlet UILabel *songcountlbl;




@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator ;
@property (nonatomic, readwrite) BOOL isPlayingVal;
- (IBAction)playpausebtnclk:(id)sender;
- (IBAction)loginclk:(id)sender;
- (IBAction)addsongclk:(id)sender;

@end
