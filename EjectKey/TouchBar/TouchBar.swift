//
//  TouchBar.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import Cocoa
import Defaults
import SFSafeSymbols

extension AppModel {
    func setupTouchBar() {
        let isPresent = !(Defaults[.displayOnlyWhenExternalVolumeIsConnected] && devices.isEmpty) && Defaults[.showControlStripButton]
        
        DFRSystemModalShowsCloseBoxWhenFrontMost(isPresent)
        
        let touchBarIdentifier = NSTouchBarItem.Identifier(rawValue: "dev.fus1on.EjectKey.touchbar")
        
        if touchBarItem == nil {
            touchBarItem = NSCustomTouchBarItem(identifier: touchBarIdentifier)
            
            let iconImage = NSImage(systemSymbol: .ejectFill)!.resize(width: 18, height: 18)
            iconImage.isTemplate = true
            
            touchBarItem?.view = NSButton(image: iconImage, target: self, action: #selector(touchBarAction))
        }
        
        if isPresent {
            NSTouchBarItem.addSystemTrayItem(touchBarItem)
        } else {
            NSTouchBarItem.removeSystemTrayItem(touchBarItem)
        }
        DFRElementSetControlStripPresenceForIdentifier(touchBarIdentifier, isPresent)
    }
    
    @objc private func touchBarAction() {
        switch Defaults[.controlStripButtonAction] {
        case .ejectAll:
            ejectAll()
            return
        case .actAsMediaEjectKey:
            HIDPostMediaKey(NX_KEYTYPE_EJECT)
            return
        }
    }
    
    private func HIDPostMediaKey(_ key: Int32) {
        func doMediaKey(_ key: Int, down: Bool) {
            let modifierFlags = NSEvent.ModifierFlags(rawValue: down ? 0xA00 : 0xB00)
            let nsEvent = NSEvent.otherEvent(with: .systemDefined, location: NSPoint(x: 0, y: 0), modifierFlags: modifierFlags, timestamp: 0, windowNumber: 0, context: nil, subtype: 8, data1: (key << 16) | ((down ? 0xA : 0xB) << 8), data2: -1)
            let cgEvent = nsEvent?.cgEvent
            cgEvent?.post(tap: .cghidEventTap)
        }
        doMediaKey(Int(key), down: true)
        doMediaKey(Int(key), down: false)
    }
}
