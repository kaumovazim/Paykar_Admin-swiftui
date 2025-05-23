//
//  MakeReportView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 09/11/24.
//

import SwiftUI

struct MakeReportView: View {
    
    @State var shopSheet = false
    @State var shop = "Выбрать подразделение"
    @State var preselectedIndex: Int = 0
    @State var options: [String] = ["Открытие", "Закрытие"]
    @State var QRcodeAvaliable = false
    @State var scanQRcode = false
    @State var scannedData: QRDataModel? = nil
    @State var imageAvaliable = false
    @State var takeImage = false
    @State var alertConnection = false
    @State var errorAlert = false
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var opencloseReportManager = OpenCloseReportManager()
    
    var body: some View {
        ZStack{
            VStack{
                HStack {
                    Text("Открытие и закрытие \n магазина")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    Spacer()
                }
                .padding(.top, 50)
                VStack(spacing: 20) {
                    HStack(spacing: 0){
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color("Secondary"))
                                
                                Rectangle()
                                    .fill(Color("CardColor"))
                                    .cornerRadius(15)
                                    .padding(2)
                                    .opacity(preselectedIndex == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            preselectedIndex = index
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                            )
                        }
                    }
                    .cornerRadius(15)
                    .frame(height: 50)
                    .padding(.horizontal)
                    if shop != "Выбрать подразделение" {
                        Text("Подразделение")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                    }
                    Button {
                        shopSheet = true
                    } label: {
                        HStack{
                            Text(shop)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(height: 20)
                            
                            Spacer()
                            Image(systemName:  "chevron.down")
                                .foregroundColor(.secondary)
                                .frame(width: 15, height: 10)
                        }
                        .padding(15)
                        .padding(.horizontal, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                        }
                        
                    }
                    .sheet(isPresented: $shopSheet){
                        CustomList(update: {},list: ["Пайкар 1", "Пайкар 2", "Пайкар 3", "Пайкар 4", "Пайкар 5", "Пайкар 6", "Пайкар 7", "Пайкар 8"], title: $shop, close: $shopSheet)
                    }.padding(.horizontal)
                    VStack {
                        Text("QR код")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        Button {
                            scanQRcode = true
                        } label: {
                            Image(systemName: QRcodeAvaliable ? "checkmark.circle" : "plus.circle")
                                .font(.system(size: 28))
                                .foregroundStyle(Color("Primary"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .background(Color("Secondary"))
                                .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        .fullScreenCover(isPresented: $scanQRcode, content: {
                            QRScannerView(scannedData: $scannedData)
                                .onDisappear() {
                                    if scannedData != nil {
                                        QRcodeAvaliable = true
                                    }
                                }
                        })
                        .disabled(QRcodeAvaliable)
                    }
                    VStack {
                        Text("Фото отчет")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        Button {
                            cameraViewModel.openCamera()
                        } label: {
                            Image(systemName: imageAvaliable ? "checkmark.circle" : "plus.circle")
                                .font(.system(size: 28))
                                .foregroundStyle(Color("Primary"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .background(Color("Secondary"))
                                .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $cameraViewModel.showCamera) {
                            ImagePicker(sourceType: .camera, selectedImage: $cameraViewModel.capturedImage)
                                .onDisappear() {
                                    if cameraViewModel.capturedImage != nil {
                                        imageAvaliable = true
                                    }
                                }
                        }
                        .disabled(imageAvaliable)
                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }
            .opacity(opencloseReportManager.isLoading ? 0 : 1)
            ProgressView()
                .opacity(opencloseReportManager.isLoading ? 1 : 0)

            HStack {
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                Spacer()
                Button {
                    if MainManager().checkInternetConnection() {
                        let admin = UserManager.shared.retrieveUserFromStorage()!
                        let firstname = admin.firstname
                        let lastname = admin.lastname
                        let userId = "\(admin.id)"
                        let type = options[preselectedIndex]
                        let location = scannedData!.location
                        let createDate = scannedData!.createDate
                        let image = cameraViewModel.capturedImage!.jpegData(compressionQuality: 0.8)!
                        opencloseReportManager.createReport(firstName: firstname,
                                                            lastName: lastname,
                                                            userId: userId, 
                                                            unit: shop,
                                                            type: type,
                                                            qrLocation: location,
                                                            qrCreateDate: createDate,
                                                            imageData: image) { response in
                            if response.status == "success" {
                                dismiss()
                            } else {
                                errorAlert = true
                            }
                        }
                    } else {
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "checkmark")
                }
                .alert(isPresented: $errorAlert, content: {
                    Alert(title: Text("Что то пошло не так!"), message: Text("\(opencloseReportManager.uploadStatus)"), dismissButton: .default(Text("Попробовать еще")))
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(40)
                .disabled(!imageAvaliable || shop == "Выбрать подразделение" || !QRcodeAvaliable)
            }
        }
        .onAppear() {
            if let admin = UserManager.shared.retrieveUserFromStorage() {
                shop = admin.unit
            }
        }
        .ignoresSafeArea()
        .alert("Что то пошло не так!", isPresented: $alertConnection) {
            Button("Попробовать еще", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к Интернету и повторите попытку.")
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
class CameraViewModel: ObservableObject {
    @Published var showCamera = false
    @Published var capturedImage: UIImage?
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showCamera = true
        } else {
            print("Camera is not available on this device.")
        }
    }
    
    func saveCapturedImage(_ image: UIImage) {
        self.capturedImage = image
    }
}
