//
//  DataManager.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 13/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StorageManager {
  
  private var context: NSManagedObjectContext!
  static let shared = StorageManager()
  var coreDataStack: CoreDataStack

  func loadDebts() -> [Debt]? {
    var debts = [Debt]()
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
    request.returnsObjectsAsFaults = false
    do {
      guard let result = try context.fetch(request) as? [Debt] else { return nil }
      debts = result
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    return debts
  }

  func saveDebt(debt: DebtModel) {
    guard let insertNewDebt = NSEntityDescription.insertNewObject(forEntityName: "Debt",
                                                                  into: context) as? Debt else { return }
    insertNewDebt.name = debt.name
    insertNewDebt.type = debt.type.rawValue
    if let amount = debt.amount {
      insertNewDebt.amount = amount
    }
    insertNewDebt.currency = debt.currency
    if let description = debt.description {
      insertNewDebt.descrption = debt.description
    }
    if let returnDate = debt.returnDate {
      insertNewDebt.returnDate = returnDate
    }
    insertNewDebt.creationDate = debt.creationDate
    performSave()
  }
  
  func updateDebt(debt: DebtModel) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
    let predicate = NSPredicate(format: "creationDate = %@", debt.creationDate as CVarArg)
    fetchRequest.includesPropertyValues = false
    fetchRequest.predicate = predicate
    do {
      let result = try context.fetch(fetchRequest)
      guard let object = result[0] as? NSManagedObject else { return }
      guard let newDebt = object as? Debt else { return }
      newDebt.name = debt.name
      newDebt.type = debt.type.rawValue
      if let amount = debt.amount {
        newDebt.amount = amount
      }
      newDebt.currency = debt.currency
      if let description = debt.description {
        newDebt.descrption = debt.description
      }
      if let returnDate = debt.returnDate {
        newDebt.returnDate = returnDate
      }
      newDebt.creationDate = debt.creationDate
      performSave()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  func deleteDebt(debt: DebtModel) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
    let predicate = NSPredicate(format: "creationDate = %@", debt.creationDate as CVarArg)
    fetchRequest.includesPropertyValues = false
    fetchRequest.predicate = predicate
    do {
      guard let result = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
        for debt in result {
            context.delete(debt)
        }
        performSave()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }

  private func performSave() {
    do {
        try context.save()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }

  init() {
    self.coreDataStack = CoreDataStack()
    context = coreDataStack.persistentContainer.viewContext
  }

}
