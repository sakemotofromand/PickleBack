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


+(void) initialize
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

-(id)init {
	//NSLog(@"Datastore init:");
	if (self = [super init])
        {
		NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"pickleback.db"];
		
		self.db = [FMDatabase databaseWithPath: dbPath];
		[self.db open];
	}

   return self;
}


- (void) dealloc {
	//NSLog(@"Datastore dealloc:");
	[db close];
	[db release];
	[super dealloc];
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
    [self countItems];
  /*  NSDictionary *item = NULL;
  
            item = @{ @"userID" :appDelegate.secureUDID, @"sessionID" : [NSString stringWithFormat:@"%d",appDelegate.sessionId], @"time" : [NSDate date], @"type" : [NSString stringWithFormat:@"%d",i], @"count" : [NSString stringWithFormat:@"%d",value], @"complete" : @YES };
    */
    
    @synchronized(db) {        
		NSNumber *type= [NSNumber numberWithInt: [[item objectForKey:@"type"] intValue]];
        NSLog(@"HELLO!! %d", [type intValue]);
        NSLog(@"HELLO!! %@", [item objectForKey:@"time"]);
        
		NSNumber *count= [NSNumber numberWithInt: [[item objectForKey:@"count"] intValue]];
        NSNumber *sessionID= [NSNumber numberWithInt: [[item objectForKey:@"sessionID"] intValue]];
        
	   [db executeUpdate: @"insert into item (time,type,count,sessionID,userID) values(?,?,?,?,?)",[item objectForKey:@"time"],type,count,sessionID,[item objectForKey:@"userID"],nil];
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM item", nil];
        while ([rs next])
        {
            int type= [rs intForColumn:@"type"];
            int count= [rs intForColumn:@"count"];
            int sessionID= [rs intForColumn:@"sessionID"];
            NSString *time = [rs stringForColumn:@"time"];
            //problemes amb data...
            NSLog(@"Time: %@ and type:%d and count:%d and sessionID:%d",time,type,count,sessionID);
        }
        [rs close];
	}
}

/*
-(NSMutableArray *)courseStatesAndCountries {
	NSLog(@"Datastore courseStatesAndCountries:");
	NSMutableArray *countries =[NSMutableArray array];
	
	@synchronized(db){
		FMResultSet *rs = [db executeQuery:@"SELECT * FROM country ORDER BY description DESC", nil];
		while ([rs next]) {
			
			NSString *countryName = [rs stringForColumn:@"description"];
			NSLog(@"COUnTRY NAME: %@",countryName);
			
			NSMutableDictionary *countryDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:countryName, @"CountryName", [NSMutableArray array], @"StateIDs", nil];
			[countries addObject:countryDictionary];
			[countryDictionary release];
		}
		
		[rs close]; 
		
		// Hard code the states that have coordinated courses until we figure out a better way of doing this
		//rs = [db executeQuery:@"SELECT * FROM state WHERE abbreviation IN ('FL', 'MN', 'NY') ORDER BY name", nil];
		rs = [db executeQuery:@"SELECT * FROM state ORDER BY name", nil];
		while ([rs next]) {
			NSString *stateName = [rs stringForColumn:@"name"];
			NSString *country = [rs stringForColumn:@"country"];
			NSString *abbreviation = [rs stringForColumn:@"abbreviation"];
			
			NSMutableDictionary *countryDictionary = countryDictionaryWithNameInArray (country, countries);
			NSMutableArray *states = [countryDictionary objectForKey:@"StateIDs"];
			
			NSMutableDictionary *stateDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stateName, @"StateName", abbreviation, @"Abbreviation", nil];
			[states addObject:stateDictionary];
			[stateDictionary release];
		}
		[rs close];  
	}
	return countries;
}

-(NSMutableArray *)countries {
	NSMutableArray *countries =[NSMutableArray array];
	@synchronized(db){
		FMResultSet *rs = [db executeQuery:@"SELECT * FROM country", nil];
		while ([rs next]) {
			//NSLog(@"Got a country");
			Country *country = [[Country alloc] init]; 
			country.primaryKey = [rs intForColumn:@"pk"];
			country.description = [rs stringForColumn:@"description"];
			country.countryCode = [rs intForColumn:@"countrycode"];
			country.lastDownload = [NSDate dateWithTimeIntervalSince1970: [rs doubleForColumn:@"lastdownload"]]; 
			[countries addObject:country];
			[country release];
		}
	}
	return countries;
}
 */
@end
