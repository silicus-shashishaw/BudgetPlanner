//
//  USDCurrencyFormatter.m
//  BudgetPlanner
//
//  Created by Shashi Shaw on 20/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import "USDCurrencyFormatter.h"

@implementation USDCurrencyFormatter

// Initializer.
- (USDCurrencyFormatter*) init
{
    self = [super init];
    if (self) {
        [self setNumberStyle:NSNumberFormatterCurrencyStyle];
        [self setCurrencyCode:@"USD"];
        [self setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [self setGeneratesDecimalNumbers:YES];
        [self setUsesGroupingSeparator:YES];
        [self setGroupingSize:3];
    }
    return self;
}


@end
