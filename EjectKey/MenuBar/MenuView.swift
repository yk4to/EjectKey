//
//  MenuView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/11/02.
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
            
            ForEach(model.units, id: \.self) { unit in
                if showDetailedInformation {
                    Text(L10n.diskNumProtocol(unit, model.getVolumesFromUnit(unit).first!.protocol))
                } else {
                    Text(L10n.diskNum(unit))
                }
                
                Button(L10n.ejectNumVolumes(model.getVolumesFromUnit(unit).count)) {
                    model.ejectAllVolumeInDisk(unit)
                }
                .hidden(!showEjectAllVolumesInDiskButtons || model.getVolumesFromUnit(unit).count <= 1)
                
                ForEach(model.getVolumesFromUnit(unit), id: \.bsdName) { volume in
                    if showActionMenu {
                        Menu {
                            Button(L10n.eject) {
                                model.eject(volume)
                            }
                            Button(L10n.showInFinder) {
                                NSWorkspace.shared.activateFileViewerSelecting([volume.url])
                            }
                            if showDetailedInformation {
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
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel()
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
