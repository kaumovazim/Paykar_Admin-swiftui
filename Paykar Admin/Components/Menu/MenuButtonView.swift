//
//  MenuButtonView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 28/08/24.
//

import SwiftUI


struct MenuButtonView: View {
    var project: Projects
    @State var showShop = false
    @State var showWallet = false
    @State var showLogistics = false
    @State var showLoyalty = false
    @State var showAcademy = false
    @State var showBusiness = false
    @State var showParking = false
    @State var showService = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        if project.shop {
            Button {
                withAnimation {
                    showShop = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Shop")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Shop description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "cart")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showShop, content: {
                ShopView()
            })
        }
        if project.wallet {
            Button {
                withAnimation {
                    showWallet = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Wallet")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Wallet description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "banknote")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showWallet, content: {
                @Environment(\.presentationMode) var presentationMode // For dismissing the view
                @State var isAnimating = false // For animation control
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Animated icon
                    Image(systemName: "hammer.fill") // Use a "construction" or "in progress" related icon
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    
                    // Message Text
                    Text("Проект Пайкар кошелек находится в стадии разработки")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Назад")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
            })
        }
        if project.loyalty {
            Button {
                withAnimation {
                    showLoyalty = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Loyalty")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Loyalty description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "creditcard")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showLoyalty, content: {
                LoyalityView()
            })
        }
        if project.academy {
            Button {
                withAnimation {
                    showAcademy = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Academy")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Academy description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "graduationcap")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showAcademy, content: {
                @Environment(\.presentationMode) var presentationMode // For dismissing the view
                @State var isAnimating = false // For animation control
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Animated icon
                    Image(systemName: "hammer.fill") // Use a "construction" or "in progress" related icon
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    
                    // Message Text
                    Text("Проект Пайкар академия находится в стадии разработки")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Назад")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
            })
        }
        if project.business {
            Button {
                withAnimation {
                    showBusiness = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Business")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Business description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "briefcase")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showBusiness, content: {
                @Environment(\.presentationMode) var presentationMode // For dismissing the view
                @State var isAnimating = false // For animation control
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Animated icon
                    Image(systemName: "hammer.fill") // Use a "construction" or "in progress" related icon
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    
                    // Message Text
                    Text("Проект Пайкар Бизнес находится в стадии разработки")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Назад")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
            })
        }
        if project.logistics {
            Button {
                withAnimation {
                    showLogistics = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Logistics")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Logistics description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "truck.box")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showLogistics, content: {
                @Environment(\.presentationMode) var presentationMode // For dismissing the view
                @State var isAnimating = false // For animation control
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Animated icon
                    Image(systemName: "hammer.fill") // Use a "construction" or "in progress" related icon
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    
                    // Message Text
                    Text("Проект Пайкар логистика находится в стадии разработки")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Назад")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
            })
        }
        if project.parking {
            Button {
                withAnimation {
                    showParking = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Parking")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Parking description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }.padding(.leading, 20)
                    Spacer()
                    Image(systemName: "car.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showParking, content: {
                @Environment(\.presentationMode) var presentationMode // For dismissing the view
                @State var isAnimating = false // For animation control
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Animated icon
                    Image(systemName: "hammer.fill") // Use a "construction" or "in progress" related icon
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    
                    // Message Text
                    Text("Проект Пайкар парковка находится в стадии разработки")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Назад")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
            })
        }
        if project.service {
            Button {
                withAnimation {
                    showService = true
                }
            } label: {
                HStack{
                    VStack{
                        Text("Service")
                            .fontWeight(.medium)
                            .foregroundStyle(Color("CardColor"))
                            .font(.title2)
                        Text("Service description")
                            .foregroundStyle(Color("CardColor").opacity(0.5))
                            .font(.body)
                    }
                    .padding(.leading, 20)
                    Spacer()
                    Image(systemName: "wrench.and.screwdriver")
                        .font(.system(size: 34))
                        .foregroundStyle(Color("CardColor"))
                        .padding()
                        .padding(.trailing, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(lineWidth: 0.5).fill(Color("Card")))
                .background{
                    LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                }
                .cornerRadius(20)
                .shadow(color: Color("Accent"), radius: 2)
                .padding(.vertical, 3)
            }
            .fullScreenCover(isPresented: $showService, content: {
                @Environment(\.presentationMode) var presentationMode // For dismissing the view
                @State var isAnimating = false // For animation control
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Animated icon
                    Image(systemName: "hammer.fill") // Use a "construction" or "in progress" related icon
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                    
                    // Message Text
                    Text("Проект Пайкар сервис находится в стадии разработки")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Назад")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
            })
        } 
    }
}



