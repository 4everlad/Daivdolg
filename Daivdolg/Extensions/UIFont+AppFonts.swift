//
//  UIFont+AppFonts.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 30/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit

extension UIFont {
  static func appFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size)
  }

  static func mediumAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .medium)
  }

  static func semiboldAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .semibold)
  }
  
  static func boldAppFont(ofSize size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size, weight: .bold)
  }

  static let title = UIFont.semiboldAppFont(ofSize: 20)
  
  static let subtitle = UIFont.appFont(ofSize: 17)
  
  static let body = UIFont.mediumAppFont(ofSize: 17)
  
  static let subtitleBody = UIFont.appFont(ofSize: 14)
}
