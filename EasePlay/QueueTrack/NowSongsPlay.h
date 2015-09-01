//
//  NowSongsPlay.h
//  EasePlay
//
//  Created by Umesh Dhuri on 4/19/15.
//  Copyright (c) 2015 AppKnetics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowSongsPlay : NSObject

@property (nonatomic, strong) NSString *musicTypeVal;
@property (nonatomic, strong) NSString *thumbVal;
@property (nonatomic, strong) NSString *musicURLVal;
@property (nonatomic, strong) NSString *descriptionVal;
@property (nonatomic, readwrite) NSNumber *indexVal;
@property (nonatomic, strong) NSString *titleVal ;
@end
