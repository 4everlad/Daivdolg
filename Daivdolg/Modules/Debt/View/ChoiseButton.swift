//
//  ChoiseButton.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 05.06.2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class ChoiseButton: UIButton {
  
  @IBInspectable var disabledBorderWidth: CGFloat = 0.0 {
    didSet {
      updateBorderWidth()
    }
  }
  @IBInspectable var enabledBorderWidth: CGFloat = 1.0 {
    didSet {
      updateBorderWidth()
    }
  }
  @IBInspectable var enabledTextColor: UIColor? {
    didSet {
      updateBorderWidth()
    }
  }
  @IBInspectable var disabledTextColor: UIColor? {
    didSet {
      updateBorderWidth()
    }
  }

  override var isEnabled: Bool {
    didSet {
      updateBorderWidth()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func updateBorderWidth() {
    if isEnabled {
      layer.borderWidth = enabledBorderWidth
      self.setTitleColor(enabledTextColor, for: .normal)
    } else {
      layer.borderWidth = disabledBorderWidth
      self.setTitleColor(disabledTextColor, for: .disabled)
    }
  }
}
