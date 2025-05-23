//
//  StoryItemView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 21/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoryItem: View {
    
    @StateObject private var storyManager = StoryManager()
    var preview: String
    @State var seen: Bool
    @Binding var editing: Bool
    @State var presented:  Bool
    @State var elementId: Int
    @Binding var alert: Bool
    @State var delete = false
    @State var title: String
    
    var body: some View {
        ZStack{
            if delete {
                VStack{
                    if storyManager.isLoading {
                        ProgressView("")
                    } else if let errorMessage = storyManager.errorMessage {
                        Text("Ошибка: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if storyManager.isDeleted {
                        Text("")
                            .onAppear() {
                                alert = true
                                editing = false
                            }
                    }
                }
            } else {
                VStack{
                    WebImage(url: URL(string: "https://paykar.shop\(preview)"))
                        .onSuccess { image, data, cacheType in
                        }
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.3))
                        .scaledToFill()
                        .frame(width: 110, height: 125)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(2)
                        .background(Color("ButtonText"))
                        .padding(1.5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 3.5)
                                .fill(seen ? Color("IconColor").opacity(0.3) : Color("Primary"))
                        }
                        .padding(.horizontal, 1)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            withAnimation {
                                presented  = true
                                seen = true
                            }
                        }
                        .fullScreenCover(isPresented: $presented, content: {
                            VStack{
                                WebImage(url: URL(string: "https://paykar.shop\(preview)"))
                                    .onSuccess { image, data, cacheType in
                                    }
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.3))
                                    .scaledToFit()
                                    .ignoresSafeArea()
                                    .onTapGesture {
                                        withAnimation {
                                            presented  = false
                                        }
                                    }
                                    .ignoresSafeArea()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    presented  = false
                                }
                            }
                            
                            .ignoresSafeArea()
                        })
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(Color("Accent"))
                        .frame(width: 110, height: 40)
                        .lineLimit(2)
                }
                .overlay {
                    if editing {
                        Button {
                            delete = true
                            storyManager.deleteStory(byElementId: elementId)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .background(Color("ItemColor"))
                                .cornerRadius(30)
                                .foregroundColor(.red)
                                .font(.system(size: 22))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.top, -5)
                        .padding(.trailing, -9)
                    }
                }
            }
        }
        
    }
}
