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
  private let userDataStorage = UserDataStorage.shared
  private let requestFetcher = APIRequestFetcher.shared
  private let notifications = Notifications.shared
  private let notificationCenter = NotificationCenter.default
  
  private var debts: [DebtModel] = []
  private var filteredDebts: [DebtModel] = [] {
    didSet {
        notificationCenter.post(name: Notification.Name("updateTableView"), object: nil)
    }
  }
  
  var mainCurrency: String {
    didSet {
      convertAllDebts()
    }
  }
  var currentDebtType: DebtType = .lend
  
  var isNoDebts: Bool {
    if filteredDebts.isEmpty {
      return true
    } else {
      return false
    }
  }
  
  // MARK: - Init
  init() {
    mainCurrency = userDataStorage.mainCurrency
    getAllDebts()
    getLendDebts()
    convertAllDebts()
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
    convertDebt(debt: debt, completionHandler: { debt in
      self.storageManager.saveDebt(debt: debt)
      self.debts.append(debt)
      switch debt.type {
      case .lend:
        self.getLendDebts()
      case .borrow:
        self.getBorrowDebts()
      }
    })
  }
  
  func getNewDebt() -> DebtModel {
    switch currentDebtType {
    case .lend:
      let debtModel = DebtModel(type: .lend)
      return debtModel
    case .borrow:
      let debtModel = DebtModel(type: .borrow)
      return debtModel
    }
  }
  
  func changeDebt(debt: DebtModel) {
    convertDebt(debt: debt, completionHandler: { debt in
      self.storageManager.updateDebt(debt: debt)
      switch debt.type {
      case .lend:
        self.getLendDebts()
      case .borrow:
        self.getBorrowDebts()
      }
    })
  }
  
  func removeDebt(at indexPath: Int) {
    let debt = filteredDebts[indexPath]
    storageManager.deleteDebt(debt: debt)
    filteredDebts.remove(at: indexPath)
    let index = debts.firstIndex(of: debt)
    debts.remove(at: index!)
  }
  
  func changeMainCurrency() {
    let newMainCurrency = userDataStorage.mainCurrency
    if mainCurrency != newMainCurrency {
      mainCurrency = newMainCurrency
    }
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
        debt.description = savedDebt.descrption
      debt.returnDate = savedDebt.returnDate
      debt.creationDate = savedDebt.creationDate!
      debts.append(debt)
    }
  }
  
  private func convertAllDebts() {
    for debt in debts {
      convertDebt(debt: debt, completionHandler: { newDebt in
        debt.convertedAmount = newDebt.convertedAmount
      })
    }
  }
  
  private func convertDebt(debt: DebtModel, completionHandler: @escaping(DebtModel) -> Void) {
    guard let debtAmount = debt.amount, let from = debt.currency else { return }
    let amount = String(debtAmount)
    if from != mainCurrency {
      convertCurrency(amount: amount, from: from, to: mainCurrency, completionHandler: { currencyRate in
        if let currencyRate = currencyRate {
          debt.convertedAmount = debtAmount * currencyRate
          self.notificationCenter.post(name: Notification.Name("updateTableView"), object: nil)
          completionHandler(debt)
        }
      })
    } else {
        debt.convertedAmount = nil
        completionHandler(debt)
    }
  }
  
  private func convertCurrency(amount: String, from: String, to: String, completionHandler: @escaping(Float?) -> Void) {
    requestFetcher.fetchConvertedCurrency(amount: amount, from: from, to: to, completionHandler: { result in
      switch result {
      case .success(let convertedCurrency):
        let amount = convertedCurrency.amount
        completionHandler(amount)
      case .failure(let error):
        print(error.localizedDescription)
        completionHandler(nil)
      }
    })
    
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
        
      guard let name = debt.name,
        let amount = debt.amount,
        let currency = debt.currency,
        let date = debt.returnDate else { return }
      notifications.scheduleNotification(notificationType: type,
                                         name: name,
                                         amount: String(amount),
                                         currency: currency,
                                         returnDate: date)
    }
  }
  
}
