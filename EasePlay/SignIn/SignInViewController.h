//
//  SignInViewController.h
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate> {
    UITextField *currentTxt ;
}


@property (weak, nonatomic) IBOutlet UIButton *signinfbbtn;
@property (weak, nonatomic) IBOutlet UIButton *signinbtn;
@property (weak, nonatomic) IBOutlet UIButton *signupbtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetpassbtn;


@property (weak, nonatomic) IBOutlet UITextField *unameemailtf;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UIButton *arrowbtn;



- (IBAction)signfbclk:(id)sender;
- (IBAction)signinclk:(id)sender;
- (IBAction)signupclk:(id)sender;
- (IBAction)forgtpassclk:(id)sender;
- (IBAction)arrowbtnclk:(id)sender;




@end
