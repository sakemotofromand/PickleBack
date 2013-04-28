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

#import "PBAppDelegate.h"

@implementation PBAppDelegate

@synthesize tabBar;
@synthesize sessionId;
@synthesize sessionDrinks;
@synthesize sessionStart;
@synthesize timerSecondsLeft;
@synthesize timer;
@synthesize timerStart;
@synthesize timerInitialSecondsLeft;

#define ToDoItemKey @"EVENTKEY1"
#define MessageTitleKey @"MSGKEY1"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Set up tabBar
    tabBar = (UITabBarController*)self.window.rootViewController;
    //Handle launching from a notification
    if (timer != nil) [timer invalidate];
    timerSecondsLeft = 0;
    sessionId = 0;
    sessionDrinks = 0;
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    tabBar.selectedIndex = 1;
}

- (void) dismissAlert:(UIAlertView*) alertView
{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void) _showAlert:(NSString*)pushmessage withTitle:(NSString*)title
{
    if (sessionId == 0) return;
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:timerInitialSecondsLeft-2];
 }

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {

    if (sessionId == 0) return;

    NSLog(@"application: didReceiveLocalNotification:");
    NSLog(@"Receive Local Notification while the app is still running...");
    NSLog(@"current notification is %@",notif);
    //[application presentLocalNotificationNow:notif];
    if (application.applicationState == UIApplicationStateActive)[self _showAlert:@"How many drinks have you had?" withTitle:@"pickleback"];

    application.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //Cancel timer
    //if (timer != nil) [timer invalidate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //Back from background
    //We have to recalculat the countdown if applicable
    if (timerSecondsLeft > 0)
    {
        NSLog(@"Initial Seconds left: %d", timerInitialSecondsLeft);
        NSLog(@"Seconds left when went to background: %d", timerSecondsLeft);
        //Recalculate countdown
        int secondsElapsed = [timerStart timeIntervalSinceNow];
        NSLog(@"Seconds elapsed: %d", secondsElapsed);
        timerSecondsLeft = timerInitialSecondsLeft + secondsElapsed;
    }
}
@end
