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
@property (nonatomic, strong) NSArray *myMaps;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *activeMapsEditButton;
@property (nonatomic) BOOL activeMapsEditingMode;
@property (nonatomic) UIColor *defaultEditButtonColor;
@property (nonatomic) UIImage *activeMapIndictor;

@end

@implementation Console_MyMapsTVC
@synthesize myMaps = _myMaps;
@synthesize activeMapsEditButton = _activeMapsEditButton;
@synthesize activeMapsEditingMode = _activeMapsEditingMode;
@synthesize defaultEditButtonColor = _defaultEditButtonColor;
@synthesize activeMapIndictor = _activeMapIndictor;

- (void)setactiveMapsEditingMode:(BOOL)activeMapsEditingMode
{
    _activeMapsEditingMode = activeMapsEditingMode;
    self.activeMapsEditButton.tintColor = (_activeMapsEditingMode) ? [UIColor redColor] : self.defaultEditButtonColor;
}

- (IBAction)switchEditingMode:(id)sender {
    [self setactiveMapsEditingMode:!_activeMapsEditingMode];
}


#pragma mark - Life cycle


- (void)viewWillAppear:(BOOL)animated
{
    self.myMaps = [[ClientSessionManager availableMapsForCurrentUser] allObjects];
    [self setactiveMapsEditingMode:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultEditButtonColor = self.editButtonItem.tintColor;
    self.activeMapIndictor = [UIImage imageNamed:@"check.png"];
}

- (void)viewDidUnload
{
    [self setActiveMapsEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section) ? self.myMaps.count : 1;
    NSLog(@"Size of myMaps Section - %@",self.myMaps.count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section) ? @"Active Maps" : nil;
}

#define CREATE_MAP_CELL_IDENTIFIER @"Console_CreateMapCell"
#define MAP_CELL_IDENTIFIER @"Console_MapCell"


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;
    if (indexPath.section) {
        Map *map = [self.myMaps objectAtIndex:indexPath.row];
        cellIdentifier = MAP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.textLabel.text = [map name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d items, # events", map.mapPins.count];  //TODO # of events? need new attribute
        if ([[ClientSessionManager activeMapsForCurrentUser] containsObject:map]) {
            cell.imageView.image = self.activeMapIndictor;
        }
    } else {
        cellIdentifier = CREATE_MAP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.imageView.image) {
                cell.imageView.image = nil;
                // Reflect selection in data model
                [ClientSessionManager removeFromActiveMaps:[self.myMaps objectAtIndex:indexPath.row]];
            } else {
                cell.imageView.image = self.activeMapIndictor;
                [ClientSessionManager addToActiveMaps:[self.myMaps objectAtIndex:indexPath.row]];
            }
        } else {
            //transition to Map detail viewcontroller
        }
    } else {
        //transition to create map
    }
}

@end
