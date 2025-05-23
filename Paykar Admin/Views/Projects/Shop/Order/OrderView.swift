//
//  OrderListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 02/09/24.
//

import SwiftUI

struct OrderView: View {
    
    @StateObject private var orderManager = OrderManager()
    @State private var selectedOrder: OrderModel?
    @Environment(\.dismiss) var dismiss
    @State var searchInput = ""
    @State var searchAlert = false
    @State var alertMessage = ""
    @State var isSearching = false
    @State var autoSearch = false
    @FocusState var focus
    @State var alertConnection = false
    @State var preselectedIndex: Int = 0
    @State var options: [String] = ["Номер заказа", "Номер телефона"]

    @available(iOS 16.0, *)
    var body: some View {
        ZStack {
            VStack{
                VStack{
                    ZStack {
                        Rectangle()
                            .fill(Color("Secondary"))
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .bottom)
                            
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                ButtonCircleView(iconName: "chevron.left", background: "")
                                    .padding(.leading)
                            }
                            Text("Заказы")
                                .font(.system(size: 22, weight: .semibold))
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                        .padding(.bottom)

                    }
                    .ignoresSafeArea()

                    VStack (spacing: 0) {
                        HStack(spacing: 0){
                            ForEach(options.indices, id:\.self) { index in
                                ZStack {
                                    Rectangle()
                                        .fill(Color("Secondary"))
                                    
                                    Rectangle()
                                        .fill(Color("CardColor"))
                                        .cornerRadius(15)
                                        .padding(2)
                                        .opacity(preselectedIndex == index ? 1 : 0.01)
                                        .onTapGesture {
                                            withAnimation(.interactiveSpring()) {
                                                preselectedIndex = index
                                            }
                                        }
                                }
                                .overlay(
                                    Text(options[index])
                                )
                            }
                        }
                        .cornerRadius(15)
                        .frame(height: 50)
                        .padding()
                        .onChange(of: preselectedIndex) {
                            searchInput = ""
                            orderManager.searchResults = []
                        }
                        HStack{
                            if preselectedIndex == 0 {
                                TextField("Поиск по номеру заказа", text: $searchInput)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .focused($focus)
                            } else if preselectedIndex == 1 {
                                TextField("Поиск по номеру телефона", text: $searchInput)
                                    .keyboardType(.phonePad)
                                    .padding()
                                    .focused($focus)
                                    .onChange(of: searchInput) { newValue in
                                        if (newValue.count == 9) {
                                            focus = false
                                            performSearch()
                                        }
                                    }
                            }
                            if focus {
                                Button {
                                    withAnimation {
                                        searchInput = ""
                                        orderManager.searchResults = []
                                        focus = false
                                        isSearching = false
                                    }
                                } label: {
                                    Image(systemName: "multiply")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color("Accent"))
                                        .padding(5)
                                        .background(Color("ItemColor"))
                                        .cornerRadius(30)
                                }
                            }
                            Button(action: performSearch) {
                                Image(systemName: "magnifyingglass")
                                    .padding()
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("Accent"))
                            }
                            .alert(isPresented: $searchAlert, content: {
                                Alert(title: Text("Внимание!"),
                                      message: Text("Вы ввели неверный номер телефона"),
                                      dismissButton: .cancel(Text("Попробовать снова"))
                                )
                            })
                        }
                        .background(Color("Secondary"))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                    .padding(.top, 30)
                    
                }
                .ignoresSafeArea()
                VStack {
                    
                    if orderManager.isLoading && !focus && !isSearching{
                        Spacer()
                        ProgressView("Загрузка...")
                            .padding(.bottom, 100)
                        Spacer()
                    } else if orderManager.errorMessage != nil {
                        Spacer()
                        Text("")
                            .onAppear(perform: {
                                alertConnection = true
                            })
                        Spacer()
                    } else if focus && !isSearching {
                        Rectangle()
                            .fill(Color("ButtonText"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    searchInput = ""
                                    focus = false
                                    orderManager.searchResults = []
                                    orderManager.errorMessage = nil
                                }
                            }
                    } else {
                        if isSearching {
                            if orderManager.isSearching {
                                Spacer()
                                ProgressView("Поиск...")
                                    .padding(.bottom, 100)
                                Spacer()
                            } else if orderManager.searchResults.isEmpty {
                                Spacer()
                                LottieView(name: "EmptyListAnim")
                                    .scaleEffect(CGSize(width: 0.4, height: 0.4))
                                    .frame(width: 200, height: 200)
                                    .padding(.bottom, 100)
                                Spacer()
                            } else {
                                ScrollView {
                                    VStack(spacing: 15) {
                                        ForEach(orderManager.searchResults) { order in
                                            Button(action: {
                                                if MainManager().checkInternetConnection() {
                                                    selectedOrder = order
                                                } else {
                                                    alertConnection = true
                                                }
                                            }) {
                                                OrderItem(order: order)
                                            }
                                            .sheet(item: $selectedOrder) { order in
                                                OrderDetailView(order: order)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.vertical)
                                    .padding(.bottom)
                                    .background(
                                        GeometryReader { geometry in
                                            Color.clear
                                                .onChange(of: geometry.frame(in: .global).minY) { _ in
                                                    focus = false
                                                }
                                        }
                                            .frame(height: 0)
                                    )
                                }
                            }
                        } else {
                            let sortedOrders = orderManager.orders.sorted {
                                convertToDate($0.createDate) > convertToDate($1.createDate)
                            }
                            if sortedOrders.isEmpty {
                                Spacer()
                                LottieView(name: "EmptyListAnim")
                                    .scaleEffect(CGSize(width: 0.4, height: 0.4))
                                    .frame(width: 200, height: 200)
                                    .padding(.bottom, 100)
                                Spacer()
                            } else {
                                ScrollView {
                                    VStack(spacing: 15){
                                        ForEach(sortedOrders) { order in
                                            Button(action: {
                                                if MainManager().checkInternetConnection() {
                                                    selectedOrder = order
                                                } else {
                                                    alertConnection = true
                                                }
                                            }) {
                                                OrderItem(order: order)
                                            }
                                            .sheet(item: $selectedOrder) { order in
                                                OrderDetailView(order: order)
                                            }
                                        }.padding(.horizontal)
                                    }.padding(.vertical)
                                        .padding(.bottom)
                                }
                            }
                        }
                    }
                }
            }
            if !focus && !isSearching {
                Button {
                    if MainManager().checkInternetConnection() {
                        orderManager.fetchOrders()
                    } else {
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(30)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if MainManager().checkInternetConnection() {
                if autoSearch {
                    performSearch()
                } else {
                    orderManager.fetchOrders()
                }
            } else {
                alertConnection = true
            }
        }
        .alert("", isPresented: $alertConnection) {
            Button("Попробовать снова", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к интернету и попробуйте снова.")
        }
    }
    
    func performSearch() {
        if MainManager().checkInternetConnection() {
            if preselectedIndex == 0 {
                if let orderId = Int(searchInput), orderId > 0 {
                    isSearching = true
                    orderManager.getOrderById(orderId: orderId)
                } else {
                    searchAlert = true
                    alertMessage = "Вы ввели неверный ID"
                }
            } else if preselectedIndex == 1 {
                if searchInput.count == 9, let _ = Int(searchInput) {
                    isSearching = true
                    orderManager.getOrderByPhone(phone: searchInput)
                    
                } else {
                    searchAlert = true
                    alertMessage = "Вы ввели неверный номер телефона"
                }
            }
        } else {
            alertConnection = true
        }
    }
    private func convertToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date.distantPast
    }
}

#Preview {
    OrderView()
}
