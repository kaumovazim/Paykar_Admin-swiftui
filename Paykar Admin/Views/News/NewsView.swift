import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsListViewModel()
    @State var selectNews: NewsListModel? = nil
    @Binding var lastOffset: CGFloat
    @State private var hideButton = false
    @State private var showCreateNews = false
    @State private var adminData = UserManager.shared.retrieveUserFromStorage()
    @State var isTapped = false
    @State var connection: Bool = false
    @State var showAlert: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 16) {

                    
                    if viewModel.displayedNews.isEmpty && !viewModel.isLoading {
                        Text("Здесь пока ничего нет")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(viewModel.displayedNews.sorted(by: { $0.create_date > $1.create_date }), id: \.id) { news in
                            
                            NewsCardView(news: news, viewModel: viewModel, selectNews: $selectNews, lineLimit: 3, isTapped: $isTapped)
                                .transition(.opacity.combined(with: .scale))
                                .onAppear {
                                    // Подгружаем следующую порцию, если это последняя новость
                                    if news.id == viewModel.displayedNews.last?.id && viewModel.hasMoreNews() {
                                        viewModel.loadMoreNews()
                                    }
                                }
                        }
                    }
                }
                .padding(.vertical)
            }
            .coordinateSpace(name: "scroll")
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.fetchNews()
            }
            if adminData?.position == "Супер Админ" {
                FloatingActionButton(showCreateNews: $showCreateNews, isHidden: hideButton)
                    .padding(20)
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showCreateNews, onDismiss: { showCreateNews = false }) {
            CreateNewsView()
        }
        .onAppear {
            checkConnection()
            viewModel.fetchNews()
        }
        .sheet(item: $selectNews, onDismiss: {
            selectNews = nil
        }) { news in
            DetailNewsView(news: news)
            .transition(.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .trailing)
            ))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Нет подключения"), message: Text("Подключитесь к сети и повторите попытку"), dismissButton: .default(Text("Повторить")) { checkConnection()})
        }

    }
    func checkConnection() {
        if MainManager().checkInternetConnection() {
            connection = false
        } else{
            connection =  true
            showAlert = true
        }
        func funcInFunc() {
            print("func")
        }
    }
    
}
