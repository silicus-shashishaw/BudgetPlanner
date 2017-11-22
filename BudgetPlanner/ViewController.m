//
//  ViewController.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "ViewController.h"
#import "BudgetPlannerConstants.h"
#import "AccountDetailViewController.h"
#import "USDCurrencyFormatter.h"

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
    accountSummaryForm = [XLFormDescriptor formDescriptorWithTitle:@"Budget Planner"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Section Header.
    section = [XLFormSectionDescriptor formSection];
    section.title = kAccount_SummaryKey;
    [accountSummaryForm addFormSection:section];
    
    // USD currency formatter.
    USDCurrencyFormatter* currencyFormatter = [[USDCurrencyFormatter alloc] init];
    
    // Income.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kIncomesKey
                                                rowType:XLFormRowDescriptorTypeSelectorPush
                                                  title:kIncomesKey];
    // Set the income value and format it.
    NSNumber *number = [NSNumber numberWithFloat:3000000.00];
    NSString *strValue = [currencyFormatter stringFromNumber:number];
    row.value = strValue;
    [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [section addFormRow:row];

    // Expenses.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kExpensesKey
                                                rowType:XLFormRowDescriptorTypeSelectorPush
                                                  title:kExpensesKey];
    [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    // Set expense value.
    number = [NSNumber numberWithFloat:7000.00];
    strValue = [currencyFormatter stringFromNumber:number];
    row.value = strValue;
    [section addFormRow:row];
    
    // Total.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTotalKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kTotalKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:1.00f];
    row.valueFormatter = currencyFormatter;
    [section addFormRow:row];
    
    
    // Set the form.
    self.form = accountSummaryForm;
}


#pragma mark - XLFormViewControllerDelegate methods

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    [super didSelectFormRow:formRow];
    
    // Load Details view.
    if ([formRow.tag isEqual:kIncomesKey] ||
        [formRow.tag isEqual:kExpensesKey]) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        AccountDetailViewController *vc= [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountDetailsViewController"];
        if([formRow.tag isEqual:kIncomesKey]) {
            [vc setEntryType:ENTRY_TYPE_INCOME];
        }
        else if([formRow.tag isEqual:kExpensesKey]) {
            [vc setEntryType:ENTRY_TYPE_EXPENSE];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
