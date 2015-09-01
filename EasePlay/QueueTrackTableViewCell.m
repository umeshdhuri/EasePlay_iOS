//
//  QueueTrackTableViewCell.m
//  EasePlay
//
//  Created by AppKnetics on 18/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "QueueTrackTableViewCell.h"

@implementation QueueTrackTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
    
}

-(void)initialize{
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsPlaying:(BOOL)isPlaying
{
    self.isPlayingVal = isPlaying;
}

- (IBAction)playpauseclk:(id)sender {
}
@end
