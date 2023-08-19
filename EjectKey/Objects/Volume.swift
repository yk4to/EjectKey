//
//  Volume.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

// ref: https://github.com/bradleybernard/EjectBar/blob/master/EjectBar/Classes/Volume.swift
// ref: https://github.com/nielsmouthaan/ejectify-macos/blob/main/ejectify/Model/ExternalVolume.swift
// ref: https://github.com/phu54321/Semulov/blob/master/SLListCulprits.m
// ref: https://github.com/CloverHackyColor/CloverBootloader/blob/master/CloverApp/Clover/Disks.swift

import Dispatch
import Cocoa
import IOKit.kext

class Volume {
    let diskInfo: [NSString: Any]
    
    let bsdName: String
    let devicePath: String
    let mediaPath: String
    let unitNumber: Int
    let type: VolumeType
    
    let name: String?
    let path: String?
    let url: URL?
    let size: Int?
    let id: String?
    
    init?(bsdName: String) {
        /* guard let resourceValues = try? url.resourceValues(forKeys: [.volumeIsInternalKey, .volumeLocalizedFormatDescriptionKey]) else {
            return nil
        }
        
        let isInternalVolume = resourceValues.volumeIsInternal ?? false
        
        if isInternalVolume {
            return nil
        } */
        
        guard let session = DASessionCreate(kCFAllocatorDefault),
              let disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, bsdName),
              let diskInfo = DADiskCopyDescription(disk) as? [NSString: Any],
              let devicePath = diskInfo[kDADiskDescriptionDevicePathKey] as? String,
              let mediaPath = diskInfo[kDADiskDescriptionMediaPathKey] as? String,
              let unitNumber = diskInfo[kDADiskDescriptionMediaBSDUnitKey] as? Int
        else {
            return nil
        }
        
        self.diskInfo = diskInfo
        self.bsdName = bsdName
        self.devicePath = devicePath
        self.mediaPath = mediaPath
        self.unitNumber = unitNumber
        
        // Optional Properties
        let name = (diskInfo[kDADiskDescriptionVolumeNameKey] as? String) ?? (diskInfo[kDADiskDescriptionMediaNameKey] as? String)
        let path = diskInfo[kDADiskDescriptionVolumePathKey] as? String
        let url = (path != nil) ? URL(fileURLWithPath: path!) : nil
        let size = diskInfo[kDADiskDescriptionMediaSizeKey] as? Int
        
        self.name = name
        self.path = path
        self.url = url
        self.size = size
        
        let guid = diskInfo[kDADiskDescriptionMediaContentKey] as? String
        let type = diskInfo[kDADiskDescriptionVolumeTypeKey] as? String
        let kind = diskInfo[kDADiskDescriptionVolumeKindKey] as? String
        self.type = VolumeType(guid, type, kind)
        
        if let idVal = diskInfo[kDADiskDescriptionVolumeUUIDKey] {
            // swiftlint:disable force_cast
            let id = CFUUIDCreateString(kCFAllocatorDefault, (idVal as! CFUUID)) as? String
            // swiftlint:enable force_cast
            self.id = id
        } else {
            self.id = nil
        }
    }
    
    var icon: NSImage? {
        if let iconPath = getIconPath() {
            return NSImage(byReferencingFile: iconPath)
        } else {
            return nil
        }
    }
    
    func unmount(unmountAndEject: Bool, withoutUI: Bool, completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            let options: FileManager.UnmountOptions = [
                unmountAndEject ? .allPartitionsAndEjectDisk : [],
                withoutUI ? .withoutUI : []
            ]
            
            if self.url != nil {
                fileManager.unmountVolume(at: self.url!, options: options, completionHandler: completionHandler)
            }
        }
    }
    
    private func getIconPath() -> String? {
        if let iconPath = url?.appending(path: "/.VolumeIcon.icns").path() {
            if FileManager.default.fileExists(atPath: iconPath) {
                return iconPath
            }
        }
        
        if let iconDict = diskInfo[kDADiskDescriptionMediaIconKey] as? NSDictionary,
              let iconName = iconDict.object(forKey: kIOBundleResourceFileKey ) as? NSString {
            // swiftlint:disable force_cast
            let identifier = iconDict.object(forKey: kCFBundleIdentifierKey as String) as! CFString
            // swiftlint:enable force_cast

            let bundleUrl = Unmanaged.takeRetainedValue(KextManagerCreateURLForBundleIdentifier(kCFAllocatorDefault, identifier))() as URL
            if let bundle = Bundle(url: bundleUrl),
               let iconPath = bundle.path(forResource: iconName.deletingPathExtension, ofType: iconName.pathExtension) {
                return iconPath
            }
        }
        
        return nil
    }

    func getCulpritApps() -> [NSRunningApplication] {
        guard path != nil else {
            return []
        }
        
        let command = Command("/usr/sbin/lsof", ["-Fn", "+D", path!])
        
        guard let result = command.run() else {
            return []
        }
        
        let lines = result.components(separatedBy: .newlines)
        
        let pids = lines.compactMap({ line in
            if line.starts(with: "p") {
                return Int32(line.dropFirst(1))
            } else {
                return nil
            }
        }).unique
        
        let apps = pids.compactMap({ NSRunningApplication(processIdentifier: $0) })
        
        return apps
    }
}
