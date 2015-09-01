//
//  DatabaseController.m
//  Mishu
//
//  Created by AppKnetics on 10/06/14.
//  Copyright (c) 2014 Needy. All rights reserved.
//

#import "DatabaseController.h"
#import "Song.h"

@implementation DatabaseController

#pragma mark -
#pragma mark NSFatchRequest with entity name

+ (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName {
    return [[NSFetchRequest alloc] initWithEntityName:entityName];
}


+ (BOOL)insertSongs:(NSDictionary *)userInfo {
    NSLog(@"userInfo === %@", userInfo) ;
    BOOL returnStr = NO;
    NSError *error;
    if([[[userInfo objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [[[userInfo objectForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            Song *notiObj = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:appDelegate.managedObjectContext];
            if(![self checkSongsExits:[userInfo objectForKey:@"title"] url:[userInfo objectForKey:@"url"]]) {
                notiObj.musictype = [userInfo objectForKey:@"musictype"];
                notiObj.subtitle = [userInfo objectForKey:@"subtitle"] ;
                notiObj.thumburl = [userInfo objectForKey:@"thumburl"];
                notiObj.title = [userInfo objectForKey:@"title"];
                notiObj.url = [userInfo objectForKey:@"url"];
                //notiObj.ordernumber = @([self checkSongsCount] + 1);
                
                NSArray *songsList = [DatabaseController getSongsData] ;
                Song *songObj = [songsList lastObject];
                NSNumber *sum = @([songObj.ordernumber integerValue] + 1);
                notiObj.ordernumber = sum;
                
                if (![context save:&error]) {
                    returnStr = NO;
                }else{
                    returnStr = YES;
                }
            }
    }
    
    
    return returnStr ;
}

+ (NSArray *)getSongsData {
 
    NSArray *userNotificationData = [[NSArray alloc] init];
    
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:@"Song"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ordernumber" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    userNotificationData = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return userNotificationData ;
    
}

+ (NSArray *)getSongsSelectedData:(NSString *) titleVal urlVal:(NSString *)urlValue {
    
    NSArray *userNotificationData = [[NSArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@ and url = %@", titleVal, urlValue];
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:@"Song"];
    [fetchRequest setPredicate:predicate];
    
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ordernumber" ascending:YES];
    //[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    userNotificationData = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return userNotificationData ;
    
}

+ (int)checkSongsCount {
    //Get User count based on GUID
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guID LIKE %@", guID];
    NSFetchRequest *request = [self fetchRequestWithEntityName:@"Song"];
    //[request setPredicate:predicate];
    
    NSError *err;
    NSUInteger count = [appDelegate.managedObjectContext countForFetchRequest:request error:&err];
    
    return count ;
    
}

+ (BOOL)checkSongsExits:(NSString *)title url:(NSString *) songurl {
    //Get User count based on GUID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@ and url = %@", title, songurl];
    NSFetchRequest *request = [self fetchRequestWithEntityName:@"Song"];
    [request setPredicate:predicate];
    
    NSError *err;
    NSUInteger count = [appDelegate.managedObjectContext countForFetchRequest:request error:&err];
    
    if(count > 0) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (NSArray *)getTrackData:(NSString *)orderNumber {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ordernumber = %@", orderNumber];
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:@"Song"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchRow = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchRow;
    
}

+(BOOL) updateOrderData:(NSString *) from orderId:(NSString *) toval {
    BOOL returnStr ;
    
    NSLog(@"from == %@", from);
    NSLog(@"toval == %@", toval);
    NSError *error;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSArray *dataVal = [self getSongsData];
    //From Record
    
    Song *fromnotiObj = [dataVal objectAtIndex:[from integerValue]];
    fromnotiObj.ordernumber = [NSNumber numberWithInt:[toval integerValue]+1] ;
    
    if (![context save:&error]) {
        returnStr = NO;
    }else{
        returnStr = YES;
    }
    NSArray *dataVal1 = [self getSongsData];
    return returnStr ;
}

+(BOOL) updateOrderDataValue:(NSString *) titleVal orderId:(NSString *) URLVal orderVal:(int) orderValue {
    BOOL returnStr ;
    
    NSLog(@"from == %@", titleVal);
    NSLog(@"toval == %@", URLVal);
     NSLog(@"orderVal == %d", orderValue);
    NSError *error;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSArray *dataVal = [self getSongsSelectedData:titleVal urlVal:URLVal];
    //From Record
    Song *songsObj = [dataVal objectAtIndex:0] ;
    songsObj.ordernumber = [NSNumber numberWithInt:orderValue+1] ;
    
    if (![context save:&error]) {
        returnStr = NO;
    }else{
        returnStr = YES;
    }
    NSArray *dataVal1 = [self getSongsData];
    return returnStr ;
}


+(BOOL) updateOrderDataTest:(NSString *) from orderId:(NSString *) toval {
    BOOL returnStr ;
    
    NSLog(@"from == %@", from);
    NSLog(@"toval == %@", toval);
    NSError *error;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSArray *dataVal = [self getSongsData];
    //From Record
    
    Song *tonotiObj = [dataVal objectAtIndex:[from integerValue]];
    tonotiObj.ordernumber = [NSNumber numberWithInt:[toval integerValue]+1] ;
    
    
    if (![context save:&error]) {
        returnStr = NO;
    }else{
        returnStr = YES;
    }
    NSArray *dataVal12 = [self getSongsData];
    return returnStr ;
}

+(BOOL) deletePlayTrackVal:(NSString *) title urlVal:(NSString *) url {
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"title = %@ and url = %@", title, url];
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:@"Song"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [appDelegate.managedObjectContext deleteObject:managedObject];
        [appDelegate.managedObjectContext save:&error];
    }
    return YES ;
}


@end
