//
//  Console_MyMapsTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_MyMapsTVC.h"
#import "ClientSessionManager.h"

@interface Console_MyMapsTVC ()
@property (nonatomic, strong) NSMutableOrderedSet *myMaps;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *activeMapsEditButton;
@property (nonatomic) BOOL activeMapsEditingMode;
@property (nonatomic) UIColor *defaultEditButtonColor;
 
@end

@implementation Console_MyMapsTVC
@synthesize myMaps = _myMaps;
@synthesize activeMapsEditButton = _activeMapsEditButton;
@synthesize activeMapsEditingMode = _activeMapsEditingMode;
@synthesize defaultEditButtonColor = _defaultEditButtonColor;

- (void)setActiveMapsEditingMode:(BOOL)activeMapsEditingMode
{
    _activeMapsEditingMode = activeMapsEditingMode;
    self.activeMapsEditButton.tintColor = (_activeMapsEditingMode) ? [UIColor redColor] : self.defaultEditButtonColor;
}

- (IBAction)switchEditingMode:(id)sender {
    [self setActiveMapsEditingMode:!_activeMapsEditingMode];
}


#pragma mark - Life cycle


- (void)viewWillAppear:(BOOL)animated
{
    self.myMaps =  [[NSMutableOrderedSet alloc] initWithOrderedSet: [ClientSessionManager availableMapsForCurrentUser]];
    [self.myMaps minusSet:[NSSet setWithArray:[[ClientSessionManager activeMapsForCurrentUser] array]]];
    [self setActiveMapsEditingMode:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultEditButtonColor = self.editButtonItem.tintColor;
}

- (void)viewDidUnload
{
    [self setActiveMapsEditButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    } else if (section == 1) {
        return [[ClientSessionManager activeMapsForCurrentUser] count];
    } else {
        return [self.myMaps count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return nil;
    } else if (section == 1) {
        return @"Active Maps";
    } else {
        return @"My Maps";
    }
}

#define CREATE_MAP_CELL_IDENTIFIER @"Console_CreateMapCell"
#define MAP_CELL_IDENTIFIER @"Console_MapCell"


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    if (!indexPath.section) {
        cellIdentifier = CREATE_MAP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    } else {
        Map *map;
        cellIdentifier = MAP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (indexPath.section == 1) {
            map = [[ClientSessionManager activeMapsForCurrentUser] objectAtIndex:indexPath.row];
        } else {
            map = [self.myMaps objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = [map name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d items", map.mapPins.count];  //TODO # of events? need new attribute
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     //newViewController = (Atlas_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Atlas_LoginVC"];
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (indexPath.section) {
        if (self.activeMapsEditingMode) {
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
            if (indexPath.section == 1) {
                Map *map = [[ClientSessionManager activeMapsForCurrentUser] objectAtIndex:indexPath.row];
                [ClientSessionManager removeFromActiveMaps:map];
                [self.myMaps addObject:map];
            } else {
                Map *map = [self.myMaps objectAtIndex:indexPath.row];
                [self.myMaps removeObject:map];
                [ClientSessionManager addToActiveMaps:map];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            //transition to Map detail viewcontroller
        }
    } else {
        //transition to create map
    }
}

@end
