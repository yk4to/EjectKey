//
//  Debouncer.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/08/22.
//

import Foundation

class Debouncer {
    private let interval: TimeInterval
    private var timer: Timer?

    init(interval: TimeInterval) {
        self.interval = interval
    }

    func debounce(action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            action()
        }
    }
}
