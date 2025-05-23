//
//  Floalting TabView.swift
//  Bubble Tab bar
//
//  Created by Macbook Pro on 02.05.2025.
//

import SwiftUI

protocol FloatingTabProtocol {
    var symbolImage: String { get }
}

fileprivate class FloatingTabViewHelper: ObservableObject {
    @Published var hideTabBar: Bool = false
}

fileprivate struct HideFloatingTabBarModifire: ViewModifier {
    var status: Bool
    @EnvironmentObject private var helper: FloatingTabViewHelper
    func body(content: Content) -> some View {
        content
            .onChange(of: status, initial: true) { oldValue, newValue in
                helper.hideTabBar = newValue
            }
    }
    
}

extension View {
    func hideFloatingTabBar(_ status: Bool) -> some View {
        self
            .modifier(HideFloatingTabBarModifire(status: status))
    }
}

struct FloatingTabView<Content: View, Value: Hashable & FloatingTabProtocol>: View {
    var config: FloatingTabCofig
    var visibleTabs: [Value]
    @Binding var selection: Value
    var content: (Value, CGFloat) -> Content

    init(config: FloatingTabCofig = .init(), visibleTabs: [Value], selection: Binding<Value>, @ViewBuilder content: @escaping (Value, CGFloat) -> Content) {
        self.config = config
        self.visibleTabs = visibleTabs
        self._selection = selection
        self.content = content
    }

    @StateObject private var helper: FloatingTabViewHelper = .init()

    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $selection) {
                    ForEach(visibleTabs, id: \.hashValue) { tab in
                        Tab(value: tab) {
                            content(tab, 0)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                }
            } else {
                TabView(selection: $selection) {
                    ForEach(visibleTabs, id: \.hashValue) { tab in
                        content(tab, 0)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }

            FloatingTabBar(config: config, visibleTabs: visibleTabs, activeTab: $selection)
                .padding(.horizontal, config.hPadding)
                .padding(.bottom, config.bPadding)
        }
        .environmentObject(helper)
    }
}


struct FloatingTabCofig  {
    var activeTint: Color = .white
    var activeBackgroundTint: Color = .accentColor
    var inactiveTint: Color = .gray
    var tabAnimation: Animation = .smooth(duration: 0.35, extraBounce: 0)
    var backgroudColor: Color = .gray.opacity(0.1)
    var insetAmount: CGFloat = 6
    var isTranslucet: Bool = true
    var hPadding: CGFloat = 15
    var bPadding: CGFloat = 5
}

fileprivate struct FloatingTabBar<Value: Hashable & FloatingTabProtocol>: View {
    var config: FloatingTabCofig
    var visibleTabs: [Value]
    @Binding var activeTab: Value

    @Namespace private var animation
    @State private var toggleSymbolEffect: [Bool]

    init(config: FloatingTabCofig, visibleTabs: [Value], activeTab: Binding<Value>) {
        self.config = config
        self.visibleTabs = visibleTabs
        self._activeTab = activeTab
        self._toggleSymbolEffect = State(initialValue: Array(repeating: false, count: visibleTabs.count))
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(visibleTabs.enumerated()), id: \.1) { index, tab in
                let isActive = activeTab == tab

                Image(systemName: tab.symbolImage)
                    .font(.title3)
                    .foregroundStyle(isActive ? config.activeTint : config.inactiveTint)
                    .symbolEffect(.bounce.byLayer.down, value: toggleSymbolEffect[index])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .background {
                        if isActive {
                            Capsule(style: .continuous)
                                .fill(config.activeBackgroundTint.gradient)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        activeTab = tab
                        toggleSymbolEffect[index].toggle()
                    }
                    .padding(.vertical, config.insetAmount)
            }
        }
        .padding(.horizontal, config.insetAmount)
        .frame(height: 65)
        .background {
            ZStack {
                if config.isTranslucet {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.background)
                }
                Rectangle()
                    .fill(config.backgroudColor)
            }
        }
        .clipShape(Capsule(style: .continuous))
        .animation(config.tabAnimation, value: activeTab)
    }
}




