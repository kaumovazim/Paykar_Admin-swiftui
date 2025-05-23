//
//  ProductDiscountListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 01/11/24.
//

import SwiftUI

struct ProductDiscountListView: View {
    
    @StateObject var discountListManager = ProductDiscountListManager()
    @State var selectedDiscount: DiscountProgram? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            VStack{
                Text("Акции")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.top, 50)
                if discountListManager.isLoading {
                    Spacer()
                    ProgressView("")
                    Spacer()
                } else if discountListManager.errorMessage != nil || discountListManager.discountList.isEmpty {
                    Spacer()
                    LottieView(name: "EmptyListAnim")
                        .scaleEffect(CGSize(width: 0.4, height: 0.4))
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 100)
                    Spacer()
                } else {
                    ForEach(discountListManager.discountList) { discount in
                        VStack(spacing: 15){
                            Button {
                                selectedDiscount = discount
                            } label: {
                                ProductDiscountListItemView(program: discount)
                                    .onDisappear(){
                                        discountListManager.getDiscountList()
                                    }
                            }
                            .sheet(item: $selectedDiscount) { selectedDiscount in
                                
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .onAppear(){
                discountListManager.getDiscountList()
            }
            HStack{
                Button(action: {
                    discountListManager.getDiscountList()
                }, label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                Button(action: {
                    dismiss()
                }, label: {
                    CustomButton(icon: "multiply")
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(40)
            }
        }.ignoresSafeArea()
    }
}
#Preview {
    ProductDiscountListView()
}
struct ProductDiscountListItemView: View {
    var program: DiscountProgram
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack (spacing: 10){
                Text(program.programName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            HStack {
                Text("Начало:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(program.dateStart)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Завершения:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(program.dateEnd)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Департамент:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(program.department)
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            HStack {
                Text("Ответсвенный:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(program.responsiblePerson)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(15)
        .shadow(color: Color("Accent"), radius: 1)
    }
}

struct DiscountProgramDetailView: View {
    let program: DiscountProgram
    
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    Text(program.programName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                }.padding()
                VStack(spacing: 15){
                    HStack {
                        Text("Начало: ")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(program.dateStart)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Text("Завершения:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(program.dateEnd)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Text("Департамент:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(program.department)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Text("Ответсвенный:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(program.responsiblePerson)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: 400)
            .background(Color("CardColor"))
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.3), radius: 1, x: 0, y: 5)
            .ignoresSafeArea()
        }
    }
}

//struct DiscountProgramDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscountProgramDetailView(program: DiscountProgram(
//            id: "1308",
//            status: "active",
//            programName: "Скидка на Кондитерские изделия 15%",
//            department: "Супермаркет Пайкар 3",
//            discountValue: "15",
//            dateStart: "0000-00-00 00:00:00",
//            dateEnd: "0000-00-00 00:00:00",
//            productCode: "00132128",
//            productName: "Десерт Клубника в шоколаде Пайкар (вес)",
//            productQuantity: "5.0",
//            productImages: [
//                "24-10-28-15-42-18-516.jpg",
//                "24-10-28-15-42-19-009.jpg",
//            ],
//            user: "Гелла Кадзов",
//            responsiblePerson: "Фарида Садулаева"
//        ))
//    }
//}
