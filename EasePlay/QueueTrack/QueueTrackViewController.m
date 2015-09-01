//
//  QueueTrackViewController.m
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "QueueTrackViewController.h"
#import "QueueTrackTableViewCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Song.h"
#import "LBYouTubePlayerViewController.h"
#import "MusicPlayerViewController.h"
#import "HCYoutubeParser.h"
#import "UIImageView+WebCache.h"

@interface QueueTrackViewController ()
{
    NSMutableArray *songtitle;
    NSMutableArray *subtitles;
    NSMutableArray *thumbimages;
    NSMutableArray *trackurlarray;
    
    LBYouTubePlayerViewController *lbYoutubePlayerVC;
}

@end

@implementation QueueTrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _songtable.backgroundColor=[UIColor clearColor];
    
    if(isPhone480) {
        CGRect tableFrame = self.songtable.frame ;
        tableFrame.size.height = self.songtable.frame.size.height - 200 ;
        self.songtable.frame = tableFrame ;
        
    }
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    songsListData = [[NSArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0] ;
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    
    //UIImage *buttonImage = [UIImage imageNamed:@"add_icon_ph2.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitle:@"Now Playing" forState:UIControlStateNormal] ;
    aButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[aButton setBackgroundColor:[UIColor redColor]];
   // [aButton setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //[aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0.0, 110, 35);
   // UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
   // [aButton addTarget:self action:@selector(nowPlayingBtn:) forControlEvents:UIControlEventTouchUpInside];
   // [self.navigationItem setRightBarButtonItem:aBarButtonItem];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
    
    NSString *notificationName = @"deletePlayedTracks";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deletePlayedTracksMethod:)
     name:notificationName
     object:nil];
    
    [self.noQueuedLbl setHidden:YES];
    [self.songtable setHidden:YES];
    [self.songtable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self performSelector:@selector(fetchdata) withObject:nil afterDelay:0.1];
   // [self fetchdata];
    self.songtable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    NSString *notificationNamePlay = @"ChangePlyaImage";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ChangePlyaImageWithString:)
     name:notificationNamePlay
     object:nil];
    
}

- (void)ChangePlyaImageWithString:(NSNotification *)notification
{
    [self.songtable reloadData] ;
    NSLog(@"Played songs Title == %@", [userDefault valueForKey:@"ququedTrackTitle"]);
    NSLog(@"Played songs URL == %@", [userDefault valueForKey:@"ququedTrackURL"]);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
}

-(void) deletePlayedTracksMethod:(id) sender {
    [self fetchdata] ;
   // [self performSelector:@selector(fetchdata) withObject:nil afterDelay:0.1];
}

-(void)fetchdata
{
    
    songtitle=[[NSMutableArray alloc]init];
    subtitles=[[NSMutableArray alloc]init];
    thumbimages=[[NSMutableArray alloc]init];
     trackurlarray=[[NSMutableArray alloc]init];
    appDelegate.queuedSongsList = [[NSMutableArray alloc] init];
    songsListData = [DatabaseController getSongsData] ;
    songsListresult = [[NSMutableArray alloc] initWithArray:songsListData] ;
    //[mycontext save:nil];
    if([songsListresult count]) {
        //[self.noQueuedLbl setHidden:YES];
        [self.songtable setHidden:NO];
         _songtable.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
        [_songtable reloadData];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < [songsListresult count]; i++) {
            Song *songObj = [songsListresult objectAtIndex:i];
            NowSongsPlay *nowPlay = [[NowSongsPlay alloc] init];
            nowPlay.musicTypeVal = songObj.musictype;
            nowPlay.descriptionVal = songObj.subtitle;
            nowPlay.thumbVal = songObj.thumburl;
            nowPlay.titleVal = songObj.title;
            nowPlay.musicURLVal = songObj.url;
            nowPlay.indexVal = songObj.ordernumber ;
            [list addObject:nowPlay];
        }
        appDelegate.queuedSongsList = list ;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }else{
        //[self.nowPlayingBtn setHidden:YES];
        [self.noQueuedLbl setHidden:NO];
        [self.songtable setHidden:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

-(IBAction) nowPlayingBtn:(id) sender {
    if([appDelegate.songsList count]) {
        MusicPlayerViewController *musicPlayer = [[MusicPlayerViewController alloc] init];
        //musicPlayer.songsList = songsListresult ;
        //musicPlayer.songsRedirection =@"searchtrack";
        [self presentViewController:musicPlayer animated:YES completion:nil];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"”No songs in Now Playing”";
        hud.margin = 10.f;
        if(isPhone480) {
            hud.yOffset = 150.f;
        }else{
            hud.yOffset = 200.f;
        }
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_songtable) {
        return [songsListresult count];
    }
    else
    {
    
    }
   // return songtitle.count;
    return 0;
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Queue";
   /* QueueTrackTableViewCell *cell = (QueueTrackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName: @"QueueTrackTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }*/
    QueueTrackTableViewCell *cell = (QueueTrackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueueTrackTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.playPlaceHolder setHidden:YES];
    [cell.activityIndicator setHidden:YES];
    cell.isPlayingVal = NO;
    
   /* UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }*/
    Song *songsObj = [songsListresult objectAtIndex:indexPath.row] ;
    
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:30.0f spaceValue:10];
  // [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:28.0f];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    cell.backgroundColor=[UIColor clearColor];
    NSArray *nameList = [songsObj.title componentsSeparatedByString:@"###$$"];
    cell.songtitle.text=[nameList objectAtIndex:0];
    cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
    cell.plaupausebtn.tag=indexPath.row;
    /*if(![songsObj.thumburl isKindOfClass:[NSNull class]] && [songsObj.thumburl length] > 0) {
        cell.thumbimage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:songsObj.thumburl]]];
    }*/
    
   // [cell.thumbimage startImageDownloadingWithUrl:songsObj.thumburl  placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    
    [cell.thumbimage sd_setImageWithURL:[NSURL URLWithString:songsObj.thumburl] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    
    cell.songsubtitle.text = songsObj.subtitle ;

    cell.dragBtn.tag = indexPath.row ;
    [cell.dragBtn addTarget:self action:@selector(dragCell:) forControlEvents:UIControlEventTouchUpInside];
   // [cell.playBtn addTarget:self action:@selector(playpauseclk:) forControlEvents:UIControlEventTouchUpInside];
  //  cell.playBtn.tag = indexPath.row ;
    if((appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) && [[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"])
    {
       // if(([[userDefault valueForKey:@"playIndex"] integerValue] == indexPath.row) && [[userDefault valueForKey:@"songRedirectionTypeSubType"] isEqualToString:@"queued"]) {
        
        if([[userDefault valueForKey:@"ququedTrackTitle"] isEqualToString:songsObj.title] && [[userDefault valueForKey:@"ququedTrackURL"] isEqualToString:songsObj.url] && [[userDefault valueForKey:@"songRedirectionTypeSubType"] isEqualToString:@"queued"]) {
            [cell.playPlaceHolder setHidden:NO];
            [cell.activityIndicator setHidden:YES];
            cell.isPlayingVal = YES;
        }else{
            [cell.playPlaceHolder setHidden:YES];
            [cell.activityIndicator setHidden:YES];
            cell.isPlayingVal = NO;
        }
        
    }else{
        
        [cell.playPlaceHolder setHidden:YES];
        [cell.activityIndicator setHidden:YES];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_songtable setSeparatorColor:[UIColor colorWithRed:82.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1.0]];
    return cell;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"delete.png"]];
   // [rightUtilityButtons sw_addUtilityButtonWithColor:nil icon:[UIImage imageNamed:@"delete.png"]];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [_songtable indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self deletequeue:cellIndexPath];
            NSLog(@"sucess");
            break;
        }
                default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

-(IBAction)dragCell:(id)sender {
   // UIButton *btn = (UIButton *) sender ;
   // [self.songtable ]
   // QueueTrackTableViewCell *cell =(QueueTrackTableViewCell *)[self.songtable cellForRowAtIndexPath:btn.tag] ;
    
//    self.songtable
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"sourceIndexPath.row111 == %d", sourceIndexPath.row) ;
    NSLog(@"destinationIndexPath.row111 == %d", destinationIndexPath.row) ;
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleInsert == editingStyle)
    {
        // inserts are always done at the end
        
        [tableView beginUpdates];
        [songsListresult addObject:[NSMutableArray array]];
        [tableView insertSections:[NSIndexSet indexSetWithIndex:[songsListresult count]-1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
    }
    else if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        // check if we are going to delete a row or a section
        [tableView beginUpdates];
        if([[songsListresult objectAtIndex:indexPath.section] count] == 0)
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [songsListresult removeObjectAtIndex:indexPath.section];
        }
        else
        {
            // Delete the row from the table view.
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            // Delete the row from the data source.
            [[songsListresult objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        }
        [tableView endUpdates];
    }
}

#pragma mark DragAndDropTableViewDataSource

-(BOOL)canCreateNewSection:(NSInteger)section
{
    return NO;
}

#pragma mark -
#pragma mark DragAndDropTableViewDelegate

-(void)tableView:(UITableView *)tableView willBeginDraggingCellAtIndexPath:(NSIndexPath *)indexPath placeholderImageView:(UIImageView *)placeHolderImageView
{
    // this is the place to edit the snapshot of the moving cell
    // add a shadow
    placeHolderImageView.layer.shadowOpacity = .1;
    placeHolderImageView.layer.shadowRadius = 1;
    
    
}

-(void)tableView:(DragAndDropTableView *)tableView didEndDraggingCellAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath placeHolderView:(UIImageView *)placeholderImageView
{
    // The cell has been dropped. Remove all empty sections (if you want to)
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    /* for(int i = 0; i < _datasource.count; i++)
     {
     NSArray *ary = [_datasource objectAtIndex:i];
     if(ary.count == 0)
     [indexSet addIndex:i];
     }*/
    
    NSLog(@"sourceIndexPath === %d", sourceIndexPath.row);
    NSLog(@"toIndexPath === %d", toIndexPath.row);
    Song *songsObj1 = [songsListresult objectAtIndex:sourceIndexPath.row] ;
    Song *songsObj2 = [songsListresult objectAtIndex:toIndexPath.row] ;
    NSLog(@"songsObj1.ordernumber === %@", songsObj1.ordernumber) ;
    NSLog(@"songsObj1.ordernumber === %@", songsObj2.ordernumber) ;
    
    NSObject *o1 = [songsListresult objectAtIndex:toIndexPath.row];
    NSObject *o = [songsListresult objectAtIndex:sourceIndexPath.row];
    
    [songsListresult removeObjectAtIndex:sourceIndexPath.row];
     [songsListresult insertObject:o atIndex:toIndexPath.row];
    
    for (int i = 0; i < [songsListresult count]; i++) {
        
        Song *songObj = [songsListresult objectAtIndex:i];
        [DatabaseController updateOrderDataValue:songObj.title orderId:songObj.url orderVal:i] ;
        //[DatabaseController updateOrderData:[NSString stringWithFormat:@"%d", sourceIndexPath.row] orderId:[NSString stringWithFormat:@"%d", toIndexPath.row]];
    }
    
   /* [songsListresult replaceObjectAtIndex:toIndexPath.row withObject:o];
    [songsListresult replaceObjectAtIndex:sourceIndexPath.row withObject:o1];
    
    [DatabaseController updateOrderData:[NSString stringWithFormat:@"%d", sourceIndexPath.row] orderId:[NSString stringWithFormat:@"%d", toIndexPath.row]];
    
    [DatabaseController updateOrderDataTest:[NSString stringWithFormat:@"%d", toIndexPath.row] orderId:[NSString stringWithFormat:@"%d", sourceIndexPath.row]];*/
    
    NSArray *songsListData1 = [DatabaseController getSongsData] ;
    NSMutableArray *songsListresult1 = [[NSMutableArray alloc] initWithArray:songsListData1] ;
    //[mycontext save:nil];
    if([songsListresult1 count]) {
        
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < [songsListresult1 count]; i++) {
            Song *songObj = [songsListresult1 objectAtIndex:i];
            NowSongsPlay *nowPlay = [[NowSongsPlay alloc] init];
            nowPlay.musicTypeVal = songObj.musictype;
            nowPlay.descriptionVal = songObj.subtitle;
            nowPlay.thumbVal = songObj.thumburl;
            nowPlay.titleVal = songObj.title;
            nowPlay.musicURLVal = songObj.url;
            nowPlay.indexVal = songObj.ordernumber ;
            
            if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
                if ([[userDefault valueForKey:@"ququedTrackTitle"] isEqualToString:songObj.title] && [[userDefault valueForKey:@"ququedTrackURL"] isEqualToString:songObj.url]) {
                    
                    [userDefault setValue:[NSString stringWithFormat:@"%d", i] forKey:@"playIndex"];
                    [userDefault setValue:[NSString stringWithFormat:@"%d", i] forKey:@"playQueuedIndex"];
                }
            }
            
            
            [list addObject:nowPlay];
        }
        appDelegate.queuedSongsList = list ;
    }
    
    //[songsListresult removeObjectAtIndex:toIndexPath.row];
    //[songsListresult insertObject:o1 atIndex:sourceIndexPath.row];
    
    //[DatabaseController updateOrderData:[songsObj1.ordernumber stringValue] orderId:[songsObj2.ordernumber stringValue]] ;
    
    //[DatabaseController updateOrderData:[songsObj2.ordernumber stringValue] orderId:[songsObj1.ordernumber stringValue]] ;
    
    /*[tableView beginUpdates];
     [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
     [songsListresult removeObjectsAtIndexes:indexSet];
     [tableView endUpdates];*/
}

/*-(void)tableView:(DragAndDropTableView *)tableView didEndDraggingCellAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath placeHolderView:(UIImageView *)placeholderImageView
{
    // The cell has been dropped. Remove all empty sections (if you want to)
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
 
    
    NSLog(@"sourceIndexPath === %d", sourceIndexPath.row);
    NSLog(@"toIndexPath === %d", toIndexPath.row);
    Song *songsObj1 = [songsListresult objectAtIndex:sourceIndexPath.row] ;
    Song *songsObj2 = [songsListresult objectAtIndex:toIndexPath.row] ;
    NSLog(@"songsObj1.ordernumber === %@", songsObj1.ordernumber) ;
    NSLog(@"songsObj1.ordernumber === %@", songsObj2.ordernumber) ;
    
    NSObject *o1 = [songsListresult objectAtIndex:toIndexPath.row];
    NSObject *o = [songsListresult objectAtIndex:sourceIndexPath.row];
    
    //[songsListresult removeObjectAtIndex:sourceIndexPath.row];
   // [songsListresult insertObject:o atIndex:toIndexPath.row];
    [songsListresult replaceObjectAtIndex:toIndexPath.row withObject:o];
    [songsListresult replaceObjectAtIndex:sourceIndexPath.row withObject:o1];
    
    [DatabaseController updateOrderData:[NSString stringWithFormat:@"%d", sourceIndexPath.row] orderId:[NSString stringWithFormat:@"%d", toIndexPath.row]];
    
    [DatabaseController updateOrderDataTest:[NSString stringWithFormat:@"%d", toIndexPath.row] orderId:[NSString stringWithFormat:@"%d", sourceIndexPath.row]];
    
    
    NSArray *songsListData1 = [DatabaseController getSongsData] ;
    NSMutableArray *songsListresult1 = [[NSMutableArray alloc] initWithArray:songsListData1] ;
    //[mycontext save:nil];
    if([songsListresult1 count]) {
        
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < [songsListresult1 count]; i++) {
            Song *songObj = [songsListresult1 objectAtIndex:i];
            NowSongsPlay *nowPlay = [[NowSongsPlay alloc] init];
            nowPlay.musicTypeVal = songObj.musictype;
            nowPlay.descriptionVal = songObj.subtitle;
            nowPlay.thumbVal = songObj.thumburl;
            nowPlay.titleVal = songObj.title;
            nowPlay.musicURLVal = songObj.url;
            nowPlay.indexVal = songObj.ordernumber ;
            
            if([[userDefault valueForKey:@"songRedirectionType"] isEqualToString:@"queuedtrack"]) {
                if ([[userDefault valueForKey:@"ququedTrackTitle"] isEqualToString:songObj.title] && [[userDefault valueForKey:@"ququedTrackURL"] isEqualToString:songObj.url]) {
                    
                    [userDefault setValue:[NSString stringWithFormat:@"%d", i] forKey:@"playIndex"];
                    [userDefault setValue:[NSString stringWithFormat:@"%d", i] forKey:@"playQueuedIndex"];
                }
            }
            
            
            [list addObject:nowPlay];
        }
        appDelegate.queuedSongsList = list ;
    }
    
    //[songsListresult removeObjectAtIndex:toIndexPath.row];
    //[songsListresult insertObject:o1 atIndex:sourceIndexPath.row];
    
    //[DatabaseController updateOrderData:[songsObj1.ordernumber stringValue] orderId:[songsObj2.ordernumber stringValue]] ;
    
    //[DatabaseController updateOrderData:[songsObj2.ordernumber stringValue] orderId:[songsObj1.ordernumber stringValue]] ;
    
 
}*/

#pragma mark - UITableViewDelegate Methods
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // handle table view selection
    
    NSLog(@"songs=%@",songsListresult);
    //UIButton *btn = (UIButton *) sender ;
    Song *songsObj = [songsListresult objectAtIndex:indexPath.row] ;
    userDefault = [NSUserDefaults standardUserDefaults] ;
    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:@"playIndex"];
    [userDefault setValue:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:@"playQueuedIndex"];
    [userDefault setValue:@"Queued" forKey:@"PlayFrom"] ;
    
    NSLog(@"URL == %@", songsObj.musictype) ;
    NSLog(@"tag=%ld",(long)[indexPath row]);
    if ([songsObj.musictype isEqualToString:@"Youtube"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        QueueTrackTableViewCell *cell =(QueueTrackTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
        [appDelegate pauseMusic];
        
        NSString *url1= songsObj.url;
        NSURL *url = [NSURL URLWithString:url1];
        // _activityIndicator.hidden = NO;
        [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
            
            if (!error) {
                // [_playButton setBackgroundImage:image forState:UIControlStateNormal];
                
                [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                    
                    // _playButton.hidden = NO;
                    // _activityIndicator.hidden = YES;
                    
                    NSDictionary *qualities = videoDictionary;
                    
                    NSString *URLString = nil;
                    if ([qualities objectForKey:@"small"] != nil) {
                        URLString = [qualities objectForKey:@"small"];
                    }
                    else if ([qualities objectForKey:@"live"] != nil) {
                        URLString = [qualities objectForKey:@"live"];
                    }
                    else {
                        
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                        return;
                    }
                    
                     NSURL *videoURL = [NSURL URLWithString:URLString];
                    if(cell.isPlayingVal) {
                        [appDelegate pauseMusic];
                        cell.isPlayingVal = NO;
                        appDelegate.currentPlaySong = @"";
                        [cell.activityIndicator stopAnimating];
                        [cell.activityIndicator setHidden:YES];
                        [self.songtable reloadData];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                    }else{
                        [userDefault setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"] ;
                        //[appDelegate playMusic:videoURL];
                        [cell.activityIndicator startAnimating];
                        [cell.activityIndicator setHidden:NO];
                        cell.isPlayingVal = YES;
                        [self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                        [appDelegate showSongTitle:songsObj.title];
                        [userDefault setValue:songsObj.title forKey:@"ququedTrackTitle"];
                        [userDefault setValue:songsObj.url forKey:@"ququedTrackURL"];
                    }
                    
                   
                    //[self playYouTubeVideo:_urlToLoad];
                   // [self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                    
                    NSMutableArray *list = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < [songsListresult count]; i++) {
                        Song *songObj = [songsListresult objectAtIndex:i];
                        NowSongsPlay *nowPlay = [[NowSongsPlay alloc] init];
                        nowPlay.musicTypeVal = songObj.musictype;
                        nowPlay.descriptionVal = songObj.subtitle;
                        nowPlay.thumbVal = songObj.thumburl;
                        nowPlay.titleVal = songObj.title;
                        nowPlay.musicURLVal = songObj.url;
                        nowPlay.indexVal = songObj.ordernumber ;
                        [list addObject:nowPlay];
                    }
                    appDelegate.songsList = list ;
                    appDelegate.tmpSongsList = appDelegate.songsList ;
                    
                   // [self.nowPlayingBtn setHidden:NO];
                    
                    
                    
                    [userDefault setValue:@"queuedtrack" forKey:@"songRedirectionType"];
                    [userDefault setValue:@"queued" forKey:@"songRedirectionTypeSubType"];
                }];
            }
            else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
        
        
    }else if([songsObj.musictype isEqualToString:@"SoundCloud"]){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        QueueTrackTableViewCell *cell =(QueueTrackTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
        [appDelegate pauseMusic];
        
        //[appDelegate playMusic:[NSURL URLWithString:songsObj.url]];
        //[appDelegate.moviePlayer setContentURL:[NSURL URLWithString:songsObj.url]] ;
       // [appDelegate.moviePlayer play] ;
        //[self.nowPlayingBtn setHidden:NO];
        [userDefault setValue:@"queuedtrack" forKey:@"songRedirectionType"];
        [userDefault setValue:@"queued" forKey:@"songRedirectionTypeSubType"];
        
        
        if(cell.isPlayingVal) {
            [appDelegate pauseMusic];
            cell.isPlayingVal = NO;
            appDelegate.currentPlaySong = @"";
            [cell.activityIndicator stopAnimating];
            [cell.activityIndicator setHidden:YES];
            [userDefault setValue:@"" forKey:@"ququedTrackTitle"];
            [userDefault setValue:@"" forKey:@"ququedTrackURL"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES] ;
            [self.songtable reloadData];
            
        }else{
            [userDefault setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"] ;
            [appDelegate playMusic:[NSURL URLWithString:songsObj.url]];
            [appDelegate showSongTitle:songsObj.title];
            [cell.activityIndicator startAnimating];
            [cell.activityIndicator setHidden:NO];
            cell.isPlayingVal = YES;
            
            [userDefault setValue:songsObj.title forKey:@"ququedTrackTitle"];
            [userDefault setValue:songsObj.url forKey:@"ququedTrackURL"];
        }
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [songsListresult count]; i++) {
            Song *songObj = [songsListresult objectAtIndex:i];
            NowSongsPlay *nowPlay = [[NowSongsPlay alloc] init];
            nowPlay.musicTypeVal = songObj.musictype;
            nowPlay.descriptionVal = songObj.subtitle;
            nowPlay.thumbVal = songObj.thumburl;
            nowPlay.titleVal = songObj.title;
            nowPlay.musicURLVal = songObj.url;
            nowPlay.indexVal = songObj.ordernumber ;
            [list addObject:nowPlay];
        }
        appDelegate.songsList = list ;
        appDelegate.tmpSongsList = appDelegate.songsList ;
       
    }
}
-(void)deletequeue:(NSIndexPath *)indexpath
{
    UIApplication *myapp=[UIApplication sharedApplication];
     AppDelegate *mydel=(AppDelegate *)myapp.delegate;
     NSManagedObjectContext *mycontext=mydel.managedObjectContext;
     NSFetchRequest *req=[NSFetchRequest fetchRequestWithEntityName:@"Song"];
     NSArray *result=[mycontext executeFetchRequest:req error:nil];
     NSLog(@"result=%@",[result valueForKeyPath:@"musictype"]);
    NSManagedObject *object=[result objectAtIndex:indexpath.row];
    
     [mycontext deleteObject:object];
    
     [mycontext save:nil];
    [self fetchdata];
    [_songtable reloadData];
}


-(void)playpauseclk:(id)sender
{
    
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    [appDelegate.moviePlayer setContentURL:videoURL] ;
    [appDelegate.moviePlayer play] ;
    
    
}

-(void)viewDidLayoutSubviews
{
    if ([self.songtable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.songtable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.songtable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.songtable setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)playYouTubeVideo:(NSURL *) url {
    
    [appDelegate playMusic:url] ;
  //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[mp.moviePlayer stop] ;
    // mp.view.frame = CGRectMake(0, 0, 0.5, 0.5);
    //[appDelegate.moviePlayer setContentURL:url] ;
    //[mp.moviePlayer prepareToPlay];
    //[appDelegate.moviePlayer play];
    //  [self.view addSubview:mp.view];
    
    // [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
}



@end
