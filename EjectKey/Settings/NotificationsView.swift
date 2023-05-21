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
    @Default(.sendWhenVolumeIsConnected) var sendWhenVolumeIsConnected
    @Default(.sendWhenVolumeIsEjected) var sendWhenVolumeIsEjected
    @Default(.doNotSendNotificationsAboutVirtualVolumes) var doNotSendNotificationsAboutVirtualVolumes
    @Default(.soundWhenSendingNotifications) var soundWhenSendingNotifications
    
    @State private var isAuthed = true
    
    var body: some View {
        VStack {
            Form {
                if ( sendWhenVolumeIsConnected || sendWhenVolumeIsEjected ) && !isAuthed {
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
                    Toggle(L10n.whenVolumeIsConnected, isOn: $sendWhenVolumeIsConnected)
                    Toggle(L10n.whenVolumeIsEjected, isOn: $sendWhenVolumeIsEjected)
                }
                Section {
                    Toggle(L10n.doNotSendNotificationsAboutVirtualVolumes, isOn: $doNotSendNotificationsAboutVirtualVolumes)
                    Toggle(L10n.soundWhenSendingNotifications, isOn: $soundWhenSendingNotifications)
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
