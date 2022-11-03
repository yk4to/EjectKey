//
//  EjectKeyApp.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/06.
//

import SwiftUI
import Defaults

@main
struct EjectKeyApp: App {
    // Use of `Defaults` like this causes crashes
    // @Default(.showMenuBarExtra) var showMenuBarExtra
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @Default(.showNumberOfConnectedVolumes) var showNumberOfConnectedVolumes
    
    @StateObject var model = AppModel()
    
    var body: some Scene {

        MenuBarExtra(isInserted: $showMenuBarExtra) {
            MenuView(model: model)
        } label: {
            Image(systemSymbol: .ejectFill)
            Text(String(model.volumes.count))
                .hidden(!showNumberOfConnectedVolumes)
        }
        Settings {
            SettingsView()
        }
    }
}
