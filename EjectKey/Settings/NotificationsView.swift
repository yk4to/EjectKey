//
//  NotificationsView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import SwiftUI
import Defaults
import UserNotifications

struct NotificationsView: View {
    @Default(.sendWhenDiskIsConnected) var sendWhenDiskIsConnected
    @Default(.sendWhenDiskIsEjected) var sendWhenDiskIsEjected
    @Default(.soundWhenSendingNotifications) var soundWhenSendingNotifications
    @Default(.showAppsWhenEjectionFails) var showAppsWhenEjectionFails
    @State private var isAuthed = false
    
    var body: some View {
        VStack {
            Form {
                if ( sendWhenDiskIsConnected || sendWhenDiskIsEjected ) && !isAuthed {
                    Section {
                        HStack {
                            Label(L10n.notificationsAreNotAllowed, systemSymbol: .exclamationmarkTriangle)
                            Button(L10n.openSettings) {
                                NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Notifications.prefPane"))
                            }
                        }
                    }
                }
                Section {
                    Toggle(L10n.whenDiskIsConnected, isOn: $sendWhenDiskIsConnected)
                    Toggle(L10n.whenDiskIsEjected, isOn: $sendWhenDiskIsEjected)
                }
                Section {
                    Toggle(L10n.soundWhenSendingNotifications, isOn: $soundWhenSendingNotifications)
                }
                Section {
                    Toggle(L10n.showAppsWhenEjectionFails + L10n.experimental, isOn: $showAppsWhenEjectionFails)
                }
            }
            .formStyle(.grouped)
            .fixedSize(horizontal: false, vertical: true)
        }
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
