//
//  Event.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MapPin;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * expiration;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) MapPin *location;

@end
