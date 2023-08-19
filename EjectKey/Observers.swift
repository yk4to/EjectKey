//
//  Observers.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/08/07.
//

import Cocoa
import Defaults
import KeyboardShortcuts

extension AppModel {
    func setVolumeObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        notificationCenter.removeObserver(self)
        
        notificationCenter.addObserver(self, selector: #selector(didMountHandler), name: NSWorkspace.didMountNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(didUnmountHandler), name: NSWorkspace.didUnmountNotification, object: nil)
        
        /* ioDetector?.callbackQueue = DispatchQueue.main
         ioDetector?.callback = { _, event, _ in
            print("Event \(event)")
            self.setUnitsAndVolumes()
        }
         ioDetector?.start() */
    }
    
    @objc private func didMountHandler() {
        let oldVolumes = allVolumes
        setUnitsAndVolumes()
        let newVolumes = allVolumes
        checkMountedVolumes(old: oldVolumes, new: newVolumes)
        
        if Defaults[.displayOnlyWhenExternalVolumeIsConnected] {
            setupTouchBar()
        }
    }
    
    @objc private func didUnmountHandler() {
        let oldVolumes = allVolumes
        setUnitsAndVolumes()
        let newVolumes = allVolumes
        checkEjectedVolumes(old: oldVolumes, new: newVolumes)
        
        if Defaults[.displayOnlyWhenExternalVolumeIsConnected] {
            setupTouchBar()
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
