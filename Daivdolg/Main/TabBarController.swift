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
  
  private let debtsViewController: DebtsViewController = DebtsViewController()
  private let settingsViewController: SettingsViewController = SettingsViewController()
  
  // MARK: - Properties
  private let actionButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.mainGreen
    let image = UIImage(named: "addButtonIcon.png")
    button.setImage(image, for: .normal)
    button.layer.cornerRadius = Constants.Sizes.actionButtonSize.height/2
    button.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)
    return button
  }()

  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    if userDataStorage.isAuthenticationRequired {
      authenticationService.getAuthenticated {
        self.configureSubviews()
        self.configureConstraints()
      }
    } else {
      self.configureSubviews()
      self.configureConstraints()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      actionButton.isHidden = false
  }
  
  // MARK: - Configure
  private func configureConstraints() {
      actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    actionButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.actionButtonSize.width).isActive = true
    actionButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.actionButtonSize.height).isActive = true
      actionButton.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  private func configureSubviews() {
    configureViewControllers()
    view.addSubview(actionButton)
  }
  
  // MARK: - Actions
  @objc private func actionButtonTapped(sender: UIButton) {
    if let debtType = userDataStorage.currentDebtType {
      let debtViewController = DebtViewController(debt: nil, debtType: debtType, debtStatus: .new)
      debtViewController.delegate = debtsViewController
      let navigationController = UINavigationController(rootViewController: debtViewController)
      present(navigationController, animated: true)
    } else {
      let debtViewController = DebtViewController(debt: nil, debtType: .lend, debtStatus: .new)
      debtViewController.delegate = debtsViewController
      let navigationController = UINavigationController(rootViewController: debtViewController)
      present(navigationController, animated: true)
    }
  }
  
  // MARK: - Private methods
  private func configureViewControllers() {
    let debtsTag = EBRoundedTabBarItem.firstItem
    let debtsTabBar = createController(viewController: debtsViewController, for: debtsTag, with: 1)
    
    let debtViewController = DebtViewController(debt: nil, debtType: .lend, debtStatus: .new)
    debtViewController.delegate = debtsViewController
    let debtTag = EBRoundedTabBarItem.roundedItem
    let debtTabBar = createController(viewController: debtViewController, for: debtTag, with: 2)
    
    let settingsTag = EBRoundedTabBarItem.secondItem
    let settingsTabBar = createController(viewController: settingsViewController, for: settingsTag, with: 3)
    
    let tabBarList = [debtsTabBar, debtTabBar, settingsTabBar]
    
    self.viewControllers = tabBarList
  }
  
  private func createController(viewController: UIViewController, for customTabBarItem: EBRoundedTabBarItem, with tag: Int) -> UINavigationController {
      let viewController = viewController
      viewController.title = customTabBarItem.title
      viewController.tabBarItem = customTabBarItem.tabBarItem
      return UINavigationController(rootViewController: viewController)
  }
}
