//
//  ThemeChangeView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct ThemeChangeView: View {
    //@Environment(\.colorScheme) private var scheme
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Namespace private var animation
    @State private var circleOffset: CGSize = .zero
    init(scheme: ColorScheme) {
        self.scheme = scheme
        let isDark = scheme == .dark
        self._circleOffset = .init(initialValue: CGSize(width: isDark ? 30: 150, height: isDark ? -25: -150))
    }
    var body: some View {
        VStack(spacing: 15) {
            Circle()
                .fill(userTheme.color(scheme).gradient)
                .frame(width: 150, height: 150)
                .mask {
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(circleOffset)
                                .blendMode(.destinationOut)
                        }
                    
                }
            Text("Оформление")
                .font(.title2.bold())
                .padding(.top, 25)
            Text("Выберите оформления вашего экрана")
                .multilineTextAlignment(.center)
            
            HStack(spacing: 0) {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 120)
                        .background{
                            ZStack {
                                if userTheme == theme {
                                    Capsule()
                                        .fill(Color("ThemeBG"))
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }.animation(.snappy, value: userTheme)
                            
                        }
                        .containerShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.1), in: .capsule)
            .padding(.top, 20)
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
          .frame(height: 410)
          .background(Color("ThemeBG"))
          .clipShape(.rect(cornerRadius: 30))
          .padding(.horizontal, 5)
          .environment(\.colorScheme, scheme)
//          .onChange(of: scheme, initial: false) { _, newValue in
//              let isDark = newValue == .dark
//              withAnimation(.bouncy) {
//                  circleOffset = CGSize(width: isDark ? 30: 150, height: isDark ? -25: -150)
//              }
//          }
        
    }
}

#Preview {
    ThemeChangeView(scheme: .light)
}

enum Theme: String, CaseIterable {
    case systemDefault = "Системный"
    case light = "Светлый"
    case dark = "Темный"
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return scheme == .dark ? Color("Moon") : Color("Sun")
        case .light:
            return Color("Sun")
        case .dark:
            return Color("Moon")
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
