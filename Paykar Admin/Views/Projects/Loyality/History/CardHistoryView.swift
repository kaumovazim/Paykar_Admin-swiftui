//
//  CardHistoryView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct CardHistoryView: View {
    
    @State var isShowing = false
    @ObservedObject var storageData: StorageData = StorageData()
    @State var historyList: [CardHistoryModel] = []
    @State private var selectedOrder: CardHistoryModel?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack{
                Text("История покупок")
                    .font(.title)
                    .fontWeight(.semibold)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding()
//            if HistoryManager().isLoading {
//                Spacer()
//                ProgressView("")
//                Spacer()
//            } else if historyList.isEmpty {
//                Spacer()
//                LottieView(name: "EmptyListAnim")
//                    .scaleEffect(CGSize(width: 0.5, height: 0.5))
//                    .frame(width: 200, height: 200)
//                    .padding(.bottom, 100)
//                Spacer()
//            } else {
                ScrollView {
                    ForEach(historyList, id: \.DocumentId) { historyItem in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Покупка")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(storageData.convertDateToString(date: historyItem.DocumentDate ?? ""))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("\(String(format: "%0.2f", historyItem.TotalSum ?? 0.00)) сомони")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("+\(String(format: "%0.2f", historyItem.AddBonus ?? 0.00)) баллов")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                Text("\(String(format: "%0.2f", historyItem.TotalSumDiscounted ?? 0.00)) сомони со скидкой")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                Spacer()
                                Text("-\(String(format: "%0.2f", historyItem.RemoveBonus ?? 0.00)) баллов")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color("CardColor"))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 2)
                        .onTapGesture {
                            selectedOrder = historyItem
                        }
                        .sheet(item: $selectedOrder) { selectedOrder in
                            ProductDetailsView(sale: selectedOrder)
                        }
                        .onDisappear(perform: {
                            selectedOrder = CardHistoryModel()
                        })
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            historyList = storageData.getHistoryList().sorted { (item1, item2) -> Bool in
                                let date1 = storageData.convertStringToDate(dateString: item1.DocumentDate ?? "")
                                let date2 = storageData.convertStringToDate(dateString: item2.DocumentDate ?? "")
                                return date1 > date2
                            }
                        }
                    }
                }
//            }
        }
    }
}

#Preview {
    CardHistoryView()
}
