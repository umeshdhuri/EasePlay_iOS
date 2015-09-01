//
//  SearchSongsViewController.m
//  EasePlay
//
//  Created by AppKnetics on 13/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "SearchSongsViewController.h"
#import "MGBox.h"
#import "MGScrollView.h"
#import "AppDelegate.h"
#import "JSONModelLib.h"
#import "VideoModel.h"
#import "VideoLink.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LBYouTubePlayerViewController.h"
#import "SearchSongTableViewCell.h"
#import "AFNetworking.h"
#import "SignInViewController.h"
#import <CoreData/CoreData.h>
#import "QueueTrackViewController.h"
#import "NAPopoverView.h"
#import "DatabaseController.h"
#import "HCYoutubeParser.h"
#import "NowSongsPlay.h"
#import "UIImageView+WebCache.h"


@interface SearchSongsViewController ()
{
    NAPopoverView *popView;
    NAPopoverView *popView1;
    MGBox* searchBox;
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerController *player;
     NSData *imageData;
    
    
    int flag;
    
    //youtube
    NSString* searchCall;
    NSMutableArray *videos;
    VideoLink* link;
    
    UITableView *playlisttable;
    NSMutableArray *description;
    
    //soundcloud
    NSMutableArray *data;
    NSMutableArray *songthumb;
    
    //playlist
    
    UIButton *plstimgbtn;
    UITextField *plnmtf;
    UIButton *editbtn;
    NSString *trackname;
    NSString *trackimages;
    NSString *trackurl;
    NSString *trackduration;
    NSString *trackdscrptn;
    UIImagePickerController *pickerController;
     NSString *imagepassing;
    
    NSMutableArray *playlistdat;
    NSUserDefaults *user;
    
}

@end

@implementation SearchSongsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    currentPlayList = [[NSMutableArray alloc] init];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    
    self.songlisttabl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedIndexVal = 0 ;
    
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
   
    
    NSString *notificationName = @"ChangePlyaImage";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ChangePlyaImageWithString:)
     name:notificationName
     object:nil];
    
    self.songlisttabl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //[self.view setBackgroundColor:[UIColor redColor]] ;
}

- (void)ChangePlyaImageWithString:(NSNotification *)notification
{
    [self.songlisttabl reloadData] ;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    
    [self.viewMore setHidden:YES];
    [self.viewMoreSeperatore setHidden:YES];
    nextCloudVal = 20 ;
    
    if(isPhone480) {
        CGRect tableFrame = self.songlisttabl.frame ;
        tableFrame.size.height = self.songlisttabl.frame.size.height - 91 ;
        self.songlisttabl.frame = tableFrame ;
        
    }
    
    CGRect tableViewFrame = self.songlisttabl.frame ;
    CGRect moreViewFrame = self.viewMore.frame ;
    CGRect viewMoreSeperatoreFrame = self.viewMoreSeperatore.frame ;
    
    viewMoreSeperatoreFrame.origin.y = tableViewFrame.origin.y + tableViewFrame.size.height ;
    self.viewMoreSeperatore.frame = viewMoreSeperatoreFrame ;
    
    moreViewFrame.origin.y = viewMoreSeperatoreFrame.origin.y + viewMoreSeperatoreFrame.size.height ;
    self.viewMore.frame = moreViewFrame ;
    
     flag=1;
    
    NSLog(@"flag=%d",flag);
     videos=[[NSMutableArray alloc]init];
    _searchview.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0];
      self.view.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];

    user=[NSUserDefaults standardUserDefaults];
    [self.songlisttabl setHidden:YES];
    [self.noSongsLbl setHidden:NO] ;
    //[self.songlisttabl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
     _songlisttabl.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, self.serchsongtf.frame.size.height)];
    self.serchsongtf.leftView = paddingView;
    self.serchsongtf.leftViewMode = UITextFieldViewModeAlways;
    
    //mp = [[MPMoviePlayerViewController alloc] init];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


//Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTxt = textField ;
    //[self searchvideo:_serchsongtf.text];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([_serchsongtf.text length] > 0) {
        [self searchvideo:_serchsongtf.text];
    }
    
    return YES;
}
-(void)searchvideo:(NSString *)term
{
    NSLog(@"flag=%d",flag);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    term = [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(flag==1)
    {
        searchCall=[NSString stringWithFormat:@"%@youtube/?q=%@&pageID=",kBaseURL, term, @""];
        NSLog(@"url=%@",searchCall);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        songthumb=[[NSMutableArray alloc]init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"responseObject === %@", [[responseObject valueForKey:@"data"] valueForKey:@"nextPageToken"]) ;
                 if([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                     nextTokanVal = [[responseObject valueForKey:@"data"] valueForKey:@"nextPageToken"] ;
                 }
                 
                 //data=[[responseObject valueForKey:@"data"] valueForKey:@"items"];
                 data = [[responseObject valueForKey:@"data"] valueForKey:@"items"];
                 
                // NSLog(@"response data=%@",data);
                 if([data count] > 0) {
                     [self.songlisttabl setHidden:NO];
                     [self.noSongsLbl setHidden:YES] ;
                    [self.songlisttabl reloadData];
                     
                     [self.viewMore setHidden:NO];
                     [self.viewMoreSeperatore setHidden:NO];
                     
                 }else{
                     [self.songlisttabl setHidden:YES];
                  [self.noSongsLbl setHidden:NO] ;
                     [self.viewMore setHidden:YES];
                     [self.viewMoreSeperatore setHidden:YES];
                 }
                 NSLog(@"response=%@",data);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self.viewMore setHidden:YES];
                 [self.viewMoreSeperatore setHidden:YES];
             }
         ];
        
          }
    else if (flag==3)
    {
        searchCall=[NSString stringWithFormat:@"%@groovesharksongs?keyword=%@",kBaseURL, term];
        NSLog(@"url=%@",searchCall);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        songthumb=[[NSMutableArray alloc]init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 data=[responseObject valueForKey:@"data"];

                 if([data count] > 0) {
                     [self.songlisttabl setHidden:NO];
                     [self.noSongsLbl setHidden:YES] ;
                     [self.songlisttabl reloadData];
                 }else{
                     [self.songlisttabl setHidden:YES];
                     [self.noSongsLbl setHidden:NO] ;
                 }
                 NSLog(@"response=%@",data);
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
         ];

        
    }
    else if (flag==4)
    {
        NSLog(@"BeatPort");
        searchCall=[NSString stringWithFormat:@"%@beatportsongs?keyword=%@",kBaseURL, term];
        NSLog(@"url=%@",searchCall);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 data=[responseObject valueForKey:@"data"];
                // NSLog(@"data == %@", data);
                 if([data count] > 0) {
                     [self.songlisttabl setHidden:NO];
                     [self.noSongsLbl setHidden:YES] ;
                     [self.songlisttabl reloadData];
                 }else{
                     [self.songlisttabl setHidden:YES];
                     [self.noSongsLbl setHidden:NO] ;
                 }
                 NSLog(@"response=%@",data);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
             }
         ];
        
    }
    else if ((flag=2))
    {
        searchCall =[NSString stringWithFormat:@"https://api.soundcloud.com/tracks?client_id=af6adf4824fd764562ee975a657ab094&q=%@&limit=%d&order=created_at&streamable=true",term, nextCloudVal];
        NSLog(@"searchCall ==== %@", searchCall) ;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        songthumb=[[NSMutableArray alloc]init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 data=(NSMutableArray *)responseObject;
                // NSLog(@"data=%@",data);
                // NSLog(@"data=%@",data);
                 for (int i=0; i<data.count; i++) {
                     [songthumb addObject:[[data objectAtIndex:i] valueForKey:@"user"]];
                 }
                 
                 if([data count] > 0) {
                     [self.songlisttabl setHidden:NO];
                     [self.noSongsLbl setHidden:YES] ;
                     [self.songlisttabl reloadData];
                     [self.viewMore setHidden:NO];
                     [self.viewMoreSeperatore setHidden:NO];
                 }else{
                     [self.songlisttabl setHidden:YES];
                     [self.noSongsLbl setHidden:NO] ;
                     [self.viewMore setHidden:YES];
                     [self.viewMoreSeperatore setHidden:YES];

                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self.viewMore setHidden:YES];
                 [self.viewMoreSeperatore setHidden:YES];
             }
         ];
    }
}


-(IBAction)loadMoreSarch:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *term = [_serchsongtf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(flag==1){
    searchCall=[NSString stringWithFormat:@"%@youtube/?q=%@&pageID=%@",kBaseURL, term, nextTokanVal];
    NSLog(@"url=%@",searchCall);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    songthumb=[[NSMutableArray alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:searchCall parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"responseObject === %@", responseObject) ;
             //data=[[responseObject valueForKey:@"data"] valueForKey:@"items"];
             if([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                 nextTokanVal = [[responseObject valueForKey:@"data"] valueForKey:@"nextPageToken"] ;
             }
             NSMutableArray *data1 = [[responseObject valueForKey:@"data"] valueForKey:@"items"] ;
             NSLog(@"data1 count == %d", [data1 count]) ;
             if([data1 isKindOfClass:[NSArray class]]) {
                 data = [[data arrayByAddingObjectsFromArray:data1] mutableCopy];
             }
             NSLog(@"data count == %d", [data count]) ;
             
             // NSLog(@"response data=%@",data);
             if([data count] > 0) {
                 [self.songlisttabl setHidden:NO];
                 [self.noSongsLbl setHidden:YES] ;
                 [self.songlisttabl reloadData];
                 
                 [self.viewMore setHidden:NO];
                 [self.viewMoreSeperatore setHidden:NO];
                 
             }else{
                 [self.songlisttabl setHidden:YES];
                 [self.noSongsLbl setHidden:NO] ;
                 [self.viewMore setHidden:YES];
                 [self.viewMoreSeperatore setHidden:YES];
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSLog(@"response=%@",data);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"eroor=%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.viewMore setHidden:YES];
             [self.viewMoreSeperatore setHidden:YES];
         }
     ];
    }else if(flag==2) {
        nextCloudVal = nextCloudVal + 20 ;
        searchCall =[NSString stringWithFormat:@"https://api.soundcloud.com/tracks?client_id=af6adf4824fd764562ee975a657ab094&q=%@&limit=%d&order=created_at&streamable=true",term, nextCloudVal];
        NSLog(@"searchCall ==== %@", searchCall) ;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        songthumb=[[NSMutableArray alloc]init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 data=(NSMutableArray *)responseObject;
                 // NSLog(@"data=%@",data);
                 // NSLog(@"data=%@",data);
                 for (int i=0; i<data.count; i++) {
                     [songthumb addObject:[[data objectAtIndex:i] valueForKey:@"user"]];
                 }
                 
                 if([data count] > 0) {
                     [self.songlisttabl setHidden:NO];
                     [self.noSongsLbl setHidden:YES] ;
                     [self.songlisttabl reloadData];
                     [self.viewMore setHidden:NO];
                     [self.viewMoreSeperatore setHidden:NO];
                 }else{
                     [self.songlisttabl setHidden:YES];
                     [self.noSongsLbl setHidden:NO] ;
                     [self.viewMore setHidden:YES];
                     [self.viewMoreSeperatore setHidden:YES];
                     
                 }
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self.viewMore setHidden:YES];
                 [self.viewMoreSeperatore setHidden:YES];
             }
         ];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_songlisttabl) {
        if (flag==1) {
            
            return data.count;
        }
        else if (flag==2)
        {
            return data.count;
        }
        else if (flag==3)
        {
            return data.count;
        }
        else if (flag==4)
        {
            return data.count;
        }
        return 0;

    }
    else if (tableView==playlisttable)
    {
        return playlistdat.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (tableView==_songlisttabl) {
    static NSString *cellIdentifier = @"song";
    /*SearchSongTableViewCell *cell = (SearchSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName: @"SearchSongTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }*/
       SearchSongTableViewCell *cell = (SearchSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       
       if (cell == nil) {
           NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchSongTableViewCell" owner:self options:nil];
           cell = [nib objectAtIndex:0];
       }
       [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:30.0f spaceValue:10];
       cell.rightUtilityButtons = [self rightButtons];
       cell.delegate = self;
       
       [cell.playPlaceHolder setHidden:YES];
       [cell.activityIndicator setHidden:YES];
       cell.isPlayingVal = NO;
       
          if (flag==1) {
          
           cell.songtitlelbl.text=[[[data objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"title"];
          cell.songsubtitlelbl.text=[[[data objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"description"];
          // [cell.thumbimage startImageDownloadingWithUrl:[[[data objectAtIndex:indexPath.row] valueForKey:@"thumbnail"] valueForKey:@"hqDefault"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
              [cell.thumbimage sd_setImageWithURL:[[[[[data objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"high"] valueForKey:@"url"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
              
              if((appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) && [[user valueForKey:@"songRedirectionType"] isEqualToString:@"searchtrack"])
              {
                  if(([[user valueForKey:@"playIndex"] integerValue] == indexPath.row) && [[user valueForKey:@"songRedirectionTypeSubType"] isEqualToString:@"youtube"]) {
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
       }
       else if (flag==2)
       {
           cell.songtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"title"];
           // [cell.thumbimage startImageDownloadingWithUrl:[[[data objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"avatar_url"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
           [cell.thumbimage sd_setImageWithURL:[[[data objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"avatar_url"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
           
           NSString *descptn=[[data objectAtIndex:indexPath.row] valueForKey:@"description"];
           if (descptn == (id)[NSNull null]) {
               cell.songsubtitlelbl.text=@"";
           }
           else
           {
               cell.songsubtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"description"];
           }
           
           if((appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) && [[user valueForKey:@"songRedirectionType"] isEqualToString:@"searchtrack"])
           {
               if(([[user valueForKey:@"playIndex"] integerValue] == indexPath.row) && [[user valueForKey:@"songRedirectionTypeSubType"] isEqualToString:@"soundcloud"]) {
                   //NSLog(@"soundcloud songRedirectionTypeSubType innnnnnn") ;
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
           
       }
       else if (flag==3)
       {
           //NSLog(@"name=%@",[[data objectAtIndex:indexPath.row] valueForKey:@"AlbumName"]);
           cell.songtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"AlbumName"];
           cell.songsubtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"ArtistName"];
       }
       else if (flag==4)
       {
           cell.songtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"name"];
           [cell.thumbimage sd_setImageWithURL:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
           //[cell.thumbimage startImageDownloadingWithUrl:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
       }
       
       cell.songcountlbl.hidden=YES;
        cell.backgroundColor=[UIColor clearColor];
        cell.playpausebtn.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
       // _songlisttabl.separatorColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
        cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
       
       
       
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      
      // [self.songlisttabl setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"divider.png"]]];
       [_songlisttabl setSeparatorColor:[UIColor colorWithRed:82.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1.0]];
    return cell;
   }
  else if (tableView==playlisttable)
  {
      static NSString *cellIdentifier = @"Playlist";
      PlayListTableViewCell *cell = (PlayListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (!cell) {
          [tableView registerNib:[UINib nibWithNibName: @"PlayListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
          cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      }
      //cell.selectionStyle=UITableViewCellSelectionStyleNone;
      cell.playlisttitle.text=[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"name"];
      cell.deletplaylistbtn.tag=[[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];
      //[cell.playlistimage startImageDownloadingWithUrl:[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
      
      [cell.playlistimage sd_setImageWithURL:[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
      
      NSString *str1=[[[playlistdat objectAtIndex:indexPath.row] valueForKeyPath:@"trackcount"] stringValue];
      NSString *str2=[str1 stringByAppendingString:@" songs"];
      
      cell.playlistdescrptn.text=str2;
      
      playlisttable.separatorColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
      cell.backgroundColor=[UIColor clearColor];
      cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
      cell.deletplaylistbtn.hidden=YES;
      
      
      return cell;

  }
    return 0;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"add-to-playlist.png"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"add-to-queue.png"]];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [_songlisttabl indexPathForCell:cell];
            //NSLog(@"indexpath=%@",cellIndexPath);
            [self liginclk:cellIndexPath];
           // NSLog(@"sucess");
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_songlisttabl indexPathForCell:cell];
            [self addsongqueue:cellIndexPath];
           // NSLog(@"indexpath=%@",cellIndexPath);
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
#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [user setValue:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:@"playIndex"];
    if (tableView==_songlisttabl)
    {
        
       // NSLog(@"tag=%ld",(long)[sender tag]);
        [user setValue:@"Search" forKey:@"PlayFrom"] ;
        if (flag==1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SearchSongTableViewCell *cell =(SearchSongTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
            [appDelegate pauseMusic];
            
           /* NSString* videoId = nil;
            VideoModel* video = videos[indexPath.row];
            link =[video.link objectAtIndex:0];*/
           
           //NSString *url1=[link.href absoluteString];
            NSString *videoId=[[[data objectAtIndex:indexPath.row] valueForKey:@"id"] valueForKey:@"videoId"];
            NSString *url1=[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
            NSURL *url = [NSURL URLWithString:url1];
            
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
                        //[self playYouTubeVideo:_urlToLoad];
                        if(cell.isPlayingVal) {
                            [appDelegate pauseMusic];
                            cell.isPlayingVal = NO;
                            appDelegate.currentPlaySong = @"";
                            [cell.activityIndicator stopAnimating];
                            [cell.activityIndicator setHidden:YES];
                            [self.songlisttabl reloadData];
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                        }else{
                            [user setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"] ;
                            //[appDelegate playMusic:videoURL];
                            [cell.activityIndicator startAnimating];
                            [cell.activityIndicator setHidden:NO];
                            cell.isPlayingVal = YES;
                            [self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                            [appDelegate showSongTitle:[[[data objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"title"]];
                        }
                        [user setValue:@"youtube" forKey:@"songRedirectionTypeSubType"];
                        [user setValue:@"searchtrack" forKey:@"songRedirectionType"];
                        [currentPlayList removeAllObjects];
                        NowSongsPlay *nowPlay ;
                        for (int i=0; i<[data count]; i++) {
                            nowPlay = [[NowSongsPlay alloc] init] ;
                            nowPlay.musicTypeVal = @"Youtube";
                            nowPlay.descriptionVal = [[[data objectAtIndex:i] valueForKey:@"snippet"] valueForKey:@"description"];
                            nowPlay.thumbVal = [[[[[data objectAtIndex:i] valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"high"] valueForKey:@"url"];
                            nowPlay.titleVal = [[[data objectAtIndex:i] valueForKey:@"snippet"] valueForKey:@"title"];
                            NSLog(@"Data == %@", [data objectAtIndex:i]) ;
                            NSString *videoId=[[[data objectAtIndex:i] valueForKey:@"id"] valueForKey:@"videoId"];
                            NSLog(@"videoId === %@", videoId) ;
                            nowPlay.musicURLVal =[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId]; //[link.href absoluteString];
                            nowPlay.indexVal = [NSNumber numberWithInt:i] ;
                            [currentPlayList addObject:nowPlay];
                        }
                        appDelegate.tmpSongsList = [[NSArray alloc] init] ;
                        appDelegate.songsList = [[NSArray alloc] init];
                        appDelegate.songsList = currentPlayList ;
                        appDelegate.currentPlaySong = url1 ;
                        appDelegate.tmpSongsList = appDelegate.songsList ;
                    }];
                }
                else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
            }];
            
        }
        else if (flag==2)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SearchSongTableViewCell *cell =(SearchSongTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
            [appDelegate pauseMusic];
           // cell.isPlaying = NO;
            //[cell.playPlaceHolder setHidden:NO] ;
            
            NSString *songurl;
            NSString *urlsong=[[data objectAtIndex:indexPath.row] valueForKey:@"stream_url"];
            NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
            
            
            
            if(![appendurl isKindOfClass:[NSNull class]] && [appendurl length] > 0) {
                songurl=appendurl;
            }
           // NSLog(@"appendurl=%@",songurl);
            if(cell.isPlayingVal) {
                [appDelegate pauseMusic];
                cell.isPlayingVal = NO;
                appDelegate.currentPlaySong = @"";
                [cell.activityIndicator stopAnimating];
                [cell.activityIndicator setHidden:YES];
                [self.songlisttabl reloadData];
                
            }else{
                [user setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"] ;
                [appDelegate playMusic:[NSURL URLWithString:songurl]];
                [appDelegate showSongTitle:[[data objectAtIndex:indexPath.row] valueForKey:@"title"]];
                [cell.activityIndicator startAnimating];
                [cell.activityIndicator setHidden:NO];
                cell.isPlayingVal = YES;
            }
            
            [currentPlayList removeAllObjects];
            NowSongsPlay *nowPlay ;
            for (int i=0; i<data.count; i++) {
                nowPlay = [[NowSongsPlay alloc] init] ;
                //[songthumb addObject:[[data objectAtIndex:i] valueForKey:@"user"]];
                nowPlay.musicTypeVal = @"soundcloud";
                nowPlay.descriptionVal = [[description objectAtIndex:i] valueForKey:@"$t"];
                nowPlay.thumbVal = [[[data objectAtIndex:i] valueForKey:@"user"] valueForKey:@"avatar_url"];
                nowPlay.titleVal = [[data objectAtIndex:i] valueForKey:@"title"];
                
                NSString *urlsong=[[data objectAtIndex:i] valueForKey:@"stream_url"];
                NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
                
                nowPlay.musicURLVal = appendurl;
                nowPlay.indexVal = [NSNumber numberWithInt:i] ;
                [currentPlayList addObject:nowPlay];
            }
            appDelegate.songsList = nil ;
            appDelegate.tmpSongsList = [[NSArray alloc] init];
            appDelegate.songsList = [[NSArray alloc] init];
            appDelegate.songsList = currentPlayList ;
            appDelegate.tmpSongsList = appDelegate.songsList ;
            
            [user setValue:@"soundcloud" forKey:@"songRedirectionTypeSubType"];
             [user setValue:@"searchtrack" forKey:@"songRedirectionType"];
            appDelegate.currentPlaySong = urlsong ;
            
           // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           // [self.songlisttabl reloadData];
            //[appDelegate.moviePlayer setContentURL:[NSURL URLWithString:songurl]] ;
            //[appDelegate.moviePlayer play];
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundCloudedEnded:) name:MPMoviePlayerPlaybackDidFinishNotification object:appDelegate.moviePlayer];
        }
        else if (flag==3)
        {
            NSString *URLString=[kBaseURL stringByAppendingString:kplaygssong];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[data objectAtIndex:indexPath.row] valueForKey:@"SongID"],@"songid",nil];
            //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSString *groveshrkurl=[responseObject valueForKey:@"data"];
               // NSLog(@"response=%@",[responseObject valueForKey:@"data"]);
                [appDelegate.moviePlayer setContentURL:[NSURL URLWithString:groveshrkurl]] ;
                [appDelegate.moviePlayer play];
                [[NSNotificationCenter defaultCenter]
                 addObserver:self
                 selector:@selector(soundCloudedEnded:)
                 name:MPMoviePlayerPlaybackDidFinishNotification
                 object:appDelegate.moviePlayer];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        else if (flag==4)
        {
            NSString *songurl=[[data objectAtIndex:indexPath.row] valueForKey:@"stream"];
            //NSLog(@"songurl=%@",songurl);
            [appDelegate.moviePlayer setContentURL:[NSURL URLWithString:songurl]] ;
            [appDelegate.moviePlayer play];
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(soundCloudedEnded:)
             name:MPMoviePlayerPlaybackDidFinishNotification
             object:appDelegate.moviePlayer];
        }
    }
    else if (tableView==playlisttable)
    {
       NSLog(@"playlistclk");
        [self addtracktoplaylist:indexPath.row];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_songlisttabl)
    {
      return 67;
    }
    else if (tableView==playlisttable)
    {
        return 70;
    }
    return 0;
}

-(void)viewDidLayoutSubviews
{
    if ([self.songlisttabl respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.songlisttabl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.songlisttabl respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.songlisttabl setLayoutMargins:UIEdgeInsetsZero];
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

- (IBAction)crossbtnclk:(id)sender {
    _serchsongtf.text=nil;

}

- (IBAction)beatprtclk:(id)sender {
   // NSLog(@"beatportclk");
    [currentTxt resignFirstResponder];
    flag=4;
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube.png"]] ;
    [self.soundcloudImg setImage:[UIImage imageNamed:@"soundcloud.png"]] ;
    [self.grooveshrImg setImage:[UIImage imageNamed:@"groovshark.png"]] ;
    [self.betportImg setImage:[UIImage imageNamed:@"beatport-active.png"]] ;
    [self.songlisttabl setHidden:YES];
    [self.noSongsLbl setHidden:NO] ;
    if([_serchsongtf.text length] > 0) {
      //  [self searchvideo:_serchsongtf.text];
    }
    /*[self.noSongsLbl setHidden:NO] ;
    [self.songlisttabl reloadData] ;*/
}

- (IBAction)youtbclk:(id)sender {
    // NSLog(@"youtubeclk");
    [currentTxt resignFirstResponder];
    flag=1;
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube-active.png"]] ;
    [self.soundcloudImg setImage:[UIImage imageNamed:@"soundcloud.png"]] ;
    [self.grooveshrImg setImage:[UIImage imageNamed:@"groovshark.png"]] ;
    [self.betportImg setImage:[UIImage imageNamed:@"beatport.png"]] ;
    [self.songlisttabl setHidden:YES];
    [self.noSongsLbl setHidden:NO] ;
    if([_serchsongtf.text length] > 0) {
        [self searchvideo:_serchsongtf.text];
    }
}

- (IBAction)soundcldclk:(id)sender {
    [currentTxt resignFirstResponder];
    flag=2;
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube.png"]] ;
    [self.soundcloudImg setImage:[UIImage imageNamed:@"soundcloud-active.png"]] ;
    [self.grooveshrImg setImage:[UIImage imageNamed:@"groovshark.png"]] ;
    [self.betportImg setImage:[UIImage imageNamed:@"beatport.png"]] ;
   //  [self searchvideo:_serchsongtf.text];
   // NSLog(@"soudcliudclk");
    [self.songlisttabl setHidden:YES];
    [self.noSongsLbl setHidden:NO] ;
    if([_serchsongtf.text length] > 0) {
        [self searchvideo:_serchsongtf.text];
    }
   
}

- (IBAction)groovshrkclk:(id)sender {
    flag=3;
    [currentTxt resignFirstResponder];
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube.png"]] ;
    [self.soundcloudImg setImage:[UIImage imageNamed:@"soundcloud.png"]] ;
    [self.grooveshrImg setImage:[UIImage imageNamed:@"groovshark-active.png"]] ;
    [self.betportImg setImage:[UIImage imageNamed:@"beatport.png"]] ;
    [self.songlisttabl setHidden:YES];
    [self.noSongsLbl setHidden:NO] ;
    if([_serchsongtf.text length] > 0) {
       // [self searchvideo:_serchsongtf.text];
    }
    // NSLog(@"groovshrkclk");
}
-(void)playpauseclk:(id)sender
{
    
}


-(void) soundCloudedEnded:(id) sender {
    
}

-(void)playYouTubeVideo:(NSURL *) url {
    
   // NSLog(@"Data === %@", appDelegate.songsList) ;
    [appDelegate playMusic:url] ;
    //[self.nowPlayingBtn setHidden:NO];
    [user setValue:@"searchtrack" forKey:@"songRedirectionType"];
    
}


- (void) moviePlayBackDidFinish:(NSNotification*) aNotification
{
    /*player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];*/
}
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
   // NSLog(@"videourl;=%@",videoURL);
    /*_moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:videoURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer setScalingMode:MPMovieScalingModeFill];
    _moviePlayer.view.frame = CGRectMake(0,0, 0.5,0.5);
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:NO animated:YES];
     [_moviePlayer play];*/
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerViewController.moviePlayer prepareToPlay];
    [moviePlayerViewController.moviePlayer play];
    [self presentModalViewController:moviePlayerViewController animated:YES];
   
}
-(void)liginclk:(NSIndexPath *)indexpath
{
    if([user valueForKey:@"uid"])
    {
        
        if (flag==1) {
            trackname=[[[data objectAtIndex:indexpath.row] valueForKey:@"snippet"] valueForKey:@"title"];
            trackduration=@"";
            trackimages=[[[[[data objectAtIndex:indexpath.row] valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"high"] valueForKey:@"url"];
           // trackurl=[[[data objectAtIndex:indexpath.row] valueForKey:@"player"] valueForKey:@"default"];
            NSString *videoId=[[[data objectAtIndex:indexpath.row] valueForKey:@"id"] valueForKey:@"videoId"];
            trackurl=[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
            
            trackdscrptn=[[[data objectAtIndex:indexpath.row] valueForKey:@"snippet"] valueForKey:@"description"];
        }
        else if (flag==2)
        {
            trackname=[[data objectAtIndex:indexpath.row] valueForKey:@"title"];
            trackimages=[[songthumb objectAtIndex:indexpath.row] valueForKey:@"avatar_url"];
            float milliseconds=[[[data objectAtIndex:indexpath.row] valueForKey:@"duration"] intValue];
            float seconds = milliseconds / 1000.0;
            float minutes = seconds / 60.0;
            minutes *= 100;
            if(minutes >= 0) minutes += 0.5; else minutes -= 0.5;
            long round = minutes;
            minutes = round;
            minutes /= 100;
            trackduration=[NSString stringWithFormat:@"%.2f", minutes];
            NSString *urlsong=[[data objectAtIndex:indexpath.row] valueForKey:@"stream_url"];
            NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
            trackdscrptn=[[data objectAtIndex:indexpath.row] valueForKey:@"description"];
            if (trackdscrptn == (id)[NSNull null]) {
                trackdscrptn=@"";
            }
            else
            {
                trackdscrptn=[[data objectAtIndex:indexpath.row] valueForKey:@"description"];
            }
            
            if(![appendurl isKindOfClass:[NSNull class]] && [appendurl length] > 0) {
                trackurl=appendurl;
            }
        }
        else if (flag==4)
        {
            trackname=[[data objectAtIndex:indexpath.row] valueForKey:@"name"];
            trackimages=[[data objectAtIndex:indexpath.row] valueForKey:@"image"];
            trackdscrptn=@"";
            trackduration=@"";
        
            trackurl=[[data objectAtIndex:indexpath.row] valueForKey:@"stream"];
        }
        [self fetchplaylist];
        
    }else{
        SignInViewController *signinview=[[SignInViewController alloc]init];
        [self presentViewController:signinview animated:YES completion:nil];
    }
}
-(void)fetchplaylist
{
    playlistdat=[[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString =[kBaseURL stringByAppendingString:klistplaylist];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"User id === %@", [user valueForKey:@"uid"]) ;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",nil];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(![[responseObject valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
            playlistdat=[responseObject valueForKey:@"data"];
            NSLog(@"response=%@",playlistdat);
            
        }
        
        [self showplaylist];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
-(void)showplaylist
{
    popView=[[NAPopoverView alloc] init];
    [popView setFrame:CGRectMake(10,50,300, self.view.height-80)];
    popView.center=self.view.center;
    popView.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];
    
    popView.layer.borderColor = [UIColor blackColor].CGColor;
    popView.layer.cornerRadius = 0.0;
    popView.layer.borderWidth = 1.0;

    UIButton * addplaylist=[UIButton buttonWithType:UIButtonTypeCustom];
    [addplaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [addplaylist setTitle:@"     Add New Playlist" forState:UIControlStateNormal];
    [addplaylist addTarget:self action:@selector(addplaylistclk:) forControlEvents:UIControlEventTouchUpInside];
    [addplaylist setFrame:CGRectMake(80,0,154,28)];
    addplaylist.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [addplaylist setBackgroundImage:[UIImage imageNamed:@"add-new-playlist.png"] forState:UIControlStateNormal];
    [addplaylist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if([playlistdat count]) {
        playlisttable=[[UITableView alloc]initWithFrame:CGRectMake(0, 37, popView.frame.size.width, 280)];
        playlisttable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        playlisttable.delegate=self;
        playlisttable.dataSource=self;
        playlisttable.backgroundColor=[UIColor clearColor];
        [popView addSubview:playlisttable];
    }else{
        UILabel *errMsgLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 180, 200, 30)];
        errMsgLbl.text = @"No Playlist Found.";
        [errMsgLbl setTextColor:[UIColor whiteColor]];
        [errMsgLbl setTextAlignment:NSTextAlignmentCenter] ;
        [popView addSubview:errMsgLbl];
    }
    
    UIButton * cutplalist=[UIButton buttonWithType:UIButtonTypeCustom];
    [cutplalist addTarget:self action:@selector(cutplaylistclk:) forControlEvents:UIControlEventTouchUpInside];
    [cutplalist setFrame:CGRectMake(80,330,150,35)];
    //[cutplalist setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [cutplalist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cutplalist setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cutplalist setBackgroundColor:[UIColor whiteColor]];
    [cutplalist setTitle:@"Close" forState:UIControlStateNormal];
    cutplalist.layer.cornerRadius=0.0f;
    cutplalist.layer.masksToBounds=YES;
    cutplalist.layer.borderWidth= 1.0f;
    cutplalist.layer.borderColor = [[UIColor grayColor] CGColor];
    [cutplalist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cutplalist.backgroundColor=[UIColor whiteColor];
    [cutplalist setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    if(isPhone480) {
        NSLog(@"innnn 3.5 inch") ;
        
        [popView setFrame:CGRectMake(10,10,300, self.view.height-10)];
        CGRect addplaylistframe =addplaylist.frame ;
        
        CGRect tableframe=playlisttable.frame;
        tableframe.size.height=addplaylist.frame.size.height+240;
        playlisttable.frame=tableframe;
        
        CGRect termslblframe=cutplalist.frame;
        termslblframe.origin.y=addplaylistframe.origin.y+315;
        cutplalist.frame=termslblframe;
        
    }
    
    [popView addSubview:cutplalist];
    [popView addSubview:addplaylist];
    [popView show];
    [playlisttable reloadData];
    
}
-(void)cutplaylistclk:(id)sender
{
    [popView dismiss];
}
-(void)addplaylistclk:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    addplaylistview=[[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.origin.y+32, popView.frame.size.width, 70)];
    addplaylistview.backgroundColor=[UIColor clearColor];
    CGRect tablefrme=playlisttable.frame;
    tablefrme.origin.y=playlisttable.frame.origin.y+70;
    if(isPhone480) {
        NSLog(@"innnn 3.5 inch") ;
        
        tablefrme.size.height=playlisttable.size.height-75;
    }
    
    playlisttable.frame=tablefrme;
    
    plstimgbtn=[[UIButton alloc]initWithFrame:CGRectMake(addplaylistview.frame.origin.x+7, 10, 56, 50)];
    
    plstimgbtn.layer.cornerRadius=0.0;
    plstimgbtn.layer.masksToBounds=YES;
    plstimgbtn.layer.borderWidth= 1.0f;
    plstimgbtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [plstimgbtn setBackgroundImage:[UIImage imageNamed:@"easeplay_placeholder.png"] forState:UIControlStateNormal];
    [plstimgbtn addTarget:self action:@selector(addimage:) forControlEvents:UIControlEventTouchUpInside];
    
    plnmtf=[[UITextField alloc]initWithFrame:CGRectMake(addplaylistview.frame.origin.x+75, 10, 160, 30)];
    plnmtf.placeholder=@"Enter playlist Name";
    plnmtf.backgroundColor=[UIColor whiteColor];
    plnmtf.borderStyle = UITextBorderStyleRoundedRect;
    plnmtf.font = [UIFont systemFontOfSize:15];
    plnmtf.autocorrectionType = UITextAutocorrectionTypeNo;   //addplaylistview.frame.origin.x
    plnmtf.keyboardType = UIKeyboardTypeDefault;
    plnmtf.returnKeyType = UIReturnKeyDone;
    plnmtf.clearButtonMode = UITextFieldViewModeWhileEditing;
    plnmtf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    plnmtf.backgroundColor=[UIColor whiteColor];
    plnmtf.delegate=self;
    
    editbtn=[[UIButton alloc]initWithFrame:CGRectMake(addplaylistview.frame.origin.x+255, 20, 30, 30)];
    [editbtn setBackgroundImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(editplaylist:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *bordrlbl=[[UILabel alloc]initWithFrame:CGRectMake(addplaylistview.frame.origin.x, 69, addplaylistview.frame.size.width, 0.4)];
    bordrlbl.backgroundColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];;
    
    UILabel *upperbordrlbl=[[UILabel alloc]initWithFrame:CGRectMake(addplaylistview.frame.origin.x, 1, addplaylistview.frame.size.width, 0.4)];
    upperbordrlbl.backgroundColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
    
    
    [addplaylistview addSubview:plstimgbtn];
    [addplaylistview addSubview:plnmtf];
    [addplaylistview addSubview:bordrlbl];
    [addplaylistview addSubview:upperbordrlbl];
    [addplaylistview addSubview:editbtn];
    
    [popView addSubview:addplaylistview];

}
-(void)addimage:(id)sender
{
    NSLog(@"selectimage");
    [popView dismiss];
    popView1=[[NAPopoverView alloc] init];
    [popView1 setFrame:CGRectMake(0,0,300, 99)];
    popView1.center=self.view.center;
    popView1.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0];
    
    popView1.layer.borderColor = [UIColor blackColor].CGColor;
    popView1.layer.cornerRadius = 0.0;
    popView1.layer.borderWidth = 1.0;
    
    UIButton * btnCamera=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCamera setTitle:@"Camera" forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(btnCameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnCamera setBackgroundColor:[UIColor whiteColor]];
    btnCamera.layer.cornerRadius=0.0;
    btnCamera.layer.masksToBounds=YES;
    btnCamera.layer.borderWidth= 1.0f;
    btnCamera.layer.borderColor = [[UIColor grayColor] CGColor];
    [btnCamera setFrame:CGRectMake(10,0,popView.bounds.size.width,75)];
    [btnCamera setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnCamera setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, 10)];
    [btnCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCamera.backgroundColor=[UIColor clearColor];
    
    UIButton * btnGallery=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnGallery setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnGallery setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnGallery setBackgroundColor:[UIColor whiteColor]];
    [btnGallery setTitle:@"Gallery" forState:UIControlStateNormal];
    [btnGallery addTarget:self action:@selector(imageUploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnGallery setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btnGallery.layer.cornerRadius=0.0f;
    btnGallery.layer.masksToBounds=YES;
    btnGallery.layer.borderWidth= 1.0f;
    btnGallery.layer.borderColor = [[UIColor grayColor] CGColor];
    [btnGallery setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, 10)];
    [btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnCamera setFrame:CGRectMake(0,49,popView.bounds.size.width,50)];
    [btnGallery setFrame:CGRectMake(0,0,popView.bounds.size.width,50)];
    [btnGallery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGallery.backgroundColor=[UIColor clearColor];
    
    [popView1 addSubview:btnCamera];
    [popView1 addSubview:btnGallery];
    [popView1 show];
    

}

-(void)btnCameraPressed:(UIButton *)sender{
    
    NSLog(@"Camera button pressed .");
    
    if([UIImagePickerController	isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [popView1 dismiss];
        UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{}];
        
    }
}

-(void)imageUploadButtonClick:(id)sender
{
    [popView1 dismiss];
    pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.toolbarHidden = NO;
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
    //[popView show];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _playlistimage  =[info objectForKey:@"UIImagePickerControllerOriginalImage"] ;
    
    [plstimgbtn setBackgroundImage:_playlistimage forState:UIControlStateNormal];
    [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSLog(@"urlimage=%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]);
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    imageData = UIImageJPEGRepresentation(_playlistimage, 0.5f) ;
    [popView show];

}

-(void)editplaylist:(id)sender
{
    [currentTxt resignFirstResponder] ;
    NSLog(@"edited");
    if(imageData!=nil)
    {
        [MBProgressHUD showHUDAddedTo:addplaylistview animated:YES];
        NSString *MyString;
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        MyString = [dateFormatter stringFromDate:now];
        
        NSString *filename=[MyString stringByAppendingString:@"easeplay.jpg"];
        
        NSString *URLString1 =[kBaseURL stringByAppendingString:kimagetoserver];
        NSLog(@"URL=%@",URLString1);
        //imagedata passing to server
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:URLString1 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:filename mimeType:@"image/jpeg"] ;
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            NSDictionary *data1=[responseObject valueForKey:@"data"];
            NSString *imagename1=[data1 valueForKey:@"image"];
            
            //imagepassing=[@"http://118.139.163.225/easeplay/images/playlist/" stringByAppendingString:imagename1];
            imagepassing=[kimagedwnld stringByAppendingString:imagename1];
            NSLog(@"date=%@",imagepassing);
            
            if([[plnmtf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                [self addPlayList:imagepassing];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"”Please enter the playlist name.”";
                hud.margin = 10.f;
                if(isPhone480) {
                    hud.yOffset = 150.f;
                }else{
                    hud.yOffset = 200.f;
                }
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else if (imageData==nil)
    {
        if([[plnmtf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            imagepassing=@"";
            [self addPlayList:imagepassing];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Please enter the playlist name.”";
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
    

}
-(void) addPlayList:(NSString *)imageurl {
    [MBProgressHUD showHUDAddedTo:addplaylistview animated:YES];
    NSString *URLString =[kBaseURL stringByAppendingString:kaddPlaylist];
    //creating playlist
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:plnmtf.text,@"Playlist[name]",[user valueForKey:@"uid"],@"Playlist[uid]",imageurl,@"Playlist[image]",nil];
    
    NSLog(@"params === %@", params) ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSMutableArray *da=[responseObject valueForKeyPath:@"data"];
        NSString *pid=[da valueForKeyPath:@"id"];
        
        NSLog(@"response=%@",pid);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self addtracttoplaystcrtd:(NSString *)pid];
        //[self  addtracktoplaylist:(int )0];
        [popView dismiss];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"”Failed. Some server error occures.”";
        hud.margin = 10.f;
        if(isPhone480) {
            hud.yOffset = 150.f;
        }else{
            hud.yOffset = 200.f;
        }
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
    }];
}
-(void)addtracttoplaystcrtd:(NSString *)pid
{
    NSString *tracktype;
    if(flag==1)
    {
        tracktype=@"youtube";
    }
    else if(flag==2)
    {
        tracktype=@"soundcloud";
    }
    else if (flag==4)
    {
        tracktype=@"Beatpoart";
    }

    
    NSString *URLString =[kBaseURL stringByAppendingString:kaddtracks];
    NSLog(@"url=%@",pid);
    NSLog(@"url=%@",trackname);
    NSLog(@"url=%@",trackdscrptn);
  
    trackdscrptn = [trackdscrptn stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"Track[uid]",pid,@"Track[pid]",trackname,@"Track[name]",trackimages,@"Track[image]",trackurl,@"Track[url]",trackdscrptn,@"Track[description]",@"",@"Track[duration]",tracktype,@"Track[type]",nil];
    
    NSLog(@"parameters=%@",params);
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status=[responseObject valueForKey:@"status"] ;
         NSLog(@"response=%@",responseObject);
        if ([status intValue]==1) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Track successfully added to Playlist”";
            hud.margin = 10.f;
            if(isPhone480) {
                hud.yOffset = 150.f;
            }else{
                hud.yOffset = 200.f;
            }
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
            
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Some Problem to add track”";
            hud.margin = 10.f;
            if(isPhone480) {
                hud.yOffset = 150.f;
            }else{
                hud.yOffset = 200.f;
            }
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }

        
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"”Some Problem to add track”";
        hud.margin = 10.f;
        if(isPhone480) {
            hud.yOffset = 150.f;
        }else{
            hud.yOffset = 200.f;
        }
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
    }];
    [popView dismiss];
}

-(void)addsongqueue:(NSIndexPath *)indexpath
{
    NSMutableDictionary *songsDict = [[NSMutableDictionary alloc] init];
    NSLog(@"Innnnn add songs in queue");
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    if(flag==1)
    {
        NSString *trackTitleVal = [[[[data objectAtIndex:indexpath.row] valueForKey:@"snippet"] valueForKey:@"title"] stringByAppendingString:[NSString stringWithFormat:@"###$$%@", timeStampObj]];
        [songsDict setValue:trackTitleVal forKey:@"title"] ;
        [songsDict setValue:[[[[[data objectAtIndex:indexpath.row] valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"high"] valueForKey:@"url"]  forKey:@"thumburl"] ;
        //[songsDict setValue:[[[data objectAtIndex:indexpath.row] valueForKey:@"player"] valueForKey:@"default"] forKey:@"url"] ;
        NSString *videoId=[[[data objectAtIndex:indexpath.row] valueForKey:@"id"] valueForKey:@"videoId"];
        [songsDict setValue:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId] forKey:@"url"];
        
        [songsDict setValue:[[[data objectAtIndex:indexpath.row] valueForKey:@"snippet"] valueForKey:@"description"] forKey:@"subtitle"] ;
        [songsDict setValue:@"Youtube" forKey:@"musictype"];
    }
    else if (flag==2)
    {
        NSString *trackTitleVal = [[[data objectAtIndex:indexpath.row] valueForKey:@"title"] stringByAppendingString:[NSString stringWithFormat:@"###$$%@", timeStampObj]];
        
        [songsDict setValue:trackTitleVal forKey:@"title"] ;
        [songsDict setValue:[[[data objectAtIndex:indexpath.row] valueForKey:@"user"] valueForKey:@"avatar_url"] forKey:@"thumburl"] ;
        
        NSString *urlsong=[[data objectAtIndex:indexpath.row] valueForKey:@"stream_url"];
        NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
         NSLog(@"appendurl=%@",appendurl);
        if(![appendurl isKindOfClass:[NSNull class]] && [appendurl length] > 0) {
            [songsDict setValue:appendurl forKey:@"url"] ;
         }
        
        NSString *descptn = [[data objectAtIndex:indexpath.row] valueForKey:@"description"];
        if (descptn == (id)[NSNull null]) {
            [songsDict setValue:@"" forKey:@"subtitle"];
        }
        else
        {
            [songsDict setValue:descptn forKey:@"subtitle"];
        }
        
        
        [songsDict setValue:@"SoundCloud" forKey:@"musictype"];
    }
    else if (flag==4)
    {
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"name"] forKey:@"title"];
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"image"]forKey:@"thumburl"] ;
        [songsDict setValue:@"BeatPort" forKey:@"musictype"];
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"stream"] forKey:@"url"] ;
        
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    /*if(![DatabaseController checkSongsExits:[songsDict valueForKey:@"title"] url:[songsDict valueForKey:@"url"]]) {
        [DatabaseController insertSongs:songsDict] ;
        hud.labelText = @"”Track added to Queued”";
    }else{
        hud.labelText = @"”Track already exits into Queued”";
    }*/
    
    [DatabaseController insertSongs:songsDict] ;
    hud.labelText = @"”Track added to Queued”";
    hud.margin = 10.f;
    if(isPhone480) {
        hud.yOffset = 150.f;
    }else{
        hud.yOffset = 200.f;
    }
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
    
    
}
-(void)addtracktoplaylist:(int )indexPath
{
    
    NSString *tracktype;
    if(flag==1)
    {
       tracktype=@"Youtube";
    }
    else if(flag==2)
    {
        tracktype=@"soundcloud";
    }
    else if (flag==4)
    {
        tracktype=@"Beatpoart";
    }
   else if (flag==3)
   {
       tracktype=@"Grooveshark";
   }
       NSString *URLString =[kBaseURL stringByAppendingString:kaddtracks];
    NSLog(@"url=%@",URLString);
     NSLog(@"url=%@",tracktype);
     NSLog(@"url=%@",[playlistdat objectAtIndex:indexPath]);
     trackdscrptn = [trackdscrptn stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"Track[uid]",[[playlistdat objectAtIndex:indexPath] valueForKey:@"id"],@"Track[pid]",trackname,@"Track[name]",trackimages,@"Track[image]",trackurl,@"Track[url]",trackdscrptn,@"Track[description]",trackduration,@"Track[duration]",tracktype,@"Track[type]",nil];
    
    NSLog(@"parameters=%@",params);
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        NSLog(@"response objject=%@",responseObject);
        NSString *status=[responseObject valueForKey:@"status"] ;
        //data=[responseObject valueForKey:@"data"];
       // NSLog(@"response=%@",responseObject);
        if ([status intValue]==1) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Track successfully added to Playlist”";
            hud.margin = 10.f;
            if(isPhone480) {
                hud.yOffset = 150.f;
            }else{
                hud.yOffset = 200.f;
            }
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];

        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Some Problem to add track”";
            hud.margin = 10.f;
            if(isPhone480) {
                hud.yOffset = 150.f;
            }else{
                hud.yOffset = 200.f;
            }
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }

        
        // Configure for text only and offset down
        
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [popView dismiss];

}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)remoteControlEventNotification:(NSNotification *)note{
    UIEvent *event = note.object;
    if (event.type == UIEventTypeRemoteControl){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying){
                    [appDelegate.moviePlayer pause];
                } else {
                    [appDelegate.moviePlayer play];
                }
                break;
                // You get the idea.
            default:
                break;
        }
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

@end
