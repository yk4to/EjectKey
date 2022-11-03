//
//  Defaults.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Cocoa
import Defaults

enum ControlStripButtonAction: String, CaseIterable, Defaults.Serializable {
    case ejectAll, actAsMediaEjectKey
    
    var localized: String {
        switch self {
        case .ejectAll:
            return L10n.ejectAllVolumes
        case .actAsMediaEjectKey:
            return L10n.actAsMediaEjectKey
        }
    }
}

extension Defaults.Keys {
    static let isFirstLaunch = Key<Bool>("isFirstLaunch", default: true)
    // Menu Bar
    static let showMenuBarExtra = Key<Bool>("showMenuBarExtra", default: true)
    static let showNumberOfConnectedVolumes = Key<Bool>("showNumberOfConnectedVolumes", default: false)
    static let showEjectAllVolumesButton = Key<Bool>("showEjectAllButton", default: true)
    static let showEjectAllVolumesInDiskButtons = Key<Bool>("showEjectAllVolumesInDiskButtons", default: true)
    static let showActionMenu = Key<Bool>("showActionMenu", default: false)
    static let showDetailedInformation = Key<Bool>("showDetailedInformation", default: false)
    // Touch Bar
    static let showControlStripButton = Key<Bool>("showControlStripButton", default: true)
    static let displayOnlyWhenExternalVolumeIsConnected = Key<Bool>("displayOnlyWhenExternalVolumeIsConnected", default: false)
    static let controlStripButtonAction = Key<ControlStripButtonAction>("controlStripButtonAction", default: .ejectAll)
    // Notifications
    static let enableNotifications = Key<Bool>("enableNotifications", default: true)
}
