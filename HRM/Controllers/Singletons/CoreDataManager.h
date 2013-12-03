//
//  CoreDataManager.h
//  heartrate
//
//  Created by Jonathan Grana on 12/2/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

SHARED_SINGLETON_HEADER(CoreDataManager);

@property (nonatomic, readonly) NSManagedObjectContext          *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel            *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
