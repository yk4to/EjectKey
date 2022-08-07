//
//  GeneralView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import SwiftUI
import LaunchAtLogin

struct GeneralView: View {

    var body: some View {
        Form {
            LaunchAtLogin.Toggle {
                Text(L10n.launchAtLogin)
            }
        }
        .padding(20)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
