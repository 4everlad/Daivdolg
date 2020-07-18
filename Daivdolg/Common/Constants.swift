//
//  Constants.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 30/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  struct Texts {
    struct Main {
      static let title = "Daivdolg"
      static let deleteActionTitle = "Удалить"
    }
    struct Debt {
      static let newTitle = "Новый долг"
      static let changeTitle = "Изменение долга"
      static let lend = "Дал в долг"
      static let borrow = "Взял в долг"
      static let contactViewTitle = "Выбрать контакт"
      static let contactViewSubtitle = "Нажмите, чтобы выбрать контакт"
      static let sumTextField = "Выберите сумму"
      static let createButtonChange = "Изменить"
      static let dateViewTitle = "Выберите дату"
      static let alertTitle = "Введите имя"
      static let alertMessage = "Имя будет привязано к контакту"
    }
    struct Currencies {
      static let title = "Выбор валюты"
      static let searchBarTitle = "Код или название валюты"
    }
    struct Calendar {
      static let title = "Выбор даты"
    }
    struct Settings {
      static let title = "Настройки"
    }
  }
  struct Sizes {
    static let actionButtonSize = CGSize(width: 64, height: 64)
  }
}
