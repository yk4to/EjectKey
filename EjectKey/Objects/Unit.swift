//
//  Unit.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

import Foundation

struct Unit: Identifiable {
    let id = UUID()
    
    let number: Int
    let bsdName: String
    let name: String?
    let volumes: [Volume]
    let existsMountedVolume: Bool
    let isApfs: Bool
    var physicalStoreBsdName: String?
    
    init?(number: Int, deviceVolumes: [Volume]) {
        let volumes = deviceVolumes.filter({ $0.unitNumber == number })
        
        let bsdName = "disk\(number)"
        
        guard let session = DASessionCreate(kCFAllocatorDefault),
              let disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, bsdName),
              let diskInfo = DADiskCopyDescription(disk) as? [NSString: Any]
        else {
            return nil
        }
        
        let name = diskInfo[kDADiskDescriptionMediaNameKey] as? String
        
        self.number = number
        self.bsdName = bsdName
        self.name = name
        self.volumes = volumes
        self.existsMountedVolume = volumes.contains(where: \.isMounted)
        self.isApfs = name == "AppleAPFSMedia"
        
        self.physicalStoreBsdName = nil
        if isApfs {
            guard let pathComponents = volumes.first?.mediaPath.components(separatedBy: "/"),
                  let previousIndex = pathComponents.firstIndex(of: "IOGUIDPartitionScheme"),
                  let physicalStoreName = pathComponents[previousIndex + 1].components(separatedBy: "@").first,
                  let physicalStore = deviceVolumes.filter({ $0.name == physicalStoreName }).first
            else {
                return
            }
            self.physicalStoreBsdName = physicalStore.bsdName
        }
    }
    
    func eject() {
        guard !existsMountedVolume else {
            return
        }
        
    }
}
