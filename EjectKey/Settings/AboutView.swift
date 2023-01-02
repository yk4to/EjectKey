//
//  AboutView.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/11/03.
//

import SwiftUI
import DependencyList

struct AboutView: View {
    @EnvironmentObject var updaterViewModel: UpdaterViewModel
    
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
                Text("\(L10n.version) \(version ?? "unknown") (\(build ?? "unknown"))")
                    .foregroundColor(Color.secondary)
                    .textSelection(.enabled)
                Spacer()
                    .frame(height: 10)
                Text("© 2022 fus1ondev. All rights reserved.")
                    .foregroundColor(Color.secondary)
                    .font(.callout)
                Spacer()
                    .frame(height: 4)
                Text(L10n.acknowledgments)
                    .foregroundColor(Color.secondary)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Button("GitHub") {
                        if let url = URL(string: "https://github.com/fus1ondev/EjectKey") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    Button(L10n.license) {
                        let window = DependencyListWindow()
                        let licensesWindowColtroller = NSWindowController(window: window)
                        licensesWindowColtroller.showWindow(nil)
                        window.center()
                    }
                    CheckForUpdatesView(updaterViewModel: updaterViewModel)
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
