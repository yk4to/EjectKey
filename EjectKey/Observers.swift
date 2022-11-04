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
            NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(volumeObserverHandler), name: notification, object: nil)
        }
    }
    
    @objc func volumeObserverHandler() {
        getVolumes(check: true)
    }
    
    func setShortcutObservers() {
        KeyboardShortcuts.onKeyDown(for: .ejectAllVolumes) {
            self.ejectAll()
        }
    }
}
