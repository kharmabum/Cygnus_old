//
//  Console_MyGroupsTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_MyGroupsTVC.h"
#import "ClientSessionManager.h"

@interface Console_MyGroupsTVC ()
@property (nonatomic, strong) NSArray *myGroups;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *activeGroupsEditButton;
@property (nonatomic) BOOL activeGroupsEditingMode;
@property (nonatomic) UIColor *defaultEditButtonColor;
@property (nonatomic) UIImage *activeGroupIndictor;

@end

@implementation Console_MyGroupsTVC
@synthesize myGroups = _myGroups;
@synthesize activeGroupsEditButton = _activeGroupsEditButton;
@synthesize activeGroupsEditingMode = _activeGroupsEditingMode;
@synthesize defaultEditButtonColor = _defaultEditButtonColor;
@synthesize activeGroupIndictor = _activeGroupIndictor;

- (void)setactiveGroupsEditingMode:(BOOL)activeGroupsEditingMode
{
    _activeGroupsEditingMode = activeGroupsEditingMode;
    self.activeGroupsEditButton.tintColor = (_activeGroupsEditingMode) ? [UIColor redColor] : self.defaultEditButtonColor;
}

- (IBAction)switchEditingMode:(id)sender {
    [self setactiveGroupsEditingMode:!_activeGroupsEditingMode];
}

#pragma mark - Life cycle


- (void)viewWillAppear:(BOOL)animated
{
    self.myGroups = [[[ClientSessionManager currentUser] groups] allObjects];
    self.activeGroupsEditingMode = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultEditButtonColor = self.editButtonItem.tintColor;
    self.activeGroupIndictor = [UIImage imageNamed:@"check.png"];
}

- (void)viewDidUnload
{
    [self setActiveGroupsEditButton:nil];
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
    return (section) ? self.myGroups.count : 1;
    NSLog(@"Size of MyGroups Section - %@",self.myGroups.count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section) ? @"Active Groups" : nil;
}

#define CREATE_GROUP_CELL_IDENTIFIER @"Console_CreateGroupCell"
#define GROUP_CELL_IDENTIFIER @"Console_GroupCell"


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;
    if (indexPath.section) {
        Group *group = [self.myGroups objectAtIndex:indexPath.row];
        cellIdentifier = GROUP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSLog(@"cell exists - %@", cell);
        cell.textLabel.text = [group name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d online members", group.members.count]; //TODO - Not accurate. ONLY FOR DEMO
        if ([[ClientSessionManager activeGroupsForCurrentUser] containsObject:group]) {
            cell.imageView.image = self.activeGroupIndictor;
        }
    } else {
        cellIdentifier = CREATE_GROUP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section) ? YES : NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    
     //newViewController = (Atlas_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Atlas_LoginVC"];
     [self.navigationController pushViewController:detailViewController animated:YES];
    */
    
    if (indexPath.section) {
        if (self.activeGroupsEditingMode) {
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.imageView.image) {
                cell.imageView.image = nil;
                // Reflect selection in data model
                [ClientSessionManager removeFromActiveGroups:[self.myGroups objectAtIndex:indexPath.row]];
            } else {
                cell.imageView.image = self.activeGroupIndictor;
                [ClientSessionManager addToActiveGroups:[self.myGroups objectAtIndex:indexPath.row]];
            }
        } else {
            //transition to group description
        }
    } else {
        //transition to either create group or group invitations. 
    }
}

@end
