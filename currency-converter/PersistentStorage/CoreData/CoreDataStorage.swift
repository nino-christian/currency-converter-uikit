//
//  CoreDataStorage.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import Foundation
import CoreData

protocol CoreDataStorageProtocol: AnyObject {
    func saveContext()
    func performBackgroundTask(_ callBlock: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataStorage: CoreDataStorageProtocol{
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyCoreModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CurrencyCoreModel Unresolved error \(error), \(error.userInfo)")
            }
            print("Data Core Model has successfully loaded")
        }
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                assertionFailure("CurrencyCoreModel Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ callBlock: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(callBlock)
    }
    
}

