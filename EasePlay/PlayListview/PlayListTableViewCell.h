//
//  PlayListTableViewCell.h
//  EasePlay
//
//  Created by AppKnetics on 19/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetImage.h"
#import "SWTableViewCell.h"

@interface PlayListTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *playlisttitle;

@property (weak, nonatomic) IBOutlet UILabel *playlistdescrptn;

@property (weak, nonatomic) IBOutlet UIImageView *playlistimage;

@property (weak, nonatomic) IBOutlet UIButton *deletplaylistbtn;



@end
