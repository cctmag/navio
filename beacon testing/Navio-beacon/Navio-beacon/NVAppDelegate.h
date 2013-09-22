//
//  NVAppDelegate.h
//  Navio-beacon
//
//  Created by Danny Holmes on 9/21/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
