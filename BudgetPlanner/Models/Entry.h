//
//  Entry.h
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Entry : NSManagedObject

@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSDate *entryDate;
@property (nonatomic) int16_t entryType;
@property (nonatomic) int16_t transactionType;
@property (nonatomic) float amount;

@end

NS_ASSUME_NONNULL_END
