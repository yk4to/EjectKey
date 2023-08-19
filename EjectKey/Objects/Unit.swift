//
//  Unit.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

import Foundation

struct Unit {
    let number: Int
    let bsdName: String
    let name: String?
    let volumes: [Volume]
    let isApfs: Bool
    
    init?(number: Int, allVolumes: [Volume]) {
        let volumes = allVolumes.filter({ $0.unitNumber == number })
        
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
        self.isApfs = name == "AppleAPFSMedia"
    }
}
