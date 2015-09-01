//
//  SearchSongTableViewCell.m
//  EasePlay
//
//  Created by AppKnetics on 13/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "SearchSongTableViewCell.h"

@implementation SearchSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        

    }
    return self;
}


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
    
    //[self.thumbimage.layer  setCornerRadius:5];
   // [self.thumbimage.layer  setMasksToBounds:YES];
    
   
    
}


-(void)layoutSubviews
{
   /* if (!_playPlaceHolder) {
        // http://commons.wikimedia.org/wiki/File:Speaker_Icon.svg
        self.playPlaceHolder.image = [UIImage imageNamed:@"pause-placeholder.png"];
    }
    
    if(!self.isPlaying){
        self.playPlaceHolder.image = nil;
    } else {
        //self.playPlaceHolder.image = [UIImage imageNamed:@"pause-placeholder.png"];
        //self.playPlaceHolder.hidden =NO;
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
    }*/
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
   
}

-(void)setIsPlaying:(BOOL)isPlaying
{
    self.isPlayingVal = isPlaying;
    
    
}

- (IBAction)playpausebtnclk:(id)sender {
}

- (IBAction)loginclk:(id)sender {
}

- (IBAction)addsongclk:(id)sender {
}
@end
