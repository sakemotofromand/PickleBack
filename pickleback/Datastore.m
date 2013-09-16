//
//  Datastore.m
//  pickleback
//
//  Created by Marc Visent Menardia on 5/1/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import "Datastore.h"
#import "FMDatabase.h"


@implementation Datastore

@synthesize db;

static Datastore* instance;

#pragma mark --
#pragma mark Setup


+ (void)initialize
{
	//First test for existence
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writeableDBPath = [documentsDirectory stringByAppendingPathComponent:@"pickleback.db"];
	success = [fileManager fileExistsAtPath:writeableDBPath];
	
	if (success == NO)
	{
		//the writeable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pickleback.db"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writeableDBPath error:&error];
		if (!success) {
			
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
			
		}
	}	
			
}

+ (Datastore*)datastore
{

	if(instance == nil) instance = [[Datastore alloc] init];
    
    return instance;
}

- (id)init
{
	//NSLog(@"Datastore init:");
	if (self = [super init])
        {
		NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"pickleback.db"];
		
		self.db = [FMDatabase databaseWithPath: dbPath];
		[self.db open];
	}

   return self;
}


- (void)dealloc
{
	//NSLog(@"Datastore dealloc:");
	[db close];
	//[db release];
	//[super dealloc];
}

- (int)countItems
{
    int count = 0;
     @synchronized(db)
    {
        FMResultSet *rs  = [db executeQuery:@"SELECT * FROM item", nil];
        while ([rs next]) count++;
    }
    NSLog(@"Count:%d",count);
    return count;
}


- (void)saveItem:(NSDictionary *)item
{
    //Count items to see where we are. Get rid of this soon.
    [self countItems];
    
    @synchronized(db) {        
		NSNumber *type= [NSNumber numberWithInt: [[item objectForKey:@"type"] intValue]];
        //NSLog(@"HELLO!! %d", [type intValue]);
        //NSLog(@"HELLO!! %@", [item objectForKey:@"time"]);
        
		NSNumber *count= [NSNumber numberWithInt: [[item objectForKey:@"count"] intValue]];
        NSNumber *sessionID= [NSNumber numberWithInt: [[item objectForKey:@"sessionID"] intValue]];
        
	   [db executeUpdate: @"insert into item (time,type,count,sessionID,userID) values(?,?,?,?,?)",[item objectForKey:@"time"],type,count,sessionID,[item objectForKey:@"userID"],nil];
        
        /*FMResultSet *rs = [db executeQuery:@"SELECT * FROM item", nil];
        while ([rs next])
        {
            int type= [rs intForColumn:@"type"];
            int count= [rs intForColumn:@"count"];
            int sessionID= [rs intForColumn:@"sessionID"];
            NSDate *time = [rs dateForColumn:@"time"];
            //NSLog(@"Time: %@ and type:%d and count:%d and sessionID:%d",time,type,count,sessionID);
        }
        [rs close];
	*/
    }
}


-(NSMutableArray *)getSavedItems
{
	NSMutableArray *items =[NSMutableArray array];
	@synchronized(db){
		FMResultSet *rs = [db executeQuery:@"SELECT * FROM item", nil];
		while ([rs next]) {        
            NSDictionary *item = @{ @"sessionID" : [NSNumber numberWithInt:[rs intForColumn:@"sessionID"]], @"time" : [rs dateForColumn:@"time"],@"count" : [NSNumber numberWithInt:[rs intForColumn:@"count"]] };
			[items addObject:item];
			//[item release];
		}
		
		[rs close]; 
	}
	return items;
}

@end
