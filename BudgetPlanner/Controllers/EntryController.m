//
//  EntryController.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "EntryController.h"
#import "BudgetPlannerConstants.h"
#import "EntryDataController.h"

@implementation EntryController

// Initialize database with default values for income and expenses.
-(void) initializeDefaultEntries
{
    // Load and read from properties list.
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:kDefaultBudgetItemsFilename
                                                              ofType:@"plist"];
    NSArray* defaultBudgetItems = [NSArray arrayWithContentsOfFile:plistFilePath];
    if(!(defaultBudgetItems && [defaultBudgetItems count] > 0)) {
        return;
    }
    
    // Initialize the datacontroller.
    EntryDataController* dataController = [[EntryDataController alloc] init];
    
    // Filter all incomes and add to Database.
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"type == [cd]%@",@"Income"];
    NSArray* filtered = [defaultBudgetItems filteredArrayUsingPredicate:predicate];
    if(filtered && [filtered count] > 0) {
        for(NSDictionary* item in filtered) {
            NSString* name = [item objectForKey:@"name"];
            if(name) {
                [dataController addUpdateEntryWithType:ENTRY_TYPE_INCOME
                                       transactionType:TRANSACTION_TYPE_REGULAR amount:0.0
                                               forDate:[NSDate date]
                                           description:name];
            }
        }
    }
    
    // Add all Default Expense items.
    predicate = [NSPredicate predicateWithFormat:@"type == [cd]%@",@"Expense"];
    filtered = [defaultBudgetItems filteredArrayUsingPredicate:predicate];
    if(filtered && [filtered count] > 0) {
        for(NSDictionary* item in filtered) {
            NSString* name = [item objectForKey:@"name"];
            if(name) {
                [dataController addUpdateEntryWithType:ENTRY_TYPE_EXPENSE
                                       transactionType:TRANSACTION_TYPE_REGULAR amount:0.0
                                               forDate:[NSDate date]
                                           description:name];
            }
        }
    }
}


// Returns account balance.
-(float) getAccountBalance
{
    EntryDataController* dc = [[EntryDataController alloc] init];
    return ([dc getAccountBalance]);
}

@end
