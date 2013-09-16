//
//  PBMeViewController.h
//  pickleback
//
//  Created by Marc Visent Menardia on 5/6/13.
//  Copyright (c) 2013 PBCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMeViewController : UIViewController
{
    IBOutlet UILabel *countThisSession;
    IBOutlet UILabel *countLastHour;
    IBOutlet UILabel *countLastDay;
    IBOutlet UILabel *countLastWeek;
    IBOutlet UILabel *countLastMonth;
}

@property (nonatomic, strong) IBOutlet UILabel *countThisSession;
@property (nonatomic, strong) IBOutlet UILabel *countLastHour;
@property (nonatomic, strong) IBOutlet UILabel *countLastDay;
@property (nonatomic, strong) IBOutlet UILabel *countLastWeek;
@property (nonatomic, strong) IBOutlet UILabel *countLastMonth;
@end
