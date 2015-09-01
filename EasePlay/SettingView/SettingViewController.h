//
//  SettingViewController.h
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *editprflbtn;
@property (weak, nonatomic) IBOutlet UIButton *changpassbtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutbtn;








- (IBAction)logoutclk:(id)sender;
- (IBAction)editacntclk:(id)sender;
- (IBAction)changepasswrdclk:(id)sender;








@end
