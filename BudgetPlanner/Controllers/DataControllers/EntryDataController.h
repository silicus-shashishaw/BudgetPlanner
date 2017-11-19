//
//  EntryDataController.h
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BudgetPlannerConstants.h"

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
 * @brief Returns the current account balance.
 * @return float                    The current amount with the Bank.
 */
-(float) getAccountBalance;


@end
