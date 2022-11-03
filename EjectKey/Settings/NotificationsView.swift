//
//  NotificationsView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import SwiftUI
import Defaults
import UserNotifications

struct NotificationsView: View {
    @Default(.enableNotifications) var enableNotifications
    @State private var isAuthed = false
    
    var body: some View {
        VStack {
            Form {
                Toggle(L10n.enableNotifications, isOn: $enableNotifications)
            }
            if enableNotifications && !isAuthed {
                HStack {
                    Spacer()
                    VStack {
                        Text(L10n.notificationsAreNotAllowed)
                            .fixedSize(horizontal: false, vertical: true)
                        Button(L10n.openSettings) {
                            NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Notifications.prefPane"))
                        }
                    }
                    .padding(14)
                    .background(Color(NSColor.separatorColor))
                    .cornerRadius(4)
                    Spacer()
                }
            }
        }
        .padding(20)
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.getNotificationSettings { settings in
            isAuthed = settings.authorizationStatus == .authorized
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
