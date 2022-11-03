//
//  Defaults.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Cocoa
import Defaults

extension Defaults.Keys {
    static let isFirstLaunch = Key<Bool>("isFirstLaunch", default: true)
    // Menu Bar
    static let showNumberOfConnectedVolumes = Key<Bool>("showNumberOfConnectedVolumes", default: false)
    static let showEjectAllVolumesButton = Key<Bool>("showEjectAllButton", default: true)
    static let showEjectAllVolumesInDiskButtons = Key<Bool>("showEjectAllVolumesInDiskButtons", default: true)
    static let showActionMenu = Key<Bool>("showActionMenu", default: false)
    static let showDetailedInformation = Key<Bool>("showDetailedInformation", default: false)
    // Notifications
    static let enableNotifications = Key<Bool>("enableNotifications", default: true)
}
