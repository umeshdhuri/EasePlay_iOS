//
//  PlayListViewController.m
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "PlayListViewController.h"
#import "PlayListTableViewCell.h"
#import "NAPopoverView.h"
#import "Constant.h"
#import "Global.h"
#import "TrackListViewController.h"
#import "SignInViewController.h"
#import "SWTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface PlayListViewController ()
{
    NAPopoverView *popView;
    NAPopoverView *popView1;
      NAPopoverView *popView2;
    UIButton * imagebtn;
    UITextField *playlisttextField;
    UIImagePickerController *pickerController;
    UIButton *okbtn;
    UIButton *Cancelbtn;
    NSMutableArray *data;
    NSData *imageData;
    NSString *imagedata;
    NSUserDefaults *user;
    UIView *editview;
    NSString *imagepassing;
    AVPlayer *avPlayer;
    AVPlayerLayer *avPlayerLayer;
    
    UIWebView *videoView;
}
@end

@implementation PlayListViewController

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
        CGRect tableFrame = self.songlisttbl.frame ;
        tableFrame.size.height = self.songlisttbl.frame.size.height - 70 ;
        self.songlisttbl.frame = tableFrame ;
        
    }
    
    _songlisttbl.backgroundColor=[UIColor clearColor];
     _songlisttbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
     user=[NSUserDefaults standardUserDefaults];
    
    [_noplaylistlbl setHidden:NO];
    [_songlisttbl setHidden:YES];
    
    
  // UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    //tap.numberOfTapsRequired=1;
    
  // [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)fetchPlaylist
{
    NSLog(@"value=%@",[user valueForKey:@"uid"]);
    data=[[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString =[kBaseURL stringByAppendingString:klistplaylist];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"User id === %@", [user valueForKey:@"uid"]);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",nil];
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if(![[responseObject valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
            data=[responseObject valueForKey:@"data"];
        }
        
         NSLog(@"response=%@",data);
        
        if (data.count>0) {
            [_noplaylistlbl setHidden:YES];
            [_songlisttbl setHidden:NO];
            [_songlisttbl reloadData];
        }else{
            [_noplaylistlbl setHidden:NO];
            [_songlisttbl setHidden:YES];
        }
        

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
-(void)tapped:(id)seneder
{
    [playlisttextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [editview removeFromSuperview] ;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    self.songlisttbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self fetchPlaylist];
   
}
- (IBAction)addplaylistclk:(id)sender {
    popView=[[NAPopoverView alloc] init];
    [popView setFrame:CGRectMake(10,180,300, 170)];
    popView.center=self.view.center;
    popView.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];

    popView.layer.borderColor = [UIColor blackColor].CGColor;
    popView.layer.cornerRadius = 0.0;
    popView.layer.borderWidth = 1.0;
    
   imagebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [imagebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [imagebtn addTarget:self action:@selector(btnimagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [imagebtn setBackgroundColor:[UIColor clearColor]];
    imagebtn.layer.cornerRadius=0.0;
    imagebtn.layer.masksToBounds=YES;
    imagebtn.layer.borderWidth= 1.0f;
    imagebtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [imagebtn setFrame:CGRectMake(5,30,70,70)];
    [imagebtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [imagebtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, 20)];
    [imagebtn setBackgroundImage:[UIImage imageNamed:@"easeplay_placeholder.png"] forState:UIControlStateNormal];
    
  playlisttextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 35, 210, 40)];
    playlisttextField.borderStyle = UITextBorderStyleRoundedRect;
    playlisttextField.font = [UIFont systemFontOfSize:15];
    playlisttextField.placeholder = @"Enter Playlist Name";
    playlisttextField.autocorrectionType = UITextAutocorrectionTypeNo;
    playlisttextField.keyboardType = UIKeyboardTypeDefault;
    playlisttextField.returnKeyType = UIReturnKeyDone;
    playlisttextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    playlisttextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    playlisttextField.backgroundColor=[UIColor whiteColor];

    
    okbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [okbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [okbtn setTitle:@"OK" forState:UIControlStateNormal];
    [okbtn addTarget:self action:@selector(Okpressed:) forControlEvents:UIControlEventTouchUpInside];
    [okbtn setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    
    
    
    [okbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okbtn.layer.cornerRadius=0.0;
    okbtn.layer.masksToBounds=YES;
    okbtn.layer.borderWidth= 1.0f;
    okbtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [okbtn setFrame:CGRectMake(10,115,135,40)];
    [okbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [okbtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,60)];
    
    
    Cancelbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [Cancelbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Cancelbtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [Cancelbtn addTarget:self action:@selector(Cancelpressed:) forControlEvents:UIControlEventTouchUpInside];
    [Cancelbtn setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0]];
    Cancelbtn.layer.cornerRadius=0.0;
    Cancelbtn.layer.masksToBounds=YES;
    Cancelbtn.layer.borderWidth= 1.0f;
    Cancelbtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [Cancelbtn setFrame:CGRectMake(153,115,135,40)];
    [Cancelbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [Cancelbtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,30)];
    [Cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    
    playlisttextField.delegate = self;
    
    [popView addSubview:Cancelbtn];
    [popView addSubview:okbtn];
    [popView addSubview:playlisttextField];
    [popView addSubview:imagebtn];
    [popView show];

}
-(void)dissmissclk:(id)sender
{
    [popView dismiss];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [playlisttextField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    currentTxt = textField ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
    
}
-(void)Cancelpressed:(id)sender
{
    [popView dismiss];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Playlist";
   /* PlayListTableViewCell *cell = (PlayListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName: @"PlayListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }*/
    PlayListTableViewCell *cell = (PlayListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //
   [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:40.0f spaceValue:10];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.playlisttitle.text=[[data objectAtIndex:indexPath.row] valueForKey:@"name"];
    //[cell.playlistimage startImageDownloadingWithUrl:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] placeHolder:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    
    [cell.playlistimage sd_setImageWithURL:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"easeplay_placeholder.png"]];
    
 //   UISwipeGestureRecognizer *recognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    //[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //[cell addGestureRecognizer:recognizer];

    NSString *str1=[[[data objectAtIndex:indexPath.row] valueForKeyPath:@"trackcount"] stringValue];
    NSString *str2=[str1 stringByAppendingString:@" songs"];
    
    cell.playlistdescrptn.text=str2;
    cell.backgroundColor=[UIColor clearColor];
    cell.separatorInset=UIEdgeInsetsMake(-20,0,0,0);
    _songlisttbl.separatorColor=[UIColor colorWithRed:78.0/255.0 green:100/255.0 blue:127/255.0 alpha:1.0];
    return cell;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"edit.png"]];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [_songlisttbl indexPathForCell:cell];
            NSLog(@"indexpath=%@",cellIndexPath);
            [self deleteplaylist:cellIndexPath];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            
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
   
    static NSString *cellIdentifier = @"Playlist";
    PlayListTableViewCell *cell = (PlayListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     NSLog(@"play;isttitle=%@",[cell.playlisttitle text]);
   user=[NSUserDefaults standardUserDefaults];
    [user setValue:[[data objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"Playlisttitle"];
    [user setValue:[[data objectAtIndex:indexPath.row] valueForKey:@"image"] forKey:@"playlistimage"];
    [user setValue:[[data objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"pid"];
    [user setValue:[[data objectAtIndex:indexPath.row] valueForKey:@"trackcount"] forKey:@"trackcount"];

    
    TrackListViewController *trackview=[[TrackListViewController alloc]init];
    [self.navigationController pushViewController:trackview animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)btnimagePressed:(id)sender
{
    NSLog(@"hi..");
    [popView dismiss];
    popView2=[[NAPopoverView alloc] init];
    [popView2 setFrame:CGRectMake(0,0,300, 99)];
    popView2.center=self.view.center;
    popView2.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0];
    
    popView2.layer.borderColor = [UIColor blackColor].CGColor;
    popView2.layer.cornerRadius = 0.0;
    popView2.layer.borderWidth = 1.0;
    
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
    
    [popView2 addSubview:btnCamera];
    [popView2 addSubview:btnGallery];
    [popView2 show];
    
    NSLog(@"hi..");
}
-(void)btnCameraPressed:(UIButton *)sender{
	
	NSLog(@"Camera button pressed .");
	
    if([UIImagePickerController	isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [popView2 dismiss];
        UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{}];
		
	}
}
- (void)imageUploadButtonClick:(id)sender
{
    [popView2 dismiss];
    pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.toolbarHidden = NO;
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
    [popView dismiss];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _thumbimage  =[info objectForKey:@"UIImagePickerControllerOriginalImage"] ;
    
    [imagebtn setBackgroundImage:_thumbimage forState:UIControlStateNormal];
    [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSLog(@"urlimage=%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]);
    [picker dismissViewControllerAnimated:NO completion:nil];

    imageData = UIImageJPEGRepresentation(_thumbimage, 0.5f) ;
    
   // imagedata=imageData;
    [popView addSubview:imagebtn];
    [popView addSubview:playlisttextField];
    [popView show];
    // NSLog(@"imageData === %@", imageData) ;
    
}
-(void)Okpressed:(id)sender
{
  if(imageData!=nil)
  {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        //NSLog(@"Success: %@", responseObject);
        NSDictionary *data1=[responseObject valueForKey:@"data"];
       NSString *imagename1=[data1 valueForKey:@"image"];
        
        //imagepassing=[@"http://118.139.163.225/easeplay/images/playlist/" stringByAppendingString:imagename1];
        imagepassing=[kimagedwnld stringByAppendingString:imagename1];
      //  NSLog(@"date=%@",imagepassing);

        if([[playlisttextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
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
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      imagepassing=@"";
      if([[playlisttextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
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
          
          [hud hide:YES afterDelay:1];
      }
      
  }

    
}

-(void) addPlayList:(NSString *)imageurl {
    NSString *playlistnm=nil;
    if (playlisttextField.text.length > 0) {
        playlistnm=playlisttextField.text;
    }
    else
    {
        playlistnm=@"";
    }
    
   
    NSString *URLString =[kBaseURL stringByAppendingString:kaddPlaylist];
    //creating playlist
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:playlistnm,@"Playlist[name]",[user valueForKey:@"uid"],@"Playlist[uid]",imageurl,@"Playlist[image]",nil];
  
    NSLog(@"params === %@", params) ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"JSON: %@", responseObject);
        
       // NSLog(@"response=%@",responseObject);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [popView dismiss];
        [self fetchPlaylist];
        [_songlisttbl reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)deleteplaylist:(NSIndexPath*)indexpath
{

    UIImage *unselect=[UIImage imageNamed:@"edit.png"];
    UIImage *select=[UIImage imageNamed:@"edit-hover.png"];
    NSLog(@"sender=%ld",(long)indexpath.row);
    //if([btn imageForState:UIControlStateNormal] ==select )
    //{
        //[btn setBackgroundImage:select forState:UIControlStateNormal];
    //}
    //else
   // {
        //[btn setBackgroundImage:select forState:UIControlStateNormal];

   // }
    
    int rowHeight = (indexpath.row * 70) ;
    NSLog(@"rowHeight === %d", rowHeight) ;
    
    if(rowHeight > 300) {
        rowHeight = 300 ;
    }
    
    editview=[[UIView alloc]init];
    [editview setFrame:CGRectMake(90,rowHeight, 190, 148)];
    
    
    
    editview.backgroundColor=[UIColor colorWithRed:1.0/255.0 green:105.0/255.0 blue:178.0/255.0 alpha:1.0];
    
    UIButton * Renameplaylist=[UIButton buttonWithType:UIButtonTypeCustom];
    [Renameplaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Renameplaylist setTitle:@"Rename PlayList" forState:UIControlStateNormal];
    [Renameplaylist addTarget:self action:@selector(Renameplaylistpressed:) forControlEvents:UIControlEventTouchUpInside];
    [Renameplaylist setBackgroundColor:[UIColor whiteColor]];
    Renameplaylist.layer.cornerRadius=0.0;
    Renameplaylist.layer.masksToBounds=YES;
    Renameplaylist.layer.borderWidth= 1.0f;
    Renameplaylist.layer.borderColor = [[UIColor grayColor] CGColor];
    [Renameplaylist setFrame:CGRectMake(10,0,editview.bounds.size.width,75)];
    [Renameplaylist setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [Renameplaylist setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, 10)];
    [Renameplaylist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Renameplaylist.backgroundColor=[UIColor whiteColor];
    //Renameplaylist.tag=[sender tag];
    Renameplaylist.tag=indexpath.row;
    
    
    UIButton * Deleteplst=[UIButton buttonWithType:UIButtonTypeCustom];
    [Deleteplst setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Deleteplst setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [Deleteplst setBackgroundColor:[UIColor whiteColor]];
    [Deleteplst setTitle:@"Delete Playlist" forState:UIControlStateNormal];
    [Deleteplst addTarget:self action:@selector(Deleteplaylistclk:) forControlEvents:UIControlEventTouchUpInside];
    [Deleteplst setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    Deleteplst.layer.cornerRadius=0.0f;
    Deleteplst.layer.masksToBounds=YES;
    Deleteplst.layer.borderWidth= 1.0f;
    Deleteplst.layer.borderColor = [[UIColor grayColor] CGColor];
    [Deleteplst setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, 10)];
    //Deleteplst.tag=[sender tag];
    Deleteplst.tag=indexpath.row;
    
    
    [Deleteplst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Deleteplst.backgroundColor=[UIColor whiteColor];
    
    UIButton * Cancelbtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [Cancelbtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Cancelbtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [Cancelbtn1 setBackgroundColor:[UIColor whiteColor]];
    [Cancelbtn1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [Cancelbtn1 addTarget:self action:@selector(Cancelclked:) forControlEvents:UIControlEventTouchUpInside];
    [Cancelbtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    Cancelbtn1.layer.cornerRadius=0.0f;
    Cancelbtn1.layer.masksToBounds=YES;
    Cancelbtn1.layer.borderWidth= 1.0f;
    Cancelbtn1.layer.borderColor = [[UIColor grayColor] CGColor];
    [Cancelbtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, 10)];
    [Cancelbtn1 setFrame:CGRectMake(0,0,editview.bounds.size.width,50)];
    [Cancelbtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cancelbtn1.backgroundColor=[UIColor whiteColor];
    
    
    [Renameplaylist setFrame:CGRectMake(0,0,editview.bounds.size.width,50)];
    [Deleteplst setFrame:CGRectMake(0,49,editview.bounds.size.width,50)];
    [Cancelbtn1 setFrame:CGRectMake(0,98,editview.bounds.size.width,50)];
    
       [editview addSubview:Renameplaylist];
    [editview addSubview:Deleteplst];
    [editview addSubview:Cancelbtn1];
    [self.view addSubview:editview];

}
-(void)Cancelclked:(id)sender
{
    [_songlisttbl reloadData];
    [editview removeFromSuperview];
}
-(void)Renameplaylistpressed:(id)sender
{
    
    user=[NSUserDefaults standardUserDefaults];
    [user setValue:[[data objectAtIndex:[sender tag]] valueForKey:@"name"] forKey:@"Playlisttitle"];
    [user setValue:[[data objectAtIndex:[sender tag]] valueForKey:@"image"] forKey:@"playlistimage"];
    [user setValue:[[data objectAtIndex:[sender tag]] valueForKey:@"id"] forKey:@"pid"];
    

    
    
    
    TrackListViewController *trackview=[[TrackListViewController alloc]init];
    [self.navigationController pushViewController:trackview animated:YES];
    NSLog(@"tag=%ld",(long)[sender tag]);
    [editview removeFromSuperview];
    [popView dismiss];

}
-(void)Deleteplaylistclk:(id)sender
{
  
    popView=[[NAPopoverView alloc] init];
    [popView setFrame:CGRectMake(0,0,250, 130)];
    popView.center=self.view.center;
    popView.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:36.0/255.0 blue:75.0/255.0 alpha:1.0];
    
    popView.layer.borderColor = [UIColor blackColor].CGColor;
    popView.layer.cornerRadius = 0.0;
    popView.layer.borderWidth = 1.0;
   
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,-6,220,90)];
    fromLabel.numberOfLines = 3;
    NSString *string1=@"Are you sure you want to delete the playlist?";
    fromLabel.text=string1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.adjustsLetterSpacingToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    [fromLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    fromLabel.clipsToBounds = YES;
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
    
    [Yesbtn setFrame:CGRectMake(10,70,110,35)];
     [Nobtn setFrame:CGRectMake(130,70,110,35)];
   
    [editview removeFromSuperview];
    [popView addSubview:fromLabel];
    [popView addSubview:Yesbtn];
    [popView addSubview:Nobtn];
    [popView show];

}
-(void)Cutclicked:(id)sender
{
    [popView dismiss];
}
-(void)Cancelclk:(id)sender
{
    [_songlisttbl reloadData];
    [popView dismiss];
}
-(void)Yesclick:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     NSString *URLString =[kBaseURL stringByAppendingString:kdeleteplaylist];
    NSLog(@"sender tag=%ld",(long)[sender tag]);
    
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[user valueForKey:@"uid"],@"uid",[[data objectAtIndex:[sender tag]] valueForKey:@"id"],@"pid",nil];
     //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     
     
     [manager GET:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     
         if([responseObject isKindOfClass:[NSDictionary class]]) {
             
             if([responseObject valueForKey:@"status"]) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = @"”PlayList deleted successfully.”";
                 hud.margin = 10.f;
                 hud.yOffset = 200.f;
                 hud.removeFromSuperViewOnHide = YES;
                 
                 [hud hide:YES afterDelay:2];
                
                 [self fetchPlaylist];
                 [_songlisttbl reloadData];
                 [popView dismiss];
                 [popView1 dismiss];
                 [popView2 dismiss];
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
                 [popView dismiss];
                 [popView1 dismiss];
                 [popView2 dismiss];
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
             [popView dismiss];
             [popView1 dismiss];
             [popView2 dismiss];
         }
         
     
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];
     
     
    
}
/*
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"hi");
    //Get location of the swip
    static NSString *cellIdentifier = @"Playlist";
    PlayListTableViewCell *cell = (PlayListTableViewCell *)[_songlisttbl dequeueReusableCellWithIdentifier:cellIdentifier];
    CGRect frame=cell.deletplaylistbtn.frame;
    frame.origin.x=222;
    cell.deletplaylistbtn.frame=frame;
    [self.songlisttbl reloadData];
    }*/
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *section = (NSMutableArray *)[data objectAtIndex:fromIndexPath.section];
    id object = [section objectAtIndex:fromIndexPath.row];
    [section removeObjectAtIndex:fromIndexPath.row];
    
    NSMutableArray *newSection = (NSMutableArray *)[data objectAtIndex:toIndexPath.section];
    [newSection insertObject:object atIndex:toIndexPath.row];
}

-(void)viewDidLayoutSubviews
{
    if ([self.songlisttbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.songlisttbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.songlisttbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.songlisttbl setLayoutMargins:UIEdgeInsetsZero];
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

@end
