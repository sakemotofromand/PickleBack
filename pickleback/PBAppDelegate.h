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

#import <UIKit/UIKit.h>

@interface PBAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
    int sessionId;
    int sessionDrinks;
    NSDate *sessionStart;
    int timerSecondsLeft;
    int timerInitialSecondsLeft;
    NSTimer *timer;
    NSDate *timerStart;
    IBOutlet UITabBarController *tabBar;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) int sessionId;
@property (assign, nonatomic) int sessionDrinks;
@property (strong, nonatomic) NSDate *sessionStart;
@property (assign, nonatomic) int timerSecondsLeft;
@property (assign, nonatomic) int timerInitialSecondsLeft;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *timerStart;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBar;

@end
