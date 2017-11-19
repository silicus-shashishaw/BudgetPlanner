//
//  EntryDataController.m
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import "EntryDataController.h"
#import "DataController.h"
#import "Entry.h"
#import "BudgetPlannerConstants.h"


@implementation EntryDataController

// Adds/Updates a transaction entry.
-(BOOL) addUpdateEntryWithType:(EntryType)entryType
               transactionType:(TransactionType)transactionType
                        amount:(float)amount
                       forDate:(NSDate*)date
                   description:(NSString*)description
{
    // Get a handle to the database controller and insert a new record.
    DataController* dataController = [DataController sharedInstance];
    Entry* entryObject = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameEntry
                                                       inManagedObjectContext:dataController.managedObjectContext];
    if(entryObject) {
        // Set properties for the object.
        entryObject.entryType = entryType;
        entryObject.transactionType = transactionType;
        if(date) {
            entryObject.entryDate = date;
        }
        entryObject.amount = amount;
        if(description){
            entryObject.desc = description;
        }
        // Save to database..
        [dataController saveContext];
        return YES;
    }
    return NO;
}


// Returns the current ledger balance for the account.
-(float) getAccountBalance
{
    float balance = 0.0f;
    float totalIncome = 0.0f;
    float totalExpense = 0.0f;
    
    // Get All entries.
    DataController* dataController = [DataController sharedInstance];
    NSArray* allEntities = [dataController getAllEntitiesWithEntityName:kEntityNameEntry
                                                          withPredicate:nil
                                                        sortDescriptors:nil];
    if(allEntities && [allEntities count] > 0){
        // Get all income entries.
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"entryType == %d",
                                  ENTRY_TYPE_INCOME];
        NSArray* filteredValues = [allEntities filteredArrayUsingPredicate:predicate];
        if(filteredValues && [filteredValues count] > 0) {
            for(Entry* item in filteredValues) {
                totalIncome += item.amount;
            }
        }
        
        // Get all expenses.
        predicate = [NSPredicate predicateWithFormat:@"entryType == %d",
                     ENTRY_TYPE_EXPENSE];
        filteredValues = [allEntities filteredArrayUsingPredicate:predicate];
        if(filteredValues && [filteredValues count] > 0) {
            for(Entry* item in filteredValues) {
                totalExpense += item.amount;
            }
        }
        
        // Compute balance
        balance = totalIncome - totalExpense;
    }
    return balance;
}

@end
