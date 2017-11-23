//
//  EntryDataController.h
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BudgetPlannerConstants.h"

@class AccountSummary;

@interface EntryDataController : NSObject

/*!
 * @brief Adds an Adhoc transaction entry, where as add/updates a regular transaction based on the description passed.
 * @param  entryType                The entry type of Income or Expense.
 * @param  transactionType          The transaction Type (Regular or AdHoc).
 * @param  amount                   The amount of money in the entry.
 * @param  date                     The date of the entry
 * @param  description              The description for the entry.
 * @return BOOL                     Returns YES on success, NO otherwise.
 */
-(BOOL) addUpdateEntryWithType:(EntryType)entryType
               transactionType:(TransactionType)transactionType
                        amount:(float)amount
                       forDate:(NSDate*)date
                   description:(NSString*)description;

/*!
 * @brief Returns the Account Summary as available from the Database
 * @return AccountSummary*          The current account summary.
 */
-(AccountSummary*) getAccountSummary;


/*!
 * @brief Returns the current account balance.
 * @return float                    The current amount with the Bank.
 */
-(float) getAccountBalance;

/*!
 * @brief Returns all entries of specified entry type.
 * @param  entryType                The type of the entries to be return either Income or Expense.
 * @return NSArray*                 An array of all entries of specified type.
 */
-(NSArray*) getAllEntriesOfType:(EntryType)entryType;

/*!
 * @brief Performs a save on all the objects in the context.
 */
-(void) saveAllObjects;


@end
