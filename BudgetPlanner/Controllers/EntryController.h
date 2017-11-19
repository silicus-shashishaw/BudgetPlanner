//
//  EntryController.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryController : NSObject


/*!
 * @brief Initializes the default set of Income/Expense entries as read from properties file.
 */
-(void) initializeDefaultEntries;

/*!
 * @brief Returns the current account balance.
 * @return float                    The current balance amount as available in the database.
 */
-(float) getAccountBalance;


@end
