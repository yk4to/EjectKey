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
    let id: String
    let name: String
    let url: URL
    let unit: Int
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
        
        guard let diskInfo = DADiskCopyDescription(disk) as? [String: Any] else {
            return nil
        }
        
        guard let name = diskInfo["DAVolumeName"] as? String else {
            return nil
        }
        guard let id = diskInfo["DAMediaBSDName"] as? String else {
            return nil
        }
        guard let unit = diskInfo["DAMediaBSDUnit"] as? Int else {
            return nil
        }
        let icon = NSWorkspace.shared.icon(forFile: url.path)
        
        self.disk = disk
        self.id = id
        self.name = name
        self.url = url
        self.unit = unit
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
