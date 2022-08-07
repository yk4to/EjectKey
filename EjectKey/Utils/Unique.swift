//
//  Unique.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/08/07.
//

import Foundation

// ref: https://stackoverflow.com/questions/27624331/unique-values-of-array-in-swift

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
