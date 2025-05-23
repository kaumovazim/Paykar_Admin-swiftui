import SwiftUI

struct TypeSelect: View {
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let holiday: Int
    let type: String
    
    let unit = ["Департамент управления персоналом", "Отдел маркетинга", "Департамент it технологий и техн.развития", "Колл-центр", "Коммерческий департамент", "Отдел кат.менеджеров", "Департамент финансового анализа", "Юридический отдел", "Интернет-магазин"]
    
    @State private var selectedUnit: String? = nil
    @State private var showTop = false // Изменили начальное значение на false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            mainContent
                .fullScreenCover(isPresented: $showTop) {
                    TopListView(
                        startDate: startDate,
                        endDate: endDate,
                        startTime: startTime,
                        endTime: endTime,
                        type: type,
                        holiday: holiday,
                        allowedUnits: selectedUnit != nil ? [selectedUnit!] : []
                    )
                }
        }
        .ignoresSafeArea()
    }
    
    private var mainContent: some View {
        VStack {
            TittleGray(tittle: "Выбор подразделения")
            Spacer()
            ScrollView {
                VStack(spacing: 10) {
                    dateTimeSection
                    unitsList
                }
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(spacing: 10) {
            Text("Выбранный период")
                .font(.headline)
            HStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Дата")
                        .font(.subheadline)
                    Text(formatDisplayDate(from: startDate))
                        .foregroundStyle(Color.gray)
                    Text(formatDisplayDate(from: endDate))
                        .foregroundStyle(Color.gray)
                }
                .padding(.horizontal, 20)
                Spacer(minLength: 0)
                VStack(alignment: .trailing) {
                    Text("Время")
                        .font(.subheadline)
                    Text("\(startTime) - \(endTime)")
                        .foregroundStyle(Color.gray)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var unitsList: some View {
        LazyVStack(spacing: 10) {
            ForEach(unit, id: \.self) { unit in
                HStack {
                    Text(unit)
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
                .background(selectedUnit == unit ? Color.green.opacity(0.2) : Color(.systemGray6))
                .cornerRadius(10)
                .onTapGesture {
                    selectedUnit = unit
                    showTop = true
                    print("Selected unit: \([unit])")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    
    private func formatDisplayDate(from dateString: String) -> String {
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        return displayFormatter.string(from: date)
    }
}

// Временная обертка для исправления синтаксиса fullScreenCover
struct FullScreenCover<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content
    
    var body: some View {
        EmptyView() // Замените на реальную реализацию в вашем проекте
            .fullScreenCover(isPresented: $isPresented, content: content)
    }
}
