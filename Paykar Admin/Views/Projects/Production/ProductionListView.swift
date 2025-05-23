//
//  ProductionListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 31/10/24.
//

import SwiftUI

struct ProductionListView: View {
    
    @StateObject var productManager = ProductListManager()
    @State var products: [ProductModel] = []
    @State var quantity: Int = 0
    @State var fullAlert = false
    @Binding var folderId: Int
    @Binding var title: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            VStack {
                VStack(spacing: 15){
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Количество товаров: \(quantity)")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                ScrollView {
                    ForEach(products, id: \.ProductId) { product in
                        ProductionListItemView(product: product)
                    }
                    .padding(.bottom, 70)
                }
                .padding(.horizontal)
            }
            .padding(.top, 50)
            .onAppear {
                productManager.getProductlist(folderId: folderId, page: 1) { productData in
                    products = productData.first!.Data
                    quantity = productData.first!.Total ?? 0
                }
            }
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    CustomButton(icon: "multiply")
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                Button(action: {
                    
                }, label: {
                    CustomButton(icon: "chevron.right")
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(40)
            }
        }
        .ignoresSafeArea()
    }
}

struct ProductionListItemView: View {
    
    var product: ProductModel
    @State var selected = false
    @State var color = Color("CardColor")
    var body: some View {
        HStack {
            Toggle(isOn: $selected) {
                if let productName = product.ProductName {
                    Text(productName)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("Accent"))
                        .multilineTextAlignment(.leading)
                }
            }
            .onChange(of: selected) {
                if selected {
                    withAnimation() {
                        color =  Color("Primary").opacity(0.1)
                    }
                } else {
                    withAnimation() {
                        color =  Color("CardColor")
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("IconColor").opacity(0.1), lineWidth: 1)
        }
    }
    
    private func roundToTwoDecimals(_ priceString: String) -> String {
        if let price = Double(priceString) {
            return String(format: "%.2f", price)
        } else {
            return "0.00"
        }
    }
}

#Preview {
    ProductionListView(folderId: .constant(801), title: .constant("Кондитерские изделия"))
}
