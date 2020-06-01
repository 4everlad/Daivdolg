//
//  Notifications.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 20/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import UserNotifications

// несколько раз создаются объекты этого типа, все объекты будут одинаковые
// либо сделать поля/методы статическими
// либо singleton

class Notifications: NSObject, UNUserNotificationCenterDelegate {
  
  let notificationCenter = UNUserNotificationCenter.current()
  
  func requestAutorization() {
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
      print("Permsission granted: \(granted)")
      guard granted else {return}
      self.getNotificationSettings()
    }
  }
  
  func getNotificationSettings() {
    notificationCenter.getNotificationSettings { (settings) in
      print("Not settings: \(settings)")
    }
  }

  func scheduleNotification(notificationType: String,
                            name: String,
                            amount: String,
                            currency: String,
                            returnDate: Date) {
    
    guard let notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: returnDate) else { return }
    
    let content = UNMutableNotificationContent()
    let userAction = "User Action"
    
    content.title = notificationType
    content.body = "До \(returnDate.toString()) \(name) \(amount) \(currency)"
    content.sound = UNNotificationSound.default
    content.badge = 1
    content.categoryIdentifier = userAction
    
    let dateComponents = Calendar.current.dateComponents([Calendar.Component.year,
                                                          Calendar.Component.month,
                                                          Calendar.Component.day],
                                                         from: notificationDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let identifire = "Local notifier"
    let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
    
    notificationCenter.add(request) { (error) in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
    
    let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
    let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
    let category = UNNotificationCategory(identifier: userAction,
                                          actions: [snoozeAction, deleteAction],
                                          intentIdentifiers: [], options: [])
    
    notificationCenter.setNotificationCategories([category])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler:
                              @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }

}
