//
//  MenuView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/11/02.
//

import SwiftUI
import Defaults

struct MenuView: View {
    @ObservedObject var model: AppModel
    
    @Default(.showEjectAllVolumesButton) var showEjectAllVolumesButton
    @Default(.showEjectAllVolumesInDiskButtons) var showEjectAllVolumesInDiskButtons
    @Default(.showActionMenu) var showActionMenu
    @Default(.showDetailedInformation) var showDetailedInformation
    
    var body: some View {
        if model.units.isEmpty {
            Text(L10n.noExternalVolumeConnected)
        } else {
            Button(L10n.ejectAllVolumes) {
                model.ejectAll()
            }
            .hidden(!showEjectAllVolumesButton || model.units.count <= 1)
            Divider()
                .hidden(!showEjectAllVolumesButton || model.units.count <= 1)
            
            ForEach(model.units, id: \.devicePath) { unit in
                if showDetailedInformation {
                    Text("\(unit.deviceVendor) \(unit.deviceModel) (\(unit.deviceProtocol))")
                } else {
                    Text(L10n.diskNum(unit.numbers.map(String.init).joined(separator: ", ")))
                }
                
                Button(L10n.ejectNumVolumes(unit.volumes.count)) {
                    model.ejectAllVolumeInDisk(unit)
                }
                .hidden(!showEjectAllVolumesInDiskButtons || unit.volumes.count <= 1)
                
                ForEach(unit.volumes.sorted(by: {$0.bsdName < $1.bsdName}), id: \.id) { volume in
                    if showActionMenu {
                        Menu {
                            Button(L10n.eject) {
                                model.eject(volume)
                            }
                            Button(L10n.showInFinder) {
                                NSWorkspace.shared.activateFileViewerSelecting([volume.url])
                            }
                            if showDetailedInformation {
                                Divider()
                                Text(volume.type)
                                Text("Size: \(volume.size.formatted(.byteCount(style: .file)))")
                                Text("ID: \(volume.bsdName)")
                            }
                        } label: {
                            Image(nsImage: volume.icon)
                            Text(volume.name)
                        }
                    } else {
                        Button {
                            model.eject(volume)
                        } label: {
                            Image(nsImage: volume.icon)
                            Text(volume.name)
                        }
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
        Button(L10n.quitEjectkey) {
            quitApp()
        }
        .keyboardShortcut("Q")
    }
    
    private func showSettingsWindow() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        NSApp.windows.forEach {
            if $0.canBecomeMain {
                $0.orderFrontRegardless()
            }
        }
    }
    
    private func showAbout() {
        model.settingsTabSelection = "about"
        showSettingsWindow()
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(model: AppModel())
    }
}
