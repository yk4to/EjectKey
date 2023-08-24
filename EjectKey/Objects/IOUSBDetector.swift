//
//  IOUSBDetector.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/08/18.
//

// ref: https://stackoverflow.com/questions/34628464/how-to-implement-ioservicematchingcallback-in-swift/39662693#39662693

import Foundation
import IOKit.usb

class IOUSBDetector {
    
    enum Event {
        case Matched
        case Terminated
    }

    var callbackQueue: DispatchQueue?

    var callback: ((_ detector: IOUSBDetector, _ event: Event, _ service: io_service_t) -> Void)?
    
    private let internalQueue: DispatchQueue

    private let notifyPort: IONotificationPortRef

    private var matchedIterator: io_iterator_t = 0

    private var terminatedIterator: io_iterator_t = 0

    private func dispatchEvent(event: Event, iterator: io_iterator_t) {
        repeat {
            let nextService = IOIteratorNext(iterator)
            guard nextService != 0 else { break }
            if let cb = self.callback, let q = self.callbackQueue {
                q.async {
                    cb(self, event, nextService)
                    IOObjectRelease(nextService)
                }
            } else {
                IOObjectRelease(nextService)
            }
        } while (true)
    }

    init? () {
        self.internalQueue = DispatchQueue(label: "IODetector")

        guard let notifyPort = IONotificationPortCreate(kIOMainPortDefault) else {
            return nil
        }

        self.notifyPort = notifyPort
        IONotificationPortSetDispatchQueue(notifyPort, self.internalQueue)
    }
    
    func start() {
        guard matchedIterator == 0 else {
            return
        }

        let matchingDict = IOServiceMatching("IOMedia")

        let matchCallback: IOServiceMatchingCallback = { userData, iterator in
            let detector = Unmanaged<IOUSBDetector>
                .fromOpaque(userData!).takeUnretainedValue()
            detector.dispatchEvent(
                event: .Matched, iterator: iterator
            )
        }
        let termCallback: IOServiceMatchingCallback = { userData, iterator in
            let detector = Unmanaged<IOUSBDetector>
                .fromOpaque(userData!).takeUnretainedValue()
            detector.dispatchEvent(
                event: .Terminated, iterator: iterator
            )
        }

        let selfPtr = Unmanaged.passUnretained(self).toOpaque()

        let addMatchError = IOServiceAddMatchingNotification(
            self.notifyPort, kIOFirstMatchNotification,
            matchingDict, matchCallback, selfPtr, &self.matchedIterator
        )
        let addTermError = IOServiceAddMatchingNotification(
            self.notifyPort, kIOTerminatedNotification,
            matchingDict, termCallback, selfPtr, &self.terminatedIterator
        )

        guard addMatchError == 0 && addTermError == 0 else {
            if self.matchedIterator != 0 {
                IOObjectRelease(self.matchedIterator)
                self.matchedIterator = 0
            }
            if self.terminatedIterator != 0 {
                IOObjectRelease(self.terminatedIterator)
                self.terminatedIterator = 0
            }
            return
        }

        self.dispatchEvent(event: .Matched, iterator: self.matchedIterator)
        self.dispatchEvent(event: .Terminated, iterator: self.terminatedIterator)
    }

    deinit {
        guard self.matchedIterator != 0 else {
            return
        }
        IOObjectRelease(self.matchedIterator)
        IOObjectRelease(self.terminatedIterator)
        self.matchedIterator = 0
        self.terminatedIterator = 0
    }
}
