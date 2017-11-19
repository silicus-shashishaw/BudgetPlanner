//
//  BudgetPlannerConstants.h
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants for the type of ENTRY.
typedef enum
{
    ENTRY_TYPE_INCOME,
    ENTRY_TYPE_EXPENSE
    
} EntryType;


// Constants for the nature of the transaction.
typedef enum
{
    // Regular monthly/periodic transactions.
    TRANSACTION_TYPE_REGULAR,
    // Irregular but proper transactions.
    TRANSACTION_TYPE_AD_HOC,
    // Irregular where only the current balance is updated.
    TRANSACTION_TYPE_MANUAL
} TransactionType;


// Database entity types.
FOUNDATION_EXPORT NSString* const kEntityNameEntry;



