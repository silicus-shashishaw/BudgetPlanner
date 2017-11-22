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

@interface AccountDetailViewController : XLFormViewController

// Type used to display appropriate form.
@property (assign, nonatomic) EntryType entryType;

@end
