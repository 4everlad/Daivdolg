//
//  DissmissKeyboard+Extension.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 25/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
