//
//  SettingViewController.m
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import "SettingViewController.h"
#import "EditProfileViewController.h"
#import "EditPasswordViewController.h"
#import "SearchSongsViewController.h"

@interface SettingViewController ()
{
    NSUserDefaults *user;
}

@end

@implementation SettingViewController

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
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutclk:(id)sender {
    
    NSLog(@"user=%@",[user valueForKey:@"status_flag"]);
    
    user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"Password"];
    [user removeObjectForKey:@"uid"];
    [user removeObjectForKey:@"email"];
    [user removeObjectForKey:@"firstname"];
    [user removeObjectForKey:@"lastname"];
    [user removeObjectForKey:@"status_flag"];
    NSLog(@"user=%@",[user valueForKey:@"status_flag"]);

    self.tabBarController.selectedIndex = 2;
    
    

}

- (IBAction)editacntclk:(id)sender {
    
    EditProfileViewController *editview=[[EditProfileViewController alloc]init];
    [self.navigationController pushViewController:editview animated:YES];
}

- (IBAction)changepasswrdclk:(id)sender {
    EditPasswordViewController *editPassview=[[EditPasswordViewController alloc]init];
    [self.navigationController pushViewController:editPassview animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{

}

@end
