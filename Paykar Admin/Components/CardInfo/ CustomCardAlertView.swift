import SwiftUI
import CoreImage.CIFilterBuiltins

struct CustomCardAlertView: View {
    @Binding var isPresented: Bool
    let card: InfomationModel?

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4) // Затемнение фона
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                VStack(spacing: 20) {
                    if let card = card {
                        VStack {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("На карте")
                                        Text("\(String(format: "%.2f", card.Balance ?? 0.00)) баллов").font(.system(size: 20)).fontWeight(.bold)
                                        Text("10 баллов = 1 сомони")
                                        Text("Обновлено: \(formattedDate())")
                                    }.foregroundColor(.white).frame(width: 190)
                                    VStack(alignment: .leading) {
                                        Text("Номер Карты")
                                        Text("\(extractSubstring(from: card.CardCode ?? "000000"))").font(.system(size: 20)).fontWeight(.bold)
                                    }.foregroundColor(.white).offset(y: -27)
                                }
                                if let barcodeImage = generateBarcode(from: card.CardCode ?? "000000") {
                                    Image(uiImage: barcodeImage)
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 300, height: 70) // Размер штрих-кода
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .padding(.top, 10)
                                }
                            }

                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                    } else {
                        Text("Нет данных о карте")
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(width: 380,height: 250)
                .background(LinearGradient(colors: [Color("LightPrimary"), Color("DarkPrimary")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
    func formattedDate() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: Date())
        }
    func generateBarcode(from string: String) -> UIImage? {
            let context = CIContext()
            let filter = CIFilter.code128BarcodeGenerator()
            let data = string.data(using: .ascii)
            filter.message = data!

            if let outputImage = filter.outputImage {
                let scaleX: CGFloat = 5.5
                let scaleY: CGFloat = 3.5
                let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

                if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
            return nil
        }

    func extractSubstring(from text: String) -> String {
           let characters = Array(text)
           
           guard characters.count > 11 else { return "Недостаточно символов" }
           
           let subArray = characters[6...11]
           return String(subArray)
       }
}
