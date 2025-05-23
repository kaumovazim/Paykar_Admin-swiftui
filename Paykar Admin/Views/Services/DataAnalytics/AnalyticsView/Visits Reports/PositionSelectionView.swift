import SwiftUI
import Alamofire

struct PositionSelectionView: View {
    let unit: UnitListModel
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let holiday: Int
    let penaltyUnderperformance: Int
    let incentivesOvertime: Int
    let absenceForReason: Int
    
    @StateObject private var positionList = PositionList()
    @State private var selectedPosition: PositionListModel?
    @Environment(\.dismiss) private var dismiss
    @State var showUsers = false
    
    var body: some View {
        ZStack {
            VStack {
                // Заголовок и кнопки
                TittleGray(tittle: "Выбор позиции")
                
                Spacer()
                
                
                if positionList.isLoading {
                    SetLottieView(name: "Loading")
                    Spacer()
                } else if positionList.positions.isEmpty {
                    Text("Позиции не найдены")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                                    HStack {
                                        VStack(spacing: 10) {
                                            Text("Выбранное подразделение")
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                            Text(unit.name)
                                                .font(.subheadline)
                                        }
                                    }
                                    .frame(maxWidth: .infinity) // Растягиваем HStack на всю ширину
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                        
                        LazyVStack(spacing: 10) {
                            ForEach(positionList.positions) { position in
                                HStack {
                                    Text(position.name)
                                    Spacer()
                                    ZStack {
                                        Circle()
                                            .fill(Color("Primary"))
                                            .opacity(0.1)
                                            .frame(width: 30, height: 30)
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color("Primary"))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(selectedPosition?.id == position.id ? Color.green.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedPosition = position
                                    showUsers = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .scrollIndicators(.hidden)
                }
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .onAppear {
                positionList.getPositionList(unit: unit.name)
            }
            .fullScreenCover(isPresented: $showUsers) {
                if let selectedPosition = selectedPosition {
                    UserSelectionView(
                        position: selectedPosition,
                        unit: unit,
                        startDate: startDate,
                        endDate: endDate,
                        startTime: startTime,
                        endTime: endTime,
                        holiday: holiday,
                        penaltyUnderperformance: penaltyUnderperformance,
                        incentivesOvertime: incentivesOvertime,
                        absenceForReason:absenceForReason
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}
