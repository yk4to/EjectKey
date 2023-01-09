//
//  EjectKeyApp.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/06.
//

import SwiftUI
import Defaults

@main
struct EjectKeyApp: App {
    // Use of `Defaults` like this causes crashes
    // @Default(.showMenuBarExtra) var showMenuBarExtra
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @Default(.showNumberOfConnectedVolumes) var showNumberOfConnectedVolumes
    @Default(.doNotDisplayNumbersWhenNothingIsConnected) var doNotDisplayNumbersWhenNothingIsConnected
    
    @StateObject var model = AppModel()
    @StateObject var updaterViewModel = UpdaterViewModel()
    
    var body: some Scene {

        MenuBarExtra(isInserted: $showMenuBarExtra) {
            MenuView(model: model)
                .environmentObject(updaterViewModel)
        } label: {
            Image(systemSymbol: .ejectFill)
            if !(doNotDisplayNumbersWhenNothingIsConnected && model.allVolumes.isEmpty) {
                Text(String(model.allVolumes.count))
                    .hidden(!showNumberOfConnectedVolumes)
            }
        }
        Settings {
            SettingsView(model: model)
                .environmentObject(updaterViewModel)
        }
    }
}
