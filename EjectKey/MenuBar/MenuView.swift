//
//  MenuView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/11/02.
//

import SwiftUI
import Defaults

struct MenuView: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var updaterViewModel: UpdaterViewModel
    
    @Default(.showEjectAllVolumesButton) var showEjectAllVolumesButton
    @Default(.showEjectAllVolumesInDiskButtons) var showEjectAllVolumesInDiskButtons
    @Default(.showInternalVolumes) var showInternalVolumes
    @Default(.showActionMenu) var showActionMenu
    @Default(.showDetailedInformation) var showDetailedInformation
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        if model.devices.isEmpty {
            Text(L10n.noExternalVolumeConnected)
        } else {
            Button(L10n.ejectAllVolumes) {
                model.ejectAll()
            }
            .hidden(!showEjectAllVolumesButton || model.devices.count <= 1)
            Divider()
                .hidden(!showEjectAllVolumesButton || model.devices.count <= 1)
            
            ForEach(model.devices.sorted(by: { $0.minUnitNumber < $1.minUnitNumber }), id: \.path) { device in
                if !(!showInternalVolumes && device.isInternal) {
                    Menu {
                        ForEach(device.units.sorted(by: { $0.number < $1.number }), id: \.number) { unit in
                            if !unit.isApfs {
                                Text("\(unit.name ?? "Unknown") (\(unit.bsdName))")
                                Button(L10n.ejectNumVolumes(unit.volumes.count)) {
                                    model.ejectAllVolumeInDisk(unit)
                                }
                                .hidden(!showEjectAllVolumesInDiskButtons || unit.volumes.count <= 1)
                                
                                VolumeList(model: model, device: device, unit: unit)
                            }
                        }
                        if showDetailedInformation {
                            Divider()
                            Text("Protocol: \(device.deviceProtocol ?? "Unknown")")
                        }
                    } label: {
                        // if showDetailedInformation {
                            if device.isDiskImage {
                                Text(L10n.diskImage)
                            } else {
                                Text("\(device.vendor ?? "Unknown") \(device.model ?? "Unknown")")
                            }
                        /*} else {
                            let numbersStr = device.units.map({ String($0.number) }).joined(separator: ", ")
                            if device.isDiskImage {
                                Text(L10n.diskImageNum(numbersStr))
                            } else {
                                Text(L10n.diskNum(numbersStr))
                            }
                        }*/
                    }
                }
            }
        }
        Divider()
        Button(L10n.settings) {
            showSettingsWindow()
        }
        .keyboardShortcut(",")
        Button(L10n.aboutEjectkey) {
            showAbout()
        }
        Button(L10n.checkForUpdates, action: updaterViewModel.checkForUpdates)
        Button(L10n.quitEjectkey) {
            quitApp()
        }
        .keyboardShortcut("Q")
    }
    
    private func showSettingsWindow() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        if let window = NSApp.windows.first(where: { $0.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" }) {
            window.toolbarStyle = .unified
            window.titlebarAppearsTransparent = true
            if window.canBecomeMain {
                window.orderFrontRegardless()
            }
        }
    }
    
    private func showAbout() {
        model.settingsTabSelection = .about
        showSettingsWindow()
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
