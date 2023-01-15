//
//  UpdaterViewModel.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

// ref: https://sparkle-project.org/documentation/programmatic-setup/
// ref: https://github.com/RobotsAndPencils/XcodesApp/blob/main/Xcodes/Frontend/Preferences/UpdatesPreferencePane.swift

import Sparkle
import Defaults

extension URL {
    static let appcast = URL(string: "https://fus1ondev.github.io/EjectKey/appcast.xml")!
    static let prereleaseAppcast = URL(string: "https://fus1ondev.github.io/EjectKey/appcast_pre.xml")!
}

// This view model class publishes when new updates can be checked by the user
final class UpdaterViewModel: ObservableObject {
    private let updaterController: SPUStandardUpdaterController
    
    @Published var canCheckForUpdates = false
    
    @Published var checkPrereleaseVersions = false {
        didSet {
            Defaults[.checkPrereleaseVersions] = checkPrereleaseVersions

            if checkPrereleaseVersions {
                updaterController.updater.setFeedURL(.prereleaseAppcast)
            } else {
                updaterController.updater.setFeedURL(.appcast)
            }
        }
    }
    
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
        
        checkPrereleaseVersions = Defaults[.checkPrereleaseVersions]
    }
    
    func checkForUpdates() {
        if canCheckForUpdates {
            updaterController.checkForUpdates(nil)
        }
    }
}
