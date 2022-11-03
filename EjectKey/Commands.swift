//
//  Commands.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Foundation

extension AppModel {
    func eject(_ volume: Volume) {
        volume.eject(force: false, action: {
            self.alert(
                title: L10n.volWasSuccessfullyEjected(volume.name),
                body: L10n.safelyRemoved,
                sound: .default,
                identifier: volume.id
            )
        }, errorAction: { description in
            self.alert(
                title: L10n.failedToEjectVol(volume.name),
                body: description,
                sound: .defaultCritical,
                identifier: volume.id
            )
        })
    }
    
    func ejectAll() {
        volumes.forEach {
            eject($0)
        }
    }
    
    func ejectAllVolumeInDisk(_ unit: Int) {
        getVolumesFromUnit(unit).forEach {
            eject($0)
        }
    }
    
    func getVolumesFromUnit(_ unit: Int) -> [Volume] {
        return volumes.filter { $0.unit == unit }
    }
    
    func getVolumes() {
        if let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: []) {
            volumes = mountedVolumeURLs.compactMap({Volume(url: $0)})
            units = volumes.map({$0.unit}).unique
        }
    }
}
