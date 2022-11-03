//
//  EjectKeyApp.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/06.
//

import SwiftUI
// import Defaults

@main
struct EjectKeyApp: App {
    // Use of `Defaults` like this causes crashes
    // @Default(.showMenuBarExtra) var showMenuBarExtra
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    @StateObject var model = AppModel()
    
    var body: some Scene {
        MenuBarExtra("EjectKey", systemImage: "eject.fill", isInserted: $showMenuBarExtra) {
            MenuView(model: model)
        }
        Settings {
            SettingsView()
        }
    }
}
