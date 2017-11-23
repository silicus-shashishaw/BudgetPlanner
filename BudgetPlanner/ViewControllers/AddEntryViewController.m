//
//  AddEntryViewController.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 23/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "AddEntryViewController.h"
#import "USDCurrencyFormatter.h"
#import "EntryController.h"

@interface AddEntryViewController ()
{
    // XL form for adding a new entry.
    XLFormDescriptor* addForm;
}

@end


@implementation AddEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Check the current entry type and display appropriate form.
-(void) initializeView
{
    
    addForm = [XLFormDescriptor formDescriptorWithTitle:@"Add Entry"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // USD currency formatter.
    USDCurrencyFormatter* currencyFormatter = [[USDCurrencyFormatter alloc] init];
    
    // Filter in terms of Regular and Ad-Hoc.
    // Section Header.
    section = [XLFormSectionDescriptor formSection];
    if(self.entryType == ENTRY_TYPE_INCOME){
        section.title = @"Income Entry";
    }
    else {
        section.title = @"Expense Entry";
    }
    [addForm addFormSection:section];
    
    // Transaction Type
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTypeKey
                                                rowType:XLFormRowDescriptorTypeSelectorPickerView
                                                  title:kTypeKey];
    row.selectorTitle = @"Transaction Type";
    row.selectorOptions = [NSArray arrayWithObjects:kRegularKey, kAd_HocKey, nil];
    row.value = [row.selectorOptions objectAtIndex:0];
    [section addFormRow:row];
    
    // Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDescriptionKey
                                                rowType:XLFormRowDescriptorTypeText
                                                  title:kDescriptionKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row.cellConfigAtConfigure setObject:@"Enter description" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    
    // Amount.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAmountKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kAmountKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:0.00f];
    row.valueFormatter = currencyFormatter;
    [section addFormRow:row];
    
    // Set the form.
    self.form = addForm;
}


#pragma mark - IB Action.


// Handle Save.
-(IBAction) didTapSaveButton:(UIBarButtonItem *)sender
{
    // Ensure all field values are captured.
    [self.view endEditing:YES];
    
    // Validate form.
    if(![self isFormInputValid]) {
        return;
    }
    
    // Add a new entry.
    [self addNewEntry];
}


#pragma mark - Private Methods.


// Add a new entry to the database.
-(void) addNewEntry
{
    // Get all values and
    NSDictionary* allValues = [addForm formValues];
    
    // Reading values.
    // Description.
    NSString* desc = [allValues objectForKey:kDescriptionKey];
    
    // Transaction type.
    TransactionType type = TRANSACTION_TYPE_REGULAR;
    NSString* transactionType = [allValues objectForKey:kTypeKey];
    if(transactionType && [transactionType caseInsensitiveCompare:kAd_HocKey] == NSOrderedSame) {
        type = TRANSACTION_TYPE_AD_HOC;
    }
    
    // Amount:
    float amount = 0.0;
    NSNumber* numValue = [allValues objectForKey:kAmountKey];
    if(numValue && [numValue isKindOfClass:[NSNumber class]]) {
        amount = [numValue floatValue];
    }
    
    // Add entry into database.
    EntryController* ec = [[EntryController alloc] init];
    [ec addUpdateEntryWithType:self.entryType
               transactionType:type
                        amount:amount
                       forDate:[NSDate date]
                   description:desc];
    
    // Notify add.
    if(self.addDelegate && [self.addDelegate respondsToSelector:@selector(newEntryAdded)]) {
        [self.addDelegate newEntryAdded];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


// Validate Input form
-(BOOL) isFormInputValid
{
    // Check if any required fields are missing.
    NSArray * errorFieldarray = [self formValidationErrors];
    if (errorFieldarray.count == 0) {
        return YES;
    }
    
    // Iteretate on errorField to display the errors to the Patient
    [errorFieldarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        NSString* title = validationStatus.rowDescriptor.title;
        NSString* msg = validationStatus.msg;
        
        // Create controller.
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:title
                                                                    message:msg
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        // Create Action
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
        }];
        
        // add action.
        [ac addAction:ok];

        // Show Error.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:ac animated:YES completion:nil];
        });
        *stop = YES;    // Stop enumerating
        return;
    }];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
