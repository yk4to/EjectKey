//
//  Appswift
//  EjectKey
//
//  Created by Fus1onDev on 2022/11/02.
//

import Defaults
import UserNotifications

final class AppModel: ObservableObject {
    
    @Published var volumes: [Volume] = []
    @Published var units: [Int] = []
    
    // Workaround for switching tabs of Settings View programmatically
    @Published var settingsTabSelection = "general"

    let userNotificationCenter = UNUserNotificationCenter.current()
    
    init() {
        // For debug
        // Defaults[.isFirstLaunch] = true
        
        if Defaults[.isFirstLaunch] {
            // Request permissions
            requestNotificationAuth()
            
            Defaults[.isFirstLaunch] = false
        }
        
        setVolumeObservers()
        setShortcutObservers()
        reload()
    }
    
    @objc func reload() {
        getVolumes()
    }
}
