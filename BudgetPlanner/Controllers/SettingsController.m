//
//  SettingsController.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "SettingsController.h"
#import "BudgetPlannerConstants.h"

@interface SettingsController()


@end


// Implementation.
@implementation SettingsController

static SettingsController* sharedInstance = nil;


+(SettingsController*) sharedInstance
{
    @synchronized(self){
        if(sharedInstance == nil){
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}


// Initializer:
-(instancetype) init
{
    self = [super init];
    if(self){
        // Do required initialization.
        // Set default values for settings if not already set by user.
        if([[NSUserDefaults standardUserDefaults] objectForKey:kIsFirstUseKey] == nil){
            [self initializeDefaultSettings];
        }
    }
    return self;
}

#pragma mark - Custom property synthesis.

// isFirstUse
-(BOOL) isFirstUse
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults  synchronize];
    NSNumber* numValue = [userDefaults objectForKey:kIsFirstUseKey];
    return ([numValue boolValue]);
}

// Set IsFirst Use.
-(void) setIsFirstUse:(BOOL)firstUse
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:firstUse] forKey:kIsFirstUseKey];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}


#pragma mark - private


-(void) initializeDefaultSettings
{
    NSMutableDictionary* defaultSettings = [[NSMutableDictionary alloc] init];
    
    // First Use.
    [defaultSettings setObject:[NSNumber numberWithBool:YES] forKey:kIsFirstUseKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

@end
