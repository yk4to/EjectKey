//
//  MenuBar.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Cocoa
import Defaults
import SFSafeSymbols

extension AppDelegate {
    func createMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbol: .ejectFill)
        }
        let menu = NSMenu()
        statusItem.menu = menu
    }
    
    func setMenu() {
        if let menu = statusItem.menu {
            menu.removeAllItems()
            
            if units.isEmpty {
                menu.addItem(NSMenuItem(
                    title: L10n.noExternalVolumeConnected,
                    action: nil,
                    keyEquivalent: ""
                ))
            } else {
                setEjectAllVolumesButton(menu)
                
                units.forEach {
                    setEjectVolumesInDiskButtons(menu, $0)
                }
            }
            
            menu.addItem(NSMenuItem.separator())
            
            setOtherButtons(menu)
        }
    }
    
    private func setEjectAllVolumesButton(_ menu: NSMenu) {
        if Defaults[.showEjectAllVolumesButton] && units.count > 1 {
            menu.addItem(NSMenuItem(
                title: L10n.ejectAllVolumes,
                action: #selector(AppDelegate.ejectAll(_:)),
                keyEquivalent: ""
            ))
            menu.addItem(NSMenuItem.separator())
        }
    }
    
    private func setEjectVolumesInDiskButtons(_ menu: NSMenu, _ unit: Int) {
        let header = NSMenuItem()
        header.title = L10n.diskNum(unit)
        menu.addItem(header)
        
        let unitVolumes = getVolumesFromUnit(unit)
        
        if Defaults[.showEjectAllVolumesInDiskButtons] && unitVolumes.count > 1 {
            let ejectAllInDisk = NSMenuItem()
            ejectAllInDisk.title = L10n.ejectNumVolumes(unitVolumes.count)
            ejectAllInDisk.tag = -unit
            ejectAllInDisk.action = #selector(AppDelegate.ejectAllVolumeInDisk(_:))
            menu.addItem(ejectAllInDisk)
        }
        
        for (index, volume) in unitVolumes {
            let item = NSMenuItem()
            item.title = volume.name
            item.image = volume.icon
            item.image?.size = NSSize(width: 18, height: 18)
            item.tag = index
            item.action = #selector(AppDelegate.eject(_:))
            menu.addItem(item)
        }
    }
    
    private func setOtherButtons(_ menu: NSMenu) {
        menu.addItem(NSMenuItem(
            title: L10n.preferences,
            action: #selector(openPreferencesWindow),
            keyEquivalent: ""
        ))
        
        menu.addItem(NSMenuItem(
            title: L10n.aboutEjectkey,
            action: #selector(showAbout),
            keyEquivalent: ""
        ))
        
        menu.addItem(NSMenuItem(
            title: L10n.quitEjectkey,
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
    }
    
    @objc private func eject(_ sender: NSMenuItem) {
        eject(index: sender.tag)
    }
    
    @objc private func ejectAll(_ sender: NSMenuItem) {
        ejectAll()
    }
    
    @objc private func ejectAllVolumeInDisk(_ sender: NSMenuItem) {
        ejectAllVolumeInDisk(unit: -sender.tag)
    }
    
    @objc private func openPreferencesWindow() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        NSApp.windows.forEach {
            if $0.canBecomeMain {
                $0.orderFrontRegardless()
            }
        }
    }
    
    @objc private func showAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel()
    }
}
