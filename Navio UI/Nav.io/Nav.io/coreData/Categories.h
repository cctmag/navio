//
//  Categories.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Areas, PointOfInterests;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Areas *area;
@property (nonatomic, retain) PointOfInterests *pointofinterest;

@end
