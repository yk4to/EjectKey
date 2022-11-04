//
//  Volume.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

// ref: https://github.com/bradleybernard/EjectBar/blob/master/EjectBar/Classes/Volume.swift
// ref: https://github.com/nielsmouthaan/ejectify-macos/blob/main/ejectify/Model/ExternalVolume.swift

import Dispatch
import Cocoa

class Volume {

    let disk: DADisk
    let bsdName: String
    let name: String
    let url: URL
    let size: Int
    let `protocol`: String
    let unit: Int
    let id: String
    let icon: NSImage
    
    init?(url: URL) {
        let isExternalVolume = url.pathComponents.count > 1 && url.pathComponents[1] == "Volumes"
        if !isExternalVolume {
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
        guard let `protocol` = diskInfo[kDADiskDescriptionDeviceProtocolKey] as? String else {
            return nil
        }
        guard let unit = diskInfo[kDADiskDescriptionMediaBSDUnitKey] as? Int else {
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
        
        self.disk = disk
        self.bsdName = bsdName
        self.name = name
        self.url = url
        self.size = size
        self.protocol = `protocol`
        self.unit = unit
        self.id = id
        self.icon = icon
    }
    
    func eject(force: Bool, action: (() -> Void)?, errorAction: ((String) -> Void)?) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            do {
                try NSWorkspace.shared.unmountAndEjectDevice(at: self.url)
                action?()
            } catch {
                errorAction?((error as NSError).description)
            }
        }
    }
}
