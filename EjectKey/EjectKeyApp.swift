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
    @Default(.showNumberOfConnectedVolumes) var showNumberOfConnectedVolumes
    @Default(.doNotDisplayNumbersWhenNothingIsConnected) var doNotDisplayNumbersWhenNothingIsConnected
    
    @StateObject var model = AppModel()
    
    var body: some Scene {

        MenuBarExtra {
            MenuView(model: model)
        } label: {
            Image(systemSymbol: .ejectFill)
            if !(doNotDisplayNumbersWhenNothingIsConnected && model.allVolumes.isEmpty) {
                Text(String(model.allVolumes.count))
                    .hidden(!showNumberOfConnectedVolumes)
            }
        }
        Settings {
            SettingsView(model: model)
        }
    }
}
