//
//  Unit.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/01/02.
//

import Foundation

struct Unit {
    let deviceModel: String
    let deviceVendor: String
    let deviceProtocol: String
    let devicePath: String
    let isDiskImage: Bool
    let isLocal: Bool
    let volumes: [Volume]
    let numbers: [Int]
    let minNumber: Int
    
    init(devicePath: String, allVolumes: [Volume]) {
        self.devicePath = devicePath
        
        self.volumes = allVolumes.filter { $0.devicePath == devicePath }
        
        let firstVolume = self.volumes.first!
        self.deviceModel = firstVolume.deviceModel
        self.deviceVendor = firstVolume.deviceVendor
        self.deviceProtocol = firstVolume.deviceProtocol
        self.isDiskImage = firstVolume.isDiskImage
        self.isLocal = firstVolume.isLocal
        
        self.numbers = volumes.map(\.unitNumber).unique.sorted()
        self.minNumber = numbers.min() ?? 0
    }
}
