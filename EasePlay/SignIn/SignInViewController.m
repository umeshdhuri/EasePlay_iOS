//
//  SignInViewController.m
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "SignInViewController.h"
#import "SearchSongsViewController.h"
#import "SignUpViewController.h"
#import "Constant.h"
#import "Global.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SignInViewController ()
{
    UITextField *myTextField;
    NSUserDefaults *user;
      NSDictionary *params;
    NSDictionary *data;
}

@end

@implementation SignInViewController

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
    user=[NSUserDefaults standardUserDefaults];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    self.unameemailtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signfbclk:(id)sender {
    NSArray *permissions = [[NSArray alloc]initWithObjects:@"publish_actions",@"publish_stream",@"user_status",@"public_profile",@"user_photos",@"user_videos",@"email", nil];
    FBSession *session = [[FBSession alloc] initWithAppID:FacebookId permissions:permissions defaultAudience:FBSessionDefaultAudienceNone urlSchemeSuffix:nil tokenCacheStrategy:nil];
    [FBSession setActiveSession: session];
    [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        switch (status) {
            case FBSessionStateOpen:
                // call the legacy session delegate
                //Now the session is open do corresponding UI changes
                DLog(@"Login Successfully");
                [self FBCheck] ;
                
                break;
            case FBSessionStateClosedLoginFailed:
            {
                NSLog(@"FBSessionStateClosedLoginFailed") ;
            }
                break;
            default: {
                
                NSLog(@"default") ;
            }
                break;
        }
    }];
    
}
-(void) FBCheck
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                           NSDictionary<FBGraphUser> *fbuser,
                                                           NSError *error) {
        NSLog(@"user %@", fbuser);
        if (!error) {
            if (FBSession.activeSession.isOpen ) {
                [self CheckUser:fbuser];
            }
            else
            {
                if ([fbuser objectForKey:@"email"] != nil) {
                    NSLog(@"email %@",[fbuser objectForKey:@"email"]);
                }
                
            }
            
        }else
        {
            NSLog(@"Found Error === %@", error);
        }
    }];
}

-(void) CheckUser:(NSDictionary *)userData
{
    
    NSString *signinUrl = [kBaseURL stringByAppendingString:kLoginURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"emailsending=%@",[userData valueForKey:@"email"]);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:[userData valueForKey:@"email"],@"User[email]",@"1", @"User[sociallogin]",nil];
    NSLog(@"userdata=%@",[userData valueForKey:@"email"]);
    [manager POST:signinUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *status=[responseObject valueForKey:@"status"] ;
         data=[responseObject valueForKey:@"data"];
         NSLog(@"response=%@",responseObject);
         if ([status intValue]==1) {
             
             [user setValue:_passwordtf.text forKeyPath:@"Password"];
             [user setValue:[data valueForKey:@"id"] forKey:@"uid"];
             [user setValue:[data valueForKey:@"email"] forKey:@"email"];
             [user setValue:[data valueForKey:@"firstname"] forKey:@"firstname"];
             [user setValue:[data valueForKey:@"lastname"] forKey:@"lastname"];
             [user setValue:@"1" forKey:@"status_flag"];
             NSLog(@"user=%@",[user valueForKey:@"status_flag"]);
             [self dismissViewControllerAnimated:YES completion:nil];
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"”Login Successful”";
             hud.margin = 10.f;
             if(isPhone480) {
                 hud.yOffset = 150.f;
             }else{
                 hud.yOffset = 200.f;
             }
             hud.removeFromSuperViewOnHide = YES;
             
             [hud hide:YES afterDelay:2];
         }
         else if ([status intValue]==0)
         {
             NSLog(@"emailsending=%@",[userData valueForKey:@"email"]);
             [user setValue:[userData valueForKey:@"email"] forKey:@"useremailfromfb"];
             [user setValue:@"1" forKey:@"Userfrom"];
             SignUpViewController *signupview=[[SignUpViewController alloc]init];
             UIViewController* presentingViewController = self.presentingViewController;
             [self dismissViewControllerAnimated:NO completion:^{
                 [presentingViewController presentViewController:signupview animated:YES completion:nil];
             }];
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
    
    
}

- (IBAction)signinclk:(id)sender {
    [currentTxt resignFirstResponder] ;
    
    NSString *emailReg = @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if(!(_unameemailtf.text.length > 0))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([emailTest evaluateWithObject:_unameemailtf.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(!(_passwordtf.text.length > 0))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    /*else if (!(_passwordtf.text.length >= 6)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hi" message:@"Please enter password more than OR equles to 6 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }*/
    else
    {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         NSString *URLString =[kBaseURL stringByAppendingString:kLoginURL];
         NSLog(@"URL=%@",URLString);
      
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
        
            params = [NSDictionary dictionaryWithObjectsAndKeys:_unameemailtf.text,@"User[email]",_passwordtf.text,@"User[password]",@"0", @"User[sociallogin]",nil];
            NSLog(@"parmeters=%@",params);
       
       
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
        [manager POST:URLString  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
         NSString *status=[responseObject valueForKey:@"status"] ;
        
         NSLog(@"response=%@",responseObject);
         if ([status intValue]==0) {
               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:@"Entered email or password is incorrect. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
               [alert show];
            
            }
           else
          {
               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                data=[responseObject valueForKey:@"data"];
                NSLog(@"data=%@",data);
              
            
                [user setValue:_passwordtf.text forKeyPath:@"Password"];
                [user setValue:[data valueForKey:@"id"] forKey:@"uid"];
                [user setValue:[data valueForKey:@"email"] forKey:@"email"];
                 [user setValue:[data valueForKey:@"firstname"] forKey:@"firstname"];
                [user setValue:[data valueForKey:@"lastname"] forKey:@"lastname"];
                [user setValue:@"1" forKey:@"status_flag"];
                 NSLog(@"user=%@",[user valueForKey:@"status_flag"]);
            
                [self dismissViewControllerAnimated:YES completion:nil];

          }
        
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
        }];
    }

}

-(IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signupclk:(id)sender {
    
     /*[self dismissViewControllerAnimated:YES completion:nil];
   
    [self presentViewController:signupview animated:YES completion:nil];*/
    [user setValue:@"0" forKey:@"Userfrom"];
     SignUpViewController *signupview=[[SignUpViewController alloc]init];
    UIViewController* presentingViewController = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [presentingViewController presentViewController:signupview animated:YES completion:nil];
    }];

}

- (IBAction)forgtpassclk:(id)sender {
    /*UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Enter Your Email." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
   myTextField= [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    myAlertView.alertViewStyle=UIAlertViewStylePlainTextInput;
  //  myTextField=[myAlertView textFieldAtIndex:0];
    
    //[myTextField setBackgroundColor:[UIColor whiteColor]];
    //[myAlertView addSubview:myTextField];
    [myAlertView show];*/
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Forgot Your Password?"
                                                          message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    myAlertView.tag = 2;
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [myAlertView show];
    
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
    [_passwordtf resignFirstResponder];
        [_unameemailtf resignFirstResponder];
    
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        NSLog(@"hiiii");
        
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *emailReg = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
        
        myTextField = [alertView textFieldAtIndex:0] ;
        if ([emailTest evaluateWithObject:myTextField.text] == NO)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            NSString *forgetpassurl=[kBaseURL stringByAppendingString:kforgotpassword];
            NSDictionary *params1 = [NSDictionary dictionaryWithObjectsAndKeys:myTextField.text, @"User[email]",nil];
            NSLog(@"emailtest=%@",myTextField.text);
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager GET:forgetpassurl parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if ([[responseObject valueForKey:@"status"] intValue]==0) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Please enter correct email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }else if([[responseObject valueForKey:@"status"] intValue] == 1){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"New password has been sent on your email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:@"Process Fail please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                      NSLog(@"Error: %@", error);
                  }];
            
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
}

@end
