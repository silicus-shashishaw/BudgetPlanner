//
//  EntryController.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BudgetPlannerConstants.h"

// forward declaration.
@class AccountSummary;


@interface EntryController : NSObject

/*!
 * @brief Initializes the default set of Income/Expense entries as read from properties file.
 */
-(void) initializeDefaultEntries;

/*!
 * @brief Returns the Account Summary as available from the Database
 * @return AccountSummary*          The current account summary.
 */
-(AccountSummary*) getAccountSummary;

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


@end
