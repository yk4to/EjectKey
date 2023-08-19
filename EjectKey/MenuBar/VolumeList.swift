//
//  VolumeList.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/08/19.
//

import SwiftUI
import Defaults

struct VolumeList: View {
    @ObservedObject var model: AppModel
    @State var device: Device?
    @State var unit: Unit
    
    @Default(.showEjectAllVolumesInDiskButtons) private var showEjectAllVolumesInDiskButtons
    @Default(.showUnmountedVolumes) private var showUnmountedVolumes
    @Default(.showActionMenu) private var showActionMenu
    @Default(.showDetailedInformation) private var showDetailedInformation
    
    var body: some View {
        ForEach(unit.volumes.sorted(by: {$0.bsdName < $1.bsdName}), id: \.bsdName) { volume in
            // if showActionMenu {
            if volume.type == .apfsContainer {
                if let contentUnit = device?.units.filter({ $0.physicalStoreBsdName == volume.bsdName }).first {
                    if !(!showUnmountedVolumes && !contentUnit.existsMountedVolume) {
                        Menu {
                            // Text("APFS Container (\(unit.bsdName))")
                            Button(L10n.ejectNumVolumes(contentUnit.volumes.count)) {
                                model.ejectAllVolumeInDisk(unit)
                            }
                            .hidden(!showEjectAllVolumesInDiskButtons || contentUnit.volumes.count <= 1)
                            
                            VolumeList(model: model, device: nil, unit: contentUnit)
                            if showDetailedInformation {
                                Divider()
                                Text(volume.type.displayName())
                                Text("\(L10n.size): \(volume.size?.formatted(.byteCount(style: .file)) ?? "Unknown")")
                                Text("Physical Store: \(volume.bsdName)")
                            }
                        } label: {
                            Image(systemSymbol: .shippingbox)
                            Text("APFS Container (\(contentUnit.bsdName))")
                        }
                    }
                }
            } else {
                if !(!showUnmountedVolumes && !volume.isMounted) {
                    Menu {
                        if volume.isMounted {
                            Button(L10n.eject) {
                                model.eject(volume)
                            }
                        } else {
                            Button("Mount") {
                                // model.eject(volume)
                            }
                        }
                        if let url = volume.url {
                            Button(L10n.showInFinder) {
                                NSWorkspace.shared.activateFileViewerSelecting([url])
                            }
                        }
                        if showDetailedInformation {
                            Divider()
                            Text(volume.type.displayName())
                            if unit.isApfs {
                                Text("\(L10n.size): \(volume.size?.formatted(.byteCount(style: .file)) ?? "Unknown") (Shared)")
                            } else {
                                Text("\(L10n.size): \(volume.size?.formatted(.byteCount(style: .file)) ?? "Unknown")")
                            }
                            Text("ID: \(volume.bsdName)")
                            Text(volume.isMounted ? "Mounted" : "Not Mounted")
                        }
                    } label: {
                        if let icon = volume.icon {
                            Image(nsImage: icon)
                        } else {
                            Image(systemSymbol: .externaldrive)
                        }
                        Text(volume.name ?? "Unknown")
                    }
                }
            }
            /*} else {
                Button {
                    model.eject(volume)
                } label: {
                    if let icon = volume.icon {
                        Image(nsImage: icon)
                    } else {
                        Image(systemSymbol: .externaldrive)
                    }
                    Text(volume.name ?? "Unknown")
                }
            }*/
        }
    }
}

/* struct VolumeList_Previews: PreviewProvider {
    static var previews: some View {
        VolumeList(model: AppModel(), device: nil, unit: Unit(number: 0, deviceVolumes: []))
    }
} */
