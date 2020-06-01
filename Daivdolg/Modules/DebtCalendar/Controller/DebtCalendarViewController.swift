//
//  DebtCalendarViewController.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 29/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import FSCalendar

protocol DebtCalendarViewControllerDelegate: class {
  func setReturnDate(date: Date)
}

class DebtCalendarViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet private weak var calendar: FSCalendar!
  
  weak var delegate: DebtCalendarViewControllerDelegate?
  var returnDate: Date?
  private var somedays = [String]()
  
  // MARK: - Init
  init(debt: DebtModel) {
    self.returnDate = debt.returnDate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Constants.Texts.Calendar.title
    configureCalendarView()
    configureCloseButton()
  }
  
  // MARK: - Configure
  func configureCalendarView() {
    calendar.dataSource = self
    calendar.delegate = self
    calendar.scrollDirection = .vertical
    calendar.today = nil
  }
  
  func configureCloseButton() {
    let leftButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped(_:)))
    navigationItem.leftBarButtonItem = leftButton
  }
  
  // MARK: - Actions
  @objc private func closeTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - Calendar
extension DebtCalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    delegate?.setReturnDate(date: date)
    dismiss(animated: true, completion: nil)
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    // guard let else
    if date .compare(Date()) == .orderedAscending {
      return false
    } else {
      return true
    }
  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    //разделяй пустыми строками смысловые части, чтобы легче было читать
    guard let returnDate = returnDate else { return 0 }
    let dateString = date.toString()
    let returnDateString = returnDate.toString()
    if dateString == returnDateString {
      return 1
    }
    return Int()
  }
}

extension DebtCalendarViewController: FSCalendarDelegateAppearance {
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    let currentDate = Date().addingTimeInterval(-24*60*60)
    if date < currentDate {
      return .lightGray
    } else {
      return nil
    }
  }
}
