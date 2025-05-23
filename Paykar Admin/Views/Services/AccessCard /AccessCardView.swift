import SwiftUI

struct AccessCardView: View {
    @StateObject var mainManager = MainManager()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ListAccessCard()
    @State var alertConnection: Bool = false
    @State var showAddCard = false
    @State var showUpdateAlert = false
    @State private var selectedCard: ListAccessCardModel?  // выбранная карта
    @State var update = UpdateCard()
    var admin: AdminModel?
    let adminData = UserManager.shared.retrieveUserFromStorage()
    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
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
                            .fullScreenCover(isPresented: $showAddCard) {
                                AddCardView()
                            }
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
                    SetLottieView(name: "Loading")
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.cards) { card in
                                let cardId = card.id
                                let addCard = card.add_card ?? "Неизвестно"
                                let unit = card.unit ?? "Неизвестно"
                                let addDate = card.create_date ?? "Неизвестно"
                                Button {
                                    // При нажатии сохраняем выбранную карту
                                    selectedCard = card
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
                                        }
                                        .padding()
                                    }
                                    .padding(.horizontal)
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
                    } else{
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
        // Применяем .sheet(item:) для показа деталей выбранной карты
        .sheet(item: $selectedCard) { card in
            VStack {
                DetailAccessCardVIew(name: card.add_card ?? " ", number: card.number_card ?? " ", unit: card.unit ?? " ", position: card.position ?? " ", status: card.status ?? " ")
                if adminData?.position == "Супер Админ" {
                    Button {
                        showUpdateAlert = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("CardColor"))
                                .shadow(color: Color("Accent").opacity(0.1), radius: 5, x: 0, y: 3)
                                .frame(width: 200, height: 50)
                            Text("Удалить")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding(10)
                        }
                    }
                    .alert("Вы уверены", isPresented: $showUpdateAlert) {
                        Button("Да", role: .cancel) {
                            // Преобразуем selectedCard.id в отдельном выражении
                            if let cardId = Int(card.id) {
                                update.updateCard(cardId: cardId) { response in
                                    // Обработка ответа
                                }
                                DispatchQueue.main.async {
                                // Сбрасываем выбранную карту, чтобы закрыть sheet
                                    selectedCard = nil
                                    viewModel.getCardList()
                               }
                            }
                        }
                        Button("Отмена", role: .destructive) { }
                    } message: {
                        Text("Это действие нельзя будет отменить")
                    }
                }
            }
        }
    }
}
