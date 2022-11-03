//
//  GeneralView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import SwiftUI
import LaunchAtLogin
import Defaults

struct GeneralView: View {

    var body: some View {
        Form {
            LaunchAtLogin.Toggle {
                Text(L10n.launchAtLogin)
            }
            Defaults.Toggle(L10n.showNumberOfConnectedVolumes, key: .showNumberOfConnectedVolumes)
            Defaults.Toggle(L10n.showEjectAllVolumesButton, key: .showEjectAllVolumesButton)
            Defaults.Toggle(L10n.showEjectAllVolumesInDiskButtons, key: .showEjectAllVolumesInDiskButtons)
            Defaults.Toggle(L10n.showActionMenu, key: .showActionMenu)
            Defaults.Toggle(L10n.showDetailedInformation, key: .showDetailedInformation)
        }
        .padding(20)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
