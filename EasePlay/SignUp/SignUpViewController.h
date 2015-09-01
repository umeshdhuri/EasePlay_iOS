//
//  SignUpViewController.h
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate> {
    UITextField *currentTxt ;
}

@property (weak, nonatomic) IBOutlet UITextField *fullnmtf;
@property (weak, nonatomic) IBOutlet UITextField *usernmtf;
@property (weak, nonatomic) IBOutlet UITextField *passwrdtf;
@property (weak, nonatomic) IBOutlet UITextField *emailtf;

@property (weak, nonatomic) IBOutlet UITextField *confrmpasstf;
@property (weak, nonatomic) IBOutlet UITextField *confrmemailtf;

@property (weak, nonatomic) IBOutlet UIButton *signupbtn;
@property (weak, nonatomic) IBOutlet UIButton *signinbtn;

- (IBAction)signinclk:(id)sender;
- (IBAction)signupclk:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *termsofcontnlbl;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollview1;
@end
