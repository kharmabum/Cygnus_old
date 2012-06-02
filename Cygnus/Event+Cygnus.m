//
//  Event+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event+Cygnus.h"

@implementation Event (Cygnus)

+ (Event *)eventFromPlistData:(NSDictionary*)eventInfo inManagedObjectContext:(NSManagedObjectContext*)context
{
    Event *event = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [eventInfo objectForKey:@"uid"]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        event.uid = [eventInfo objectForKey:@"uid"];
        event.name = [eventInfo objectForKey:@"name"];
        event.summary = [eventInfo objectForKey:@"summary"];
        event.expiration = [eventInfo objectForKey:@"expiration"];
        event.imgURL = [eventInfo objectForKey:@"imgURL"];
         
        //NSLog(@"Event sucessfully created");

    } else {
        event = [matches lastObject];
    }
    return event;
}

@end
