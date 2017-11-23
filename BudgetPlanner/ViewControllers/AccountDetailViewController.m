//
//  AccountDetailViewController.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 20/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "EntryDataController.h"
#import "Entry.h"
#import "AddEntryViewController.h"
#import "USDCurrencyFormatter.h"

@interface AccountDetailViewController ()<AddEntryDelegate>
{
    // XL form for details
    XLFormDescriptor* detailForm;
}

// Flag used to refresh screen.
@property (assign, nonatomic) BOOL isReloadRequired;

// Array to hold the entries.
@property (strong, nonatomic) NSArray* entries;

@end

@implementation AccountDetailViewController

// String Constants

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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


// Initialize the data model to be loaded.
-(void) initialize
{
    EntryDataController* dc = [[EntryDataController alloc] init];
    self.entries = [dc getAllEntriesOfType:self.entryType];
    
    // Initialize the view.
    [self initializeView];
}


// Check the current entry type and display appropriate form.
-(void) initializeView
{
    NSString* title = nil;
    if(self.entryType == ENTRY_TYPE_INCOME) {
        title = @"Incomes";
    }
    else {
        title = @"Expenses";
    }
    
    // Set the title
    self.title = title;
    
    detailForm = [XLFormDescriptor formDescriptorWithTitle:title];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // USD currency formatter.
    USDCurrencyFormatter* currencyFormatter = [[USDCurrencyFormatter alloc] init];
    
    // Filter in terms of Regular and Ad-Hoc.
    // Section Header.
    float total = 0.0;
    section = [XLFormSectionDescriptor formSection];
    section.title = kRegularKey;
    [detailForm addFormSection:section];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"transactionType == %d",
                              TRANSACTION_TYPE_REGULAR];
    NSArray* filteredList = [self.entries filteredArrayUsingPredicate:predicate];
    if(filteredList && [filteredList count] > 0) {
        
        // Loading Regular items.
        for(Entry* entry in filteredList) {
            // Desc.
            row = [XLFormRowDescriptor formRowDescriptorWithTag:entry.desc
                                                        rowType:XLFormRowDescriptorTypeDecimal
                                                          title:entry.desc];
            [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
            row.value = [NSNumber numberWithFloat:entry.amount];
            total += entry.amount;
            row.valueFormatter = currencyFormatter;
            [section addFormRow:row];
        }
    }
    // Total.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTotalKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kTotalKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:total];
    row.valueFormatter = currencyFormatter;
    row.disabled = @YES;
    [section addFormRow:row];
    
    
    // Load Ad Hoc Items.
    // Section Header.
    total = 0.0;
    section = [XLFormSectionDescriptor formSection];
    section.title = kAd_HocKey;
    [detailForm addFormSection:section];
    
    predicate = [NSPredicate predicateWithFormat:@"transactionType == %d",
                 TRANSACTION_TYPE_AD_HOC];
    filteredList = [self.entries filteredArrayUsingPredicate:predicate];
    if(filteredList && [filteredList count] > 0) {
        
        // Loading Regular items.
        for(Entry* entry in filteredList) {
            // Desc.
            row = [XLFormRowDescriptor formRowDescriptorWithTag:entry.desc
                                                        rowType:XLFormRowDescriptorTypeDecimal
                                                          title:entry.desc];
            [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
            row.value = [NSNumber numberWithFloat:entry.amount];
            total += entry.amount;
            row.valueFormatter = currencyFormatter;
            [section addFormRow:row];
        }
    }
    // Total.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTotalKey
                                                rowType:XLFormRowDescriptorTypeDecimal
                                                  title:kTotalKey];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = [NSNumber numberWithFloat:total];
    row.valueFormatter = currencyFormatter;
    row.disabled = @YES;
    [section addFormRow:row];
    
    // Set the form.
    self.form = detailForm;
}


#pragma mark - IBActions


// Save the form.
-(IBAction) didTapSave:(UIBarButtonItem *)sender
{
    // Ensure all field values are captured.
    [self.view endEditing:YES];
    
    // Update
    NSArray* allSections = [detailForm formSections];
    for(XLFormSectionDescriptor* section in allSections){
        
        // Set the type.
        TransactionType type = TRANSACTION_TYPE_REGULAR;
        if([section.title caseInsensitiveCompare:kAd_HocKey] == NSOrderedSame) {
            type = TRANSACTION_TYPE_AD_HOC;
        }
        
        // Update row values in Db.
        NSPredicate* predicate = nil;
        NSArray* allRows = [section formRows];
        for(XLFormRowDescriptor* row in allRows) {
            NSString* rowDesc = row.title;
            NSNumber* rowValue = row.value;
            
            // Select only the actual rows.. Not the 'Total' row.
            if([rowDesc caseInsensitiveCompare:kTotalKey] != NSOrderedSame) {
                float amount = 0.0;
                if(rowValue && [rowValue isKindOfClass:[NSNumber class]]) {
                    amount = [rowValue floatValue];
                }
                predicate = [NSPredicate predicateWithFormat:@"desc == [c]%@ && transactionType == %d",
                             rowDesc, type];
                NSArray* result = [self.entries filteredArrayUsingPredicate:predicate];
                if(result && [result count] > 0) {
                    Entry* currentEntry = [result firstObject];
                    currentEntry.amount = amount;
                }
            }
        }
    }
    
    // Save the form
    EntryDataController* dc = [[EntryDataController alloc] init];
    [dc saveAllObjects];
    
    // Notify, navigate back to previous screen.
    if(self.delegate && [self.delegate respondsToSelector:@selector(accountUpdated)]) {
        [self.delegate accountUpdated];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}


// Handle add action.
-(IBAction) didTapAddButton:(UIBarButtonItem *)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AddEntryViewController *vc= [mainStoryboard instantiateViewControllerWithIdentifier:@"AddEntryViewController"];
    [vc setEntryType:self.entryType];
    [vc setAddDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - XLFormDescriptorDelegate


// Handle change in Quantity or Unit Price.
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    
    if([formRow.title caseInsensitiveCompare:kTotalKey] != NSOrderedSame) {
        // Get the Total Row for the current section and update its value.
        XLFormSectionDescriptor* currentSection =  formRow.sectionDescriptor;
        NSArray* rows = currentSection.formRows;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tag == [c]%@",kTotalKey];
        NSArray* filteredList = [rows filteredArrayUsingPredicate:predicate];
        if(filteredList && [filteredList count]  > 0) {
            
            float previous = 0.0;
            if(oldValue && [oldValue isKindOfClass:[NSNumber class]]) {
                previous = [oldValue floatValue];
            }
            
            float next = 0.0;
            if(newValue && [newValue isKindOfClass:[NSNumber class]]) {
                next = [newValue floatValue];
            }
            
            XLFormRowDescriptor* totalRow = [filteredList firstObject];
            float currentValue = [totalRow.value floatValue];
            float result = currentValue + next - previous;
            totalRow.value = [NSNumber numberWithFloat:result];
            [self reloadFormRow:totalRow];
        }
    }
}


#pragma mark - AddEntryDelegate

// Notifies new entry added.
-(void) newEntryAdded
{
    self.isReloadRequired = YES;
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
