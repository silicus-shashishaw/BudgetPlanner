//
//  DataController.m
//  BudgetPlanner
//
//  Created by Saoirse on 11/18/17.
//  Copyright © 2017 Crossover. All rights reserved.
//

#import "DataController.h"

@interface DataController()

@end


@implementation DataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static DataController *sharedInstance = nil;

+(DataController*) sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}


#pragma mark - Core Data Life Cycle.


// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
-(NSManagedObjectContext*) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
-(NSManagedObjectModel*) managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BudgetPlanner" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
-(NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BudgetPlanner.sqlite"];
    
    // Change for core data migration - lightweight.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


// Returns the URL to the application's Documents directory.
-(NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Public methods.


-(void) saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Helper Methods.

// Fetch the requested entity.
-(id) getEntityWithName:(NSString*)entityName
{
    NSManagedObject* result = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    
    // Execute fetch request.
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
                                                     error:&error];
    if (fetchedObjects && [fetchedObjects count] > 0){
        result = fetchedObjects[0];
    }
    return result;
}


// Returns the Entity with the specified entity name and predicate.
-(id) getEntityWithName:(NSString*)entityName predicate:(NSPredicate*)predicate
{
    // Validate entity.
    BOOL valid = NO;
    if(entityName && [entityName length] > 0){
        valid = YES;
    }
    if(!valid){
        return nil;
    }
    
    NSManagedObject* result = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    
    // Set predicate
    if(predicate && [predicate isKindOfClass:[NSPredicate class]]){
        [fetchRequest setPredicate:predicate];
    }
    
    
    // Execute fetch request.
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
                                                     error:&error];
    if (fetchedObjects && [fetchedObjects count] > 0){
        result = fetchedObjects[0];
    }
    return result;
}


// A generic method to fetch an array of entities.
-(NSArray*) getAllEntitiesWithEntityName:(NSString*)entityName
                           withPredicate:(NSPredicate*)predicate
                         sortDescriptors:(NSArray*)sortDescriptors
{
    // Validate entity.
    BOOL valid = NO;
    if(entityName && [entityName length] > 0){
        valid = YES;
    }
    if(!valid){
        return nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    
    // Set predicate
    if(predicate && [predicate isKindOfClass:[NSPredicate class]]){
        [fetchRequest setPredicate:predicate];
    }
    
    // Set sort descriptors.
    if(sortDescriptors &&
       [sortDescriptors isKindOfClass:[NSArray class]] &&
       [sortDescriptors count] > 0){
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    // Execute fetch request.
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
                                                     error:&error];
    return fetchedObjects;
}


// Removes all content. Delete the database and recreates it.
-(void) resetAllUserData
{
    __block NSError * error;
    // retrieve the store URL
    NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    NSLog(@"%@",[storeURL absoluteString]);
    
    // lock the current context
    [self.managedObjectContext performBlockAndWait:^{
        
        // to drop pending changes
        [self.managedObjectContext reset];
        
        // delete the store from the current managedObjectContext
        if ([[self.managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error]){
            // remove the file containing the data
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
            // recreate the persistent store
            [[self.managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        }
    }];
}


@end
