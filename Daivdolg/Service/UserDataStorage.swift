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
}
