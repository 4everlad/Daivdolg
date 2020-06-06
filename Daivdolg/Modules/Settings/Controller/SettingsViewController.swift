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
  
  private let userDataStorage = UserDataStorage.shared
  private let authenticationService = AuthenticationService.shared
  private let notifications = Notifications.shared
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Constants.Texts.Settings.title
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
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
    } else if !notificationsSwitch.isOn {
      userDataStorage.isNotificationsRequired = false
    }
  }
  
  // MARK: - Private methods
  private func changeAuthSetting() {
    if self.authenticationSwitch.isOn {
      userDataStorage.isAuthenticationRequired = true
      authenticationService.state = .loggedOut
    } else if !self.authenticationSwitch.isOn {
      userDataStorage.isAuthenticationRequired = false
      authenticationService.state = .loggedOut
    }
  }
  
}
