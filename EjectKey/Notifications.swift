//
//  Notifications.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Foundation
import Defaults
import UserNotifications

extension AppModel {
    func requestNotificationAuth() {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound]) { authorized, _ in
            guard authorized else {
                // print("Not authorized")
                return
            }
        }
    }
    
    func alert(title: String, body: String, sound: UNNotificationSound, identifier: String) {
        if Defaults[.enableNotifications] {
            userNotificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {
                    return
                }

                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = sound
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
                self.userNotificationCenter.add(request)
            }
        }
    }
}
