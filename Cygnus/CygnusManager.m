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
#import "ClientSessionManager.h"

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

    NSArray *people = [rootDict valueForKey:@"People"];
    NSArray *maps = [rootDict valueForKey:@"Maps"];
    NSArray *groups = [rootDict valueForKey:@"Groups"];
    
    for (NSDictionary *map in maps) {
        [Map mapFromPlistData:map inManagedObjectContext:sim.managedObjectContext];
    }
    
    for (NSDictionary *person in people) {
        [Person personFromPlistData:person inManagedObjectContext:sim.managedObjectContext];
    }
    
    for (NSDictionary *group in groups) {
        [Group groupFromPlistData:group inManagedObjectContext:sim.managedObjectContext];
    }
    
   //NSArray *activePublicGroupAndMapDefault = [NSArray arrayWithObject:[NSNumber numberWithInt:0]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:activePublicGroupAndMapDefault forKey:CURRENT_USER_ACTIVE_GROUPS];
    //[defaults setObject:activePublicGroupAndMapDefault forKey:CURRENT_USER_ACTIVE_MAPS];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:CURRENT_USER_MAP_PREFERENCE];
    [defaults setObject:[NSNumber numberWithInt:1] forKey:CURRENT_USER_BEACON_ENABLED];
    [defaults setObject:[NSNumber numberWithInt:5*60] forKey:CURRENT_USER_BEACON_FREQUENCY];
    [defaults setObject:[NSNumber numberWithInt:10000] forKey:CURRENT_USER_BEACON_RANGE];
    [defaults synchronize];
}


+ (void)loadSimulation 
{
    //NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSURL *simURL = [CygnusManager simulationDirectoryURL];
    //BOOL createSuccess = [fm createDirectoryAtPath:[simURL path] withIntermediateDirectories:YES attributes:nil error:&err];
    //if (!createSuccess) NSLog(@"Could not create directory");
    _simulation = [[UIManagedDocument alloc] initWithFileURL:simURL];
    
    BOOL __block documentReady = NO;
    if ([fm fileExistsAtPath:[_simulation.fileURL path]]) {
            [_simulation openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    documentReady=YES;
                } else {
                    NSLog(@"Failed to open %@",_simulation.fileURL);           
                }
            }]; 
    } else {
        [_simulation saveToURL:_simulation.fileURL forSaveOperation:UIDocumentSaveForCreating
             completionHandler:^(BOOL success) {
                 if (success) {
                     NSLog(@"Document created at %@", _simulation.fileURL);
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


+ (void)saveUserSettings
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *groupIds = [NSMutableArray array];
    for (Group *group in [ClientSessionManager activeGroupsForCurrentUser]) {
        [groupIds addObject: group.uid];
    }
    NSMutableArray *mapIds = [NSMutableArray array];
    for (Map *map in [ClientSessionManager activeMapsForCurrentUser]) {
        [mapIds addObject: map.uid];
    }
    
    [defaults setObject:groupIds forKey:CURRENT_USER_ACTIVE_GROUPS];
    [defaults setObject:mapIds forKey:CURRENT_USER_ACTIVE_MAPS];
    

    [defaults synchronize];
}


@end
