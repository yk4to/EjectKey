//
//  Notifications.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import Cocoa
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
    
    func sendNotification(title: String, body: String, sound: UNNotificationSound, identifier: String) {
        userNotificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                return
            }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            if Defaults[.soundWhenSendingNotifications] {
                content.sound = sound
            }
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
            self.userNotificationCenter.add(request)
        }
    }
    
    func alert(alertStyle: NSAlert.Style, messageText: String, informativeText: String, buttonTitle: String, showCancelButton: Bool, hasDestructiveAction: Bool, completionHandler: (() -> Void)?) {
        let alert = NSAlert()
        alert.alertStyle = alertStyle
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: buttonTitle)
        if showCancelButton {
            alert.addButton(withTitle: L10n.cancel)
        }
        alert.buttons.first?.hasDestructiveAction = hasDestructiveAction
        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            completionHandler?()
        default:
            break
        }
    }
}
