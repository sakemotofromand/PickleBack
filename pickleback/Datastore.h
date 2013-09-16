//
//  Datastore.h
//  pickleback
//
//  Created by Marc Visent Menardia on 5/1/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"



@interface Datastore : NSObject {
	FMDatabase *db;
}

@property (nonatomic, retain) FMDatabase *db;


- (int)countItems;
- (void)saveItem:(NSDictionary *)item;
- (NSMutableArray *)getSavedItems;
+ (Datastore*)datastore;



@end
