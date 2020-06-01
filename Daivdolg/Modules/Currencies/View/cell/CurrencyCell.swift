//
//  CurrencyCell.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 15/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit

protocol CurrencyCellConfiguration {
  var code: String? { get set }
  var name: String? { get set }
}

class CurrencyCell: UITableViewCell, CurrencyCellConfiguration {
  
  var code: String? {
    didSet {
      codeLabel.text = code
    }
  }
  
  var name: String? {
    didSet {
      nameLabel.text = name
    }
  }
  
  @IBOutlet private weak var codeLabel: UILabel!
  @IBOutlet private weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
