//
//  Locations.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beacons, PointOfInterests;

@interface Locations : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) Beacons *beacon;
@property (nonatomic, retain) PointOfInterests *pointOfInterest;
@property (nonatomic, retain) NSManagedObject *polygon;

@end
