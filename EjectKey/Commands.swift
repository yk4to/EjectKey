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
                identifier: UUID().uuidString
            )
        }, errorAction: { description in
            self.alert(
                title: L10n.failedToEjectVol(volume.name),
                body: description,
                sound: .defaultCritical,
                identifier: UUID().uuidString
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
    
    func getVolumes(check: Bool) {
        if let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: []) {
            let _volumes = mountedVolumeURLs.compactMap { Volume(url: $0) }
            if check {
                checkVolumes(old: volumes, new: _volumes)
            }
            
            volumes = _volumes
            units = volumes.map({$0.unit}).unique.sorted()
        }
    }
    
    func checkVolumes(old: [Volume], new: [Volume]) {
        let oldIds = old.map { $0.id }
        let mountedVolumes = new.filter { !oldIds.contains($0.id) }
        
        for volume in mountedVolumes {
            alert(
                title: L10n.volHasBeenConnected(volume.name),
                body: "",
                sound: .default,
                identifier: UUID().uuidString
            )
        }
    }
}
