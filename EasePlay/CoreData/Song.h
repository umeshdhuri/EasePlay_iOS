//
//  Song.h
//  EasePlay
//
//  Created by Umesh Dhuri on 4/2/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * musictype;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * thumburl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, readwrite) NSNumber *ordernumber;

@end
