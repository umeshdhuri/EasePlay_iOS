//
//  EditPasswordViewController.h
//  EasePlay
//
//  Created by AppKnetics on 31/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"



@interface EditPasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldpasswrdtf;

@property (weak, nonatomic) IBOutlet UITextField *newpswrd;

@property (weak, nonatomic) IBOutlet UITextField *confrmpswrd;


- (IBAction)saveclk:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *savebtn;

@end
