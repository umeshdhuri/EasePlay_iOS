//
//  EditPasswordViewController.m
//  EasePlay
//
//  Created by AppKnetics on 31/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "Constant.h"
#import "Global.h"


@interface EditPasswordViewController ()
{
    NSUserDefaults *user;
}

@end

@implementation EditPasswordViewController

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
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImage *titleImage = [UIImage imageNamed:@"top-navigation-logo.png"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
    
    UIImage *bkbuttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *abkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [abkButton setBackgroundImage:bkbuttonImage forState:UIControlStateNormal];
    abkButton.frame = CGRectMake(0.0, 0.0, bkbuttonImage.size.width, bkbuttonImage.size.height);
    UIBarButtonItem *aBackBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:abkButton];
    [abkButton addTarget:self action:@selector(backRedirect:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBackBarButtonItem];

    user=[NSUserDefaults standardUserDefaults];
    NSLog(@"password=%@",[user valueForKeyPath:@"Password"]);
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapp:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    [_newpswrd.layer setBorderWidth:0];
    _newpswrd.layer.cornerRadius = 5;
    _newpswrd.clipsToBounds = YES;
    
    [_oldpasswrdtf.layer setBorderWidth:0];
    _oldpasswrdtf.layer.cornerRadius = 5;
    _oldpasswrdtf.clipsToBounds = YES;
    
    [_confrmpswrd.layer setBorderWidth:0];
    _confrmpswrd.layer.cornerRadius = 5;
    _confrmpswrd.clipsToBounds = YES;

    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveclk:(id)sender {
    NSString *newpass=_newpswrd.text;
    NSString *confrm=_confrmpswrd.text;
    NSLog(@"test=%@",newpass);
     NSLog(@"test=%@",confrm);
    
  if (![_oldpasswrdtf.text isEqualToString:[user valueForKeyPath:@"Password"]]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Old password is incorrect. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
                NSLog(@"hi...");
    }
   else if(!(_newpswrd.text.length >= 6))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Password length should be minimum six characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

    else if (![newpass isEqualToString: confrm])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"New password and confirm password should be match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         NSString *URLString =[kBaseURL stringByAppendingString:kchangepassword];
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         
         NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_newpswrd.text,@"User[new_password]",[user valueForKey:@"uid"],@"User[uid]", nil];
         [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         [user setValue:_newpswrd.text forKeyPath:@"Password"];
         NSLog(@"response=%@",responseObject);
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.navigationController popViewControllerAnimated:YES];
         
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         }];
        
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)tapp:(id)sender
{
    [_oldpasswrdtf resignFirstResponder];
    [_newpswrd resignFirstResponder];
    [_confrmpswrd resignFirstResponder];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4.0/255 green:36.0/255 blue:75.0/255 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourimage.png"]];
}
-(void)backRedirect:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
