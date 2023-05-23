//
//  SettingsView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import SwiftUI
import SFSafeSymbols

struct SettingsPage: Hashable, Identifiable {
    internal init(
        _ name: Name,
        baseColor: Color? = nil,
        icon: SFSymbol
    ) {
        self.name = name
        self.baseColor = baseColor ?? .blue
        self.icon = icon
    }

    var id: String { name.rawValue }

    let name: Name
    let baseColor: Color
    let icon: SFSymbol

    enum Name: String {
        case general
        case shortcuts
        case notifications
        case touchbar
        case experimental
        case about
    }
}

struct SettingsView: View {
    @ObservedObject var model: AppModel
    
    let settingsPages: [SettingsPage] = [
        .init(.general, baseColor: .gray, icon: .gear),
        .init(.shortcuts, baseColor: .blue, icon: .command),
        .init(.notifications, baseColor: .red, icon: .bellBadgeFill),
        .init(.touchbar, baseColor: .blue, icon: .rectangleAndHandPointUpLeft),
        .init(.experimental, baseColor: .cyan, icon: .sparkles),
        .init(.about, baseColor: .gray, icon: .infoCircle)
    ]
    
    private func getDisplayName(_ name: SettingsPage.Name) -> String {
        switch name {
        case .general:
            return L10n.general
        case .shortcuts:
            return L10n.shortcuts
        case .notifications:
            return L10n.notifications
        case .touchbar:
            return L10n.touchBar
        case .experimental:
            return L10n.experimental
        case .about:
            return L10n.about
        }
    }
    
    var body: some View {
        
        NavigationSplitView {
            List(selection: $model.settingsTabSelection) {
                ForEach(settingsPages) { page in
                    Label {
                        Text(getDisplayName(page.name))
                            .padding(.leading, 2)
                    } icon: {
                        Image(systemSymbol: page.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: Color(NSColor.black).opacity(0.25), radius: 0.5, y: 0.5)
                        .padding(2.5)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 5,
                                style: .continuous
                            )
                            .fill(page.baseColor.gradient)
                            .shadow(color: Color(NSColor.black).opacity(0.25), radius: 0.5, y: 0.5)
                        )
                    }
                    .tag(page.name)
                }
            }
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(215)
        } detail: {
            Group {
                switch model.settingsTabSelection {
                case .general:
                    GeneralView()
                case .shortcuts:
                    ShortcutsView()
                case .notifications:
                    NotificationsView()
                case .touchbar:
                    TouchBarView()
                case .experimental:
                    ExperimentalView()
                case .about:
                    AboutView()
                }
            }
            .hideSidebarToggle()
            .navigationSplitViewColumnWidth(500)
        }
        .navigationTitle(getDisplayName(model.settingsTabSelection))
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Rectangle()
                    .frame(width: 10)
                    .opacity(0)
            }
        }
        .frame(minHeight: 418)
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: AppModel())
    }
}
