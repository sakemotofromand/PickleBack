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
#import "OpenUDID.h"
#import "SecureUDID.h"
#import "TestFlight.h"


@implementation PBAppDelegate

@synthesize tabBar;
@synthesize sessionId;
@synthesize sessionDrinks;
@synthesize sessionStart;
@synthesize timerSecondsLeft;
@synthesize timer;
@synthesize timerStart;
@synthesize timerInitialSecondsLeft;
@synthesize secureUDID;


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Use during beta only!!
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    //TestFlightApp Code
    [TestFlight takeOff:@"3296aa1d-f8bb-4277-8a43-8f3044af10a9"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...
    
    //Set up tabBar
    tabBar = (UITabBarController*)self.window.rootViewController;
    //Handle launching from a notification
    if (timer != nil) [timer invalidate];
    timerSecondsLeft = 5; //first position of the array, otherwise it doesn't work if user doesnt touch the picker view
    timerInitialSecondsLeft = 0;
    sessionId = 0;
    sessionDrinks = -1;
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    /* Use following code to create open ID
    NSString* openUDID = [OpenUDID value];
    NSLog(@"openUDID: %@",openUDID);
    */
    
    //Use following code to create secure ID
    NSString *domain = @"com.PBCo.pickleback";
    NSString *key = @"picklebacksareverygood111222333";
    secureUDID = [SecureUDID UDIDForDomain:domain usingKey:key];
    NSLog(@"secureUDID: %@",secureUDID);
    
    //Now we load data from file
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Data"];

    NSArray *contentArray = [[NSArray alloc] initWithContentsOfFile:path];
    NSLog(@"I load %d",[contentArray count]);
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    tabBar.selectedIndex = 1;
}

/*
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
*/

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    [TestFlight passCheckpoint:@"PUSH_NOTIFICATION"];
    if (sessionId == 0 || timer == NULL) return;
    NSLog(@"Application: didReceiveLocalNotification:");
    NSLog(@"Receive Local Notification while the app is still running...");
    NSLog(@"Current notification is %@",notif);
    //[application presentLocalNotificationNow:notif];
    //if (application.applicationState == UIApplicationStateActive)[self _showAlert:@"How many drinks have you had?" withTitle:@"pickleback"];
    application.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1;
    tabBar.selectedIndex = 1;
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    [TestFlight passCheckpoint:@"ENTER_BACKGROUND"];
    //Cancel timer
    //if (timer != nil) [timer invalidate];
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    [TestFlight passCheckpoint:@"ENTER_FOREGROUND"];
    //Back from background
    //We have to recalculat the countdown if applicable
    if (timerSecondsLeft > 0) {
        //NSLog(@"Initial Seconds left: %d", timerInitialSecondsLeft);
        //NSLog(@"Seconds left when went to background: %d", timerSecondsLeft);
        //Recalculate countdown
        int secondsElapsed = [timerStart timeIntervalSinceNow];
        //NSLog(@"Seconds elapsed: %d", secondsElapsed);
        timerSecondsLeft = timerInitialSecondsLeft + secondsElapsed;
    }
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    if (sessionId != 0 && timer != NULL) {
        tabBar.selectedIndex = 1;
    }
}

@end
