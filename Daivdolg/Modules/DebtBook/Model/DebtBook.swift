//
//  Debts.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 03/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

class DebtBook {
  
  // MARK: - Properties
  var storageManager = StorageManager.shared
  private let userDataStorage: UserDataStorage
  private let notifications: Notifications
  private let nc = NotificationCenter.default
  
  private var debts: [DebtModel] = []
  private var filteredDebts: [DebtModel] = [] {
    didSet {
        nc.post(name: Notification.Name("updateView"), object: nil)
    }
  }
  
  var isNoDebts: Bool {
    if filteredDebts.isEmpty {
      return true
    } else {
      return false
    }
  }
  
  // MARK: - Init
  init() {
    self.userDataStorage = UserDataStorage()
    self.notifications = Notifications()
    getAllDebts()
    getLendDebts()
    let isNotificationsRequired = userDataStorage.isNotificationsRequired
    if isNotificationsRequired {
      getDebtNotifications()
    }
  }
  
  // MARK: - External methods
  func countDebts() -> Int {
    return filteredDebts.count
  }
  
  func getDebts() -> [DebtModel] {
    return filteredDebts
  }
  
  func getLendDebts() {
    filteredDebts = debts.filter { $0.type == .lend }
  }
  
  func getBorrowDebts() {
    filteredDebts = debts.filter { $0.type == .borrow }
  }
  
  func addDebt(debt: DebtModel) {
    // для этого проекта норм писать сразу в CoreData
    // но если данных много и они часто обновляются,
    // то лучше в coredata записывать при сворачивании/закрытии/креше аппа
    // потому что она не очень быстрая 
    storageManager.saveDebt(debt: debt)
    debts.append(debt)
    switch debt.type {
    case .lend:
      getLendDebts()
    case .borrow:
      getBorrowDebts()
    }
  }
  
  func changeDebt(debt: DebtModel) {
    storageManager.updateDebt(debt: debt)
    switch debt.type {
    case .lend:
      getLendDebts()
    case .borrow:
      getBorrowDebts()
    }
  }
  
  func removeDebt(at indexPath: Int) {
    let debt = filteredDebts[indexPath]
    storageManager.deleteDebt(debt: debt)
    filteredDebts.remove(at: indexPath)
    let index = debts.firstIndex(of: debt)
    debts.remove(at: index!)
  }
  
  // MARK: - Private methods
  private func getAllDebts() {
    guard let savedDebts = storageManager.loadDebts() else { return }
    for savedDebt in savedDebts {
      let debt = DebtModel()
      debt.name = savedDebt.name
      debt.amount = savedDebt.amount
      debt.type = DebtType(rawValue: savedDebt.type!)!
      debt.currency = savedDebt.currency
      debt.returnDate = savedDebt.returnDate
      debt.creationDate = savedDebt.creationDate!
      debts.append(debt)
    }
  }
  
  private func getDebtNotifications() {
    let debts = self.debts.filter { $0.returnDate != nil}
    for debt in debts {
      var type = ""
      if debt.type == .lend {
        type = Constants.Texts.Debt.lend
      } else if debt.type == .borrow {
        type = Constants.Texts.Debt.borrow
      }
      guard let name = debt.name else { return }
      guard let amount = debt.amount else { return }
      guard let currency = debt.currency else { return }
      guard let date = debt.returnDate else { return }
      notifications.scheduleNotification(notificationType: type,
                                         name: name,
                                         amount: String(amount),
                                         currency: currency,
                                         returnDate: date)
    }
  }
  
}
