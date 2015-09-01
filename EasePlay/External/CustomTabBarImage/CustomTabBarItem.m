//
//  CustomTabBarItem.m
//  NEW
//
//  Created by iphone on 31/07/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem  

@synthesize customHighlightedImage;  
@synthesize customNormalImage;  

- (id)initWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage tag:(NSInteger)tag
{
    self = [super init];
   // [self initWithTitle:title image:nil tag:tag];
    [self setCustomNormalImage:normalImage];
    [self setCustomHighlightedImage:highlightedImage];
    //[self setImageInsets:UIEdgeInsetsMake(8, 0, -5, 0)];
    //[self setImageInsets:UIEdgeInsetsMake(8, 0, -5, 0)];
    return self;
}

- (void) dealloc  
{  
    //[customHighlightedImage release];
    customHighlightedImage=nil;  
    //[customNormalImage release];
    customNormalImage=nil;  
    //[super dealloc];
}  
-(UIImage *) selectedImage  
{  
    return self.customHighlightedImage;  
}  

-(UIImage *) unselectedImage  
{  
    return self.customNormalImage;  
}  

@end  
