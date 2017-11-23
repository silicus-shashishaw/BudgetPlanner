//
//  AccountDetailViewController.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 20/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "BudgetPlannerConstants.h"

// Delegate to notify save occured.
@protocol AccountDetailDelegate <NSObject>

// callback to notify that account was updated.
-(void) accountUpdated;

@end


/*!
 * @brief Class to manage account details.
 */
@interface AccountDetailViewController : XLFormViewController

// Type used to display appropriate form.
@property (assign, nonatomic) EntryType entryType;

// Delegate reference to notify update.
@property (weak, nonatomic) id<AccountDetailDelegate> delegate;

@end
