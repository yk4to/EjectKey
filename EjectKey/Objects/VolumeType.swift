//
//  VolumeType.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/08/19.
//

import Foundation

enum VolumeType {
    case efi
    case apfsContainer, apfs, apfsSnapshot, apfsCaseSensitive, apfsEncrypted, apfsCaseSensitiveEncrypted
    case hfsPlus, hfsPlusCaseSensitive, hfsPlusJournaled, hfsPlusCaseSensitiveJournaled
    case linuxFilesystem, linuxSwap
    case windowsBasicData, windowsRecovery
    case dosFat32
    case partitionMap
    case unknown
    
    // swiftlint:disable cyclomatic_complexity
    init(_ guid: String?, _ type: String?, _ kind: String?) {
        switch guid {
        case "C12A7328-F81F-11D2-BA4B-00A0C93EC93B":
            self = .efi
        case "0xEF":
            self = .efi
        case "7C3457EF-0000-11AA-AA11-00306543ECAC":
            self = .apfsContainer
        case "41504653-0000-11AA-AA11-00306543ECAC":
            // APFS
            switch type {
            case "APFS (Case-sensitive)":
                self = .apfsCaseSensitive
            case "APFS (Encrypted)":
                self = .apfsEncrypted
            case "APFS (Case-sensitive, Encrypted)":
                self = .apfsCaseSensitiveEncrypted
            case nil:
                self = .apfsSnapshot
            default:
                self = .apfs
            }
        case "48465300-0000-11AA-AA11-00306543ECAC":
            // HFS+ (Mac OS Extended)
            switch type {
            case "Mac OS Extended":
                self = .hfsPlus
            case "Mac OS Extended (Case-sensitive)":
                self = .hfsPlusCaseSensitive
            case "Mac OS Extended (Journaled)":
                self = .hfsPlusJournaled
            case "Mac OS Extended (Case-sensitive, Journaled)":
                self = .hfsPlusCaseSensitiveJournaled
            default:
                self = .hfsPlus
            }
        case "0FC63DAF-8483-4772-8E79-3D69D8477DE4":
            self = .linuxFilesystem
        case "0657FD6D-A4AB-43C4-84E5-0933C84B4F4F":
            self = .linuxSwap
        case "EBD0A0A2-B9E5-4433-87C0-68B6B72699C7":
            self = .windowsBasicData
        case "DE94BBA4-06D1-4D40-A16A-BFD50179D6AC":
            self = .windowsRecovery
        case "DOS_FAT_32":
            self = .dosFat32
        case "Apple_partition_map":
            self = .partitionMap
        case "Apple_HFSX":
            self = .hfsPlus
        default:
            self = .unknown
        }
    }
    
    func displayName() -> String {
        switch self {
        case .efi:
            return "EFI"
        case .apfsContainer:
            return "APFS Container"
        case .apfs:
            return "APFS"
        case .apfsSnapshot:
            return "APFS Snapshot"
        case .apfsCaseSensitive:
            return "APFS (Case-sensitive)"
        case .apfsEncrypted:
            return "APFS (Encrypted)"
        case .apfsCaseSensitiveEncrypted:
            return "APFS (Case-sensitive, Encrypted)"
        case .hfsPlus:
            return "Mac OS Extended"
        case .hfsPlusCaseSensitive:
            return "Mac OS Extended (Case-sensitive)"
        case .hfsPlusJournaled:
            return "Mac OS Extended (Journaled)"
        case .hfsPlusCaseSensitiveJournaled:
            return "Mac OS Extended (Case-sensitive, Journaled)"
        case .linuxFilesystem:
            return "Linux Filesystem"
        case .linuxSwap:
            return "Linux Swap"
        case .windowsBasicData:
            return "Windows Basic Data"
        case .windowsRecovery:
            return "Windows Recovery"
        case .dosFat32:
            return "MS-DOS (FAT32)"
        case .partitionMap:
            return "Partition Map"
        case .unknown:
            return "Unknown"
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
