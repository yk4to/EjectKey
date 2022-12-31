//
//  Defaults.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
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
    static let sendWhenDiskIsConnected = Key<Bool>("sendWhenDiskIsConnected", default: true)
    static let sendWhenDiskIsEjected = Key<Bool>("sendWhenDiskIsEjected", default: true)
    static let soundWhenSendingNotifications = Key<Bool>("soundWhenSendingNotifications", default: false)
    static let showAppsWhenEjectionFails = Key<Bool>("showAppsWhenEjectionFails", default: false)
}
