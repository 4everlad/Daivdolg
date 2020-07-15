//
//  TabBarController.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 29/05/2020.
//  Copyright © 2020 Компьютер. All rights reserved.
//

import UIKit
import LocalAuthentication

class TabBarController: UITabBarController {
  
  // MARK: - Properties
  private let userDataStorage = UserDataStorage.shared
  private let authenticationService = AuthenticationService()

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    if userDataStorage.isAuthenticationRequired {
      authenticationService.getAuthenticated {
        self.configureViewControllers()
      }
    } else {
      configureViewControllers()
    }
  }
  
  // MARK: - Private methods
  private func configureViewControllers() {
    let debtsViewController = DebtsViewController()
    let debtsIcon = UIImage(named: "debtsIcon")
    let debtsIconSelected = UIImage(named: "debtsIconSelected")
    debtsViewController.tabBarItem = UITabBarItem(title: "Долги", image: debtsIcon, tag: 0)
    debtsViewController.tabBarItem.selectedImage = debtsIconSelected?.withRenderingMode(.alwaysOriginal)
    
    let settingsViewController = SettingsViewController()
    let settingsIcon = UIImage(named: "settingsIcon")
    let settingsIconSelected = UIImage(named: "settingsIconSelected")
    settingsViewController.tabBarItem = UITabBarItem(title: "Настройки", image: settingsIcon, tag: 2)
    settingsViewController.tabBarItem.selectedImage = settingsIconSelected?.withRenderingMode(.alwaysOriginal)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainGreen], for: .selected)
    
    let tabBarList = [debtsViewController, settingsViewController]
    
    viewControllers = tabBarList.map {
      UINavigationController(rootViewController: $0)
    }
  }
  
}
