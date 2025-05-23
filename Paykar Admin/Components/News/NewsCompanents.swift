//
//  NewsCompanents.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 25.04.2025.
//

import SwiftUI

struct NewsCardView: View {
    let news: NewsListModel
    @ObservedObject var viewModel: NewsListViewModel
    @Binding var selectNews: NewsListModel?
    @StateObject private var publishedUser = GetPublishedUser()
    @Environment(\.colorScheme) var colorScheme // Для адаптации к тёмной/светлой теме

    private let cornerRadius: CGFloat = 16
    private let shadowRadius: CGFloat = 8
    @State var lineLimit: Int
    @State private var isAppearing = false
    @Binding var isTapped: Bool

    // Логика отображения имени пользователя
    private var userDisplayText: String {
        guard let userId = news.published_user_id, !userId.isEmpty else {
            return "Unknown user"
        }
        return publishedUser.user?.fullName ?? "Loading..."
    }

    // Адаптивный фон для карточки
    private var cardBackground: some ShapeStyle {
        colorScheme == .dark ?
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGray5).opacity(0.5),
                    Color(.systemGray6).opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ) :
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.85)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
    }

    // Адаптивный цвет тени
    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.3) : .black.opacity(0.15)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Изображение новости
            if news.image != nil {
                if let url = viewModel.imageURL(for: news.image) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            EmptyView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            colorScheme == .dark ? .black.opacity(0.5) : .black.opacity(0.4),
                                            .clear
                                        ]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .transition(.opacity.combined(with: .scale))
                        case .failure:
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(colorScheme == .dark ? 0.4 : 0.2), lineWidth: 1)
                    )
                }
            }

            // Контент карточки
            VStack(alignment: .leading, spacing: 6) {
                // Иконка и имя пользователя
                HStack(alignment: .center, spacing: 8) {
//                    Image("loyalty-icon")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 28, height: 28)
//                        .foregroundColor(colorScheme == .dark ? .white : .accentColor)
//                        .padding(8)
//                        .background(Circle().fill(colorScheme == .dark ? Color.gray.opacity(0.7) : Color.white.opacity(0.95)))
//                        .clipShape(Circle())
//                        .shadow(radius: 3)
//                        .scaleEffect(isTapped ? 1.1 : 1)
//                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isTapped)
                    
                    
                    Text(userDisplayText)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer()
                    
                    Text(formatDate(news.create_date))
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .secondary)
                    
                }
                .padding(.top, -3)

                // Разделитель
                Divider()
                    .frame(height: 1)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colorScheme == .dark ? .white.opacity(0.4) : .accentColor.opacity(0.3),
                                colorScheme == .dark ? .white.opacity(0.2) : .secondary.opacity(0.3)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.bottom, 8)

                // Заголовок
                Text(news.title ?? " ")
                    .font(.title3.weight(.bold))
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Описание
                VStack(alignment: .leading, spacing: 6) {
                    if let description = news.description, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .secondary)
                            .lineLimit(lineLimit)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Нет описания")
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : .secondary.opacity(0.7))
                            .italic()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 9)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(cardBackground)
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 14) // Увеличен для тёмной темы
        .scaleEffect(isAppearing ? (isTapped ? 0.98 : 1) : 0.95)
        .opacity(isAppearing ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.75).delay(0.1), value: isAppearing)
        .animation(.easeInOut(duration: 0.2), value: isTapped)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isTapped = true
                selectNews = news
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isTapped = false
                }
            }
        }
        .onAppear {
            isAppearing = true
            if let userId = news.published_user_id, !userId.isEmpty {
                publishedUser.fetchUserById(userId: userId) { user in
                    print("")
                }
            }
        }
        .onDisappear {
            isAppearing = false
        }
    }
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = formatter.date(from: dateString) else {
            return "Неверный формат даты"
        }
        
        formatter.dateFormat = "d MMMM HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}


struct FloatingActionButton: View {
    @Binding var showCreateNews: Bool
    var isHidden: Bool
    
    var body: some View {
        Button {
            showCreateNews = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Circle().fill(Color.accentColor))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .opacity(isHidden ? 0 : 1)
        .scaleEffect(isHidden ? 0.8 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHidden)
    }
}
