//
//  SubAreas.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Areas, Beacons, PointOfInterests, Polygons;

@interface SubAreas : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Areas *area;
@property (nonatomic, retain) NSSet *beacons;
@property (nonatomic, retain) NSSet *pointOfInterests;
@property (nonatomic, retain) Polygons *polygon;
@end

@interface SubAreas (CoreDataGeneratedAccessors)

- (void)addBeaconsObject:(Beacons *)value;
- (void)removeBeaconsObject:(Beacons *)value;
- (void)addBeacons:(NSSet *)values;
- (void)removeBeacons:(NSSet *)values;

- (void)addPointOfInterestsObject:(PointOfInterests *)value;
- (void)removePointOfInterestsObject:(PointOfInterests *)value;
- (void)addPointOfInterests:(NSSet *)values;
- (void)removePointOfInterests:(NSSet *)values;

@end
