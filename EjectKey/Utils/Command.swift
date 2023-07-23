//
//  Command.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/07/23.
//

import Foundation

class Command {
    private let process: Process?
    
    init(_ command: String, _ arguments: [String]) {
        process = Process()
        process?.launchPath = command
        process?.arguments = arguments
    }

    func run() -> String? {
        let pipe = Pipe()
        process?.standardOutput = pipe
        process?.standardError = pipe
        process?.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        process?.waitUntilExit()

        return output
    }
}
