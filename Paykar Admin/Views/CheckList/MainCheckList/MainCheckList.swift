
import SwiftUI

struct MainCheckList: View {
    @StateObject private var getQuestions = QuestionList()
    @StateObject var sendAnswer = SendAnswers()
    @State private var selectedAnswers: [String: Bool] = [:]
    @State var comments: [String: String] = [:]
    @State var showAlert = false
    @State var alertTittle = ""
    @State var alertMessage = ""
    @State var showConfirmationDialog = false
    @State var loading = false
    var admin: AdminModel?
    let adminData = UserManager.shared.retrieveUserFromStorage()
    @Environment(\.dismiss) var dismiss
    
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
                        Text("Опрос")
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                    .padding(.bottom)
                }
                .ignoresSafeArea()
                Spacer()

                if getQuestions.isLoading {
                    SetLottieView(name: "Loading")
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(getQuestions.questions) { question in
                                let binding = Binding<Bool>(
                                    get: { selectedAnswers[question.id] ?? false },
                                    set: { selectedAnswers[question.id] = $0 }
                                )
                              
                                let commentBinding = Binding<String>(
                                    get: { comments[question.id] ?? "" },
                                    set: { comments[question.id] = $0 }
                                )

                                // Вынесем формирование label в отдельную переменную
                                let toggleLabel: some View = HStack {
                                    Text("Ответ: ")
                                    Spacer()
                                    Text(binding.wrappedValue ? "Да" : "Нет")
                                        .foregroundStyle(binding.wrappedValue ? Color("LightPrimary") : Color.red)
                                        .font(.headline)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(question.question ?? "Вопрос")")
                                        .font(.headline)
                                        .foregroundColor(Color("Accent"))
                                        
                                    if adminData?.position == "Охрана" || adminData?.position == "Кассир" {
                                        Toggle(isOn: binding) {
                                            toggleLabel
                                        }
                                        .toggleStyle(SwitchToggleStyle())
                                        .animation(.easeInOut)
                                        TextField("Комментарий", text: commentBinding)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color("CardColor"))
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                )
                            }
                        }
                        .padding(.vertical, 15)
                    }
                    .scrollIndicators(.hidden)

                    // Кнопка для отправки всех ответов
                    if adminData?.position == "Охрана" || adminData?.position == "Кассир" {
                        VStack {
                            
                            Button(action: {
                                showConfirmationDialog = true // Показываем диалог подтверждения
                            }) {
                                Text("Отправить")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .padding(.horizontal, 20)
                                    .background(Color("AccentColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                                
                            }
                            .padding(20)
                            .alert("Подтверждение", isPresented: $showConfirmationDialog) {
                                Button("Отмена", role: .destructive) {}
                                Button("Отправить", role: .cancel) { sendAnswers() }
                            } message: {
                                Text("Вы уверены, что хотите отправить ответы?")
                            }
                            .alert(alertTittle, isPresented: $showAlert) {
                                Button("Ок", role: .cancel) { dismiss() }
                            } message: {
                                Text(alertMessage)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                    }
                }
                
            }
            .onAppear {
                getQuestions.question { response in
                    print(response ?? " ")
                }
            }
            
            Spacer()
        }.ignoresSafeArea()
    }
    private func sendAnswers() {
        
        getQuestions.isLoading = true
        sendAnswer.questions = getQuestions.questions
        sendAnswer.answers = []
        
        let group = DispatchGroup()
        
        for question in getQuestions.questions {
            group.enter()
            
            let answerValue = selectedAnswers[question.id] ?? false
            let comment = comments[question.id] ?? " "
            
            sendAnswer.addAnswer(questionId: question.id, answer: answerValue, comment: comment) { response in
                if let response = response {
                    alertTittle = "Отправлено"
                    alertMessage = response.message
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            getQuestions.isLoading = false
            showAlert = true
        }
    }
}
