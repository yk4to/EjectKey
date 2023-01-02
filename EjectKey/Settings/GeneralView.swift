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

    var body: some View {
        Form {
            Section {
                LaunchAtLogin.Toggle {
                    Text(L10n.launchAtLogin)
                }
            }
            Section {
                Defaults.Toggle(L10n.showNumberOfConnectedVolumes, key: .showNumberOfConnectedVolumes)
                Defaults.Toggle(L10n.doNotDisplayNumbersWhenNothingIsConnected, key: .doNotDisplayNumbersWhenNothingIsConnected)
            }
            Section {
                Defaults.Toggle(L10n.showEjectAllVolumesButton, key: .showEjectAllVolumesButton)
                Defaults.Toggle(L10n.showEjectAllVolumesInDiskButtons, key: .showEjectAllVolumesInDiskButtons)
                Defaults.Toggle(L10n.showActionMenu, key: .showActionMenu)
                Defaults.Toggle(L10n.showDetailedInformation, key: .showDetailedInformation)
            }
        }
        .formStyle(.grouped)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
