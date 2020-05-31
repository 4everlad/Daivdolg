//
//  DateFormatter.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 23/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation
import UIKit

extension Date {
  func toString(format: String = "dd MMM") -> String {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ru_RU")
      formatter.dateStyle = .short
      formatter.dateFormat = format
      return formatter.string(from: self)
  }
  func toStringFull(format: String = "dd MMM YYYY") -> String {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ru_RU")
      formatter.dateStyle = .short
      formatter.dateFormat = format
      return formatter.string(from: self)
  }
}
