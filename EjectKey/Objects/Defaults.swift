//
//  Defaults.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
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
    static let automaticallyChecksForUpdates = Key<Bool>("automaticallyChecksForUpdates", default: true)
    static let checkPrereleaseVersions = Key<Bool>("checkPrereleaseVersions", default: false)
    // Menu Bar
    static let showNumberOfConnectedVolumes = Key<Bool>("showNumberOfConnectedVolumes", default: false)
    static let doNotDisplayNumbersWhenNothingIsConnected = Key<Bool>("doNotDisplayNumbersWhenNothingIsConnected", default: false)
    static let showEjectAllVolumesButton = Key<Bool>("showEjectAllButton", default: true)
    static let showEjectAllVolumesInDiskButtons = Key<Bool>("showEjectAllVolumesInDiskButtons", default: true)
    static let showActionMenu = Key<Bool>("showActionMenu", default: false)
    static let showDetailedInformation = Key<Bool>("showDetailedInformation", default: false)
    // Touch Bar
    static let showControlStripButton = Key<Bool>("showControlStripButton", default: false)
    static let displayOnlyWhenExternalVolumeIsConnected = Key<Bool>("displayOnlyWhenExternalVolumeIsConnected", default: false)
    static let controlStripButtonAction = Key<ControlStripButtonAction>("controlStripButtonAction", default: .ejectAll)
    // Notifications
    static let sendWhenVolumeIsConnected = Key<Bool>("sendWhenVolumeIsConnected", default: true)
    static let sendWhenVolumeIsEjected = Key<Bool>("sendWhenVolumeIsEjected", default: true)
    static let doNotSendNotificationsAboutVirtualVolumes = Key<Bool>("doNotSendNotificationsAboutVirtualVolumes", default: true)
    static let soundWhenSendingNotifications = Key<Bool>("soundWhenSendingNotifications", default: false)
    // Experimental
    static let showQuitDialogWhenEjectionFails = Key<Bool>("showQuitDialogWhenEjectionFails", default: false)
    static let showMoveToTrashDialog = Key<Bool>("showMoveToTrashDialog", default: false)
}
