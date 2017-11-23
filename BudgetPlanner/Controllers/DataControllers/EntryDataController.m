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
#import "AccountSummary.h"


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
    
    // Check if an entry already exists.
    Entry* entryObject = [self getEntryOfType:entryType withDescription:description];
    if(entryObject == nil) {
        entryObject = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameEntry
                                                    inManagedObjectContext:dataController.managedObjectContext];
    }
    
    // Set properties.
    if(entryObject) {
        // Set properties for the object.
        entryObject.entryType = entryType;
        entryObject.transactionType = transactionType;
        if(date) {
            entryObject.entryDate = date;
        }
        else {
            entryObject.entryDate = [NSDate date];
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


// Returns the account summary.
-(AccountSummary*) getAccountSummary
{
    AccountSummary* summary = [[AccountSummary alloc] init];
    
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
                summary.incomes += item.amount;
            }
        }
        
        // Get all expenses.
        predicate = [NSPredicate predicateWithFormat:@"entryType == %d",
                     ENTRY_TYPE_EXPENSE];
        filteredValues = [allEntities filteredArrayUsingPredicate:predicate];
        if(filteredValues && [filteredValues count] > 0) {
            for(Entry* item in filteredValues) {
                summary.expenses += item.amount;
            }
        }
        
        // Compute balance
        summary.totalBalance = summary.incomes - summary.expenses;
    }
    return summary;
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


// Returns entries of specified Type.
-(NSArray*) getAllEntriesOfType:(EntryType)entryType
{
    // Get All entries.
    DataController* dataController = [DataController sharedInstance];
    // Get all income entries.
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"entryType == %d",
                              entryType];
    // Sorted by Description.
    NSSortDescriptor* sortOrder = [[NSSortDescriptor alloc] initWithKey:@"desc"
                                                              ascending:YES];
    NSArray* descriptors = [NSArray arrayWithObjects:sortOrder, nil];
    NSArray* allEntities = [dataController getAllEntitiesWithEntityName:kEntityNameEntry
                                                          withPredicate:predicate
                                                        sortDescriptors:descriptors];
    return allEntities;
}


// Saves the context.
-(void) saveAllObjects
{
    DataController* dataController = [DataController sharedInstance];
    [dataController saveContext];
}


#pragma mark - Private Methods.

/*!
 * @brief Returns an instance of the specified entry type with the description, else nil.
 */
-(Entry*) getEntryOfType:(EntryType)entryType
         withDescription:(NSString*)description
{
    // Ensure description is valid.
    if(!(description && [description length] > 0)) {
        return nil;
    }
    
    // Get All entries.
    DataController* dataController = [DataController sharedInstance];
    // Get all income entries.
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"entryType == %d && desc == [c]%@",
                              entryType, description];
    Entry* entry = [dataController getEntityWithName:kEntityNameEntry
                                           predicate:predicate];
    return entry;
}

@end
