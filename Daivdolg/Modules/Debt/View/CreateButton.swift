//
//  CreateForm.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 25/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import SnapKit

class CreateButton: UIButton {
  
  @IBInspectable var disabledBackgroundColor: UIColor? {
    didSet {
      updateBackgroundColor()
    }
  }
  @IBInspectable var enabledBackgroundColor: UIColor? {
    didSet {
      updateBackgroundColor()
    }
  }
  override var isEnabled: Bool {
    didSet {
      updateBackgroundColor()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func updateBackgroundColor() {
    backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
  }
}
