//
//  AccessCard(card).swift
//  Paykar Admin
//
//  Created by Macbook Pro on 19.03.2025.
//


import SwiftUI
import CoreImage.CIFilterBuiltins



struct AccessCard_card_: View {
    @State var cardNumber: String
    @State var name: String
    @State var unit: String
    @State var codeNumber: String
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("НОМЕР КАРТЫ")
                        .font(.caption)
                    Text(codeNumber)
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .frame(maxHeight: .infinity)
                VStack(alignment: .leading, spacing: 4) {
                    Text("ПОДРАЗДЕЛЕНИЕ")
                        .font(.caption)
                    HStack(spacing: 4) {
                        Text(unit)
                    }
                }
                .padding(.trailing, 15)
            }

            
            VStack(alignment: .center, spacing: 10) {
                if let barcodeImage = generateBarcode(from: cardNumber) {
                    Image(uiImage: barcodeImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 320, height: 70) // Размер штрих-кода
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(.bottom, 10)
                }
                
            }.padding(.leading, 10)
        }
        .foregroundStyle(.white)
        .monospaced()
        .contentTransition(.numericText())
        .padding(15)
        
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
}
