//
//  WebView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/09/24.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    let request: URLRequest
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct LinkWebView: View{
    var url: String
    var body: some View{
        VStack{
            WebView(request: URLRequest(url: URL(string: url)!))
        }
    }
}
