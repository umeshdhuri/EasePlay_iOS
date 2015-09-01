//
//  SWTableViewCell.h
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "SWCellScrollView.h"
#import "SWLongPressGestureRecognizer.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "NSMutableArray+SWUtilityButtons.h"

@class SWTableViewCell;

typedef NS_ENUM(NSInteger, SWCellState)
{
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight,
};

@protocol SWTableViewCellDelegate <NSObject>

@optional
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state;
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell;
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state;
- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell;
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView;

@end

@interface SWTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *leftUtilityButtons;
@property (nonatomic, copy) NSArray *rightUtilityButtons;

@property (nonatomic, weak) id <SWTableViewCellDelegate> delegate;

- (void)setRightUtilityButtons:(NSArray *)rightUtilityButtons WithButtonWidth:(CGFloat) width spaceValue:(int) spaceVal;
- (void)setLeftUtilityButtons:(NSArray *)leftUtilityButtons WithButtonWidth:(CGFloat) width;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)showLeftUtilityButtonsAnimated:(BOOL)animated;
- (void)showRightUtilityButtonsAnimated:(BOOL)animated;

- (BOOL)isUtilityButtonsHidden;

/*
//playlistcell
@property (weak, nonatomic) IBOutlet UILabel *playlisttitle;

@property (weak, nonatomic) IBOutlet UILabel *playlistdescrptn;

@property (weak, nonatomic) IBOutlet InternetImage *playlistimage;

@property (weak, nonatomic) IBOutlet UIButton *deletplaylistbtn;



//trackList
@property (weak, nonatomic) IBOutlet InternetImage *trackimage;

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

//queue
@property (weak, nonatomic) IBOutlet InternetImage *thumbimage;
@property (weak, nonatomic) IBOutlet UILabel *songtitle;
@property (weak, nonatomic) IBOutlet UILabel *songsubtitle;
@property (weak, nonatomic) IBOutlet UIButton *plaupausebtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn ;


//searchcell

@property (weak, nonatomic) IBOutlet UILabel *songtitlelbl;
@property (weak, nonatomic) IBOutlet UILabel *songsubtitlelbl;

@property (weak, nonatomic) IBOutlet InternetImage *thumbimage1;
@property (weak, nonatomic) IBOutlet UIButton *playpausebtn;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;
@property (weak, nonatomic) IBOutlet UIButton *addsongbtn;
@property (weak, nonatomic) IBOutlet UIImageView *playPlaceHolder1 ;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator1 ;
*/

@end
