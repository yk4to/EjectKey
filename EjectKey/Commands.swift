//
//  Commands.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import AppKit
import Defaults
import AudioToolbox

extension AppModel {
    func eject(_ volume: Volume) {
        DispatchQueue.global().async {
            volume.eject(force: false, action: {
                /*if Defaults[.sendWhenDiskIsEjected] {
                    self.alert(
                        title: L10n.volWasSuccessfullyEjected(volume.name),
                        body: L10n.safelyRemoved,
                        sound: .default,
                        identifier: UUID().uuidString
                    )
                }*/
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
        DispatchQueue.global().async {
            if Defaults[.sendWhenDiskIsConnected] {
                let oldIds = old.map { $0.id }
                let mountedVolumes = new.filter { !oldIds.contains($0.id) }
                
                for volume in mountedVolumes {
                    DispatchQueue.main.async {
                        self.alert(
                            title: L10n.volHasBeenConnected(volume.name),
                            body: "",
                            sound: .default,
                            identifier: UUID().uuidString
                        )
                    }
                }
            }
            
            if Defaults[.sendWhenDiskIsEjected] || Defaults[.showMoveToTrashDialog] {
                let newIds = new.map { $0.id }
                let ejectedVolumes = old.filter { !newIds.contains($0.id) }
                
                if Defaults[.sendWhenDiskIsEjected] {
                    for volume in ejectedVolumes {
                        DispatchQueue.main.async {
                            self.alert(
                                title: L10n.volWasSuccessfullyEjected(volume.name),
                                body: L10n.safelyRemoved,
                                sound: .default,
                                identifier: UUID().uuidString
                            )
                        }
                    }
                }
                
                if Defaults[.showMoveToTrashDialog] && !ejectedVolumes.isEmpty {
                    let fileManager = FileManager.default
                    guard let downloadsDir = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                        return
                    }
                    guard let files = try? fileManager.contentsOfDirectory(atPath: downloadsDir.path()) else {
                        return
                    }
                    for volume in ejectedVolumes {
                        if volume.deviceProtocol != "Virtual Interface" {
                            return
                        }
                        let fixedVolumeName = volume.name.lowercased().replacingOccurrences(of: " ", with: "[ -_]*")
                        guard let regex = try? Regex("\(fixedVolumeName).*\\.dmg") else {
                            return
                        }
                        let dmgFileNames = files.filter({$0.lowercased().firstMatch(of: regex)?.0 != nil})
                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.messageText = L10n.foundTheFollowingDmgFiles
                            alert.informativeText = dmgFileNames.joined(separator: "\n")
                            alert.addButton(withTitle: L10n.moveToTrash)
                            alert.addButton(withTitle: L10n.cancel)
                            alert.buttons.first?.hasDestructiveAction = true
                            
                            let response = alert.runModal()
                            switch response {
                            case .alertFirstButtonReturn:
                                for dmgFileName in dmgFileNames {
                                    let dmgFileUrl = downloadsDir.appending(path: dmgFileName)
                                    try? fileManager.trashItem(at: dmgFileUrl, resultingItemURL: nil)
                                }
                                // Play the "Move to Trash" Sound
                                AudioServicesPlaySystemSound(0x10)
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
