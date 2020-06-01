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
  private let userDataStorage = UserDataStorage()
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
    let firstViewController = DebtsViewController()
    let debtsIcon = UIImage(named: "debtsIcon")
    let debtsIconSelected = UIImage(named: "debtsIconSelected")
    firstViewController.tabBarItem = UITabBarItem(title: "Долги", image: debtsIcon, tag: 0)
    firstViewController.tabBarItem.selectedImage = debtsIconSelected?.withRenderingMode(.alwaysOriginal)
    
    let secondViewController = SettingsViewController()
    let settingsIcon = UIImage(named: "settingsIcon")
    let settingsIconSelected = UIImage(named: "settingsIconSelected")
    secondViewController.tabBarItem = UITabBarItem(title: "Настройки", image: settingsIcon, tag: 1)
    secondViewController.tabBarItem.selectedImage = settingsIconSelected?.withRenderingMode(.alwaysOriginal)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainGreen], for: .selected)
    
    let tabBarList = [firstViewController, secondViewController]
    
    viewControllers = tabBarList.map {
      UINavigationController(rootViewController: $0)
    }
  }
  
  
  
}
