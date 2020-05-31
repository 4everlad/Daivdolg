//
//  CoreDataStack.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 24/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Daivdolg")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}
