//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 27/04/22.
// applyBG

import SwiftUI

enum AppTab: String, CaseIterable, FloatingTabProtocol {
    case news = "house.fill"
    case project = "list.dash"
    case services = "folder.fill"
    case profile = "person.crop.circle.fill"
    
    var symbolImage: String {
        switch self {
            case .news: "house.fill"
            case .project: "list.dash"
            case .services: "folder.fill"
            case .profile: "person.crop.circle.fill"
        }
    }
}

struct MainTapBar: View {
    @Binding var activateTab: AppTab
    @State private var adminData = UserManager.shared.retrieveUserFromStorage()
    @State var lastOffset: CGFloat = 0
    var update = AdminManager()

    var visibleTabs: [AppTab] {
        var tabs: [AppTab] = [.news]
        if adminData?.projects.shop == true || adminData?.projects.loyalty == true || adminData?.projects.production == true {
            tabs.append(.project)
        }
        if adminData?.position == "Супер Админ" || adminData?.position == "Управляющий" || adminData?.position == "Кассир" || adminData?.position == "Охрана" {
            tabs.append(.services)
        }
        tabs.append(.profile)
        return tabs
    }

    var body: some View {
        FloatingTabView(visibleTabs: visibleTabs, selection: $activateTab) { tab, tabBarHeight in
            switch tab {
            case .news:
                NewsView(lastOffset: $lastOffset)
                    .padding(.bottom, 30)
                    .background(Color.clear)
            case .project:
                ScrollView {
                    MenuView()
                        .padding(.bottom, 45)
                        .padding(.top, 10)
                }
                .background(Color.clear)
                .scrollIndicators(.hidden)
            case .services:
                ScrollView {
                    ServiceMenuView()
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            case .profile:
                SettingView()
                    .background(Color.clear)
            }
        } .onAppear() {
            update.updateLastVVisit { UpdateLastVisitModel in
                //
            }
        }
    }
}

