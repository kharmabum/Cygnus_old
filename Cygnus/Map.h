//
//  Map.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MapPin;

@interface Map : NSManagedObject

@property (nonatomic, retain) NSNumber * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *mapPins;
@end

@interface Map (CoreDataGeneratedAccessors)

- (void)addMapPinsObject:(MapPin *)value;
- (void)removeMapPinsObject:(MapPin *)value;
- (void)addMapPins:(NSSet *)values;
- (void)removeMapPins:(NSSet *)values;

@end
