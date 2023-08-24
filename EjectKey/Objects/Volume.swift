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

class Volume: Identifiable {
    let id = UUID()
    
    private let disk: DADisk
    let diskInfo: [NSString: Any]
    
    let bsdName: String
    let devicePath: String
    let mediaPath: String
    let unitNumber: Int
    let type: VolumeType
    
    let name: String?
    let url: URL?
    let size: Int?
    
    let isMountable: Bool
    
    let isMounted: Bool
    
    init?(bsdName: String) {
        guard let session = DASessionCreate(kCFAllocatorDefault),
              let disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, bsdName),
              let diskInfo = DADiskCopyDescription(disk) as? [NSString: Any],
              let devicePath = diskInfo[kDADiskDescriptionDevicePathKey] as? String,
              let mediaPath = diskInfo[kDADiskDescriptionMediaPathKey] as? String,
              let unitNumber = diskInfo[kDADiskDescriptionMediaBSDUnitKey] as? Int
        else {
            return nil
        }
        
        self.disk = disk
        self.diskInfo = diskInfo
        self.bsdName = bsdName
        self.devicePath = devicePath
        self.mediaPath = mediaPath
        self.unitNumber = unitNumber
        
        // Optional Properties
        let name = (diskInfo[kDADiskDescriptionVolumeNameKey] as? String) ?? (diskInfo[kDADiskDescriptionMediaNameKey] as? String)
        let url = diskInfo[kDADiskDescriptionVolumePathKey] as? URL
        let size = diskInfo[kDADiskDescriptionMediaSizeKey] as? Int
        
        self.name = name
        self.url = url
        self.size = size
        
        let guid = diskInfo[kDADiskDescriptionMediaContentKey] as? String
        let type = diskInfo[kDADiskDescriptionVolumeTypeKey] as? String
        let kind = diskInfo[kDADiskDescriptionVolumeKindKey] as? String
        self.type = VolumeType(guid, type, kind)
        
        let isMountable = diskInfo[kDADiskDescriptionVolumeMountableKey] as? Bool ?? false
        self.isMountable = isMountable
        
        self.isMounted = url != nil
        
        print(name ?? "???", bsdName, isMountable)
    }
    
    var icon: NSImage? {
        if url != nil {
            return NSWorkspace.shared.icon(forFile: url!.path())
        }
        
        if let iconDict = diskInfo[kDADiskDescriptionMediaIconKey] as? NSDictionary,
              let iconName = iconDict.object(forKey: kIOBundleResourceFileKey ) as? NSString {
            // swiftlint:disable force_cast
            let identifier = iconDict.object(forKey: kCFBundleIdentifierKey as String) as! CFString
            // swiftlint:enable force_cast

            let bundleUrl = Unmanaged.takeRetainedValue(KextManagerCreateURLForBundleIdentifier(kCFAllocatorDefault, identifier))() as URL
            if let bundle = Bundle(url: bundleUrl),
               let iconPath = bundle.path(forResource: iconName.deletingPathExtension, ofType: iconName.pathExtension) {
                return NSImage(byReferencingFile: iconPath)
            }
        }
        
        return nil
    }
    
    func mount(callback: @escaping DADiskMountCallback) {
        guard !isMounted else {
            return
        }
        
        print("mount: \(self.name ?? "unknown") (\(self.bsdName))")
        guard let session = DASessionCreate(kCFAllocatorDefault) else {
            return
        }
        var context = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        context.initialize(repeating: 0, count: 1)
        context.pointee = 0

        DASessionScheduleWithRunLoop(session, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        /*let callback: DADiskMountCallback = { _, dissenter, context in
            if (dissenter != nil) && (context != nil) {
                print("mount failure: " + printDAReturn(r: DADissenterGetStatus(dissenter!)))
            }
            CFRunLoopStop(CFRunLoopGetCurrent())
        }*/
        DADiskMountWithArguments(disk, nil, DADiskMountOptions(kDADiskMountOptionDefault), callback, &context, nil)

        CFRunLoopRun()
        DASessionUnscheduleFromRunLoop(session, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

        context.deallocate()
    }
    
    func unmount(force: Bool, callback: @escaping DADiskUnmountCallback) {
        guard isMounted else {
            return
        }
        
        print("unmount: \(self.name ?? "unknown") (\(self.bsdName))")
        guard let session = DASessionCreate(kCFAllocatorDefault) else {
            return
        }
        var context = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        context.initialize(repeating: 0, count: 1)
        context.pointee = 0

        DASessionScheduleWithRunLoop(session, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        // let force = false
        /*let callback: DADiskMountCallback = { _, dissenter, context in
            if (dissenter != nil) && (context != nil) {
                print("un mount failure: " + printDAReturn(r: DADissenterGetStatus(dissenter!)))
            }
            CFRunLoopStop(CFRunLoopGetCurrent())
        }*/
        DADiskUnmount(disk, DADiskUnmountOptions(force ? kDADiskUnmountOptionForce : kDADiskUnmountOptionDefault), callback, &context)

        CFRunLoopRun()
        DASessionUnscheduleFromRunLoop(session, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

        context.deallocate()
    }

    func getCulpritApps() -> [NSRunningApplication] {
        guard let path = url?.path() else {
            return []
        }
        
        let command = Command("/usr/sbin/lsof", ["-Fn", "+D", path])
        
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
