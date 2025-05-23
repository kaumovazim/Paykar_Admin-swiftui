//
//  OpenCloseReportDetailsView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 12/11/24.
//

import SwiftUI

struct OpenCloseReportItemView: View {
    
    var report: OpenCloseReportModel
    @StateObject var mainManager = MainManager()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("CardColor"))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            HStack{
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("\(mainManager.formattedDateToString(report.create_date))")
                            .foregroundColor(Color("Accent"))
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "key.horizontal")
                            .foregroundColor(.gray)
                        Text("\(report.type)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.gray)
                        Text("\(report.unit)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        Text("\(report.firstname) \(report.lastname)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray)
            }.padding()
        }
        .padding(.horizontal)
    }
}

struct OpenCloseReportDetailsView: View {
    
    var report: OpenCloseReportModel
    @StateObject var mainManager = MainManager()
    @State var showLinkWeb = false
    @State var showPhoto = false
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("\(report.type) \(report.unit)")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                        .font(.headline)
                    Text("\(mainManager.formattedDateToString(report.create_date))")
                        .foregroundColor(Color("Accent"))
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("Accent")).opacity(0.5)
                        .font(.headline)
                    Text("\(report.firstname) \(report.lastname)")
                        .foregroundColor(Color("Accent"))
                        .font(.headline)
                    Spacer()
                }
            }
            HStack(spacing: 20){
                Button {
                    showPhoto.toggle()
                } label: {
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .frame(maxWidth: 175, maxHeight: 175)
                        .background(Color("Secondary"))
                        .cornerRadius(20)
                }
                .sheet(isPresented: $showPhoto) {
                    ZStack{
                        AsyncImage(url: URL(string: "https://admin.paykar.tj/upload/open_close_report/media/\(report.image)")) { image in
                            image.resizable()
                        } placeholder: {
                            ZStack{
                                Color.gray.opacity(0.1)
                                ProgressView()
                            }
                        }
                    }
                }
                Button {
                    showLinkWeb.toggle()
                } label: {
                    Image(systemName: "map")
                        .font(.system(size: 30))
                        .frame(maxWidth: 175, maxHeight: 175)
                        .background(Color("Secondary"))
                        .cornerRadius(20)
                }
                .sheet(isPresented: $showLinkWeb) {
                    LinkWebView(url: yandexMapsURLString())
                }
            }
            Spacer()
        }
        .padding()
        .presentationDetents([.height(CGFloat(350))])
    }
    private func yandexMapsURLString() -> String {
        let coordinates = report.qr_location
        let urlString = "https://yandex.com/maps/?pt=\(coordinates)&z=15&l=map"
        return urlString
    }
}

