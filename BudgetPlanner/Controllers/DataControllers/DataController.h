//
//  DataController.h
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*!
 * @brief Singleton class which facilitates operations to the local CoreData based
 *        Database. (SQLite).
 */
@interface DataController : NSObject

// Disabling alloc init.
-(instancetype) __unavailable init;


/// Singleton instance handle shared by the class.
+(DataController*) sharedInstance;


/// Core Data Stack entities.
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Save the current content.
-(void) saveContext;



//-----------------------------------------------------------------------------------------------------
//
//                                      Helper Methods.
//
//-----------------------------------------------------------------------------------------------------


/*!
 * @brief Returns the specified entity if available in the Database.
 * @param  entityName                   The name of the entity to be fetched.
 * @return NSManagedObject*             The required object.
 */
-(id) getEntityWithName:(NSString*)entityName;

/*!
 * @brief Returns the specified entity if available in the Database.
 * @param  entityName                   The name of the entity to be fetched.
 * @param  predicate                    The predicate for the requested entity.
 * @return NSManagedObject*             The required object.
 */
-(id) getEntityWithName:(NSString*)entityName predicate:(NSPredicate*)predicate;

/*!
 * @brief Returns an array of CoreData entities of specified 'EntityName',
 *        sorted and filtered based on parameters passed.
 * @param  entityName       Name of CoreData entity whose list is to be fetched.
 * @param  predicate        The fitering criteria to be applied, can be nil.
 * @param  sortDescriptors  Array of 'SortDecriptors' to perform sorting of the items to be loaded.
 * @return NSArray          An NSArray of requested Entity objects, else nil.
 */
-(NSArray*) getAllEntitiesWithEntityName:(NSString*)entityName
                           withPredicate:(NSPredicate*)predicate
                         sortDescriptors:(NSArray*)sortDescriptors;

// Removes all data (Deletes the store and recreates it).
-(void) resetAllUserData;

@end

