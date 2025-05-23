//
//  WebAnalyticsView.swift
//  Paykar Admin
//
//  Created by Азим Каюмов on 2/14/25.
//

import SwiftUI
import WebKit

struct WebAnalyticsView: UIViewRepresentable {
    let urlString: String
    var onFinishedLoading: () -> Void = {}

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Присваиваем делегат
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onFinishedLoading: onFinishedLoading)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var onFinishedLoading: () -> Void

        init(onFinishedLoading: @escaping () -> Void) {
            self.onFinishedLoading = onFinishedLoading
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Когда страница загружена, вызываем onFinishedLoading
            onFinishedLoading()
        }
    }
}

struct WebViewContainer: View {
    @Environment(\.dismiss) var dismiss
    @State var url: String
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            // WebAnalyticsView принимает замыкание, которое вызывается после завершения загрузки
            WebAnalyticsView(urlString: url) {
                isLoading = false
            }
            
            // Если загрузка ещё идёт, показываем LoadingView
            if isLoading {
                SetLottieView(name: "Loading")
            }
            
            VStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .padding()
            }
        }
    }
}

