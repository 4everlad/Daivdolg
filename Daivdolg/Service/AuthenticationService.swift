//
//  AuthenticationService.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 25/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import LocalAuthentication

enum AuthenticationState {
  case loggedIn, loggedOut
}

// несколько раз создаются объекты этого типа, все объекты будут одинаковые
// либо сделать поля/методы статическими
// либо singleton
class AuthenticationService {
  
  var state = AuthenticationState.loggedOut
  
    // MethodHandler странное название
    // Наверное оно должно возвращать bool -- удалось авторизоваться или нет 
  func getAuthenticated(method: @escaping MethodHandler) {
    if state == .loggedIn {
      state = .loggedOut
    } else {
      let context = LAContext()
      context.localizedCancelTitle = "Enter Username/Password"
      var error: NSError?
      if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        let reason = "Log in to your account"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
          if success {
            DispatchQueue.main.async { [unowned self] in
              self.state = .loggedIn
              method()
            }
          } else {
            print(error?.localizedDescription ?? "Failed to authenticate")
          }
        }
      } else {
        print(error?.localizedDescription ?? "Can't evaluate policy")
      }
    }
  }
}
