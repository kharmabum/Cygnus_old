//
//  MapPin+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPin+Cygnus.h"
#import "Event+Cygnus.h"

@implementation MapPin (Cygnus)

+ (MapPin *)mapPinFromPlistData:(NSDictionary*)pinInfo inManagedObjectContext:(NSManagedObjectContext*)context
{
    MapPin *mapPin = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MapPin"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"location_name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [pinInfo objectForKey:@"uid"]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        mapPin = [NSEntityDescription insertNewObjectForEntityForName:@"MapPin" inManagedObjectContext:context];
        mapPin.uid = [pinInfo objectForKey:@"uid"];
        mapPin.location_name = [pinInfo objectForKey:@"location_name"];
        mapPin.summary = [pinInfo objectForKey:@"summary"];
        //mapPin.event = [pinInfo objectForKey:@"event"];
        mapPin.expiration = [pinInfo objectForKey:@"expiration"];
        mapPin.imgURL = [pinInfo objectForKey:@"imgURL"];
        mapPin.latitude = [pinInfo objectForKey:@"latitude"];
        mapPin.longitude = [pinInfo objectForKey:@"longitude"];
        
        NSArray *events = [pinInfo objectForKey:@"events"];
        for (NSDictionary *event in events) {
            Event *pinEvent = [Event eventFromPlistData:event inManagedObjectContext:context];
            [mapPin addEventsObject:pinEvent];
        }
        NSLog(@"MapPin sucessfully created");


    } else {
        mapPin = [matches lastObject];
    }
    return mapPin;
}

@end

