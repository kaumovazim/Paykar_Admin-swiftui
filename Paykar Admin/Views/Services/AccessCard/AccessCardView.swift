import SwiftUI

struct AccessCardView: View {
    @StateObject var mainManager = MainManager()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ListAccessCard()
    @State var alertConnection: Bool = false
    @State var showAddCard = false
    @State var showDetail = false
    @State private var selectedCard: ListAccessCardModel?
    var admin: AdminModel?
    let adminData = UserManager.shared.retrieveUserFromStorage()
    var body: some View {
        ZStack {
            VStack {
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
                        Text("Карты доступа")
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                        if adminData?.position == "Супер Админ" {
                            Button {
                                showAddCard = true
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(Color("Primary"))
                                    .font(.title2)
                            }
                            .padding(.horizontal, 20)
                                .sheet(isPresented: $showAddCard, content: {
                                    AddCardView()
                                })
                                .onChange(of: showAddCard == false) { oldValue, newValue in
                                    viewModel.getCardList()
                                }
                        }

                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                    .padding(.bottom)
                }
                .ignoresSafeArea()

                Spacer()

                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .padding(.bottom, 100)
                    Spacer()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.cards) { card in
                                let addCard = card.add_card ?? "Неизвестно"
                                let unit = card.unit ?? "Неизвестно"
                                let addDate = card.create_date ?? "Неизвестно"
                                VStack {
                                    Button {
                                        selectedCard = card // Запоминаем, какую карту открываем
                                        showDetail = true
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color("CardColor"))
                                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                            HStack {
                                                VStack(alignment: .leading, spacing: 5) {
                                                    HStack {
                                                        Text("Карта: \(unit)")
                                                            .foregroundColor(Color("Accent"))
                                                            .font(.headline)
                                                            .fontWeight(.bold)
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        Image(systemName: "person.fill")
                                                            .foregroundColor(.gray)
                                                        Text("Добавил: \(addCard)")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                    }
                                                    HStack {
                                                        Image(systemName: "calendar")
                                                            .foregroundColor(.gray)
                                                        Text(mainManager.formattedDateToString(addDate))
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
                                    .sheet(isPresented: $showDetail, content: {
                                        if let selectedCard = selectedCard { // Передаем данные только если карта выбрана
                                            DetailAccessCardVIew(
                                                name: selectedCard.add_card ?? "Неизвестно",
                                                number: selectedCard.number_card ?? "Неизвестно",
                                                unit: selectedCard.unit ?? "Неизвестно",
                                                position: selectedCard.position ?? "Неизвестно",
                                                create_date: selectedCard.create_date ?? "Неизвестно",
                                                update_date: selectedCard.update_date ?? "Неизвестно",
                                                status: selectedCard.status == "active" ? "Активно" : "Деактивно"
                                            )
                                        }
                                    })
                                }
                            }

                        }
                    }
                }
                
            }
            .alert("Что то пошло не так!", isPresented: $alertConnection) {
                Button("Попробовать еще", role: .cancel, action: {
                    dismiss()
                })
            } message: {
                Text("Проверьте подключение к Интернету и повторите попытку.")
            }
            .onAppear {
                viewModel.getCardList()
            }

            Spacer()
            HStack {
                Button {
                    if MainManager().checkInternetConnection() {
                        viewModel.getCardList()
                    }else{
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(40)
            }
        }
        .ignoresSafeArea()
        
    }
}
/*
 

 */
