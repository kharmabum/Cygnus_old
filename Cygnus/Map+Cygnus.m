//
//  Map+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Map+Cygnus.h"
#import "MapPin+Cygnus.h"
#import "CygnusManager.h"

@implementation Map (Cygnus)

+ (Map *)mapFromPlistData:(NSDictionary*)mapInfo inManagedObjectContext:(NSManagedObjectContext*)context
{

    Map *map = nil;
    NSString *mapType;
    int type = [[mapInfo valueForKey:@"mapType"] intValue];
    switch (type) {
        case SIM_MAP_TYPE_GROUP:
            mapType = CYGNUS_GROUP_MAP;
            break;
        
        case SIM_MAP_TYPE_SHARED:
            mapType = CYGNUS_SHARED_MAP;
            break;
            
        case SIM_MAP_TYPE_PRIVATE:
            mapType = CYGNUS_PRIVATE_MAP;
            break;
    }
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:mapType];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [mapInfo objectForKey:@"uid"]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"Error creating map");

    } else if (![matches count]) {
        map = [NSEntityDescription insertNewObjectForEntityForName:mapType inManagedObjectContext:context];
        map.uid = [mapInfo objectForKey:@"uid"];
        map.name = [mapInfo objectForKey:@"name"];
        map.summary = [mapInfo objectForKey:@"summary"];
        
        NSArray *mapPins = [mapInfo objectForKey:@"mapPins"];
        for (NSDictionary *pin in mapPins) {
            MapPin *mapPin = [MapPin mapPinFromPlistData:pin inManagedObjectContext:context];
            [map addMapPinsObject:mapPin];
        }
        NSLog(@"Map sucessfully created");
    } else {
        map = [matches lastObject];
    }
    return map;
}


+ (Map *)mapFromUID:(NSNumber*)mapUID inManagedObjectContext:(NSManagedObjectContext*)context
{
    Map *map = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Map"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", mapUID];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        // handle error
    } else {
        map = [matches lastObject];
    }
    return map;
}
    
/*
- (void)prepareForDeletion
{
    for (SearchTag* tag in self.searchTags) {
        tag.referenceCount = [NSNumber numberWithInt:(tag.referenceCount.intValue-1)];
        if (![tag.referenceCount intValue]) [tag.managedObjectContext deleteObject:tag];
    }
    self.locationOfmap.referenceCount = [NSNumber numberWithInt:(self.locationOfmap.referenceCount.intValue-1)];
    if (![self.locationOfmap.referenceCount intValue]) [self.locationOfmap.managedObjectContext deleteObject:self.locationOfPhoto];
    
    
}*/

@end
