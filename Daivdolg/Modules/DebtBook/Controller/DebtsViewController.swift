//
//  DebtsViewController.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 22/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit

class DebtsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet private weak var toolbar: UIToolbar!
  @IBOutlet private weak var noDebtsView: UIView!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var debtTypeControl: UISegmentedControl!
  
  var debtBook = DebtBook()
  let nc = NotificationCenter.default
    private let userDataStorage = UserDataStorage.shared
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Constants.Texts.Main.title
    configureTableView()
    configureAddButton()
    configureDebtTypeControl()
    updateView()
    nc.addObserver(self, selector: #selector(updateView), name: Notification.Name("updateView"), object: nil)
    if let navController = navigationController {
      navController.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.mainGreen]
      }
    }
  
  // MARK: - Configure
  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "DebtCell", bundle: nil), forCellReuseIdentifier: "DebtCell")
  }
  
  private func configureAddButton() {
    let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped(_:)))
    rightButton.tintColor = UIColor.mainGreen
    navigationItem.rightBarButtonItem = rightButton
  }
  
  private func configureDebtTypeControl() {
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    debtTypeControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
  }
  
  // MARK: - Actions
  @IBAction private func debtTypeChanged(_ sender: Any) {
    switch debtTypeControl.selectedSegmentIndex {
    case 0:
      debtTypeControl.selectedSegmentTintColor = UIColor.mainGreen
      debtBook.getLendDebts()
      debtBook.currentDebtType = .lend
      userDataStorage.currentDebtType = .lend
    case 1:
      debtTypeControl.selectedSegmentTintColor = UIColor.debtRed
      debtBook.getBorrowDebts()
      debtBook.currentDebtType = .borrow
      userDataStorage.currentDebtType = .borrow
    default:
      break
    }
    tableView.reloadData()
  }
  
  @objc private func addTapped(_ sender: UIButton) {
    let debt = debtBook.getNewDebt()
    let debtType = debtBook.currentDebtType
    let debtViewController = DebtViewController(debt: debt, debtType: debtType, debtStatus: .new)
    debtViewController.delegate = self
    let debtNavigationController = UINavigationController(rootViewController: debtViewController)
    if let navigationController = navigationController {
      navigationController.present(debtNavigationController, animated: true)
    }
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
  
  @objc private func updateView() {
    if debtBook.isNoDebts == true {
      tableView.isHidden = true
      noDebtsView.isHidden = false
    } else {
      tableView.isHidden = false
      noDebtsView.isHidden = true
    }
  }

}

// MARK: - UITableView
extension DebtsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 65
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return debtBook.countDebts()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DebtCell", for: indexPath) as? DebtCell
    guard let tableViewCell = cell else { return UITableViewCell() }
    if !debtBook.getDebts().isEmpty {
      let debt: DebtModel
      debt = debtBook.getDebts()[indexPath.row]
      tableViewCell.name = debt.name
      tableViewCell.returnDate = debt.returnDate
      tableViewCell.moneyAmount = debt.amount
      tableViewCell.currency = debt.currency
      tableViewCell.debtType = debt.type
    }
    return tableViewCell
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    let debt: DebtModel
    debt = debtBook.getDebts()[indexPath.row]
    let debtType = debt.type
    let debtViewController = DebtViewController(debt: debt, debtType: debtType, debtStatus: .exist)
    debtViewController.delegate = self
    let debtNavigationController = UINavigationController(rootViewController: debtViewController)
    if let navigationController = navigationController {
      navigationController.present(debtNavigationController, animated: true)
    }
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let contextItem = UIContextualAction(style: .destructive, title: Constants.Texts.Main.deleteActionTitle) {  (_, _, completion) in
      self.debtBook.removeDebt(at: indexPath.row)
      self.tableView?.deleteRows(at: [indexPath], with: .none)
      completion(true)
      }
      let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

      return swipeActions
  }
  
}

// MARK: - DebtViewControllerDelegate
extension DebtsViewController: DebtViewControllerDelegate {
  
  func changeCurrentDebtType(debt: DebtModel) {
    debtBook.currentDebtType = debt.type
    debtTypeChanged(self)
  }
  
  func addDebt(debt: DebtModel) {
    debtBook.addDebt(debt: debt)
    switch debt.type {
    case .lend:
      debtTypeControl.selectedSegmentIndex = 0
    case .borrow:
      debtTypeControl.selectedSegmentIndex = 1
    }
    tableView.reloadData()
  }
  
  func changeDebt(debt: DebtModel) {
    debtBook.changeDebt(debt: debt)
    switch debt.type {
    case .lend:
      debtTypeControl.selectedSegmentIndex = 0
    case .borrow:
      debtTypeControl.selectedSegmentIndex = 1
    }
    tableView.reloadData()
  }
}
