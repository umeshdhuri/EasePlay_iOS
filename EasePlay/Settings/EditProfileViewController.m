//
//  EditProfileViewController.m
//  EasePlay
//
//  Created by AppKnetics on 31/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Constant.h"
#import "Global.h"


@interface EditProfileViewController ()
{
    NSUserDefaults *user;
}

@end

@implementation EditProfileViewController

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
    _emailtf.text=[user valueForKey:@"email"];
    _fnamef.text=[user valueForKey:@"firstname"];
    _lastnmtf.text=[user valueForKey:@"lastname"];
    
    
    [_emailtf.layer setBorderWidth:0];
    _emailtf.layer.cornerRadius = 5;
    _emailtf.clipsToBounds = YES;
    _emailtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [_fnamef.layer setBorderWidth:0];
    _fnamef.layer.cornerRadius = 5;
    _fnamef.clipsToBounds = YES;
    
    [_lastnmtf.layer setBorderWidth:0];
    _lastnmtf.layer.cornerRadius = 5;
    _lastnmtf.clipsToBounds = YES;

    

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)tapped:(id)sender
{
    [_emailtf resignFirstResponder];
    [_fnamef resignFirstResponder];
    [_lastnmtf resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)savebtnclk:(id)sender {
    
    NSString *emailReg = @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if(!(_fnamef.text.length >= 1))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter firstname." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(!(_lastnmtf.text.length >= 1))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter lastname." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else if(!(_emailtf.text.length >= 1))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else if ([emailTest evaluateWithObject:_emailtf.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *URLString =[kBaseURL stringByAppendingString:kupdateprofile];
        //NSString *URLString=@"http://118.139.163.225/easeplay/api/updateprofile";
        NSLog(@"URL=%@",URLString);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_fnamef.text,@"User[firstname]",_lastnmtf.text,@"User[lastname]",_emailtf.text, @"User[email]",[user valueForKey:@"uid"],@"User[uid]", nil];
        NSLog(@"parmeters=%@",params);
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSLog(@"response=%@",responseObject);
            NSLog(@"data === %@", [responseObject valueForKey:@"status"]) ;
            if([[responseObject valueForKey:@"status"] boolValue]) {
                [user setValue:_emailtf.text forKey:@"email"];
                [user setValue:_fnamef.text forKey:@"firstname"];
                [user setValue:_lastnmtf.text forKey:@"lastname"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:AppName message:@"Email address already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [errMsg show] ;
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }
    
   
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
