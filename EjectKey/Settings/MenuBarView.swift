//
//  MenuBarView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import SwiftUI
import Defaults

struct MenuBarView: View {
    
    var body: some View {
        Form {
            Defaults.Toggle(L10n.showEjectAllVolumesButton, key: .showEjectAllVolumesButton)
            Defaults.Toggle(L10n.showEjectAllVolumesInDiskButtons, key: .showEjectAllVolumesInDiskButtons)
        }
        .padding(20)
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
    }
}
