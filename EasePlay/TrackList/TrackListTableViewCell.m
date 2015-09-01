//
//  TrackListTableViewCell.m
//  EasePlay
//
//  Created by AppKnetics on 20/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "TrackListTableViewCell.h"

@implementation TrackListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    
    
}
@end
