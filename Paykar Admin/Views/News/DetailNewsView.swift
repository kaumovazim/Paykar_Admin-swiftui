//
//  DetailNewsView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 22.04.2025.
//

import SwiftUI

struct DetailNewsView: View {
    let news: NewsListModel // Используем let вместо @State, так как данные не меняются
    @StateObject private var viewModel = NewsListViewModel()
    @State private var isTapped = false

    var body: some View {
        ScrollView {
            NewsCardView(
                news: news,
                viewModel: viewModel,
                selectNews: .constant(news), // Передаем news как константу
                lineLimit: .max,
                isTapped: $isTapped
            )
        }
        .scrollIndicators(.hidden)
        .padding(.top, 20)
    }
}
