//
//  Polygons.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Areas, Locations;

@interface Polygons : NSManagedObject

@property (nonatomic, retain) Areas *area;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSManagedObject *subArea;
@end

@interface Polygons (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Locations *)value;
- (void)removeLocationsObject:(Locations *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
