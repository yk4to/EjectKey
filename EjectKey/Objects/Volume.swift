//
//  Volume.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

// ref: https://github.com/bradleybernard/EjectBar/blob/master/EjectBar/Classes/Volume.swift
// ref: https://github.com/nielsmouthaan/ejectify-macos/blob/main/ejectify/Model/ExternalVolume.swift
// ref: https://github.com/phu54321/Semulov/blob/master/SLListCulprits.m

import Dispatch
import Cocoa

struct Culprit: Equatable {
    let name: String
    let application: NSRunningApplication
}

class Volume {

    let disk: DADisk
    let bsdName: String
    let name: String
    let url: URL
    let size: Int
    let deviceProtocol: String
    let deviceModel: String
    let deviceVendor: String
    let devicePath: String
    let type: String
    let unitNumber: Int
    let id: String
    let icon: NSImage
    let isVirtual: Bool
    let isDiskImage: Bool
    
    init?(url: URL) {
        let resourceValues = try? url.resourceValues(forKeys: [.volumeIsInternalKey, .volumeLocalizedFormatDescriptionKey])
        
        // let isExternalVolume = url.pathComponents.count > 1 && url.pathComponents[1] == "Volumes"
        let isInternalVolume = resourceValues?.volumeIsInternal ?? false
        if isInternalVolume {
            return nil
        }
        
        guard let session = DASessionCreate(kCFAllocatorDefault) else {
            return nil
        }
        
        guard let disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, url as CFURL) else {
            return nil
        }
        
        guard let diskInfo = DADiskCopyDescription(disk) as? [NSString: Any] else {
            return nil
        }
        // For debug
        // print("\(diskInfo as AnyObject)")
        
        guard let name = diskInfo[kDADiskDescriptionVolumeNameKey] as? String else {
            return nil
        }
        guard let bsdName = diskInfo[kDADiskDescriptionMediaBSDNameKey] as? String else {
            return nil
        }
        guard let size = diskInfo[kDADiskDescriptionMediaSizeKey] as? Int else {
            return nil
        }
        guard let deviceProtocol = diskInfo[kDADiskDescriptionDeviceProtocolKey] as? String else {
            return nil
        }
        guard let deviceModel = diskInfo[kDADiskDescriptionDeviceModelKey] as? String else {
            return nil
        }
        guard let deviceVendor = diskInfo[kDADiskDescriptionDeviceVendorKey] as? String else {
            return nil
        }
        guard let devicePath = diskInfo[kDADiskDescriptionDevicePathKey] as? String else {
            return nil
        }
        guard let unitNumber = diskInfo[kDADiskDescriptionMediaBSDUnitKey] as? Int else {
            return nil
        }
        let idVal = diskInfo[kDADiskDescriptionVolumeUUIDKey]
        // swiftlint:disable force_cast
        let uuid = idVal as! CFUUID
        guard let cfID = CFUUIDCreateString(kCFAllocatorDefault, uuid) else {
            return nil
        }
        let id = cfID as String
        let icon = NSWorkspace.shared.icon(forFile: url.path)
        
        let type = resourceValues?.volumeLocalizedFormatDescription ?? ""
        
        self.disk = disk
        self.bsdName = bsdName
        self.name = name
        self.url = url
        self.size = size
        self.deviceProtocol = deviceProtocol
        self.deviceModel = deviceModel
        self.deviceVendor = deviceVendor
        self.devicePath = devicePath
        self.type = type
        self.unitNumber = unitNumber
        self.id = id
        self.icon = icon
        self.isVirtual = deviceProtocol == "Virtual Interface"
        self.isDiskImage = self.isVirtual && ( deviceModel == "Disk Image" )
    }
    
    func unmount(unmountAndEject: Bool, withoutUI: Bool, completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            let options: FileManager.UnmountOptions = [
                unmountAndEject ? .allPartitionsAndEjectDisk : [],
                withoutUI ? .withoutUI: []
            ]
            
            fileManager.unmountVolume(at: self.url, options: options, completionHandler: completionHandler)
        }
    }
    
    func getCulprits() -> [Culprit] {
        var culprits: [Culprit] = []
        
        let applications = NSWorkspace.shared.runningApplications
        for application in applications {
            let pid = String(application.processIdentifier)
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/lsof")
            process.arguments = ["-Fcnp", "-p", pid]
            let outputPipe = Pipe()
            process.standardOutput = outputPipe
            process.launch()
            
            if let data = try? outputPipe.fileHandleForReading.readToEnd(),
               let output = String(data: data, encoding: .utf8) {
                
                let lines = output.components(separatedBy: .newlines)
                for line in lines {
                    if line.count == 0 {
                        continue
                    }
                    let c = line.prefix(1)
                    let v = String(line.dropFirst(1))
                    if c == "n" && v.hasPrefix("/Volumes/\(url.lastPathComponent)/") {
                        if let appName = application.localizedName {
                            culprits.append(Culprit(name: appName, application: application))
                        }
                    }
                }
            }
        }
        return culprits.unique
    }
}
