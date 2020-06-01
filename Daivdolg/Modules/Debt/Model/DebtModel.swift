//
//  Debt.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 22/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

class DebtModel {
  var name: String?
  var type: DebtType
  var amount: Float?
  var currency: String?
  var returnDate: Date?
  var creationDate: Date
  
  //  следовал принципу инкапсуляции
  func setContactName(name: String) {
    self.name = name
  }
  
  //  Так как это базовая модель с полями, могут ли быть тут функции для проверки, или ее нужно перенести в контроллер
  func isDebtReadyToCreate() -> Bool {
    if name != nil && amount != nil {
      return true
    }
    return false
  }
  
  init() {
    self.type = .lend
    self.creationDate = Date()
    self.currency = "RUB"
  }
}

enum DebtType: String {
  case lend
  case borrow 
}

extension DebtModel: Equatable {
  static func == (lhs: DebtModel, rhs: DebtModel) -> Bool {
    return lhs.creationDate == rhs.creationDate
  }
}
