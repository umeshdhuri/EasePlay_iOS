//
//  DatabaseController.h
//  Mishu
//
//  Created by AppKnetics on 10/06/14.
//  Copyright (c) 2014 Needy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseController : NSObject

/**
 FetchRequestWithEntityName
 @param entityName pass EntityName
 @returns return NSFetchRequest object
 */
+ (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName ;

/**
 Insert User Information in UserInfo Table
 @returns result in BOOL value
 */
+ (BOOL)insertSongs:(NSDictionary *)userInfo ;

/**
 Get Book Information Data
 @param bookID Book ID
 @param GUID User GUID
 @returns book information array
 */
+ (NSArray *)getSongsData ;

+ (int)checkSongsCount  ;

+ (BOOL)checkSongsExits:(NSString *)title url:(NSString *) songurl ;

+ (NSArray *)getTrackData:(NSString *)orderNumber ;

+(BOOL) updateOrderData:(NSString *) from orderId:(NSString *) toval ;

+(BOOL) updateOrderDataTest:(NSString *) from orderId:(NSString *) toval ;

+(BOOL) deletePlayTrackVal:(NSString *) title urlVal:(NSString *) url ;

+(BOOL) updateOrderDataValue:(NSString *) titleVal orderId:(NSString *) URLVal orderVal:(int) orderValue ;

+ (NSArray *)getSongsSelectedData:(NSString *) titleVal urlVal:(NSString *)urlValue ;
@end
