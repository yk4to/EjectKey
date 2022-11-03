//
//  Observers.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Cocoa
import Defaults
import KeyboardShortcuts

extension AppModel {
    func setVolumeObservers() {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        
        let notifications: [NSNotification.Name] = [
            NSWorkspace.didMountNotification,
            NSWorkspace.didUnmountNotification
        ]
        
        for notification in notifications {
            NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(reload), name: notification, object: nil)
        }
    }
    
    func setTouchBarObservers() {
        _ = Defaults.observe(keys: .showControlStripButton, .displayOnlyWhenExternalVolumeIsConnected) {
            self.setupTouchBar()
        }.tieToLifetime(of: self)
    }
    
    func setShortcutObservers() {
        KeyboardShortcuts.onKeyDown(for: .ejectAllVolumes) {
            self.ejectAll()
        }
    }
}
