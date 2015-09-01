//
//  TrackListViewController.m
//  EasePlay
//
//  Created by AppKnetics on 20/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "TrackListViewController.h"
#import "TrackListTableViewCell.h"
#import "Constant.h"
#import "Global.h"
#import "NAPopoverView.h"
#import "PlayListViewController.h"
#import "PlayListTableViewCell.h"
#import "HCYoutubeParser.h"
#import "SWTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NowSongsPlay.h"

@interface TrackListViewController ()
{
    NSMutableArray *trackdata;
     NSMutableArray *title;
     NSMutableArray *thuumbimages;
    NAPopoverView *popview;
    NAPopoverView *popview1;
   UIImagePickerController *pickerController;
    UITextField *playlisttf;
    UIButton *cutButton;
    int flag;
    NSString *trackid;
    NSData *imageData;
    //NSString *imagedata;
    UITableView *playlisttable;
    NSString *imagepassing;
    UIImage *select;
    UITextField *firstName;
    int hide;
    //playlistarrays
    
    NSString *trackname;
    NSString *trackimage;
    NSString *trackdescription;
    NSString *trackurla;
    NSString *trackmusictype;
    UIImage *unselect;
    
    NSMutableArray *playlistdata;
   
    //NSMutableArray *pid;
    NSUserDefaults *user;

}

@end


@implementation TrackListViewController

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
        CGRect tableFrame = self.trackstbl.frame ;
        tableFrame.size.height = self.trackstbl.frame.size.height - 180 ;
        self.trackstbl.frame = tableFrame ;
        
    }
    
    user=[NSUserDefaults standardUserDefaults];

    playlisttf.delegate=self;
    flag=1;
    _trackstbl.backgroundColor=[UIColor clearColor];
    _trackstbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_trackstbl setAllowsSelection:YES];
    
    /*UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapp:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];*/
    
    UISwipeGestureRecognizer  *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer  * rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_playlistview addGestureRecognizer:leftSwipeGestureRecognizer];
    [_playlistview addGestureRecognizer:rightSwipeGestureRecognizer];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImage *bkbuttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *abkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [abkButton setBackgroundImage:bkbuttonImage forState:UIControlStateNormal];
    abkButton.frame = CGRectMake(0.0, 0.0, bkbuttonImage.size.width, bkbuttonImage.size.height);
    UIBarButtonItem *aBackBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:abkButton];
    [abkButton addTarget:self action:@selector(backRedirect:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBackBarButtonItem];
    
    unselect=[UIImage imageNamed:@"edit.png"];
    //select=[UIImage imageNamed:@"edit-hover.png"];
    select=[UIImage imageNamed:@"edit.png"];

    
    [_notrackslbl setHidden:NO];
    [_trackstbl setHidden:YES];
    
    [self fetchplaylistdetail];
    [self fetchdata];
    [self fetchplaylist];
    // Do any additional setup after loading the view from its nib.
}

-(void) backRedirect:(id) sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}
-(void)fetchplaylistdetail
{
   
    _playlisttitle.text=[user valueForKey:@"Playlisttitle"];
    //_playlistimage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user valueForKey:@"playlistimage"]]]];
    NSLog(@"Placehoder image === %@", [user valueForKey:@"playlistimage"]) ;
   // [_playlistimage startImageDownloadingWithUrl:[user valueForKey:@"playlistimage"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    //_playlistimage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user valueForKey:@"playlistimage"]]]];
    
    [_playlistimage sd_setImageWithURL:[user valueForKey:@"playlistimage"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    
    NSString *str1=[[user valueForKey:@"trackcount"] stringValue];
    NSString *str2=[str1 stringByAppendingString:@" songs"];
    _playlistsubtitle.text=str2;
}
-(void)tapp:(id)sender
{
    [playlisttf resignFirstResponder];
}
-(void)fetchdata
{
    trackdata=[[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString =[kBaseURL stringByAppendingString:klisttracks];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",[user valueForKey:@"pid"],@"pid",nil];
    
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        trackdata=[responseObject valueForKey:@"data"];
        if (trackdata.count>0) {
            [_notrackslbl setHidden:YES];
            [_trackstbl setHidden:NO];
            _trackstbl.delegate=self;
            _trackstbl.dataSource=self;
            _playlistsubtitle.text = [NSString stringWithFormat:@"%d songs", trackdata.count];
            [_trackstbl reloadData];
        }else{
            _playlistsubtitle.text = @"0 songs" ;
        }

        [_trackstbl reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addtrackclk:(id)sender {
}

- (IBAction)deleteplaylistclk:(id)sender {
    
   // [_deletebtn setBackgroundImage:[UIImage imageNamed:@"delete-hover.png"] forState:UIControlStateNormal];
    popview=[[NAPopoverView alloc] init];
    [popview setFrame:CGRectMake(0,0,250, 130)];
    popview.center=self.view.center;
   // popview.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0];
    popview.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];
    
    popview.layer.borderColor = [UIColor blackColor].CGColor;
    popview.layer.cornerRadius = 0.0;
    popview.layer.borderWidth = 1.0;
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,-6,220,90)];
    fromLabel.numberOfLines = 3;
    NSString *string1=[NSString stringWithFormat:@"Are you sure you want to delete the playlist?"] ;//[NSString stringWithFormat:@"Are you sure you want to delete the playlist ”%@”?",[user valueForKey:@"Playlisttitle"]];
    fromLabel.text=string1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.adjustsLetterSpacingToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    [fromLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor whiteColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton * Yesbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [Yesbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Yesbtn setTitle:@"YES" forState:UIControlStateNormal];
    [Yesbtn addTarget:self action:@selector(Yesclick:) forControlEvents:UIControlEventTouchUpInside];
    [Yesbtn setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    Yesbtn.layer.cornerRadius=0.0;
    Yesbtn.layer.masksToBounds=YES;
    Yesbtn.layer.borderWidth= 1.0f;
    Yesbtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [Yesbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton * Nobtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [Nobtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Nobtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [Nobtn setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    [Nobtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [Nobtn addTarget:self action:@selector(Cancelclk:) forControlEvents:UIControlEventTouchUpInside];
    Nobtn.layer.cornerRadius=0.0f;
    Nobtn.layer.masksToBounds=YES;
    Nobtn.layer.borderWidth= 1.0f;
    Nobtn.layer.borderColor = [[UIColor grayColor] CGColor];
   
    
    
    Yesbtn.tag=[sender tag];
    
    [Nobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [Yesbtn setFrame:CGRectMake(10,80,110,35)];
    [Nobtn setFrame:CGRectMake(130,80,110,35)];
    
    [popview addSubview:fromLabel];
    [popview addSubview:Yesbtn];
    [popview addSubview:Nobtn];
    [popview show];

}
-(void)Cutclick:(id)sender
{
    [_deletebtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];

    [popview dismiss];
}
- (IBAction)editplaylistclk:(id)sender {
    [currentTextField resignFirstResponder] ;
    if (flag==1) {
       
            [sender setBackgroundImage:select forState:UIControlStateNormal];
        
      

            flag=2;
           // NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        CGRect textfieldframe=_playlisttitle.frame;
            _playlisttitle.hidden=YES;
        
        textfieldframe.origin.x=_playlisttitle.frame.origin.x+7;
        textfieldframe.size.width=_playlisttitle.frame.size.width-10;
           playlisttf = [[UITextField alloc] init];
        
           playlisttf.frame=textfieldframe;
       
           playlisttf.borderStyle = UITextBorderStyleRoundedRect;
           playlisttf.font = [UIFont systemFontOfSize:15];
           playlisttf.text=[user valueForKey:@"Playlisttitle"];
           playlisttf.autocorrectionType = UITextAutocorrectionTypeNo;
           playlisttf.keyboardType = UIKeyboardTypeDefault;
           playlisttf.returnKeyType = UIReturnKeyDone;
           playlisttf.clearButtonMode = UITextFieldViewModeWhileEditing;
           playlisttf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
           playlisttf.backgroundColor=[UIColor whiteColor];
        
           playlisttf.delegate=self;
           cutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
           cutButton.frame = CGRectMake(self.playlistimage.frame.origin.x+43, self.playlistimage.frame.origin.y-12,24, 24);
        
          cutButton.backgroundColor = [UIColor clearColor];
         // [cutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
          UIImage *buttonImageNormal = [UIImage imageNamed:@"close.png"];
        
          [cutButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
          [cutButton addTarget:self action:@selector(cutimageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *image=[user valueForKey:@"playlistimage"];
        if ([image isEqualToString:@""]) {
            cutButton.hidden=YES;
        }
          [self.playlistview addSubview:cutButton];
          [_playlistview addSubview:playlisttf];
        
          UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagetaped:)];
         _playlistimage.userInteractionEnabled=YES;
        [_playlistimage addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionTransitionFlipFromLeft         //UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             [_swipeview setFrame:CGRectMake(305.0f, 74.0f, 114.0f, 35.0f)];
                         }
                         completion:nil];

        
        
    }
    else
    {
        _playlistimage.userInteractionEnabled=NO;
        flag=1;
      if (imageData!=nil) {
        
          NSData *image;
             NSString *MyString;
             NSDate *now = [NSDate date];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
             MyString = [dateFormatter stringFromDate:now];
        
             NSString *filename=[MyString stringByAppendingString:@"easeplay.jpg"];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             NSString *URLString1 =[kBaseURL stringByAppendingString:kimagetoserver];
          
                //imagedata passing to server
             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             [manager POST:URLString1 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:imageData name:@"image" fileName:filename mimeType:@"image/jpeg"] ;
               } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Success: %@", responseObject);
                 NSDictionary *data1=[responseObject valueForKey:@"data"];
               
                   if([responseObject valueForKey:@"data"]==NULL){
                       imagepassing=@"";
                   }
                   else{
                        NSString *imagename1=[data1 valueForKey:@"image"];
                      // imagepassing=[@"http://118.139.163.225/easeplay/images/playlist/" stringByAppendingString:imagename1];
                        imagepassing=[kimagedwnld stringByAppendingString:imagename1];
                       
                       
                   }
          [user setValue:imagepassing forKey:@"playlistimage"];
            NSLog(@"date=%@",imagepassing);
            
            [self addPlayList:imagepassing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
       }
        else if (imageData==nil)
        {
            imagepassing=[user valueForKey:@"playlistimage"];
             [self addPlayList:imagepassing];

        }

    }
}
-(void)cutimageAction:(id)sender
{
    NSLog(@"hi...");
    _playlistimage.image=[UIImage imageNamed:@"easeplay_placeholder.png"];
    cutButton.hidden=YES;
    [user setValue:@"" forKey:@"playlistimage"];
}
-(void) addPlayList:(NSString *)imageurl {
    NSString *URLString =[kBaseURL stringByAppendingString:keditplaylist];
   user=[NSUserDefaults standardUserDefaults];
    //creating playlist
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:playlisttf.text,@"Playlist[name]",[user valueForKey:@"pid"],@"Playlist[pid]",imageurl,@"Playlist[image]",nil];
    NSLog(@"parmeters=%@",params);
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"response=%@",responseObject);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       user=[NSUserDefaults standardUserDefaults];
        [user setValue:playlisttf.text forKey:@"Playlisttitle"];
        [user setValue:imageurl forKey:@"playlistimage"];
        
        playlisttf.hidden=YES;
        cutButton.hidden=YES;
        _playlisttitle.hidden=NO;
        [_editbtn setBackgroundImage:unselect forState:UIControlStateNormal];

        [self fetchplaylistdetail];
        [self fetchdata];
        imageData = nil ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==_trackstbl) {
        return trackdata.count;
        
    }
    else if (tableView==playlisttable)
    {
        return playlistdata.count;
    }
    return 0;
    
}
-(void)Cancelpressed:(id)sender
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [playlisttf resignFirstResponder];
    [textField resignFirstResponder];
    if(textField != playlisttf ) {
        TrackListTableViewCell *cell = (TrackListTableViewCell *)[_trackstbl cellForRowAtIndexPath:textindex];
        NSLog(@"text=%@",cell.edittrcktf.text);
        if (cell.edittrcktf.text.length>0) {
            [self edittrackbtnclk:textindex];
        }
    }
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    currentTextField = textField ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_trackstbl) {
        
         static NSString *cellIdentifier = @"Track";
         /* TrackListTableViewCell *cell = (TrackListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if (!cell) {
                [tableView registerNib:[UINib nibWithNibName: @"TrackListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
             }*/
        TrackListTableViewCell *cell = (TrackListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrackListTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell.playPlaceHolder setHidden:YES];
        [cell.activityIndicator setHidden:YES];
        cell.isPlayingVal = NO;
        
        
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:30.0f spaceValue:30] ;
        cell.rightUtilityButtons = [self rightButtons];
        
        cell.delegate = self;
   
        cell.edittrcktf.delegate=self;
        [cell.edittrcktf setTag:indexPath.row];
        [cell.tracktitle setHidden:NO];
            cell.tracktitle.text=[[trackdata objectAtIndex:indexPath.row] valueForKey:@"name"] ;
          _trackstbl.separatorColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
        //cell.tracktime.text=[[trackdata objectAtIndex:indexPath.row] valueForKey:@"duration"] ;
         _trackstbl.allowsSelection = YES;
         //[cell.trackimage startImageDownloadingWithUrl:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        [cell.trackimage sd_setImageWithURL:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
            cell.tracksubtitle.text=[[trackdata objectAtIndex:indexPath.row] valueForKey:@"description"];
            cell.backgroundColor=[UIColor clearColor];
            cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
        cell.edittrcktf.delegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        if ([[[trackdata objectAtIndex:indexPath.row] valueForKey:@"id"] isEqualToString:trackid]) {
            NSLog(@"hi");
            [cell.tracktitle setHidden:YES];
            [cell.edittrcktf setHidden:NO];
             cell.edittrcktf.text=[[trackdata objectAtIndex:indexPath.row] valueForKey:@"name"] ;
            currentTxt = cell.edittrcktf ;
            cell.edittrcktf.backgroundColor=[UIColor whiteColor];
                                   
        }
        else
        {
            [cell.tracktitle setHidden:NO];
            [cell.edittrcktf setHidden:YES];
        }
        
        if((appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) && [[user valueForKey:@"songRedirectionType"] isEqualToString:@"playlist"])
        {
            NowSongsPlay *nowPlayObj ;
            nowPlayObj = nil;
            if([appDelegate.songsList count]) {
                nowPlayObj = [appDelegate.songsList lastObject] ;
            
                if(([[user valueForKey:@"playIndex"] integerValue] == indexPath.row) && [[user valueForKey:@"songRedirectionTypeSubType"] isEqualToString:@"playlisttrack"] && [nowPlayObj.titleVal isEqualToString:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"name"]]) {
                    [cell.playPlaceHolder setHidden:NO];
                    [cell.activityIndicator setHidden:YES];
                    cell.isPlayingVal = YES;
                }else{
                    [cell.playPlaceHolder setHidden:YES];
                    [cell.activityIndicator setHidden:YES];
                    cell.isPlayingVal = NO;
                }
            }
            
        }else{
            
            [cell.playPlaceHolder setHidden:YES];
            [cell.activityIndicator setHidden:YES];
        }
        
        
        

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
        cell.playlisttitle.text=[[playlistdata objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.deletplaylistbtn.tag=[[[playlistdata objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];
        playlisttable.separatorColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
         playlisttable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
         //[cell.playlistimage startImageDownloadingWithUrl:[[playlistdata objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        [cell.playlistimage sd_setImageWithURL:[[playlistdata objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
        
        NSString *str1=[[[playlistdata objectAtIndex:indexPath.row] valueForKeyPath:@"trackcount"] stringValue];
        NSString *str2=[str1 stringByAppendingString:@" songs"];
        
        cell.playlistdescrptn.text=str2;
        cell.backgroundColor=[UIColor clearColor];
        cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
        cell.deletplaylistbtn.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell;
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_trackstbl)
    {
         if ([[[trackdata objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"youtube"]) {
             
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSLog(@"songlistclk");
           TrackListTableViewCell *cell =(TrackListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
           [appDelegate pauseMusic];
             
            NSString *videourl=[[trackdata objectAtIndex:indexPath.row] valueForKey:@"url"];
              NSLog(@"videoid=%@",videourl);
             
               NSURL *url = [NSURL URLWithString:videourl];
            [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
            
              if (!error) {
                    [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
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
                    if(cell.isPlaying) {
                        [appDelegate pauseMusic];
                        cell.isPlaying = NO;
                        appDelegate.currentPlaySong = @"";
                        [cell.activityIndicator stopAnimating];
                        [cell.activityIndicator setHidden:YES];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self.trackstbl reloadData];
                        
                    }else{
                        [appDelegate playMusic:videoURL];
                        [appDelegate showSongTitle:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"name"]];
                        [cell.activityIndicator startAnimating];
                        [cell.activityIndicator setHidden:NO];
                        cell.isPlaying = YES;
                        [user setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"] ;
                        [self performSelector:@selector(playYouTubeVideo:) withObject:videoURL afterDelay:1.0];
                        [appDelegate showSongTitle:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"name"]];
                    }
                        
                        [user setValue:@"playlisttrack" forKey:@"songRedirectionTypeSubType"];
                        [user setValue:@"playlist" forKey:@"songRedirectionType"];
                        [currentPlayList removeAllObjects];
                        NowSongsPlay *nowPlay ;
                        for (int i=0; i<[trackdata count]; i++) {
                           // [songthumb addObject:[[data objectAtIndex:i] valueForKey:@"user"]];
                            nowPlay = [[NowSongsPlay alloc] init] ;
                            nowPlay.musicTypeVal = [[trackdata objectAtIndex:i] valueForKey:@"type"];
                            nowPlay.descriptionVal = [[trackdata objectAtIndex:i] valueForKey:@"description"];
                            nowPlay.thumbVal = [[trackdata objectAtIndex:indexPath.row] valueForKey:@"image"];
                            nowPlay.titleVal = [[trackdata objectAtIndex:i] valueForKey:@"name"];
                            nowPlay.musicURLVal = [[trackdata objectAtIndex:i] valueForKey:@"url"];
                            nowPlay.indexVal = [NSNumber numberWithInt:i] ;
                            [currentPlayList addObject:nowPlay];
                        }
                        appDelegate.tmpSongsList = [[NSArray alloc] init] ;
                        appDelegate.songsList = [[NSArray alloc] init];
                        appDelegate.songsList = currentPlayList ;
                        appDelegate.tmpSongsList = appDelegate.songsList ;
                       // [self.nowPlayingBtn setHidden:NO];
                       // appDelegate.currentPlaySong = url1 ;
                    NSLog(@"appDelegate.songsList === %@", appDelegate.songsList) ;
                    appDelegate.currentPlaySong = videourl ;
                    
                }];
            }
            else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
               }
          }];
        
       }
        else if ([[[trackdata objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"soundcloud"])
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            TrackListTableViewCell *cell =(TrackListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] ;
            [appDelegate pauseMusic];
            // cell.isPlaying = NO;
            //[cell.playPlaceHolder setHidden:NO] ;
            
            NSString *songurl;
            NSString *urlsong=[[trackdata objectAtIndex:indexPath.row] valueForKey:@"url"];
            NSLog(@"songurl=%@",urlsong);
            
            if(![urlsong isKindOfClass:[NSNull class]] && [urlsong length] > 0) {
                songurl=urlsong;
            }
            NSLog(@"appendurl=%@",songurl);
            if(cell.isPlaying) {
                [appDelegate pauseMusic];
                cell.isPlaying = NO;
                appDelegate.currentPlaySong = @"";
                [cell.activityIndicator stopAnimating];
                [cell.activityIndicator setHidden:YES];
                [self.trackstbl reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }else{
                [user setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"playIndex"];
                [appDelegate playMusic:[NSURL URLWithString:songurl]];
                [appDelegate showSongTitle:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"name"]];
                [cell.activityIndicator startAnimating];
                [cell.activityIndicator setHidden:NO];
                cell.isPlaying = YES;
               // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            [user setValue:@"playlisttrack" forKey:@"songRedirectionTypeSubType"];
            [user setValue:@"playlist" forKey:@"songRedirectionType"];
            [currentPlayList removeAllObjects];
            NowSongsPlay *nowPlay ;
            for (int i=0; i<[trackdata count]; i++) {
                // [songthumb addObject:[[data objectAtIndex:i] valueForKey:@"user"]];
                nowPlay = [[NowSongsPlay alloc] init] ;
                nowPlay.musicTypeVal = [[trackdata objectAtIndex:i] valueForKey:@"type"];
                nowPlay.descriptionVal = [[trackdata objectAtIndex:i] valueForKey:@"description"];
                nowPlay.thumbVal = [[trackdata objectAtIndex:indexPath.row] valueForKey:@"image"];
                nowPlay.titleVal = [[trackdata objectAtIndex:i] valueForKey:@"name"];
                nowPlay.musicURLVal = [[trackdata objectAtIndex:i] valueForKey:@"url"];
                nowPlay.indexVal = [NSNumber numberWithInt:i] ;
                [currentPlayList addObject:nowPlay];
            }
            appDelegate.tmpSongsList = [[NSArray alloc] init];
            appDelegate.songsList = [[NSArray alloc] init];
            appDelegate.songsList = currentPlayList ;
            appDelegate.currentPlaySong = urlsong ;
            appDelegate.tmpSongsList = appDelegate.songsList ;
           // [self.nowPlayingBtn setHidden:NO];
            NSLog(@"appDelegate.songsList === %@", appDelegate.songsList) ;
        }
        else if ([[[trackdata objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@""])
        {
            NSString *URLString=[kBaseURL stringByAppendingString:kplaygssong];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[trackdata objectAtIndex:indexPath.row] valueForKey:@"url"],@"songid",nil];
            //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSString *groveshrkurl=[responseObject valueForKey:@"data"];
                NSLog(@"response=%@",[responseObject valueForKey:@"data"]);
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
    }
    else if (tableView==playlisttable)
    {
        NSLog(@"playlistclk");
        [self addtracktoplaylistin:indexPath.row];
    }
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"delete.png"]];

    
       [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"add-to-playlist.png"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"edit.png"]];
    
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"add-to-queue.png"]];
    

    

    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSLog(@"index == %d", index ) ;
    switch (index) {
        case 0:
        {
            
            NSIndexPath *cellIndexPath = [_trackstbl indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self deletetrack:cellIndexPath];
            break;

            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_trackstbl indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self addtracktoplaylist:cellIndexPath];
            
            NSLog(@"sucess");
            break;
            }
        case 2:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_trackstbl indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self edittrackbtnclk:cellIndexPath];
            break ;
        }
        case 3:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_trackstbl indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self addsongqueue:cellIndexPath];
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
-(void) soundCloudedEnded:(id) sender {
    
}
-(void)imagetaped:(id)sender
{
    
    popview1=[[NAPopoverView alloc] init];
    [popview1 setFrame:CGRectMake(0,0,300, 99)];
    popview1.center=self.view.center;
    popview1.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0];
    
    popview1.layer.borderColor = [UIColor blackColor].CGColor;
    popview1.layer.cornerRadius = 0.0;
    popview1.layer.borderWidth = 1.0;
    
    UIButton * btnCamera=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCamera setTitle:@"Camera" forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(btnCameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnCamera setBackgroundColor:[UIColor whiteColor]];
    btnCamera.layer.cornerRadius=0.0;
    btnCamera.layer.masksToBounds=YES;
    btnCamera.layer.borderWidth= 1.0f;
    btnCamera.layer.borderColor = [[UIColor grayColor] CGColor];
    [btnCamera setFrame:CGRectMake(10,0,popview1.bounds.size.width,75)];
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
    [btnCamera setFrame:CGRectMake(0,49,popview1.bounds.size.width,50)];
    [btnGallery setFrame:CGRectMake(0,0,popview1.bounds.size.width,50)];
    [btnGallery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGallery.backgroundColor=[UIColor clearColor];
    
    [popview1 addSubview:btnCamera];
    [popview1 addSubview:btnGallery];
    [popview1 show];
    
    NSLog(@"hi..");
}
-(void)btnCameraPressed:(UIButton *)sender{
	
	NSLog(@"Camera button pressed .");
	
    if([UIImagePickerController		isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [popview1 dismiss];
        UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{}];
		
	}
}
-(void)playYouTubeVideo:(NSURL *) url {
    [appDelegate playMusic:url] ;
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)imageUploadButtonClick:(id)sender
{
    [popview1 dismiss];
    pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.toolbarHidden = NO;
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _thumbimage  =[info objectForKey:@"UIImagePickerControllerOriginalImage"] ;
    
    _playlistimage.image=_thumbimage;
    [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSLog(@"urlimage=%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]);
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    imageData = UIImageJPEGRepresentation(_thumbimage, 0.5f) ;
   // imageData=imageData;
    
}
-(void)Yesclick:(id)sender
{

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString =[kBaseURL stringByAppendingString:kdeleteplaylist];
    NSLog(@"sender tag=%ld",(long)[sender tag]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",[user valueForKey:@"pid"],@"pid",nil];
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if([responseObject valueForKey:@"status"]) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"”PlayList deleted successfully.”";
                hud.margin = 10.f;
                if(isPhone480) {
                    hud.yOffset = 150.f;
                }else{
                    hud.yOffset = 200.f;
                }
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:2];
                
                NSArray *viewControllers = self.navigationController.viewControllers;
                for (int i=0; i<[viewControllers count]; i++) {
                    UIViewController *viewController = [viewControllers objectAtIndex:i];
                    
                    if([viewController isKindOfClass:[PlayListViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                    }
                    
                }
            }else{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"”Some error occures. Please try again.”";
                hud.margin = 10.f;
                if(isPhone480) {
                    hud.yOffset = 150.f;
                }else{
                    hud.yOffset = 200.f;
                }
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:2];
            }
        }else{
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Some error occures. Please try again.”";
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
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"”Some error occures. Please try again.”";
        hud.margin = 10.f;
        if(isPhone480) {
            hud.yOffset = 150.f;
        }else{
            hud.yOffset = 200.f;
        }
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
        NSLog(@"Error: %@", error);
    }];
    
    [popview dismiss];
   
   // PlayListViewController *playlistview=[[PlayListViewController alloc]init];
   // [self.navigationController pushViewController:playlistview animated:YES];
    
    
}
-(void)edittrackbtnclk:(NSIndexPath *)indexpath
{
      textindex=indexpath;
    TrackListTableViewCell *cell=(TrackListTableViewCell *)[_trackstbl cellForRowAtIndexPath:indexpath];
    if ([[[trackdata objectAtIndex:indexpath.row] valueForKey:@"id"] isEqualToString:trackid]) {
        NSString *URLString =[kBaseURL stringByAppendingString:kedittrackname];
        NSLog(@"sender tag=%ld",(long)indexpath.row);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",[[trackdata objectAtIndex:indexpath.row] valueForKey:@"id"],@"tid",cell.edittrcktf.text,@"name",nil];
        [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSLog(@"response=%@",responseObject);
            NSString *status=[responseObject valueForKey:@"status"] ;
            NSLog(@"response=%@",responseObject);
            if ([status intValue]==1) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"”Track name successfully changed”";
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
                hud.labelText = @"”Some Problem to change the track name”";
                hud.margin = 10.f;
                if(isPhone480) {
                    hud.yOffset = 150.f;
                }else{
                    hud.yOffset = 200.f;
                }
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:2];
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            trackid=nil;
            [self fetchdata];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    trackid=[[trackdata objectAtIndex:indexpath.row] valueForKey:@"id"];
  [_trackstbl reloadData];
    [currentTxt becomeFirstResponder] ;
}
-(void)viewWillAppear:(BOOL)animated{
    
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
    
    self.trackstbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    currentPlayList = [[NSMutableArray alloc] init];
    NSString *notificationName = @"ChangePlyaImage";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ChangePlyaImageWithString:)
     name:notificationName
     object:nil];
    
}
- (void)ChangePlyaImageWithString:(NSNotification *)notification
{
    [self.trackstbl reloadData] ;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStatePaused || appDelegate.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [self.nowPlayingBtn setHidden:NO];
    }else{
        [self.nowPlayingBtn setHidden:YES];
    }
}
-(void)Cancelclk:(id)sender
{
    [_deletebtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [popview dismiss];
}
-(void)addtracktoplaylist:(NSIndexPath *)indexpath
{
    
    trackname=[[trackdata objectAtIndex:indexpath.row] valueForKey:@"name"];
    trackurla=[[trackdata objectAtIndex:indexpath.row] valueForKey:@"url"];
    trackimage=[[trackdata objectAtIndex:indexpath.row] valueForKey:@"image"];
    trackdescription=[[trackdata objectAtIndex:indexpath.row] valueForKey:@"description"];
    trackmusictype=[[trackdata objectAtIndex:indexpath.row] valueForKey:@"type"];
    
    popview=[[NAPopoverView alloc] init];
    [popview setFrame:CGRectMake(10,50,300, 400)];
    popview.center=self.view.center;
    popview.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];
    
    popview.layer.borderColor = [UIColor blackColor].CGColor;
    popview.layer.cornerRadius = 0.0;
    popview.layer.borderWidth = 1.0;

    
    UILabel *plailist=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, popview.frame.size.width, 30)];
    plailist.text=@"SELECT PLAYLIST";
    plailist.backgroundColor=[UIColor blackColor];
    plailist.textColor=[UIColor whiteColor];
    plailist.textAlignment = NSTextAlignmentCenter;
    
    UIButton * cutplalist=[UIButton buttonWithType:UIButtonTypeCustom];
    [cutplalist addTarget:self action:@selector(cutplaylistclk:) forControlEvents:UIControlEventTouchUpInside];
    [cutplalist setFrame:CGRectMake(80,350,150,35)];
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
    
    
    
    playlisttable=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, popview.frame.size.width, 300)];
    
    
    
    playlisttable.delegate=self;
    playlisttable.dataSource=self;
    playlisttable.backgroundColor=[UIColor clearColor];
    
    if(isPhone480) {
        NSLog(@"innnn 3.5 inch") ;
        
        /*[popview setFrame:CGRectMake(10,10,300,self.view.frame.size.height-10)];
        CGRect addplaylistframe =addplaylist.frame ;
        
        CGRect tableframe=playlisttable.frame;
        tableframe.size.height=addplaylist.frame.size.height+245;
        playlisttable.frame=tableframe;
        
        CGRect termslblframe=cutplalist.frame;
        termslblframe.origin.y=addplaylistframe.origin.y+320;
        cutplalist.frame=termslblframe;*/
        
    }
    [popview addSubview:cutplalist];
    [popview addSubview:plailist];
    [popview addSubview:playlisttable];
    //[popview addSubview:cutplalist];
    [popview show];

    
}
-(void)cutplaylistclk:(id)sender
{
    [popview dismiss];
}

-(void)fetchplaylist
{
    playlistdata=[[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString =[kBaseURL stringByAppendingString:klistplaylist];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",nil];
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        playlistdata=[responseObject valueForKey:@"data"];

        [playlisttable reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(void)addtracktoplaylistin:(int )indexPath
{
   
    NSString *URLString =[kBaseURL stringByAppendingString:kaddtracks];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"Track[uid]",[[playlistdata objectAtIndex:indexPath] valueForKey:@"id"],@"Track[pid]",trackname,@"Track[name]",trackimage,@"Track[image]",trackurla,@"Track[url]",trackdescription,@"Track[description]",@"",@"Track[duration]",trackmusictype,@"Track[type]",nil];
    
    NSLog(@"parameters=%@",params);
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response objject=%@",responseObject);
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
        

    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [popview dismiss];
    
}
-(void)deletetrack:(NSIndexPath *)indexpath
{
    
   NSString *URLString =[kBaseURL stringByAppendingString:kdeletetrack];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[trackdata objectAtIndex:indexpath.row] valueForKey:@"playlist_id"],@"pid",[[trackdata objectAtIndex:indexpath.row] valueForKey:@"id"],@"tid",[user valueForKey:@"uid"],@"uid",nil];
    
    NSLog(@"parameters=%@",params);
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status=[responseObject valueForKey:@"status"] ;
        NSLog(@"response=%@",responseObject);
        if ([status intValue]==1) {
            [self fetchdata];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Track deleted”";
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
            hud.labelText = @"”Some Problem to deleted the track”";
            hud.margin = 10.f;
            if(isPhone480) {
                hud.yOffset = 150.f;
            }else{
                hud.yOffset = 200.f;
            }
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [popview dismiss];

}

-(void)viewDidLayoutSubviews
{
    if ([self.trackstbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.trackstbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.trackstbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.trackstbl setLayoutMargins:UIEdgeInsetsZero];
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
-(void)addsongqueue:(NSIndexPath *)indexpath
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    NSMutableDictionary *songsDict = [[NSMutableDictionary alloc] init];
    NSString *trackTitleVal = [[[trackdata objectAtIndex:indexpath.row] valueForKey:@"name"] stringByAppendingString:[NSString stringWithFormat:@"###$$%@", timeStampObj]];
    
        [songsDict setValue:trackTitleVal forKey:@"title"] ;
        [songsDict setValue:[[trackdata objectAtIndex:indexpath.row] valueForKey:@"image"] forKey:@"thumburl"] ;
        [songsDict setValue:[[trackdata objectAtIndex:indexpath.row] valueForKey:@"url"] forKey:@"url"] ;
        [songsDict setValue:[[trackdata objectAtIndex:indexpath.row] valueForKey:@"description"] forKey:@"subtitle"] ;
        [songsDict setValue:[[trackdata objectAtIndex:indexpath.row] valueForKey:@"type"] forKey:@"musictype"];

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
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionTransitionFlipFromRight         //UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             [_swipeview setFrame:CGRectMake(240.0f, 74.0f, 114.0f, 35.0f)];
                         }
                         completion:nil];
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionTransitionFlipFromLeft         //UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             [_swipeview setFrame:CGRectMake(305.0f, 74.0f, 114.0f, 35.0f)];
                         }
                         completion:nil];
    }
}

@end
