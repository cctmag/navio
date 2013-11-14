//
//  Buildings.h
//  Nav.io
//
//  Created by Jesse Allison on 11/1/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buildings : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *areas;
@end

@interface Buildings (CoreDataGeneratedAccessors)

- (void)addAreasObject:(NSManagedObject *)value;
- (void)removeAreasObject:(NSManagedObject *)value;
- (void)addAreas:(NSSet *)values;
- (void)removeAreas:(NSSet *)values;

@end
