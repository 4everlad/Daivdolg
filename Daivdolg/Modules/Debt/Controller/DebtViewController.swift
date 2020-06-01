//
//  DebtViewController.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 02/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import ContactsUI

enum DebtStatus {
  case new
  case exist
}

protocol DebtViewControllerDelegate: class {
  func addDebt(debt: DebtModel)
  func changeDebt(debt: DebtModel)
}

class DebtViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet private weak var contactView: ContactView!
  @IBOutlet private weak var createButton: CreateButton!
  @IBOutlet private weak var lendDebtButton: CreateButton!
  @IBOutlet private weak var borrowDebtButton: CreateButton!
  @IBOutlet private weak var sumTextField: UITextField!
  @IBOutlet private weak var currencyButton: UIButton!
  @IBOutlet private weak var dateView: DateView!
  
  private let contactButton = UIButton()
  weak var delegate: DebtViewControllerDelegate?
  
  private var debt: DebtModel
  private var debtStatus: DebtStatus
  private let currencies = Currencies()
  
  // MARK: - Init
  init(debt: DebtModel, debtStatus: DebtStatus) {
    self.debt = debt
    self.debtStatus = debtStatus
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Constants.Texts.Debt.newTitle
    configureCloseButton()
    configureContactView()
    configureSumTextField()
    configureDateView()
    configureDebtView()
  }
  
  // MARK: - Configure
  private func configureContactView() {
    contactView.image = UIImage(named: "contactIcon")
    contactView.title = "Выбрать контакт"
    contactView.subtitle = "Нажмите, чтобы выбрать контакт"
    contactButton.addTarget(self, action: #selector(addPhoneContact(_:)), for: .touchUpInside)
    contactView.onDidSelect = { [unowned self] in
      self.contactButton.sendActions(for: .touchUpInside)
    }
  }
  
  private func configureSumTextField() {
    sumTextField.delegate = self
    sumTextField.keyboardType = UIKeyboardType.decimalPad
    self.hideKeyboardWhenTappedAround()
    sumTextField.attributedPlaceholder = NSAttributedString(string: "Выберите сумму",
    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
  }
  
  private func configureDebtView() {
    if debtStatus == .new {
      createButton.isEnabled = false
      lendDebtButton.isEnabled = false
      borrowDebtButton.isEnabled = true
    }
    if debtStatus == .exist {
      fillExistedDebt()
      createButton.isEnabled = true
      createButton.setTitle("Изменить", for: .normal)
    }
  }
  
  private func configureCloseButton() {
    let leftButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped(_:)))
    navigationItem.leftBarButtonItem = leftButton
  }
  
  private func configureDateView() {
    dateView.title = "Выберите дату"
    dateView.onDidSelect = { [unowned self] in
      self.debtCalendarTapped()
    }
  }
  
  // MARK: - Actions
  @IBAction private func lendBorrowTapped(_ sender: UIButton) {
    switch sender.tag {
    case 0:
      lendDebtButton.isEnabled = false
      borrowDebtButton.isEnabled = true
      debt.type = .lend
    case 1:
      lendDebtButton.isEnabled = true
      borrowDebtButton.isEnabled = false
      debt.type = .borrow
    default:
      print("no tag")
    }
  }
  
  @IBAction private func getSum(_ sender: Any) {
    guard let text = sumTextField.text else { return }
    debt.amount = Float(text)
    updateCreateButton()
  }
  
  @IBAction private func nameManuallyTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Введите имя",
                                  message: "Имя будет привязано к контакту",
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.text = ""
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0]
      guard let name = textField?.text else { return }
      self.debt.setContactName(name: name)
      self.contactView.title = name
      self.updateCreateButton()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction private func currencyTapped(_ sender: Any) {
    let currenciesViewController = CurrenciesViewController(currencies: currencies)
    currenciesViewController.delegate = self
    let currenciesNavigationController = UINavigationController(rootViewController: currenciesViewController)
    if let navigationController = navigationController {
      navigationController.present(currenciesNavigationController, animated: true)
    }
  }
  
  private func debtCalendarTapped() {
    let debtCalendarViewController = DebtCalendarViewController(debt: debt)
    debtCalendarViewController.delegate = self
    let debtCalendarNavigationController = UINavigationController(rootViewController: debtCalendarViewController)
    if let navigationController = self.navigationController {
      navigationController.present(debtCalendarNavigationController, animated: true)
    }
  }
  
  @IBAction func createButtonTapped(_ sender: Any) {
    if debtStatus == .new {
      delegate?.addDebt(debt: debt)
    } else if debtStatus == .exist {
      delegate?.changeDebt(debt: debt)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  @objc func addPhoneContact(_ sender: UIButton) {
    let contactPicker = CNContactPickerViewController()
    contactPicker.delegate = self
    contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
    self.present(contactPicker, animated: true, completion: nil)
  }
  
  @objc func closeTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - UpdateView
  private func updateCreateButton() {
    if debt.isDebtReadyToCreate() {
      createButton.isEnabled = true
    } else {
      createButton.isEnabled = false
    }
  }
  
  private func fillExistedDebt() {
    navigationItem.title = Constants.Texts.Debt.changeTitle
    if debt.type == .borrow {
      lendDebtButton.isEnabled = true
      borrowDebtButton.isEnabled = false
    } else if debt.type == .lend {
      lendDebtButton.isEnabled = false
      borrowDebtButton.isEnabled = true
    }
    if let amount = debt.amount {
      sumTextField.text = String(amount)
    }
    if let name = debt.name {
      contactView.title = name
    }
    if let returnDate = debt.returnDate {
      dateView.title = returnDate.toString()
    }
  }
}

// MARK: - ContactPicker
extension DebtViewController: CNContactPickerDelegate {
  func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    picker.dismiss(animated: true, completion: nil)
    guard let name = CNContactFormatter.string(from: contact, style: .fullName) else { return }
    debt.name = name
    contactView.title = name
    updateCreateButton()
  }
}

extension DebtViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    return true
  }
}

// MARK: - DebtCalendarViewControllerDelegate
extension DebtViewController: DebtCalendarViewControllerDelegate {
  func setReturnDate(date: Date) {
    debt.returnDate = date
    guard let returnDate = debt.returnDate else { return }
    dateView.title = returnDate.toString()
  }
}

// MARK: - CurrenciesViewControllerDelegate
extension DebtViewController: CurrenciesViewControllerDelegate {
  func setCurrency(code: String) {
    debt.currency = code
    currencyButton.setTitle(code, for: .normal)
  }
  
}
