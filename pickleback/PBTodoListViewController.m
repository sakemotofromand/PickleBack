// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "PBTodoListViewController.h"
#import "PBTodoService.h"
#import "PBAppDelegate.h"


#pragma mark * Private Interface


@interface PBTodoListViewController ()

// Private properties
@property (strong, nonatomic)   PBTodoService   *todoService;
@property (nonatomic)           BOOL            useRefreshControl;

@end


#pragma mark * Implementation


@implementation PBTodoListViewController

@synthesize todoService;
@synthesize itemText;
@synthesize activityIndicator;
@synthesize beers, wines, mixed, shots;
@synthesize beersLabel, winesLabel, mixedLabel, shotsLabel, confirmButton, headerInfo;


#pragma mark * UIView methods

- (void)resignKeyboard
{
	[itemText resignFirstResponder];
}

- (void)initView
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.sessionId == 0)
    {
        beersLabel.hidden = TRUE;
        winesLabel.hidden = TRUE;
        mixedLabel.hidden = TRUE;
        shotsLabel.hidden = TRUE;
        beers.hidden = TRUE;
        wines.hidden = TRUE;
        mixed.hidden = TRUE;
        shots.hidden = TRUE;
        confirmButton.hidden = TRUE;
        itemText.hidden = TRUE;
        headerInfo.text = @"Go Home to start new session.";
    } else
    {
        beersLabel.hidden = FALSE;
        winesLabel.hidden = FALSE;
        mixedLabel.hidden = FALSE;
        shotsLabel.hidden = FALSE;
        beers.hidden = FALSE;
        wines.hidden = FALSE;
        mixed.hidden = FALSE;
        shots.hidden = FALSE;
        confirmButton.hidden = FALSE;
        itemText.hidden = TRUE;
        headerInfo.text = @"How many drinks have you had since your last check in?";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the todoService - this creates the Mobile Service client inside the wrapped service
    self.todoService = [PBTodoService defaultService];
    
    // Set the busy method
    UIActivityIndicatorView *indicator = self.activityIndicator;
    self.todoService.busyUpdate = ^(BOOL busy)
    {
        if (busy)
        {
            [indicator startAnimating];
        } else
        {
            [indicator stopAnimating];
        }
    };
    
    // add the refresh control to the table (iOS6+ only)
    [self addRefreshControl];
    
    // load the data
    [self refresh];
    beersValue = 0;
    winesValue = 0;
    mixedValue = 0;
    shotsValue = 0;
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initView];
    
}

- (void) refresh
{
    // only activate the refresh control if the feature is available
    if (self.useRefreshControl == YES) {
        [self.refreshControl beginRefreshing];
    }
    [self.todoService refreshDataOnSuccess:^
    {
        if (self.useRefreshControl == YES) {
            [self.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    }];
    [self initView];
}


#pragma mark * UITableView methods


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Find item that was commited for editing (completed)
    NSDictionary *item = [self.todoService.items objectAtIndex:indexPath.row];
    
    // Change the appearance to look greyed out until we remove the item
    UILabel *label = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:1];
    label.textColor = [UIColor grayColor];
    
    // Ask the todoService to set the item's complete value to YES, and remove the row if successful
    [self.todoService completeItem:item completion:^(NSUInteger index)
    {  
        // Remove the row from the UITableView
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationTop];
    }];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Find the item that is about to be edited
    NSDictionary *item = [self.todoService.items objectAtIndex:indexPath.row];
    
    // If the item is complete, then this is just pending upload. Editing is not allowed
    if ([[item objectForKey:@"complete"] boolValue])
    {
        return UITableViewCellEditingStyleNone;
    }
    
    // Otherwise, allow the delete button to appear
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Customize the Delete button to say "complete"
    return @"complete";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the label on the cell and make sure the label color is black (in case this cell
    // has been reused and was previously greyed out
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.textColor = [UIColor blackColor];
    NSDictionary *item = [self.todoService.items objectAtIndex:indexPath.row];
    NSString *drinkType;
    if ([[item objectForKey:@"type"] isEqualToString:@"0"]) drinkType = @"Beers";
    if ([[item objectForKey:@"type"] isEqualToString:@"1"]) drinkType = @"Wines";
    if ([[item objectForKey:@"type"] isEqualToString:@"2"]) drinkType = @"Mixed";
    if ([[item objectForKey:@"type"] isEqualToString:@"3"]) drinkType = @"Shots";
    label.text = [NSString stringWithFormat:@"%@ %@ by %@",[item objectForKey:@"count"], drinkType, [NSDate date]];
    [label sizeToFit];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Always a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of items in the todoService items array
    return [self.todoService.items count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark * UITextFieldDelegate methods


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark * UI Actions


- (IBAction)onAdd:(id)sender
{
    if (beersValue + winesValue + mixedValue + shotsValue == 0)
    {
        return;
    }
    
    //NSDictionary *item = @{ @"text" : itemText.text, @"complete" : @NO, @"time" : [NSDate date]  };
    NSDictionary *itemBeers = NULL;
    NSDictionary *itemWines = NULL;
    NSDictionary *itemMixed = NULL;
    NSDictionary *itemShots = NULL;
   
    UITableView *view = self.tableView;
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (beersValue > 0)
    {
        NSLog(@"I have beer!");
        itemBeers = @{ @"sessionID" : [NSString stringWithFormat:@"%d",appDelegate.sessionId], @"type" : @"0", @"count" : [NSString stringWithFormat:@"%d",beersValue], @"complete" : @YES, @"time" : [NSDate date]  };
        [self.todoService addItem:itemBeers completion:^(NSUInteger index)
         {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
             [view insertRowsAtIndexPaths:@[ indexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
         }];
    }

    if (winesValue > 0)
    {
        NSLog(@"I have wine!");
        itemWines = @{ @"sessionID" : [NSString stringWithFormat:@"%d",appDelegate.sessionId], @"type" : @"1", @"count" : [NSString stringWithFormat:@"%d",winesValue], @"complete" : @YES, @"time" : [NSDate date]  };
        [self.todoService addItem:itemWines completion:^(NSUInteger index)
         {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
             [view insertRowsAtIndexPaths:@[ indexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
         }];
    }

    if (mixedValue > 0)
    {
        NSLog(@"I have mixed!");
        itemMixed = @{ @"sessionID" : [NSString stringWithFormat:@"%d",appDelegate.sessionId], @"type" : @"2", @"count" : [NSString stringWithFormat:@"%d",mixedValue], @"complete" : @YES, @"time" : [NSDate date]  };
        [self.todoService addItem:itemMixed completion:^(NSUInteger index)
         {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
             [view insertRowsAtIndexPaths:@[ indexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
         }];
    }

    if (shotsValue > 0)
    {
        NSLog(@"I have shots!");
        itemShots = @{ @"sessionID" : [NSString stringWithFormat:@"%d",appDelegate.sessionId], @"type" : @"3", @"count" : [NSString stringWithFormat:@"%d",shotsValue], @"complete" : @YES, @"time" : [NSDate date]  };
        [self.todoService addItem:itemShots completion:^(NSUInteger index)
         {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
             [view insertRowsAtIndexPaths:@[ indexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
         }];
    }

    itemText.text = @"";
    beersLabel.text = @"0 beers";
    winesLabel.text = @"0 wines";
    mixedLabel.text = @"0 mixed";
    shotsLabel.text = @"0 shots";
    beers.value = 0;
    wines.value = 0;
    mixed.value = 0;
    shots.value = 0;
    appDelegate.sessionDrinks = appDelegate.sessionDrinks + beersValue + winesValue + mixedValue + shotsValue;
    beersValue = 0;
    winesValue = 0;
    mixedValue = 0;
    shotsValue = 0;
    appDelegate.tabBar.selectedIndex = 0;
}


#pragma mark * iOS Specific Code

// This method will add the UIRefreshControl to the table view if
// it is available, ie, we are running on iOS 6+

- (void)addRefreshControl
{
    Class refreshControlClass = NSClassFromString(@"UIRefreshControl");
    if (refreshControlClass != nil)
    {
        // the refresh control is available, let's add it
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(onRefresh:)
                      forControlEvents:UIControlEventValueChanged];
        self.useRefreshControl = YES;
    }
}

- (void)onRefresh:(id) sender
{
    [self refresh];
}

- (IBAction)valueBeersChanged:(UIStepper*) sender
{
    beersValue = [sender value];
    [beersLabel setText:[NSString stringWithFormat:@"%d beers",beersValue]];
}

- (IBAction)valueWinesChanged:(UIStepper*) sender
{
    winesValue = [sender value];
    [winesLabel setText:[NSString stringWithFormat:@"%d wines",winesValue]];
}

- (IBAction)valueMixedChanged:(UIStepper*) sender
{
    mixedValue = [sender value];
    [mixedLabel setText:[NSString stringWithFormat:@"%d mixed",mixedValue]];
}

- (IBAction)valueShotsChanged:(UIStepper*) sender
{
    shotsValue = [sender value];
    [shotsLabel setText:[NSString stringWithFormat:@"%d shots",shotsValue]];
}



@end
