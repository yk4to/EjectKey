//
//  UpdaterViewModel.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

// ref: https://sparkle-project.org/documentation/programmatic-setup/

import Sparkle

// This view model class publishes when new updates can be checked by the user
final class UpdaterViewModel: ObservableObject {
    private let updaterController: SPUStandardUpdaterController
    
    @Published var canCheckForUpdates = false
    
    var automaticallyChecksForUpdates: Bool {
        get {
            return updaterController.updater.automaticallyChecksForUpdates
        }
        set(newValue) {
            updaterController.updater.automaticallyChecksForUpdates = newValue
        }
    }
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        
        updaterController.updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
        
        if automaticallyChecksForUpdates {
            updaterController.updater.checkForUpdatesInBackground()
        }
    }
    
    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }
}
