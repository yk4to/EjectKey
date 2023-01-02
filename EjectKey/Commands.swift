//
//  Commands.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import AppKit
import Defaults

extension AppModel {
    func eject(_ volume: Volume) {
        DispatchQueue.global().async {
            volume.eject(force: false, action: {
                if Defaults[.sendWhenDiskIsEjected] {
                    self.alert(
                        title: L10n.volWasSuccessfullyEjected(volume.name),
                        body: L10n.safelyRemoved,
                        sound: .default,
                        identifier: UUID().uuidString
                    )
                }
            }, errorAction: { description in
                if Defaults[.sendWhenDiskIsEjected] {
                    self.alert(
                        title: L10n.failedToEjectVol(volume.name),
                        body: description,
                        sound: .defaultCritical,
                        identifier: UUID().uuidString
                    )
                }
                
                if Defaults[.showAppsWhenEjectionFails] {
                    DispatchQueue.global().async {
                        let culprits = volume.getCulprits()
                        if !culprits.isEmpty {
                            DispatchQueue.main.async {
                                let alert = NSAlert()
                                alert.alertStyle = .warning
                                alert.messageText = L10n.applicationsUsingVol(volume.name)
                                alert.informativeText = culprits.joined(separator: "\n")
                                alert.addButton(withTitle: "OK")
                                alert.runModal()
                            }
                        }
                    }
                }
            })
        }
    }
    
    func ejectAll() {
        allVolumes.forEach {
            eject($0)
        }
    }
    
    func ejectAllVolumeInDisk(_ unit: Unit) {
        unit.volumes.forEach {
            eject($0)
        }
    }
    
    func getUnits(check: Bool) {
        if let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: []) {
            let _volumes = mountedVolumeURLs.compactMap { Volume(url: $0) }
            if check {
                checkVolumes(old: allVolumes, new: _volumes)
            }
            
            allVolumes = _volumes
            let devicePaths = allVolumes.map({$0.devicePath}).unique
            units = devicePaths.map({ Unit(devicePath: $0, allVolumes: allVolumes) })
        }
    }
    
    func checkVolumes(old: [Volume], new: [Volume]) {
        if Defaults[.sendWhenDiskIsConnected] {
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
}
