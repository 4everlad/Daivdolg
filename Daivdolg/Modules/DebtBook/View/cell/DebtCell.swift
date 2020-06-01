//
//  DebtCell.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 23/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import Foundation

protocol DebtCellConfiguration {
  var name: String? { get set }
  var returnDate: Date? { get set }
  var moneyAmount: Float? { get set }
  var currency: String? { get set }
  var debtType: DebtType? {get set }
}

class DebtCell: UITableViewCell, DebtCellConfiguration {
  
  var debtType: DebtType? {
    didSet {
      switch debtType {
      case .lend:
        moneyAmountLabel.textColor = UIColor.mainGreen
        currencyLabel.textColor = UIColor.mainGreen
      case .borrow:
        moneyAmountLabel.textColor = UIColor.debtRed
        currencyLabel.textColor = UIColor.debtRed
      case .none:
        return
      }
    }
  }
  
  var currency: String? {
    didSet {
      currencyLabel.text = currency
    }
  }
  
  var name: String? {
    didSet {
      nameLabel.text = name
    }
  }
  
  var returnDate: Date? {
    didSet {
      guard let returnDate = returnDate else { return }
      returnDateLabel.text = returnDate.toString()
    }
  }
  
  var moneyAmount: Float? {
    didSet {
      guard let moneyAmount = moneyAmount else { return }
      moneyAmountLabel.text = String(moneyAmount)
    }
  }
  
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var moneyAmountLabel: UILabel!
  @IBOutlet private  weak var returnDateLabel: UILabel!
  @IBOutlet private weak var currencyLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
