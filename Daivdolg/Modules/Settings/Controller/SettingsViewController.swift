//
//  SettingsViewController.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 22/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet private weak var authenticationSwitch: UISwitch!
  @IBOutlet private weak var notificationsSwitch: UISwitch!
  
  private let userDataStorage = UserDataStorage()
  private let authenticationService = AuthenticationService()
  private let notifications = Notifications()
  private var state = AuthenticationState.loggedOut
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Constants.Texts.Settings.title
    // дубликат
    if userDataStorage.isAuthenticationRequired {
      authenticationSwitch.isOn = true
    } else {
      authenticationSwitch.isOn = false
    }
    if userDataStorage.isNotificationsRequired {
      notificationsSwitch.isOn = true
    } else {
      notificationsSwitch.isOn = false
    }
  }
  
  // MARK: - Actions
  @IBAction private func localAuthenticationSwitched(_ sender: Any) {
    authenticationService.getAuthenticated {
      self.changeAuthSetting()
    }
  }
  
  @IBAction private func debtsNotificationsSwitched(_ sender: Any) {
    if notificationsSwitch.isOn {
      notifications.requestAutorization()
      userDataStorage.isNotificationsRequired = true
    } else if !notificationsSwitch.isOn { // ненужное условие!!!
      userDataStorage.isNotificationsRequired = false
    }
  }
  
  // MARK: - Private methods
  private func changeAuthSetting() {
    if self.authenticationSwitch.isOn {
      userDataStorage.isAuthenticationRequired = true
      state = .loggedIn
    } else if !self.authenticationSwitch.isOn { // ненужное условие!!!
      userDataStorage.isAuthenticationRequired = false
      state = .loggedOut
    }
  }
  


}
