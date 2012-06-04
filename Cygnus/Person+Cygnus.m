//
//  Person+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person+Cygnus.h"
#import "PrivateMap+Cygnus.h"

@implementation Person (Cygnus)

+ (Person *)personFromPlistData:(NSDictionary*)personInfo inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    Person *person = nil;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [personInfo objectForKey:@"uid"]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        person= [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        person.uid = [personInfo objectForKey:@"uid"];
        person.first_name = [personInfo objectForKey:@"first_name"];
        person.last_name = [personInfo objectForKey:@"last_name"];
        person.email = [personInfo objectForKey:@"email"];
        person.latitude = [personInfo objectForKey:@"latitude"];
        person.longitude = [personInfo objectForKey:@"longitude"];
        
        NSArray *privateMaps = [personInfo objectForKey:@"privateMaps"];
        for (NSNumber *mapUID in privateMaps) {
            PrivateMap *map = [PrivateMap privateMapFromUID:mapUID inManagedObjectContext:context];
            [person addPrivateMapsObject:map];
        }
        
        NSLog(@"Person sucessfully created");

        
    } else {
        person= [matches lastObject];
    }
    return person;
}

+ (Person *)personFromUID:(NSNumber*)personUID inManagedObjectContext:(NSManagedObjectContext*)context
{
    Person *person = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", personUID];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        // handle error
    } else {
        person = [matches lastObject];
    }
    return person;
    
}

+ (Person *)personFromEmail:(NSString*)email inManagedObjectContext:(NSManagedObjectContext*)context
{
    Person *person = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        // handle error
    } else {
        person = [matches lastObject];
    }
    return person;
}



@end
