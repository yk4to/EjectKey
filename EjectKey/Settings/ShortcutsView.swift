//
//  ShortcutsView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/08.
//

import SwiftUI
import KeyboardShortcuts

struct ShortcutsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder(L10n.ejectAllVolumes, name: .ejectAllVolumes)
        }
        .padding(20)
    }
}

struct ShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsView()
    }
}
