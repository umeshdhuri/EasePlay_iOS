//
//  PlayListViewController.h
//  EasePlay
//
//  Created by AppKnetics on 17/03/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SWTableViewCell.h"


@interface PlayListViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIWebViewDelegate, UINavigationControllerDelegate,SWTableViewCellDelegate> {
    UITextField *currentTxt ;
}


@property (weak, nonatomic) IBOutlet UIButton *addplaylstbtn;
@property (weak, nonatomic) IBOutlet UITableView *songlisttbl;
@property(nonatomic,retain)UIImage *thumbimage;
@property (weak, nonatomic) IBOutlet UILabel *noplaylistlbl;




- (IBAction)addplaylistclk:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addplaylistbtn3;

@end
