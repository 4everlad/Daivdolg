//
//  EBRoundedTabBarItem.swift
//  RoundedTabBarControllerExample
//
//  Created by Erid Bardhaj on 10/28/18.
//  Copyright © 2018 Erid Bardhaj. All rights reserved.
//

import UIKit

enum EBRoundedTabBarItem {
  case firstItem, roundedItem, secondItem
  
  var isRoundedItem: Bool {
    if case self = EBRoundedTabBarItem.roundedItem {
      return true
    }
    
    return false
  }
  
  var isFirstItem: Bool {
    if case self = EBRoundedTabBarItem.firstItem {
      return true
    }
    return false
  }
  
  var isSecondItem: Bool {
    if case self = EBRoundedTabBarItem.secondItem {
      return true
    }
    return false
  }
}

extension EBRoundedTabBarItem {
  
  var title: String {
    if isRoundedItem {
      return ""
    } else if isFirstItem {
      return "Долги"
    } else if isSecondItem {
      return "Настройки"
    }
    return String()
  }
  
  var isEnabled: Bool {
    return !isRoundedItem
  }
  
  var tag: Int {
    switch self {
    case .firstItem:
      return 1
    case .roundedItem:
      return 2
    case .secondItem:
      return 3
    }
  }
  
  var image: UIImage? {
      if isRoundedItem {
        return nil
      } else if isFirstItem {
        return  #imageLiteral(resourceName: "debtsIcon")
      } else if isSecondItem {
        return  #imageLiteral(resourceName: "settingsIcon")
    }
    return UIImage()
  }
  
  var selectedImage: UIImage? {
    if isRoundedItem {
      return nil
    } else if isFirstItem {
      return  #imageLiteral(resourceName: "debtsIconSelected")
    } else if isSecondItem {
      return  #imageLiteral(resourceName: "settingsIconSelected")
    }
    return UIImage()
  }
  
  var tabBarItem: UITabBarItem {
    let tabItem = UITabBarItem(title: title, image: image, tag: tag)
    tabItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
    tabItem.isEnabled = isEnabled
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainGreen], for: .selected)
    
    return tabItem
  }
  
}
