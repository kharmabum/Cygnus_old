//
//  MapPin.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Map;

@interface MapPin : NSManagedObject

@property (nonatomic, retain) NSNumber * event;
@property (nonatomic, retain) NSDate * expiration;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) Map *map;

@end
