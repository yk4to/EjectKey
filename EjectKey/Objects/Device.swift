//
//  Device.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/08/18.
//

import Foundation

struct Device {
    let path: String
    let model: String?
    let vendor: String?
    let deviceProtocol: String?
    let isInternal: Bool
    let isVirtual: Bool
    let isDiskImage: Bool
    let units: [Unit]
    let minUnitNumber: Int
    
    init?(path: String, allVolumes: [Volume]) {
        self.path = path
        
        let volumes = allVolumes.filter { $0.devicePath == path }
        
        let unitNumbers = volumes.map(\.unitNumber).unique
        self.units = unitNumbers.compactMap({ Unit(number: $0, deviceVolumes: volumes) })
        self.minUnitNumber = unitNumbers.min()!
        
        // Get information about this device from the first volume
        let firstVolume = volumes.first!
        
        let model = firstVolume.diskInfo[kDADiskDescriptionDeviceModelKey] as? String
        let vendor = firstVolume.diskInfo[kDADiskDescriptionDeviceVendorKey] as? String
        let deviceProtocol = firstVolume.diskInfo[kDADiskDescriptionDeviceProtocolKey] as? String
        let isInternal = firstVolume.diskInfo[kDADiskDescriptionDeviceInternalKey] as? Bool ?? false
        
        self.model = model
        self.vendor = vendor
        self.deviceProtocol = deviceProtocol
        self.isInternal = isInternal
        
        self.isVirtual = deviceProtocol == "Virtual Interface"
        self.isDiskImage = isVirtual && vendor == "Apple" && model == "Disk Image"
    }
}
