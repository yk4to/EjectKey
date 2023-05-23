//
//  SettingsForm.swift
//  EjectKey
//
//  Created by fus1ondev on 2023/05/21.
//

// ref: https://github.com/CodeEditApp/CodeEdit/blob/main/CodeEdit/Features/Settings/Views/SettingsForm.swift

import SwiftUI
import Introspect

struct SettingsForm<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.controlActiveState) private var activeState
    @ViewBuilder var content: Content
    
    @State var scrolledToTop = true

    var body: some View {
        Form {
            Section {
                EmptyView()
            } footer: {
                Rectangle()
                    .frame(height: 0)
                    .background(
                        GeometryReader {
                            Color.clear.preference(
                                key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named("scroll")).origin.y
                            )
                        }
                    )
                    .onPreferenceChange(ViewOffsetKey.self) {
                        if $0 <= -20.0 && !scrolledToTop {
                            withAnimation {
                                scrolledToTop = true
                            }
                        } else if $0 > -20.0 && scrolledToTop {
                            withAnimation {
                                scrolledToTop = false
                            }
                        }
                    }
            }
            content
        }
        .introspectScrollView { scrollView in
            scrollView.scrollerInsets.top = 50
        }
        .formStyle(.grouped)
        .coordinateSpace(name: "scroll")
        .safeAreaInset(edge: .top, spacing: -50) {
            EffectView(.menu)
                .opacity(!scrolledToTop ? 1 : 0)
                .transaction { transaction in
                    transaction.animation = nil
                }
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.black.opacity(colorScheme == .dark ? 1 : 0.17), .black.opacity(0)]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: colorScheme == .dark || activeState == .inactive ? 1 : 2)
                    .padding(.bottom, colorScheme == .dark || activeState == .inactive ? -1 : -2)
                    .opacity(!scrolledToTop ? 1 : 0)
                    .transition(.opacity)
                }
                .ignoresSafeArea()
                .frame(height: 0)
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
