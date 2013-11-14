//
//  PointOfInterests.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PointOfInterests : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSManagedObject *icon;
@property (nonatomic, retain) NSManagedObject *location;
@property (nonatomic, retain) NSManagedObject *subArea;
@end

@interface PointOfInterests (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(NSManagedObject *)value;
- (void)removeCategoriesObject:(NSManagedObject *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
