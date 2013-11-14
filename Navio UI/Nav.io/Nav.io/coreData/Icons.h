//
//  Icons.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PointOfInterests;

@interface Icons : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *area;
@property (nonatomic, retain) PointOfInterests *pointOfInterest;

@end
