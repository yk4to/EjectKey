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
            guard let unit = self.units.filter({ $0.devicePath == volume.devicePath }).first else {
                return
            }
            let isLastVolume = unit.volumes.count == 1
            volume.unmount(unmountAndEject: isLastVolume, withoutUI: false) { error in
                if error != nil {
                    if Defaults[.sendWhenVolumeIsEjected] {
                        self.alert(
                            title: L10n.failedToEjectVol(volume.name),
                            body: error!.localizedDescription,
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
                                    alert.informativeText = culprits.map(\.name).joined(separator: "\n")
                                    alert.addButton(withTitle: "Terminate")
                                    alert.addButton(withTitle: L10n.cancel)
                                    alert.buttons.first?.hasDestructiveAction = true
                                    let response = alert.runModal()
                                    switch response {
                                    case .alertFirstButtonReturn:
                                        for application in culprits.map(\.application) {
                                            application.terminate()
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if Defaults[.sendWhenVolumeIsEjected] {
                        self.alert(
                            title: L10n.volWasSuccessfullyEjected(volume.name),
                            body: volume.isVirtual ? L10n.thisVolumeIsAVirtualInterface : L10n.safelyRemoved,
                            sound: .default,
                            identifier: UUID().uuidString
                        )
                    }
                }
            }
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
    
    func setUnitsAndVolumes() {
        let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: [])
        allVolumes = mountedVolumeURLs?.compactMap(Volume.init) ?? []
        
        let devicePaths = allVolumes.map(\.devicePath).unique
        units = devicePaths.map({ Unit(devicePath: $0, allVolumes: allVolumes) })
    }
    
    func checkMountedVolumes(old: [Volume], new: [Volume]) {
        if !Defaults[.sendWhenVolumeIsConnected] {
            return
        }
        
        DispatchQueue.global().async {
            let oldIds = old.map(\.id)
            let mountedVolumes = new.filter({ !oldIds.contains($0.id) })
            
            for volume in mountedVolumes {
                DispatchQueue.main.async {
                    self.alert(
                        title: L10n.volumeConnected,
                        body: volume.isVirtual ? L10n.volIsAVirtualInterface(volume.name) : L10n.volIsAPhysicalDevice(volume.name),
                        sound: .default,
                        identifier: UUID().uuidString
                    )
                }
            }
        }
    }
    
    func checkEjectedVolumes(old: [Volume], new: [Volume]) {
        if !Defaults[.showMoveToTrashDialog] {
            return
        }
        
        DispatchQueue.global().async {
            let newIds = new.map(\.id)
            let ejectedVolumes = old.filter({ !newIds.contains($0.id) })
            
            if ejectedVolumes.isEmpty {
                return
            }
            
            let fileManager = FileManager.default
            guard let downloadsDir = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                return
            }
            guard let files = try? fileManager.contentsOfDirectory(atPath: downloadsDir.path()) else {
                return
            }
            
            for volume in ejectedVolumes {
                if !volume.isDiskImage {
                    return
                }
                let fixedVolumeName = volume.name.lowercased().replacingOccurrences(of: " ", with: "[ -_]*")
                guard let regex = try? Regex("\(fixedVolumeName).*\\.dmg$") else {
                    return
                }
                let dmgFileNames = files.filter({$0.lowercased().firstMatch(of: regex)?.0 != nil})
                if dmgFileNames.isEmpty {
                    return
                }
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
