//
//  CustomTabBarItem.h
//  NEW
//
//  Created by iphone on 31/07/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UITabBarItem {  
    UIImage *customHighlightedImage;  
    UIImage *customNormalImage;  
}  

@property (nonatomic, retain) UIImage *customHighlightedImage;  
@property (nonatomic, retain) UIImage *customNormalImage;  

- (id)initWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage tag:(NSInteger)tag;
@end
