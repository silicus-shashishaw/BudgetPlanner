//
//  SettingsController.h
//  BudgetPlanner
//
//  Created by Shashi Shaw on 19/11/17.
//  Copyright © 2017 Saoirse. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @brief Class to manage persistent storage for app settings and other details.
 */
@interface SettingsController : NSObject

// Disabling alloc init.
-(instancetype) __unavailable init;

/*!
 * @brief Returns the shared instance of the settings controller.
 * @return  SettingsController*         Returns a shared instance of the settings controller.
 */
+(SettingsController*) sharedInstance;

// Flag to indicate if the app is being used first time.
@property (assign,nonatomic) BOOL isFirstUse;

@end
