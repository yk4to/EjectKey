//
//  TouchBarView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import SwiftUI
import Defaults

struct TouchBarView: View {
    @Default(.controlStripButtonAction) var controlStripButtonAction
    
    var body: some View {
        Form {
            Defaults.Toggle(L10n.showControlStripButton, key: .showControlStripButton)
            Defaults.Toggle(L10n.displayOnlyWhenExternalVolumeIsConnected, key: .displayOnlyWhenExternalVolumeIsConnected)
            Picker(L10n.actionWhenButtonIsPressed, selection: $controlStripButtonAction) {
                ForEach(ControlStripButtonAction.allCases, id: \.self) { action in
                    Text(action.localized).tag(action)
                }
            }
        }
        .formStyle(.grouped)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct TouchBarView_Previews: PreviewProvider {
    static var previews: some View {
        TouchBarView()
    }
}
