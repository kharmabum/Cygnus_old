//
//  Console_RootTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_RootTVC.h"
#import "CygnusManager.h"

@interface Console_RootTVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

@end

@implementation Console_RootTVC
@synthesize mapTypeSegmentedControl;

- (void)viewWillAppear:(BOOL)animated
{
    self.mapTypeSegmentedControl.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_MAP_PREFERENCE] intValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setMapTypeSegmentedControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)mapTypeSelected:(UISegmentedControl *)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:sender.selectedSegmentIndex]forKey:CURRENT_USER_MAP_PREFERENCE];
}


#pragma mark - Table view data source
/*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}*/



@end
