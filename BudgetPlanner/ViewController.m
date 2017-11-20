//
//  ViewController.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "ViewController.h"
#import "BudgetPlannerConstants.h"

@interface ViewController () <XLFormDescriptorDelegate>
{
    // XL form for account summary
    XLFormDescriptor* accountSummaryForm;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private methods.


// intializes the default summary view.
-(void) initialize
{
    accountSummaryForm = [XLFormDescriptor formDescriptorWithTitle:@"Parts"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Section Header.
    section = [XLFormSectionDescriptor formSection];
    section.title = @"Account Summary";
    [accountSummaryForm addFormSection:section];
    
    // Income.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kIncomesKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kIncomesKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:1.00f];
    [section addFormRow:row];

    // Expenses.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kExpensesKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kExpensesKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:1.00f];
    [section addFormRow:row];
    
    // Total.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTotalKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kTotalKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:1.00f];
    [section addFormRow:row];
    
    
    // Set the form.
    self.form = accountSummaryForm;
}


@end
