//
//  EditProfileViewController.h
//  EasePlay
//
//  Created by AppKnetics on 31/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"



@interface EditProfileViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fnamef;

@property (weak, nonatomic) IBOutlet UITextField *lastnmtf;

@property (weak, nonatomic) IBOutlet UITextField *emailtf;


@property (weak, nonatomic) IBOutlet UIButton *savebtn;

- (IBAction)savebtnclk:(id)sender;



@end
