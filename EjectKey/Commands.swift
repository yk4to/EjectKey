//
//  Commands.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Foundation

extension AppDelegate {
    func eject(index: Int) {
        let volume = volumes[index]
        ejectAndAlert(volume)
    }
    
    func ejectAll() {
        volumes.forEach {
            ejectAndAlert($0)
        }
    }
    
    func ejectAllVolumeInDisk(unit: Int) {
        getVolumesFromUnit(unit).forEach {
            ejectAndAlert($0.element)
        }
    }
    
    func getVolumesFromUnit(_ unit: Int) -> [EnumeratedSequence<[Volume]>.Element] {
        return volumes.enumerated().filter { $0.element.unit == unit }
    }
    
    func getVolumes() {
        if let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: []) {
            volumes = mountedVolumeURLs.compactMap({Volume(url: $0)})
            units = volumes.map({$0.unit}).unique
        }
    }
    
    private func ejectAndAlert(_ volume: Volume) {
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
}
