//
//  ShortcutsView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/08.
//

import SwiftUI
import KeyboardShortcuts

struct ShortcutsView: View {
    var body: some View {
        SettingsForm {
            KeyboardShortcuts.Recorder(L10n.ejectAllVolumes, name: .ejectAllVolumes)
        }
    }
}

struct ShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsView()
    }
}
