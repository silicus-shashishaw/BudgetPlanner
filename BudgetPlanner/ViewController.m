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
#import "ReportViewController.h"
#import "EntryController.h"
#import "AccountSummary.h"
#import "USDCurrencyFormatter.h"

@interface ViewController () <XLFormDescriptorDelegate, AccountDetailDelegate>
{
    // XL form for account summary
    XLFormDescriptor* accountSummaryForm;
}

@property (assign, nonatomic) BOOL isReloadRequired;

// property to hold the account summary.
@property (strong, nonatomic) AccountSummary* acccountSummary;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialize];
}



-(void) viewWillAppear:(BOOL)animated
{
    // Re initialize if reload required.
    if(self.isReloadRequired) {
        self.isReloadRequired = NO;
        [self initialize];
    }
}


-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private methods.


// Load the account summary details.
-(void) initialize
{
    EntryController* ec = [[EntryController alloc] init];
    self.acccountSummary = nil;
    self.acccountSummary = [ec getAccountSummary];
    
    // Initialize view.
    [self initializeView];
}


// intializes the default summary view.
-(void) initializeView
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
    NSNumber *number = [NSNumber numberWithFloat:self.acccountSummary.incomes];
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
    number = [NSNumber numberWithFloat:self.acccountSummary.expenses];
    strValue = [currencyFormatter stringFromNumber:number];
    row.value = strValue;
    [section addFormRow:row];
    
    // Balance.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBalanceKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kBalanceKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:self.acccountSummary.totalBalance];
    row.valueFormatter = currencyFormatter;
    [section addFormRow:row];
    
    // Report.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kReportKey
                                                rowType:XLFormRowDescriptorTypeSelectorPush
                                                  title:kReportKey];
    [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
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
        [vc setDelegate:self];
        if([formRow.tag isEqual:kIncomesKey]) {
            [vc setEntryType:ENTRY_TYPE_INCOME];
        }
        else if([formRow.tag isEqual:kExpensesKey]) {
            [vc setEntryType:ENTRY_TYPE_EXPENSE];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    // Load Report view.
    else if ([formRow.tag isEqual:kReportKey]) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ReportViewController *vc= [mainStoryboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - AccountDetailDelegate


// Reload the values on account update.
-(void) accountUpdated
{
    self.isReloadRequired = YES;
}


@end
