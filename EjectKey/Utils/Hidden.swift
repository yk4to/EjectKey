//
//  Hidden.swift
//  EjectKey
//
//  Created by fus1ondev on 2022/11/03.
//

import SwiftUI

struct Hidden: ViewModifier {
    let hidden: Bool

    func body(content: Content) -> some View {
        VStack {
            if !hidden {
                content
            }
        }
    }
}

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        ModifiedContent(content: self, modifier: Hidden(hidden: isHidden))
    }
}
