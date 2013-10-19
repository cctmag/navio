//
//  MAGAppDelegate.h
//  Nav.io
//
//  Created by Jesse Allison on 9/20/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
