//
//  Commands.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import AppKit
import Defaults
import AudioToolbox
import SwiftShell

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
                        self.sendNotification(
                            title: L10n.failedToEjectVol(volume.name),
                            body: error!.localizedDescription,
                            sound: .defaultCritical,
                            identifier: UUID().uuidString
                        )
                    }
                    
                    if Defaults[.showQuitDialogWhenEjectionFails] {
                        DispatchQueue.global().async {
                            let culprits = volume.getCulprits()
                            if !culprits.isEmpty {
                                DispatchQueue.main.async {
                                    self.alert(
                                        alertStyle: .warning,
                                        messageText: L10n.theFollowingApplicationsAreUsingVol(volume.name),
                                        informativeText: culprits.map(\.name).joined(separator: "\n"),
                                        buttonTitle: L10n.quit,
                                        showCancelButton: true,
                                        hasDestructiveAction: true
                                    ) {
                                        for culprit in culprits {
                                            culprit.application.terminate()
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if Defaults[.sendWhenVolumeIsEjected] {
                        self.sendNotification(
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
                    self.sendNotification(
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
                    self.alert(
                        alertStyle: .informational,
                        messageText: L10n.foundTheFollowingDmgFiles,
                        informativeText: dmgFileNames.joined(separator: "\n"),
                        buttonTitle: L10n.moveToTrash,
                        showCancelButton: true,
                        hasDestructiveAction: true
                    ) {
                        for dmgFileName in dmgFileNames {
                            let dmgFileUrl = downloadsDir.appending(path: dmgFileName)
                            try? fileManager.trashItem(at: dmgFileUrl, resultingItemURL: nil)
                        }
                        // Play the "Move to Trash" Sound
                        AudioServicesPlaySystemSound(0x10)
                    }
                }
            }
        }
    }
    
    func setTimeMachines() {
        let result = run("/usr/bin/tmutil", "destinationinfo", "-X")
        if !result.succeeded {
            return
        }
        guard let data = result.stdout.data(using: .utf8) else {
            return
        }
        guard let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? NSMutableDictionary else {
            return
        }
        guard let destinations = plist["Destinations"] as? [NSMutableDictionary] else {
            return
        }
        
        var _timeMachineMountPoints: [String] = []
        
        for destination in destinations {
            guard let mountPoint = destination["MountPoint"] as? String else {
                return
            }
            guard let encoded = mountPoint.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                return
            }
            _timeMachineMountPoints.append(encoded + "/")
        }
        
        timeMachineMountPoints = _timeMachineMountPoints
    }
    
    func isTimeMachine(_ unit: Unit) -> Bool {
        let firstVolume = unit.volumes.first!
        return isTimeMachine(firstVolume)
    }
    
    func isTimeMachine(_ volume: Volume) -> Bool {
        return timeMachineMountPoints.contains(volume.url.path())
    }
}
