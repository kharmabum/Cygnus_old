//
//  ClientSessionManager.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClientSessionManager.h"
#import "CygnusManager.h"

@implementation ClientSessionManager

static Person *_currentUser; 
static NSMutableOrderedSet *_mapPinsForCurrentUser; 
static NSMutableOrderedSet *_activeGroupsForCurrentUser; 
static NSMutableOrderedSet *_activeMapsForCurrentUser; 
static BOOL updateRequired = NO;

+ (void)indicateNeedForUpdate:(BOOL)updateNeeded
{
    updateRequired = updateNeeded;
}

+ (BOOL)updateRequired
{
    BOOL oldStatus = updateRequired; 
    updateRequired = NO;
    return oldStatus;
}

+ (Person *)currentUser
{
    if (!_currentUser) {
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_EMAIL];
        [ClientSessionManager setCurrentUser:email];
    }
    return _currentUser;
}

+ (BOOL)setCurrentUser:(NSString*)email
{    
    if (_currentUser) [ClientSessionManager logoutCurrentUser];    
    Person *user = [Person personFromEmail:email inManagedObjectContext:[[CygnusManager simulation] managedObjectContext]];
    if (user) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:email forKey:CURRENT_USER_EMAIL];
        [defaults synchronize];
        _currentUser = user;
        return YES;
    } else {
        //ERROR user not found
        NSLog(@"Error user not found");
        return NO;
    }
}

+ (void)logoutCurrentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CURRENT_USER_EMAIL];
    _currentUser = nil;
}

+ (int)currentUserMapPreference 
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_USER_MAP_PREFERENCE] intValue];
}

+ (BOOL)currentUserBeaconEnabled
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_USER_BEACON_ENABLED] boolValue];
}

+ (int)currentUserBeaconFrequency
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_USER_BEACON_FREQUENCY] intValue]; 
}

+ (int)currentUserBeaconRange
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_USER_BEACON_RANGE] intValue]; 
}


//contain NSManagedObjects

+ (NSMutableOrderedSet*)mapPinsForCurrentUser
{
    if (!_mapPinsForCurrentUser) {
        _mapPinsForCurrentUser = [[NSMutableOrderedSet alloc] init];
        NSOrderedSet *activeMaps = [ClientSessionManager activeMapsForCurrentUser];
        for (Map *map in activeMaps) {
            [_mapPinsForCurrentUser unionSet:[map mapPins]];
        }
    }
    return _mapPinsForCurrentUser; 
}

+ (NSMutableOrderedSet*)activeGroupsForCurrentUser
{
    if (!_activeGroupsForCurrentUser) {
        _activeGroupsForCurrentUser = [[NSMutableOrderedSet alloc]init];
        
        NSArray *groupIds = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_ACTIVE_GROUPS];

        if (groupIds) {
            for (NSNumber *groupid in groupIds) {
                [_activeGroupsForCurrentUser addObject:[Group groupFromUID:groupid inManagedObjectContext:[[CygnusManager simulation] managedObjectContext]]];
            }
        }
    }   
    return _activeGroupsForCurrentUser;
}

+ (NSMutableOrderedSet*)activeMapsForCurrentUser
{
    if (!_activeMapsForCurrentUser) {
        _activeMapsForCurrentUser = [[NSMutableOrderedSet alloc]init];
        
        NSArray *mapIds = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_ACTIVE_MAPS];

        if (mapIds) {
            for (NSNumber *mapId in mapIds) {
                [_activeMapsForCurrentUser addObject:[Map mapFromUID:mapId inManagedObjectContext:[[CygnusManager simulation] managedObjectContext]]];
            }
        }
    }
    return _activeMapsForCurrentUser;
}

+ (NSMutableOrderedSet*)availableMapsForCurrentUser
{
    NSSet *groups = [[ClientSessionManager currentUser] groups];
    NSMutableOrderedSet *maps = [[NSMutableOrderedSet alloc] init];
    for (Group *group in groups) {
        [maps unionSet:group.sharedMaps];
        [maps addObject:group.groupMap];
    }
    return maps;
}

+ (void)addToActiveGroups:(Group*)group
{
    //don't need to change active maps by default...
    [ClientSessionManager activeGroupsForCurrentUser];
    [_activeGroupsForCurrentUser addObject:group];
}

+ (void)removeFromActiveGroups:(Group*)group
{
    if (_activeGroupsForCurrentUser) {
        [_activeGroupsForCurrentUser removeObject:group];
        
        /*
        //CHANGE ACTIVE MAPS
        dispatch_queue_t updateActiveMaps = dispatch_queue_create("update active maps", NULL);
        dispatch_async(updateActiveMaps, ^{
            if (_activeMapsForCurrentUser) {
                for (Map* map in _activeMapsForCurrentUser) {
                    if ([map isMemberOfClass:[GroupMap class]]) {
                        if ([(GroupMap*)map group] == group) {
                            [ClientSessionManager removeFromActiveMaps:map];
                        }
                    } else if ([map isMemberOfClass:[SharedMap class]]) {
                        if (![[(SharedMap*)map groups] intersectsSet:_activeGroupsForCurrentUser]) {
                            [ClientSessionManager removeFromActiveMaps:map];
                        }
                    }
                }
            }
        });
        dispatch_release(updateActiveMaps);
        */
    }
         
}

+ (void)addToActiveMaps:(Map*)map
{
    [ClientSessionManager activeMapsForCurrentUser];
    [_activeMapsForCurrentUser addObject:map];
    
    //CHANGE ACTIVE MAP PINS
    [ClientSessionManager mapPinsForCurrentUser];
    for (MapPin *pin in map.mapPins) {
        [_mapPinsForCurrentUser addObject:pin];
    }
}

+ (void)removeFromActiveMaps:(Map*)map
{
    [_activeMapsForCurrentUser removeObject:map];
    _mapPinsForCurrentUser = nil;
    updateRequired = YES; // TODO - instead of requiring update and rebuild. create cached storages of annotations for each active map. 
}

@end
