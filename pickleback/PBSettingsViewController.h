//
//  PBSettingsViewController
//  pickleback
//
//  Created by Marc Visent Menardia on 4/25/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBSettingsViewController : UIViewController
{
    IBOutlet UILabel *timerCountLabel;
    NSTimer *timer;
    int timerCount;
}
@property (nonatomic, strong) IBOutlet UILabel *timerCountLabel;

@end
