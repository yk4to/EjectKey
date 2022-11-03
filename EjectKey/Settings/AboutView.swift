//
//  AboutView.swift
//  EjectKey
//
//  Created by Fus1onDev on 2022/11/03.
//

import SwiftUI

struct AboutView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .resizable()
                .frame(width: 110, height: 110)
            VStack(alignment: .leading) {
                Text("EjectKey")
                    .font(.largeTitle)
                Spacer()
                    .frame(height: 0.4)
                Text("Version \(version ?? "unknown") (\(build ?? "unknown"))")
                    .foregroundColor(Color.secondary)
                    .textSelection(.enabled)
                Spacer()
                    .frame(height: 10)
                Text("© 2022 Fus1onDev. All rights reserved.")
                    .foregroundColor(Color.secondary)
                    .font(.callout)
                Spacer()
                    .frame(height: 4)
                Text("This project is open source, and licensed under the MIT license.")
                    .foregroundColor(Color.secondary)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Button("GitHub") {
                        if let url = URL(string: "https://github.com/Fus1onDev/EjectKey") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    Button("License") {
                        if let url = URL(string: "https://github.com/Fus1onDev/EjectKey/blob/main/LICENSE") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
