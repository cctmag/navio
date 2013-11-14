//
//  Beacons.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Beacons : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSManagedObject *location;
@property (nonatomic, retain) NSManagedObject *subArea;

@end
