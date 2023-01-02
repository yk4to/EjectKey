//
//  CheckForUpdatesView.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

// ref: https://sparkle-project.org/documentation/programmatic-setup/

import SwiftUI
import Sparkle

// This is the view for the Check for Updates menu item
// Note this intermediate view is necessary for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more info
struct CheckForUpdatesView: View {
    @ObservedObject var updaterViewModel: UpdaterViewModel
    
    var body: some View {
        Button(L10n.checkForUpdates, action: updaterViewModel.checkForUpdates)
            .disabled(!updaterViewModel.canCheckForUpdates)
    }
}
