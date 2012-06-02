//
//  Group+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Group+Cygnus.h"
#import "SharedMap+Cygnus.h"
#import "Person+Cygnus.h"

@implementation Group (Cygnus)

+ (Group *)groupFromPlistData:(NSDictionary*)groupInfo inManagedObjectContext:(NSManagedObjectContext*)context
{
    Group *group = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [groupInfo objectForKey:@"uid"]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
        group.uid = [groupInfo objectForKey:@"uid"];
        group.name = [groupInfo objectForKey:@"name"];
        group.summary = [groupInfo objectForKey:@"summary"];
        
        NSArray *people = [groupInfo objectForKey:@"members"];
        for (NSNumber *personUID in people) {
            Person *person = [Person personFromUID:personUID inManagedObjectContext:context];
            [group addMembersObject:person];
        }
        
        NSArray *sharedMaps = [groupInfo objectForKey:@"sharedMaps"];
        for (NSNumber *mapUID in sharedMaps) {
            SharedMap *sharedMap = [SharedMap sharedMapFromUID:mapUID inManagedObjectContext:context];
            [group addSharedMapsObject:sharedMap];
        }
        
        NSLog(@"Group sucessfully created");

        
    } else {
        group = [matches lastObject];
    }
    return group;
}


@end
