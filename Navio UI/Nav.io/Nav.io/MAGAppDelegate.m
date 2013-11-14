//
//  MAGAppDelegate.m
//  Nav.io
//
//  Created by Jesse Allison on 9/20/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "coreData/Areas.h"

@implementation MAGAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

NSManagedObjectContext *context;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyCIC3n26wbW9iPS6wYyAZ0WbrXsIPWv4tQ"];
    
    // [self loadFakeData];
    // [self readData];
    
    [self loadBuildings:@"DMC_Resource_Data"];
    [self readData];
    
    return YES;
}

- (void)loadBuildings:(NSString *)buildingPath
{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:buildingPath ofType:@"json"];
    NSArray* buildings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                     options:kNilOptions
                                                       error:&err];
    NSLog(@"Imported Banks: %@", buildings);
    
    context = [self managedObjectContext];
    
    NSManagedObject *building = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Buildings"
                                    inManagedObjectContext:context];
    
    for (NSString *str in @[@"name", @"uuid", @"version"]) {
        [building setValue:[buildings valueForKey:str] forKey:str];
    }
    NSMutableSet *areas = [[NSMutableSet alloc] init];
    for (Areas *area in [buildings valueForKey:@"areas"]) {
        NSManagedObject *newArea = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Areas"
                                    inManagedObjectContext:context];
        for (NSString *str in @[@"roomNumber", @"floor", @"name", @"information"]) {
            [newArea setValue:[area valueForKey:str] forKey:str];
        }
        [areas addObject:newArea];
    }
    
    [building setValue:areas forKey:@"areas"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

- (void)loadFakeData
{
    context = [self managedObjectContext];
    
    NSManagedObject *buildingOne = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Buildings"
                                       inManagedObjectContext:context];
    [buildingOne setValue:@"Digital Media Center" forKey:@"name"];
    [buildingOne setValue:@"E36397B6-C4FC-4D90-A044-6A35606F8D0D" forKey:@"uuid"];
    
    NSManagedObject *area1034 = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Areas"
                                          inManagedObjectContext:context];
    [area1034 setValue:@1 forKey:@"floor"];
    [area1034 setValue:@"The classroom where MAG works" forKey:@"information"];
    [area1034 setValue:@"DMC 1034" forKey:@"name"];
    [area1034 setValue:@1034 forKey:@"roomNumber"];
    [area1034 setValue:buildingOne forKey:@"building"];
    NSSet *areasForBuilding = [[NSSet alloc] initWithObjects:area1034, nil];
    
    [buildingOne setValue:areasForBuilding forKey:@"areas"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)readData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Buildings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *building in fetchedObjects) {
        NSLog(@"Name: %@", [building valueForKey:@"name"]);
        NSSet *areas = [building valueForKey:@"areas"];
        for(Areas *area in areas)
        {
            NSLog(@"area: %@", area);
            //NSLog(@"roomNumber: %@", [area valueForKey:@"roomNumber"]);
        }
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"navio" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"navio.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
