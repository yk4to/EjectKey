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
        Form {
            HStack {
                Text(L10n.ejectAllVolumes)
                Spacer()
                KeyboardShortcuts.Recorder("", name: .ejectAllVolumes)
            }
        }
        .formStyle(.grouped)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsView()
    }
}
