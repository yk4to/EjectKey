//
//  SettingsView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import SwiftUI
import SFSafeSymbols

struct SettingsView: View {
    @ObservedObject var model: AppModel
    
    var body: some View {
        TabView(selection: $model.settingsTabSelection) {
            GeneralView()
                .tabItem {
                    Label(L10n.general, systemSymbol: .gearshape)
                }
                .tag("general")
            ShortcutsView()
                .tabItem {
                    Label(L10n.shortcuts, systemSymbol: .command)
                }
                .tag("shortcut")
            NotificationsView()
                .tabItem {
                    Label(L10n.notifications, systemSymbol: .bell)
                }
                .tag("notifications")
            TouchBarView()
                .tabItem {
                    Label(L10n.touchBar, systemSymbol: .rectangleAndHandPointUpLeft)
                }
                .tag("touchbar")
            ExperimentalView()
                .tabItem {
                    Label(L10n.experimental, systemSymbol: .sparkles)
                }
                .tag("experimental")
            AboutView()
                .tabItem {
                    Label(L10n.about, systemSymbol: .infoCircle)
                }
                .tag("about")
        }
        .frame(width: 500, height: .none)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: AppModel())
    }
}
