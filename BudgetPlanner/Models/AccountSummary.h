//
//  AccountSummary.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 23/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountSummary : NSObject

// Data model to hold Account summary.
@property (assign, nonatomic) float expenses;
@property (assign, nonatomic) float incomes;
@property (assign, nonatomic) float totalBalance;

@end
