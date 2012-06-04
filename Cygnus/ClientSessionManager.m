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
static NSMutableSet *_mapPinsForCurrentUser; 
static NSMutableSet *_activeGroupsForCurrentUser; 
static NSMutableSet *_activeMapsForCurrentUser; 

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
        return NO;
    }
}

+ (void)logoutCurrentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CURRENT_USER_EMAIL];
    _currentUser = nil;
}

//contain NSManagedObjects

+ (NSSet *)mapPinsForCurrentUser
{
    if (!_mapPinsForCurrentUser) {
        _mapPinsForCurrentUser = [NSMutableSet set];
        NSSet *activeMaps = [ClientSessionManager activeMapsForCurrentUser];
        for (Map *map in activeMaps) {
            [_mapPinsForCurrentUser unionSet:[map mapPins]];
        }
    }
    return _mapPinsForCurrentUser; 
}

+ (NSSet *)activeGroupsForCurrentUser
{
    if (!_activeGroupsForCurrentUser) {
        _activeGroupsForCurrentUser = [NSMutableSet set];
        
        NSArray *groupIds = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_ACTIVE_GROUPS];
        if (groupIds) {
            for (NSNumber *groupid in groupIds) {
                [_activeGroupsForCurrentUser addObject:[Group groupFromUID:groupid inManagedObjectContext:[[CygnusManager simulation] managedObjectContext]]];
            }
        }
    }   
    return _activeGroupsForCurrentUser;
}

+ (NSSet*)activeMapsForCurrentUser
{
    if (!_activeMapsForCurrentUser) {
        _activeMapsForCurrentUser = [NSMutableSet set];
        
        NSArray *mapIds = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_ACTIVE_MAPS];
        if (mapIds) {
            for (NSNumber *mapId in mapIds) {
                [_activeMapsForCurrentUser addObject:[Map mapFromUID:mapId inManagedObjectContext:[[CygnusManager simulation] managedObjectContext]]];
            }
        }
    }
    return _activeMapsForCurrentUser;
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
}

@end
