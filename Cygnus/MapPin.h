//
//  MapPin.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Map;

@interface MapPin : NSManagedObject

@property (nonatomic, retain) NSDate * expiration;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * location_name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) Map *map;
@property (nonatomic, retain) NSSet *events;
@end

@interface MapPin (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
