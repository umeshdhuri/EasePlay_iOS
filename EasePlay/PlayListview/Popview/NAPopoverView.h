//
//  NAPopoverView.h
//  Needy
//
//  Created by parami on 07/03/14.
//  Copyright (c) 2014 Needy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAPopoverView : UIView
{
   UIControl   *_overlayView;
}

- (void)show;
- (void)dismiss;

@end
