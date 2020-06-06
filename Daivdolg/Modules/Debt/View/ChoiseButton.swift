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
    layer.borderWidth = isEnabled ? enabledBorderWidth : disabledBorderWidth
  }
}
