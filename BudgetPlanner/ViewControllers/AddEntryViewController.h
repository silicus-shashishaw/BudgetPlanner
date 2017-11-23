//
//  AddEntryViewController.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 23/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm.h>
#import "BudgetPlannerConstants.h"

// Delegate to notify new entry added.
@protocol AddEntryDelegate <NSObject>

// callback to notify new entry added.
-(void) newEntryAdded;

@end

@interface AddEntryViewController : XLFormViewController

// Type used to display appropriate form.
@property (assign, nonatomic) EntryType entryType;

// Delegate to notify event.
@property (weak, nonatomic) id<AddEntryDelegate> addDelegate;

@end
