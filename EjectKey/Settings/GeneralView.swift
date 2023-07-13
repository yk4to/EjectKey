//
//  GeneralView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import SwiftUI
import LaunchAtLogin
import Defaults

struct GeneralView: View {
    @EnvironmentObject var updaterViewModel: UpdaterViewModel
    @State private var automaticallyChecksForUpdates = true
    
    @Default(.showNumberOfConnectedVolumes) var showNumberOfConnectedVolumes

    var body: some View {
        SettingsForm {
            Section {
                LaunchAtLogin.Toggle {
                    Text(L10n.launchAtLogin)
                }
            }
            Section {
                Toggle(L10n.checkForUpdatesAutomatically, isOn: $automaticallyChecksForUpdates)
                    .onChange(of: automaticallyChecksForUpdates) { newValue in
                        updaterViewModel.automaticallyChecksForUpdates = newValue
                    }
                    .onAppear {
                        automaticallyChecksForUpdates = updaterViewModel.automaticallyChecksForUpdates
                    }
            }
            Section {
                Defaults.Toggle(L10n.showNumberOfConnectedVolumes, key: .showNumberOfConnectedVolumes)
                Defaults.Toggle(L10n.doNotDisplayNumbersWhenNothingIsConnected, key: .doNotDisplayNumbersWhenNothingIsConnected)
                    .disabled(!showNumberOfConnectedVolumes)
                    .foregroundColor(showNumberOfConnectedVolumes ? .primary : .secondary)
            }
            Section {
                Defaults.Toggle(L10n.showEjectAllVolumesButton, key: .showEjectAllVolumesButton)
                Defaults.Toggle(L10n.showEjectAllVolumesInDiskButtons, key: .showEjectAllVolumesInDiskButtons)
                Defaults.Toggle(L10n.showActionMenu, key: .showActionMenu)
                Defaults.Toggle(L10n.showDetailedInformation, key: .showDetailedInformation)
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
