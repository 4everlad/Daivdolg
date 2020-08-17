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
        notificationCenter.post(name: Notification.Name("updateView"), object: nil)
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
    let convertedDebt = convertDebt(debt: debt)
    storageManager.saveDebt(debt: convertedDebt)
    debts.append(debt)
    switch debt.type {
    case .lend:
      getLendDebts()
    case .borrow:
      getBorrowDebts()
    }
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
    let convertedDebt = convertDebt(debt: debt)
    storageManager.updateDebt(debt: convertedDebt)
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
        debt.description = savedDebt.descrption
      debt.returnDate = savedDebt.returnDate
      debt.creationDate = savedDebt.creationDate!
      debts.append(debt)
    }
  }
  
  private func convertAllDebts() {
    for debt in debts {
      if let debtAmount = debt.amount, let from = debt.currency {
        let amount = String(debtAmount)
        if from != mainCurrency {
          convertCurrency(amount: amount, from: from, to: mainCurrency, completionHandler: { currencyRate in
            if let currencyRate = currencyRate {
              debt.convertedAmount = debtAmount * currencyRate
              self.notificationCenter.post(name: Notification.Name("updateView"), object: nil)
            }
          })
        }
      }
    }
  }
  
  private func convertDebt(debt: DebtModel) -> DebtModel {
    guard let debtAmount = debt.amount, let from = debt.currency else { return debt }
    let amount = String(debtAmount)
    if from != mainCurrency {
      convertCurrency(amount: amount, from: from, to: mainCurrency, completionHandler: { currencyRate in
        if let currencyRate = currencyRate {
          debt.convertedAmount = debtAmount * currencyRate
          self.notificationCenter.post(name: Notification.Name("updateView"), object: nil)
        }
      })
    }
    return debt
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
