//
//  BrowseViewController.m
//  EasePlay
//
//  Created by AppKnetics on 31/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "BrowseViewController.h"
#import "SearchSongTableViewCell.h"
#import "AFNetworking.h"
#import "JSONModelLib.h"
#import "AppDelegate.h"
#import "VideoModel.h"
#import "VideoLink.h"
#import "MBProgressHUD.h"
#import "SignInViewController.h"
#import "PlayListTableViewCell.h"
#import "HCYoutubeParser.h"
#import "UIImageView+WebCache.h"

@interface BrowseViewController ()
{
     NSString* searchCall;
     int flag;
     NSMutableArray *videos;
        VideoLink* link;
    NSString *term;
     NSUserDefaults *user;
    NSString *trackname;
    NSString *trackimages;
    NSString *trackdscrptn;
    NSString *trackduration;
    NSString *trackurl;
    UIButton *plstimgbtn;
    UIButton *editbtn;
    UITextField *plnmtf;
    UIImagePickerController *pickerController;
     LBYouTubePlayerViewController *lbYoutubePlayerVC;
     MPMoviePlayerController *player;
    
    
    NSMutableArray *description;
    NSMutableArray *playlistdat;
    NSMutableArray *data;
    NSString *imagepassing;
    
     UITableView *playlisttable;
    NSData *imageData;
    
    NAPopoverView *popView;
    NAPopoverView *popView1;
}

@end

@implementation BrowseViewController

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
    if(isPhone480) {
        CGRect tableFrame = self.browseTbl.frame ;
        tableFrame.size.height = self.browseTbl.frame.size.height - 91 ;
        self.browseTbl.frame = tableFrame ;
    }
    
    flag=1;
    [_browseTbl setHidden:YES];
    [_noBrowseList setHidden:NO];
    user=[NSUserDefaults standardUserDefaults];
   
    term=@"Badalapur";
    
    videos=[[NSMutableArray alloc]init];
    [self.browseTbl setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    
    [self.browseTbl setHidden:YES];
    [self.noBrowseList setHidden:NO] ;
    
    [self searchvideo:term];
    self.browseTbl.delegate = nil ;
    self.browseTbl.dataSource = nil ;
    // Do any additional setup after loading the view from its nib.
}
-(void)searchvideo:(NSString *)term1
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    term = [term1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(flag==1)
    {
        data = nil ;
        data = [[NSMutableArray alloc] init];
        self.browseTbl.delegate = nil ;
        self.browseTbl.dataSource = nil ;
        //searchCall = [NSString stringWithFormat:@"%@youtubepopular/", kBaseURL];
        //searchCall = @"http://easeplay.net/api/youtubemtvchannellist";
        searchCall = [NSString stringWithFormat:@"%@youtubemtvchannellist/", kBaseURL] ;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"responseObject === %@", responseObject) ;
                 data= [responseObject valueForKey:@"data"];
                 // NSLog(@"data=%d",[data count]);
                 
                 
                 if([data count] > 0) {
                     [self.browseTbl setHidden:NO];
                     [self.noBrowseList setHidden:YES] ;
                     self.browseTbl.delegate = self ;
                     self.browseTbl.dataSource = self ;
                     [self.browseTbl reloadData];
                     
                 }else{
                     [self.browseTbl setHidden:YES];
                     [self.noBrowseList setHidden:NO] ;
                     
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
             }
         ];
        
        
       // NSLog(@"searchstring=%@",searchCall);
      /*  [JSONHTTPClient getJSONFromURLWithString: searchCall
                                      completion:^(NSDictionary *json, JSONModelError *err) {
                                          
                                          //got JSON back
                                         // NSLog(@"videos === %@", [json objectForKey:@"media$thumbnail:"]) ;
                                          
                                          NSLog(@"json === %@", json) ;
                                          if (err) {
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:[err localizedDescription]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"Close"
                                                                otherButtonTitles: nil] show];
                                              return;
                                          }
                                          
       
                                          
                                         // NSLog(@"videos === %@", videos) ;
                                         // NSLog(@"videos === %@", [[videos objectAtIndex:1] valueForKey:@"title"]) ;
                                          //if (videos) NSLog(@"Loaded successfully models");
                                          
                                          
                                          data = nil ;
                                          data = [[NSMutableArray alloc] init];
                                          data = [[json valueForKey:@"data"] valueForKey:@"items"];
                                          
                                          if([data count] > 0) {
                                              [self.browseTbl setHidden:NO];
                                              [self.noBrowseList setHidden:YES] ;
                                              self.browseTbl.delegate = self ;
                                              self.browseTbl.dataSource = self ;
                                              [self.browseTbl reloadData];
                                              
                                              
                                          }else{
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [self.browseTbl setHidden:YES];
                                              [self.noBrowseList setHidden:NO] ;
                                              
                                              
                                          }
                                          
                                          
                                          
                                      }];*/
        
    }
    else if (flag==4)
    {
        data = nil ;
        data = [[NSMutableArray alloc] init];
        self.browseTbl.delegate = nil ;
        self.browseTbl.dataSource = nil ;
        NSLog(@"BeatPort");
        searchCall=[NSString stringWithFormat:@"%@beatportsongs?keyword=%@",kBaseURL, term];
        NSLog(@"url=%@",searchCall);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 data=[responseObject valueForKey:@"data"];
                 
                 if([data count] > 0) {
                     [self.browseTbl setHidden:NO];
                     [self.noBrowseList setHidden:YES] ;
                     self.browseTbl.delegate = self ;
                     self.browseTbl.dataSource = self ;
                     [self.browseTbl reloadData];
                     
                     
                 }else{
                     [self.browseTbl setHidden:YES];
                     [self.noBrowseList setHidden:NO] ;
                 }
                // NSLog(@"response=%@",data);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                 
             }
         ];
        
    }

    else if ((flag=2))
    {
        data = nil ;
        data = [[NSMutableArray alloc] init];
        self.browseTbl.delegate = nil ;
        self.browseTbl.dataSource = nil ;
       // searchCall =[NSString stringWithFormat:@"https://api.soundcloud.com/tracks?client_id=af6adf4824fd764562ee975a657ab094&q=%@",@"Roy"];
       // searchCall = @"https://api.soundcloud.com/tracks?client_id=af6adf4824fd764562ee975a657ab094&order=hotness&limit=25" ;
        nextCloudVal = 100 ;
       searchCall = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks?client_id=af6adf4824fd764562ee975a657ab094&order=hotness&limit=%d", nextCloudVal] ;
        
        NSLog(@"searchCall ==== %@", searchCall) ;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:searchCall parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //NSLog(@"responseObject === %@", responseObject) ;
                 data=(NSMutableArray *)responseObject;
                // NSLog(@"data=%d",[data count]);
                 
                
                 if([data count] > 0) {
                     [self.browseTbl setHidden:NO];
                     [self.noBrowseList setHidden:YES] ;
                     self.browseTbl.delegate = self ;
                     self.browseTbl.dataSource = self ;
                     [self.browseTbl reloadData];
                     
                 }else{
                     [self.browseTbl setHidden:YES];
                     [self.noBrowseList setHidden:NO] ;
                     
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"eroor=%@",error);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
             }
         ];
    }
}




-(void) viewWillAppear:(BOOL)animated {
    term=@"Badlapur";
    currentPlayList = [[NSMutableArray alloc] init];

    
    self.view.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
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
    
    self.browseTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   // self.browseTbl.contentInset = UIEdgeInsetsMake(0, 0, 46, 0);
    
}

- (void)ChangePlyaImageWithString:(NSNotification *)notification
{
    [self.browseTbl reloadData] ;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
}

-(IBAction)chooseSongsOptions:(id)sender {
    
    UIButton *btnObj = (UIButton *) sender ;
    
    switch (btnObj.tag) {
        case 0:
            [self youTubeClick] ;
            break;
            
        case 1:
            [self soundCloudClick];
            break;
            
        case 2:
            [self grooveSharkClick];
            break;
            
        case 3:
            [self beatPostClick];
            break;
        default:
            break;
    }
    
}

-(void) youTubeClick {
    flag=1;
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube-active.png"]] ;
    [self.soundCloudImg setImage:[UIImage imageNamed:@"soundcloud.png"]] ;
    [self.grooveImg setImage:[UIImage imageNamed:@"groovshark.png"]] ;
    [self.beatImg setImage:[UIImage imageNamed:@"beatport.png"]] ;
    [self searchvideo:term];
}

-(void) soundCloudClick {
    flag = 2;
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube.png"]] ;
    [self.soundCloudImg setImage:[UIImage imageNamed:@"soundcloud-active.png"]] ;
    [self.grooveImg setImage:[UIImage imageNamed:@"groovshark.png"]] ;
    [self.beatImg setImage:[UIImage imageNamed:@"beatport.png"]] ;
    [self searchvideo:term];
    
}

-(void) grooveSharkClick {
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube.png"]] ;
    [self.soundCloudImg setImage:[UIImage imageNamed:@"soundcloud.png"]] ;
    [self.grooveImg setImage:[UIImage imageNamed:@"groovshark-active.png"]] ;
    [self.beatImg setImage:[UIImage imageNamed:@"beatport.png"]] ;
}

-(void) beatPostClick {
    flag=4;
    [self.youtubeImg setImage:[UIImage imageNamed:@"youtube.png"]] ;
    [self.soundCloudImg setImage:[UIImage imageNamed:@"soundcloud.png"]] ;
    [self.grooveImg setImage:[UIImage imageNamed:@"groovshark.png"]] ;
    [self.beatImg setImage:[UIImage imageNamed:@"beatport-active.png"]] ;
    //[self searchvideo:term];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_browseTbl) {
        if (flag==1) {
            
            return data.count;
        }
        else if (flag==2)
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_browseTbl)
    {
        return 67;
    }
    else if (tableView==playlisttable)
    {
        return 70;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_browseTbl) {
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
        cell.isPlayingVal = NO ;
        
        NSString *videoURL2 = @"";
        if (flag==1) {
           /* VideoModel* video = videos[indexPath.row];
            MediaThumbnail* thumb = video.thumbnail[0];
            link =[video.link objectAtIndex:0];*/
            
            [cell.thumbimage sd_setImageWithURL:[NSURL URLWithString:[[data objectAtIndex:indexPath.row] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
            
            cell.songtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"title"];
            cell.songsubtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"description"];
            
            if((appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) && [[user valueForKey:@"songRedirectionType"] isEqualToString:@"browse"])
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
           // NSLog(@"data === %@", data) ;
           // NSLog(@"data count === %d", [data count]);
           // NSLog(@"indexPath.row %d", indexPath.row) ;
            if([data isKindOfClass:[NSMutableArray class]]) {
            cell.songtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"title"];
           // [cell.thumbimage startImageDownloadingWithUrl:[[[data objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"avatar_url"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
                [cell.thumbimage sd_setImageWithURL:[[[data objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"avatar_url"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
                
            if(![[[data objectAtIndex:indexPath.row] valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
                cell.songsubtitlelbl.text = [[data objectAtIndex:indexPath.row] valueForKey:@"description"] ;
            }
            }
            
            if((appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) && [[user valueForKey:@"songRedirectionType"] isEqualToString:@"browse"])
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
            
        }else if (flag==4)
        {
            cell.songtitlelbl.text=[[data objectAtIndex:indexPath.row] valueForKey:@"name"];
           // [cell.thumbimage startImageDownloadingWithUrl:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
            
            [cell.thumbimage sd_setImageWithURL:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.playpausebtn.tag=indexPath.row;
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
        [cell.loginbtn addTarget:self action:@selector(liginclk:) forControlEvents:UIControlEventTouchUpInside];
        cell.loginbtn.tag=indexPath.row;
        cell.addsongbtn.tag=indexPath.row;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        [self.browseTbl setSeparatorColor:[UIColor colorWithRed:82.0/255.0 green:104.0/255.0 blue:131.0/255.0 alpha:1.0]];
     NSString *count = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        cell.songcountlbl.text=count;
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
        //cell.playlistimage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"image"]]]];
       // [cell.playlistimage startImageDownloadingWithUrl:[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [cell.playlistimage sd_setImageWithURL:[[playlistdat objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];

        
        NSString *str1=[[[playlistdat objectAtIndex:indexPath.row] valueForKeyPath:@"trackcount"] stringValue];
        NSString *str2=[str1 stringByAppendingString:@" songs"];
        cell.playlistdescrptn.text=str2;
        
        cell.backgroundColor=[UIColor clearColor];
        cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
        cell.deletplaylistbtn.hidden=YES;
        playlisttable.separatorColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
        
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
            NSIndexPath *cellIndexPath = [_browseTbl indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self liginclk:cellIndexPath];
            NSLog(@"sucess");
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_browseTbl indexPathForCell:cell];
            [self addsongqueue:cellIndexPath];
            NSLog(@"indexpath=%@",cellIndexPath);
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_browseTbl)
    {
        NSLog(@"songlistclk");
        
      //  NSLog(@"tag=%ld",(long)[sender tag]);
        if (flag==1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SearchSongTableViewCell *cell =(SearchSongTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
            [appDelegate pauseMusic];
            
           /* NSString* videoId = nil;
            VideoModel* video = videos[indexPath.row];
            link =[video.link objectAtIndex:0];*/
            
           /* NSArray *queryComponents = [link.href.query componentsSeparatedByString:@"&"];
            for (NSString* pair in queryComponents) {
                NSArray* pairComponents = [pair componentsSeparatedByString:@"="];
                if ([pairComponents[0] isEqualToString:@"v"]) {
                    videoId = pairComponents[1];
                    break;
                }
            }
            
            if (!videoId) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video ID not found in video URL" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil]show];
                return;
            }*/
           // NSLog(@"videoid=%@",videoId);
            NSString *videoId=[[data objectAtIndex:indexPath.row] valueForKey:@"video_id"];
            NSString *url1=[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
            
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
                        //[self playYouTubeVideo:_urlToLoad];
                        if(cell.isPlayingVal) {
                            [appDelegate pauseMusic];
                            cell.isPlayingVal = NO;
                            appDelegate.currentPlaySong = @"";
                            [cell.activityIndicator stopAnimating];
                            [cell.activityIndicator setHidden:YES];
                            [self.browseTbl reloadData];
                            
                        }else{
                            [user setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"] ;
                           // [appDelegate playMusic:videoURL];
                            
                            [cell.activityIndicator startAnimating];
                            [cell.activityIndicator setHidden:NO];
                            cell.isPlayingVal = YES;
                            [self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                            [appDelegate showSongTitle:[[data objectAtIndex:indexPath.row] valueForKey:@"title"]];
                        }
                        
                        appDelegate.currentPlaySong = url1 ;
                        [user setValue:@"youtube" forKey:@"songRedirectionTypeSubType"];
                        [user setValue:@"browse" forKey:@"songRedirectionType"];
                        [currentPlayList removeAllObjects];
                        NowSongsPlay *nowPlay ;
                        for (int i=0; i<[data count]; i++) {
                          
                            nowPlay = [[NowSongsPlay alloc] init] ;
                            nowPlay.musicTypeVal = @"Youtube";
                            nowPlay.descriptionVal = [[data objectAtIndex:i] valueForKey:@"description"];
                            nowPlay.thumbVal = [[data objectAtIndex:i] valueForKey:@"image"];
                            
                            nowPlay.titleVal = [[data objectAtIndex:i] valueForKey:@"title"];
                            
                            NSString *videoId=[[data objectAtIndex:i] valueForKey:@"video_id"];
                            nowPlay.musicURLVal = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
                            nowPlay.indexVal = [NSNumber numberWithInt:i] ;
                            [currentPlayList addObject:nowPlay];
                        }
                        
                        appDelegate.songsList = [[NSArray alloc] init];
                        appDelegate.tmpSongsList = [[NSArray alloc] init] ;
                        appDelegate.songsList = currentPlayList ;
                        appDelegate.tmpSongsList = appDelegate.songsList ;
                        //[self.nowPlayingBtn setHidden:NO];
                        
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
            
            NSString *songurl;
            NSString *urlsong=[[data objectAtIndex:indexPath.row] valueForKey:@"stream_url"];
            NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
            
            
            if(![appendurl isKindOfClass:[NSNull class]] && [appendurl length] > 0) {
                songurl=appendurl;
            }
            if(cell.isPlayingVal) {
                [appDelegate pauseMusic];
                cell.isPlayingVal = NO;
                appDelegate.currentPlaySong = @"";
                [cell.activityIndicator stopAnimating];
                [cell.activityIndicator setHidden:YES];
                [self.browseTbl reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
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
                nowPlay.musicTypeVal = @"soundcloud";
                nowPlay.descriptionVal = [[data objectAtIndex:i] valueForKey:@"description"];
                nowPlay.thumbVal = [[[data objectAtIndex:i] valueForKey:@"user"] valueForKey:@"avatar_url"];
                nowPlay.titleVal = [[data objectAtIndex:i] valueForKey:@"title"];
                
                NSString *urlsong=[[data objectAtIndex:i] valueForKey:@"stream_url"];
                NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
                
                nowPlay.musicURLVal = appendurl;
                nowPlay.indexVal = [NSNumber numberWithInt:i] ;
                [currentPlayList addObject:nowPlay];
            }
            appDelegate.songsList = nil ;
            appDelegate.tmpSongsList = nil ;
            appDelegate.songsList = [[NSArray alloc] init];
            appDelegate.tmpSongsList = [[NSArray alloc] init] ;
            appDelegate.songsList = currentPlayList ;
            appDelegate.tmpSongsList = appDelegate.songsList ;
            
            [user setValue:@"soundcloud" forKey:@"songRedirectionTypeSubType"];
            [user setValue:@"browse" forKey:@"songRedirectionType"];
            appDelegate.currentPlaySong = urlsong ;
            //[self.nowPlayingBtn setHidden:NO];
          //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           
        }
        
    }
    else if (tableView==playlisttable)
    {
       // NSLog(@"playlistclk");
        [self addtracktoplaylist:indexPath.row];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.browseTbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.browseTbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.browseTbl respondsToSelector:@selector(setLayoutMargins:)]) {
       [self.browseTbl setLayoutMargins:UIEdgeInsetsZero];
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
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

-(void)liginclk:(NSIndexPath *)indexpath
{
    if([user valueForKey:@"uid"])
    {
        
        if (flag==1) {
            
            trackname=[[data objectAtIndex:indexpath.row] valueForKey:@"title"];
            trackduration= @"0";
           // NSArray *time=[trackduration componentsSeparatedByString:@":"];
           // NSString *min=[time objectAtIndex:1];
           // NSString *sec=[time objectAtIndex:2];
           // trackduration=[min stringByAppendingString:[NSString stringWithFormat:@":%.@",sec]];
            //NSLog(@"time=%@",trackduration);
            trackimages=[[data objectAtIndex:indexpath.row] valueForKey:@"image"];
            
            NSString *videoId=[[data objectAtIndex:indexpath.row] valueForKey:@"video_id"];
            trackurl=[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
            trackdscrptn=[[data objectAtIndex:indexpath.row] valueForKey:@"description"];
        }
        else if (flag==2)
        {
            
            trackname=[[data objectAtIndex:indexpath.row] valueForKey:@"title"];
            trackimages=[[[data objectAtIndex:indexpath.row] valueForKey:@"user"] valueForKey:@"avatar_url"];
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
            trackurl=[[data objectAtIndex:indexpath.row] valueForKey:@"stream"];
            trackdscrptn=@"";
            trackduration=@"";
            
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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",nil];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        playlistdat=[responseObject valueForKey:@"data"];
       // NSLog(@"response=%@",playlistdat);
        
        [self showplaylist];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error: %@", error);
    }];
    
}
-(void)showplaylist
{
    popView=[[NAPopoverView alloc] init];
    [popView setFrame:CGRectMake(10,50,300,self.view.frame.size.height-80)];
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
        playlisttable=[[UITableView alloc]initWithFrame:CGRectMake(0,36, popView.frame.size.width,280)];
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
    [cutplalist setTitle:@"Close" forState:UIControlStateNormal];
    [cutplalist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cutplalist setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cutplalist setBackgroundColor:[UIColor whiteColor]];
    cutplalist.layer.cornerRadius=0.0f;
    cutplalist.layer.masksToBounds=YES;
    cutplalist.layer.borderWidth= 1.0f;
    cutplalist.layer.borderColor = [[UIColor grayColor] CGColor];
    [cutplalist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cutplalist.backgroundColor=[UIColor whiteColor];
    [cutplalist setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    
    
    
    if(isPhone480) {
        NSLog(@"innnn 3.5 inch") ;
        
        [popView setFrame:CGRectMake(10,10,300,self.view.frame.size.height-10)];
        CGRect addplaylistframe =addplaylist.frame ;
        
        CGRect tableframe=playlisttable.frame;
        tableframe.size.height=addplaylist.frame.size.height+240;
        playlisttable.frame=tableframe;
        
        CGRect termslblframe=cutplalist.frame;
        termslblframe.origin.y=addplaylistframe.origin.y+315;
        cutplalist.frame=termslblframe;
        
    }

    [popView addSubview:cutplalist];
    [popView addSubview:cutplalist] ;
    [popView addSubview:addplaylist];
    
    [popView show];
    [playlisttable reloadData];
    
}

-(void)cutplaylistclk:(id)sender
{
    [popView dismiss];
}

-(void)addtracktoplaylist:(int )indexPath
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
    else if (flag==3)
    {
        tracktype=@"Grooveshark";
    }
    
    NSString *URLString =[kBaseURL stringByAppendingString:kaddtracks];
   // NSLog(@"url=%@",URLString);
   // NSLog(@"url=%@",trackname);
   // NSLog(@"url=%@",trackimages);
   // NSLog(@"url=%@",[playlistdat objectAtIndex:indexPath]);
    
    trackdscrptn = [trackdscrptn stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"Track[uid]",[[playlistdat objectAtIndex:indexPath] valueForKey:@"id"],@"Track[pid]",trackname,@"Track[name]",trackimages,@"Track[image]",trackurl,@"Track[url]",trackdscrptn,@"Track[description]",trackduration,@"Track[duration]",tracktype,@"Track[type]",nil];
   
    
    NSLog(@"parameters=%@",params);
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      //  NSLog(@"response objject=%@",responseObject);
        NSString *status=[responseObject valueForKey:@"status"] ;
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
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [popView dismiss];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addsongqueue:(NSIndexPath *)indexpath
{
    NSMutableDictionary *songsDict = [[NSMutableDictionary alloc] init];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    if(flag==1)
    {
        NSString *trackTitleVal = [[[data objectAtIndex:indexpath.row] valueForKey:@"title"] stringByAppendingString:[NSString stringWithFormat:@"###$$%@", timeStampObj]];
        [songsDict setValue:trackTitleVal forKey:@"title"] ;
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"title"] forKey:@"image"] ;
        
        NSString *videoId=[[data objectAtIndex:indexpath.row] valueForKey:@"video_id"];
        [songsDict setValue:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId] forKey:@"url"] ;
        [songsDict setValue:@"Youtube" forKey:@"musictype"];
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"description"] forKey:@"subtitle"] ;
        
    }
    else if (flag==2)
    {
        NSString *trackTitleVal = [[[data objectAtIndex:indexpath.row] valueForKey:@"title"] stringByAppendingString:[NSString stringWithFormat:@"###$$%@", timeStampObj]];
        
        [songsDict setValue:trackTitleVal forKey:@"title"] ;
        [songsDict setValue:[[[data objectAtIndex:indexpath.row] valueForKey:@"user"] valueForKey:@"avatar_url"] forKey:@"thumburl"] ;
        
        NSString *urlsong=[[data objectAtIndex:indexpath.row] valueForKey:@"stream_url"];
        NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
        if(![appendurl isKindOfClass:[NSNull class]] && [appendurl length] > 0) {
            [songsDict setValue:appendurl forKey:@"url"] ;
        }
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"title"] forKey:@"subtitle"] ;
        [songsDict setValue:@"SoundCloud" forKey:@"musictype"];
    }
    else if (flag==4)
    {
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"name"] forKey:@"title"];
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"image"]forKey:@"thumburl"] ;
        [songsDict setValue:@"BeatPort" forKey:@"musictype"];
        [songsDict setValue:[[data objectAtIndex:indexpath.row] valueForKey:@"stream"] forKey:@"url"] ;
        
    }
    [DatabaseController insertSongs:songsDict] ;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"”Track added to Queued”";
    hud.margin = 10.f;
    if(isPhone480) {
        hud.yOffset = 150.f;
    }else{
        hud.yOffset = 200.f;
    }
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
    // Configure for text only and offset dow
}
-(void)addplaylistclk:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    UIView *addplaylistview=[[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.origin.y+32, popView.frame.size.width, 70)];
    addplaylistview.backgroundColor=[UIColor clearColor];
    CGRect tablefrme=playlisttable.frame;
    tablefrme.origin.y=playlisttable.frame.origin.y+70;
    if(isPhone480) {
        NSLog(@"innnn 3.5 inch") ;
        
        tablefrme.size.height=playlisttable.frame.size.height-75;
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
    bordrlbl.backgroundColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
    
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
   // NSLog(@"urlimage=%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]);
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    imageData = UIImageJPEGRepresentation(_playlistimage, 0.5f) ;
    [popView show];
    
}
-(void)editplaylist:(id)sender
{
   // NSLog(@"edited");
    if(imageData!=nil)
    {
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        
        NSString *MyString;
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        MyString = [dateFormatter stringFromDate:now];
        NSString *filename=[MyString stringByAppendingString:@"easeplay.jpg"];
        NSString *URLString1 =[kBaseURL stringByAppendingString:kimagetoserver];
       // NSLog(@"URL=%@",URLString1);
        //imagedata passing to server
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:URLString1 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:filename mimeType:@"image/jpeg"] ;
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
           // NSLog(@"Success: %@", responseObject);
            NSDictionary *data1=[responseObject valueForKey:@"data"];
            NSString *imagename1=[data1 valueForKey:@"image"];
            
            //imagepassing=[@"http://118.139.163.225/easeplay/images/playlist/" stringByAppendingString:imagename1];
            imagepassing=[kimagedwnld stringByAppendingString:imagename1];

            //NSLog(@"date=%@",imagepassing);
            
            if([[plnmtf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                [self addPlayList:imagepassing];
            }else{
                [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
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
            [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
            NSLog(@"Error: %@", error);
        }];
    }
    else if (imageData==nil)
    {
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        if([[plnmtf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            imagepassing=@"";
            [self addPlayList:imagepassing];
        }else{
            [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
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
    
    NSString *URLString =[kBaseURL stringByAppendingString:kaddPlaylist];
    //creating playlist
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:plnmtf.text,@"Playlist[name]",[user valueForKey:@"uid"],@"Playlist[uid]",imageurl,@"Playlist[image]",nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"JSON: %@", responseObject);
        
        NSMutableArray *da=[responseObject valueForKeyPath:@"data"];
        NSString *pid=[da valueForKeyPath:@"id"];
        
       // NSLog(@"response=%@",pid);
        
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        [self addtracttoplaystcrtd:(NSString *)pid];
        //[self  addtracktoplaylist:(int )0];
        [popView dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        NSLog(@"Error: %@", error);
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    trackdscrptn = [trackdscrptn stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"Track[uid]",pid,@"Track[pid]",trackname,@"Track[name]",trackimages,@"Track[image]",trackurl,@"Track[url]",trackdscrptn,@"Track[description]",trackduration,@"Track[duration]",tracktype,@"Track[type]",nil];
    
    NSLog(@"parameters=%@",params);
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status=[responseObject valueForKey:@"status"] ;
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

    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [popView dismiss];
}
-(void)playpauseclk:(id)sender
{
    NSLog(@"tag=%ld",(long)[sender tag]);
    if (flag==1) {
        NSString* videoId = nil;
        VideoModel* video = videos[[sender tag]];
        link =[video.link objectAtIndex:0];
        
        NSArray *queryComponents = [link.href.query componentsSeparatedByString:@"&"];
        for (NSString* pair in queryComponents) {
            NSArray* pairComponents = [pair componentsSeparatedByString:@"="];
            if ([pairComponents[0] isEqualToString:@"v"]) {
                videoId = pairComponents[1];
                break;
            }
        }
        
        if (!videoId) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video ID not found in video URL" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil]show];
            return;
        }
      //  NSLog(@"videoid=%@",videoId);
        NSString *url=[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",videoId];
        lbYoutubePlayerVC = [[LBYouTubePlayerViewController alloc]initWithYouTubeURL:[NSURL URLWithString:url]  quality:LBYouTubeVideoQualityLarge];
        lbYoutubePlayerVC.delegate=self;
        
        
    }
    else if (flag==2)
    {
        NSString *songurl;
        NSString *urlsong=[[data objectAtIndex:[sender tag]] valueForKey:@"stream_url"];
        NSString *appendurl=[urlsong stringByAppendingString:ksoundcloudclientid];
        
        
        if(![appendurl isKindOfClass:[NSNull class]] && [appendurl length] > 0) {
            songurl=appendurl;
        }
       // NSLog(@"appendurl=%@",songurl);
        _moviePlayer =  [[MPMoviePlayerController alloc]
                         initWithContentURL:[NSURL URLWithString:songurl]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_moviePlayer];
        
        _moviePlayer.controlStyle = MPMovieControlStyleDefault;
        _moviePlayer.view.backgroundColor=[UIColor clearColor];
        _moviePlayer.initialPlaybackTime = 0;
        [_moviePlayer setScalingMode:MPMovieScalingModeFill];
        _moviePlayer.view.frame = CGRectMake(0, 0, 0.5, 0.5);
        [self.view addSubview:_moviePlayer.view];
        [_moviePlayer play];
        [_moviePlayer setFullscreen:NO animated:YES];
    }
}
- (void) moviePlayBackDidFinish:(NSNotification*) aNotification
{
    player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
}
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
   // NSLog(@"videourl;=%@",videoURL);
    _moviePlayer =  [[MPMoviePlayerController alloc]
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
    [_moviePlayer play];
    
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
