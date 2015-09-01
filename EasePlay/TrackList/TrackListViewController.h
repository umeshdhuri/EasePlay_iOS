//
//  TrackListViewController.h
//  EasePlay
//
//  Created by AppKnetics on 20/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "InternetImage.h"
#import "SWTableViewCell.h"

@interface TrackListViewController : UIViewController<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UINavigationControllerDelegate,SWTableViewCellDelegate> {
    NSMutableArray *currentPlayList ;
    UITextField *currentTxt, *currentTextField ;
    NSIndexPath *textindex;
    BOOL updateTrack ;
}

@property (weak, nonatomic) IBOutlet UILabel *playlisttitle;

@property (weak, nonatomic) IBOutlet UILabel *playlistsubtitle;
@property (weak, nonatomic) IBOutlet UITableView *trackstbl;

@property (weak, nonatomic) IBOutlet InternetImage *playlistimage;

@property (weak, nonatomic) IBOutlet UIView *playlistview;

@property (weak, nonatomic) IBOutlet UITableView *tracklisttbl;

@property (weak, nonatomic) IBOutlet UIButton *addttrackbtn;

@property (weak, nonatomic) IBOutlet UIButton *editbtn;
@property(nonatomic,retain)UIImage *thumbimage;
@property (weak, nonatomic) IBOutlet UILabel *notrackslbl;

@property (weak, nonatomic) IBOutlet UIButton *deletebtn;
@property (weak, nonatomic) IBOutlet UIButton *nowPlayingBtn ;

@property (weak, nonatomic) IBOutlet UIView *swipeview;


- (IBAction)addtrackclk:(id)sender;


- (IBAction)deleteplaylistclk:(id)sender;

- (IBAction)editplaylistclk:(id)sender;

@end
