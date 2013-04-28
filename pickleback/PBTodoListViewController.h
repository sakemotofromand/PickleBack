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

@interface PBTodoListViewController : UITableViewController
{
    int beersValue;
    int winesValue;
    int mixedValue;
    int shotsValue;
}

@property (weak, nonatomic) IBOutlet UITextField                *itemText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *activityIndicator;
@property (nonatomic, strong) IBOutlet UIStepper *beers;
@property (nonatomic, strong) IBOutlet UIStepper *wines;
@property (nonatomic, strong) IBOutlet UIStepper *mixed;
@property (nonatomic, strong) IBOutlet UIStepper *shots;
@property (nonatomic, strong) IBOutlet UILabel *beersLabel;
@property (nonatomic, strong) IBOutlet UILabel *winesLabel;
@property (nonatomic, strong) IBOutlet UILabel *mixedLabel;
@property (nonatomic, strong) IBOutlet UILabel *shotsLabel;
@property (nonatomic, strong) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) IBOutlet UILabel *headerInfo;

- (IBAction)onAdd:(id)sender;
- (IBAction)valueBeersChanged:(UIStepper*) sender;
- (IBAction)valueWinesChanged:(UIStepper*) sender;
- (IBAction)valueMixedChanged:(UIStepper*) sender;
- (IBAction)valueShotsChanged:(UIStepper*) sender;

@end
