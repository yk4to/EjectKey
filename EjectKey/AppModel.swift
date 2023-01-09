//
//  Appswift
//  EjectKey
//
//  Created by fus1ondev on 2022/11/02.
//

import Defaults
import UserNotifications

final class AppModel: ObservableObject {
    
    @Published var allVolumes: [Volume] = []
    @Published var units: [Unit] = []
    
    // Workaround for switching tabs of Settings View programmatically
    @Published var settingsTabSelection = "general"

    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var touchBarItem: NSCustomTouchBarItem?
    
    init() {
        // For debug
        // Defaults[.isFirstLaunch] = true
        
        if Defaults[.isFirstLaunch] {
            // Request permissions
            requestNotificationAuth()
            
            Defaults[.isFirstLaunch] = false
        }
        
        setVolumeObservers()
        setTouchBarObservers()
        setShortcutObservers()
        setUnitsAndVolumes()
        setupTouchBar()
    }
}
