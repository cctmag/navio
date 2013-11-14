//
//  Areas.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Buildings, Icons;

@interface Areas : NSManagedObject

@property (nonatomic, retain) NSNumber * floor;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * roomNumber;
@property (nonatomic, retain) Buildings *building;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) Icons *icon;
@property (nonatomic, retain) NSManagedObject *polygon;
@property (nonatomic, retain) NSSet *subAreas;
@end

@interface Areas (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(NSManagedObject *)value;
- (void)removeCategoriesObject:(NSManagedObject *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addSubAreasObject:(NSManagedObject *)value;
- (void)removeSubAreasObject:(NSManagedObject *)value;
- (void)addSubAreas:(NSSet *)values;
- (void)removeSubAreas:(NSSet *)values;

@end
