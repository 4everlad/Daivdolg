//
//  UserDataStorage.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 28/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

class UserDataStorage {
  
  static let shared = UserDataStorage()
  private let userDefaults: UserDefaults
  
  struct UserDefaultsKeys {
    static let isAuthenticationRequired = "isAuthenticationRequired"
    static let isNotificationsRequired = "isNotificationsRequired"
    static let currentDebtType = "currentDebtType"
  }
  
  required init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
  }
  
  var isAuthenticationRequired: Bool {
    get {
      return userDefaults.bool(forKey: UserDefaultsKeys.isAuthenticationRequired)
    }
    set {
      userDefaults.set(newValue, forKey: UserDefaultsKeys.isAuthenticationRequired)
    }
  }
  
  var isNotificationsRequired: Bool {
    get {
      return userDefaults.bool(forKey: UserDefaultsKeys.isNotificationsRequired)
    }
    set {
      userDefaults.set(newValue, forKey: UserDefaultsKeys.isNotificationsRequired)
    }
  }
  
  var currentDebtType: DebtType? {
    get {
      guard let debtType = UserDefaults.standard.value(forKey: UserDefaultsKeys.currentDebtType) as? String else {
        return nil
      }
      return DebtType(rawValue: debtType)
    }
    set(debtType) {
      UserDefaults.standard.set(debtType?.rawValue, forKey: UserDefaultsKeys.currentDebtType)
    }
  }
}
