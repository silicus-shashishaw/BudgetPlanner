//
//  USDCurrencyFormatter.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 20/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @brief Utility class to provide '$' formatting for Decimal Numbers.
 */
@interface USDCurrencyFormatter : NSNumberFormatter

/*!
 * @brief Overrides the init method.
 * @return USDCurrencyFormatter*                Returns an instance of USD number formatter.
 */
-(USDCurrencyFormatter*) init;

@end
