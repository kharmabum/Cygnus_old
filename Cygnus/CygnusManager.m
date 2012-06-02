//
//  CygnusManager.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CygnusManager.h"
#import "MapPin+Cygnus.h"
#import "Person+Cygnus.h"
#import "Map+Cygnus.h"
#import "Group+Cygnus.h"

@implementation CygnusManager

static UIManagedDocument*_simulation; 

+ (NSURL *) simulationDirectoryURL
{
    NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *simDirURL = [fm URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    return [simDirURL URLByAppendingPathComponent:@"simulation"];
}

+ (UIManagedDocument *)simulation
{
    return _simulation;
}



+ (void)populateSimulation
{
    UIManagedDocument *sim = [CygnusManager simulation];
    NSString *simulationModelPath = [[NSBundle mainBundle] pathForResource:@"Simulation" ofType:@"plist"];
        
    NSDictionary *rootDict = [[NSDictionary alloc] initWithContentsOfFile:simulationModelPath];
    
    NSArray *mapPins = [rootDict valueForKey:@"MapPins"];
    NSArray *people = [rootDict valueForKey:@"People"];
    NSArray *maps = [rootDict valueForKey:@"Maps"];
    NSArray *groups = [rootDict valueForKey:@"Groups"];
    
    for (NSDictionary *pin in mapPins) {
        [MapPin mapPinFromPlistData:pin inManagedObjectContext:sim.managedObjectContext];
    }
    
    for (NSDictionary *person in people) {
        [Person personFromPlistData:person inManagedObjectContext:sim.managedObjectContext];
    }
    
    for (NSDictionary *map in maps) {
        [Map mapFromPlistData:map inManagedObjectContext:sim.managedObjectContext];
    }
    
    for (NSDictionary *group in groups) {
        [Group groupFromPlistData:group inManagedObjectContext:sim.managedObjectContext];
    }
}




+ (void)loadSimulation 
{
    NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSURL *simURL = [CygnusManager simulationDirectoryURL];
    [fm createDirectoryAtPath:[simURL path] withIntermediateDirectories:YES attributes:nil error:&err];
    NSArray *simulationFiles = [fm contentsOfDirectoryAtPath:[simURL path]error:&err];
    _simulation = [[UIManagedDocument alloc] initWithFileURL:simURL];
    
    BOOL __block documentReady = NO;
    if (simulationFiles.count) {
        if ([fm fileExistsAtPath:[_simulation.fileURL path]]) {
            [_simulation openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    documentReady=YES;
                } else {
                    NSLog(@"Failed to open %@",_simulation.fileURL);           
                }
            }]; 
        }
    } else {
        [_simulation saveToURL:_simulation.fileURL forSaveOperation:UIDocumentSaveForCreating
             completionHandler:^(BOOL success) {
                 if (success) {
                     [CygnusManager populateSimulation];
                     documentReady=YES;
                 } else{
                     NSLog(@"Could not create doc at %@", _simulation.fileURL);
                 }
             }]; 
    }
    while (!documentReady) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
}


@end
