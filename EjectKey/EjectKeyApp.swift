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
    @Default(.showNumberOfConnectedVolumes) var showNumberOfConnectedVolumes
    
    @StateObject var model = AppModel()
    
    var body: some Scene {

        MenuBarExtra(isInserted: .constant(true)) {
            MenuView(model: model)
        } label: {
            Image(systemSymbol: .ejectFill)
            Text(String(model.volumes.count))
                .hidden(!showNumberOfConnectedVolumes)
        }
        Settings {
            SettingsView(model: model)
        }
    }
}
