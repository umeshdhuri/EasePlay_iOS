//
//  SignUpViewController.m
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constant.h"
#import "Global.h"
#import "SignInViewController.h"

@interface SignUpViewController ()
{
    NSUserDefaults *user;
}

@end

@implementation SignUpViewController

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
        NSLog(@"innnn 3.5 inch") ;
        
         CGRect signupbtnframe = self.signupbtn.frame ;
        
        CGRect termslblframe=self.termsofcontnlbl.frame;
        termslblframe.origin.y=signupbtnframe.origin.y+110;
        self.termsofcontnlbl.frame=termslblframe;
        
    }
    

 user=[NSUserDefaults standardUserDefaults];
    if ([[user valueForKey:@"Userfrom"] isEqualToString:@"1"]) {
        _emailtf.text=[user valueForKey:@"useremailfromfb"];
    }
    
    [self.scrollview1 setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200)] ;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    self.emailtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signinclk:(id)sender {
}

- (IBAction)signupclk:(id)sender {
    
    [currentTxt resignFirstResponder] ;
    
    NSString *newpass=_passwrdtf.text;
    NSString *confrm=_confrmpasstf.text;
    NSString *emailReg = @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    
    if(!(_emailtf.text.length >= 1))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else if ([emailTest evaluateWithObject:_emailtf.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (!(_passwrdtf.text.length >= 1)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (!(_passwrdtf.text.length >= 6)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter password more than OR equles to 6 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![newpass isEqualToString: confrm])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Password and confirm password should be match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }    else
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *URLString =[kBaseURL stringByAppendingString:kRegisterURL];
        NSLog(@"URL=%@",URLString);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"User[firstname]",@"",@"User[lastname]",_emailtf.text, @"User[email]",_passwrdtf.text,@"User[password]",@"signup",@"User[type]", nil];
    NSLog(@"parmeters=%@",params);
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
           NSDictionary *data=[responseObject valueForKey:@"data"];
            NSString *status=[responseObject valueForKey:@"status"] ;
            
            if ([status intValue]==0) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([[data  valueForKey:@"message"] isEqualToString:@"Email address already exists."]) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Email address already exists. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    }
                else
                {
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Entered Email or password is incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            else
            {
                [user setValue:_passwrdtf.text forKeyPath:@"Password"];
                [user setValue:[data valueForKey:@"id"] forKey:@"uid"];
                [user setValue:[data valueForKey:@"email"] forKey:@"email"];
                [user setValue:[data valueForKey:@"firstname"] forKey:@"firstname"];
                [user setValue:[data valueForKey:@"lastname"] forKey:@"lastname"];
                [user setValue:@"1" forKey:@"status_flag"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                SignInViewController *signin=[[SignInViewController alloc]init];
                
                [signin dismissViewControllerAnimated:YES completion:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"”Signup Suucessfull”";
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
    
    
  /*  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString =@"https://accounts.google.com/o/oauth2/token";
    NSLog(@"URL=%@",URLString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"4/vk9I2DHQoaKUMMMq8QWhlqBunlXoiY4VfMdesFzW2UE.wkTyjV7ZKBUacp7tdiljKKbLcd5kmgI",@"code",@"412818729409-qs9fdpv007fj11t2piasfg3gdtuqk36n.apps.googleusercontent.com",@"client_id",@"7VZDzsWh7ogWRUM4q92HmSMv", @"client_secret",@"urn:ietf:wg:oauth:2.0:oob",@"redirect_uri",@"authorization_code",@"grant_type", nil];
    NSLog(@"parmeters=%@",params);
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *data=[responseObject valueForKey:@"data"];
        NSString *status=[responseObject valueForKey:@"status"] ;
        
        if ([status intValue]==0) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[data  valueForKey:@"message"] isEqualToString:@"Email address already exists."]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Email address already exists. Please try again." delegate:self cancelButtonTitle:OK otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Entered Email or password is incorrect." delegate:self cancelButtonTitle:OK otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            [user setValue:_passwrdtf.text forKeyPath:@"Password"];
            [user setValue:[data valueForKey:@"id"] forKey:@"uid"];
            [user setValue:[data valueForKey:@"email"] forKey:@"email"];
            [user setValue:[data valueForKey:@"firstname"] forKey:@"firstname"];
            [user setValue:[data valueForKey:@"lastname"] forKey:@"lastname"];
            [user setValue:@"1" forKey:@"status_flag"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            SignInViewController *signin=[[SignInViewController alloc]init];
            
            [signin dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"”Signup Suucessfull”";
            hud.margin = 10.f;
            hud.yOffset = 200.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

*/

}

-(IBAction)closeLoginView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    currentTxt = textField ;
}

-(void)tapview
{
    [_fullnmtf resignFirstResponder];
    [_passwrdtf resignFirstResponder];
    [_confrmemailtf resignFirstResponder];

    [_confrmpasstf resignFirstResponder];

    [_emailtf resignFirstResponder];

    [_usernmtf resignFirstResponder];

}
@end
