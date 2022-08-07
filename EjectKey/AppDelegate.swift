//
//  AppDelegate.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Cocoa
import Defaults
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Stored Properties
    // (because extensions cannot have them)
    
    var statusItem: NSStatusItem!
    
    var volumes: [Volume] = []
    var units: [Int] = []

    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var touchBarItem: NSCustomTouchBarItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // For debug
        // Defaults[.isFirstLaunch] = true
        
        if Defaults[.isFirstLaunch] {
            // Request permissions
            requestNotificationAuth()
            
            Defaults[.isFirstLaunch] = false
        }
        
        createMenu()
        setVolumeObservers()
        setMenuBarObservers()
        setTouchBarObservers()
        reload()
    }
    
    @objc func reload() {
        getVolumes()
        setMenu()
        setupTouchBar()
    }
}
