//
//  SettingsView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import SwiftUI
import SFSafeSymbols

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralView()
                .tabItem {
                    Label(L10n.general, systemSymbol: .sliderHorizontal3)
                }
            ShortcutsView()
                .tabItem {
                    Label(L10n.shortcuts, systemSymbol: .command)
                }
            NotificationsView()
                .tabItem {
                    Label(L10n.notifications, systemSymbol: .bell)
                }
        }
        .frame(width: 500, height: .none)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
