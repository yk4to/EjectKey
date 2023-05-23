//
//  HideSidebarToggle.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/05/21.
//

// ref: https://github.com/CodeEditApp/CodeEdit/blob/main/CodeEdit/Features/Settings/Views/View%2BHideSidebarToggle.swift

import SwiftUI

extension View {
    func hideSidebarToggle() -> some View {
        modifier(HideSidebarToggleViewModifier())
    }
}

struct HideSidebarToggleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                let window = NSApp.windows.first { $0.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" }!
                let sidebaritem = "com.apple.SwiftUI.navigationSplitView.toggleSidebar"
                let index = window.toolbar?.items.firstIndex { $0.itemIdentifier.rawValue == sidebaritem }
                if let index {
                    window.toolbar?.removeItem(at: index)
                }
            }
    }
}
