//
//  Resize.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

// ref: https://github.com/onmyway133/blog/issues/795

import AppKit

extension NSImage {
    func resize(width: CGFloat, height: CGFloat) -> NSImage {
        let img = NSImage(size: CGSize(width: width, height: height))

        img.lockFocus()
        let ctx = NSGraphicsContext.current
        ctx?.imageInterpolation = .high
        self.draw(
            in: NSRect(x: 0, y: 0, width: width, height: height),
            from: NSRect(x: 0, y: 0, width: size.width, height: size.height),
            operation: .copy,
            fraction: 1
        )
        img.unlockFocus()

        return img
    }
}
