//
//  ProductDetailsView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct ProductDetailsView: View {
    
    @ObservedObject var storageData: StorageData = StorageData()
    @State var sale: CardHistoryModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Transaction Info
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(storageData.convertDateTimeToString(date: sale.DocumentDate ?? ""))")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Касса: \(sale.CashName ?? "N/A")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Divider()

                // Store and Cashier Info
                VStack(alignment: .leading, spacing: 15){
                    Text("Магазин: \(sale.SubjectFullAdress ?? "N/A")")
                        .font(.headline)
                    Text("Кассир: \(sale.CashierName ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                Divider()

                VStack(alignment: .leading, spacing: 15) {
                    summaryRow(title: "Сумма покупки:", value: "\(String(format: "%.2f", sale.TotalSum ?? 0.0)) сомони")
                    summaryRow(title: "Списано баллов:", value: "-\(String(format: "%.2f", sale.RemoveBonus ?? 0.0)) баллов", valueColor: .red)
                    summaryRow(title: "Начислено баллов:", value: "+\(String(format: "%.2f", sale.AddBonus ?? 0.0)) баллов", valueColor: .green)
                    summaryRow(title: "Итого со скидкой:", value: "\(String(format: "%.2f", sale.TotalSumDiscounted ?? 0.0)) сомони", valueColor: .green)
                }
                Divider()
                // List of Purchased Items
                Text("Товары в чеке:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                ForEach(sale.DocumentDetails!, id: \.ProductCode) { product in
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.ProductName ?? "Товар")
                                .font(.system(size: 15))
                                .padding(.top, 10)
                                .frame(maxHeight: .infinity, alignment: .leading)
                                .foregroundColor(Color("Accent"))
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Text("\(String(format: "%.2f", product.Quantity ?? 0)) шт")
                                    .foregroundColor(Color("IconColor"))
                                    .font(.system(size: 15))
                                Spacer()
                                Text("\(String(format: "%.2f", product.TotalPrice ?? 0)) TJS")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color("Accent"))
                            }
                            let discountPrice = product.TotalPriceDiscounted!
                            let addBonus = product.AddBonus!
                            let removeBonus = product.RemoveBonus!
                    
                            if (removeBonus == 0.0 && addBonus == 0.0 && discountPrice != 0.0) {
                                Text("Цена по карте: \(String(format: "%.2f", discountPrice)) TJS")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 2)
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func summaryRow(title: String, value: String, valueColor: Color = .primary) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(valueColor)
        }
    }
}

