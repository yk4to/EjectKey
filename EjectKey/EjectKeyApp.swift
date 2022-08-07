//
//  EjectKeyApp.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/06.
//

import SwiftUI

@main
struct EjectKeyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}
