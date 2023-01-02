//
//  ExperimentalView.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

import SwiftUI
import Defaults

struct ExperimentalView: View {
    @Default(.showAppsWhenEjectionFails) var showAppsWhenEjectionFails
    @Default(.showMoveToTrashDialog) var showMoveToTrashDialog

    var body: some View {
        Form {
            Section {
                Label(L10n.experimentalNote, systemSymbol: .exclamationmarkCircle)
                    .foregroundColor(.secondary)
            }
            Section {
                Toggle(L10n.showAppsWhenEjectionFails, isOn: $showAppsWhenEjectionFails)
            }
            Section {
                Toggle(L10n.showMoveToTrashDialog, isOn: $showMoveToTrashDialog)
            }
        }
        .formStyle(.grouped)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ExperimentalView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentalView()
    }
}
