//
//  QrScannerView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 10/11/24.
//

import SwiftUI
import AVFoundation

struct QRCamera: UIViewRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCamera
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        init(parent: QRCamera) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let previewLayer = self.previewLayer else { return }
            
            if let metadataObject = metadataObjects.first,
               let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
               let stringValue = readableObject.stringValue {
                
                let transformedObject = previewLayer.transformedMetadataObject(for: readableObject)
                if let transformedBounds = transformedObject?.bounds, self.parent.overlayFrame.contains(transformedBounds) {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    parent.captureSession.stopRunning()
                    DispatchQueue.main.async {
                        self.parent.onCodeScanned(stringValue)
                    }
                }
            }
        }
    }
    
    var onCodeScanned: (String) -> Void
    let captureSession = AVCaptureSession()
    var overlayFrame: CGRect

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(parent: self)
        coordinator.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        return coordinator
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                DispatchQueue.main.async {
                    self.setupCaptureSession(context: context, view: view)
                }
            }
        }
        
        return view
    }
    
    private func setupCaptureSession(context: Context, view: UIView) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                return
            }
        } catch {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = UIScreen.main.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        }
        
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        captureSession.stopRunning()
    }
}

struct QRScannerView: View {
    @Binding var scannedData: QRDataModel?
    @State private var isScanning = true
    @Environment(\.dismiss) var dismiss
    
    private let overlayWidth: CGFloat = 300
    private let overlayHeight: CGFloat = 300

    var body: some View {
        ZStack {
            if isScanning {
                GeometryReader { geometry in
                    QRCamera(
                        onCodeScanned: { code in
                            parseQRCodeData(code)
                            self.isScanning = false
                            if scannedData != nil {
                                dismiss()
                            }
                        },
                        overlayFrame: CGRect(
                            x: (geometry.size.width - overlayWidth) / 2,
                            y: (geometry.size.height - overlayHeight) / 2,
                            width: overlayWidth,
                            height: overlayHeight
                        )
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            
            VStack {
                Spacer(minLength: 100)
                VStack {
                    Text("QR scanner")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    QRCodeOverlayView()
                        .frame(width: overlayWidth, height: overlayHeight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                Spacer(minLength: 200)
            }
            VStack {
                Button {
                    self.scannedData = nil
                    self.isScanning = false
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(60)
        }
    }
    
    private func parseQRCodeData(_ code: String) {
        if let data = code.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let qrData = try decoder.decode(QRDataModel.self, from: data)
                self.scannedData = qrData
            } catch {
                print("Failed to parse QR code as JSON: \(error)")
            }
        }
    }
}

struct QRCodeOverlayView: View {
    @State private var isScanning = false
    let overlayWidth: CGFloat = 300
    let overlayHeight: CGFloat = 300
    let cornerLength: CGFloat = 30
    let lineWidth: CGFloat = 5

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .trim(from: 0.50, to: 0.75)
                .stroke(Color("Primary"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: cornerLength, height: cornerLength)
                .offset(x: -overlayWidth / 2.2 + cornerLength / 2.2, y: -overlayHeight / 2.2 + cornerLength / 2.2)

            RoundedRectangle(cornerRadius: 2)
                .trim(from: 0.75, to: 1.0)
                .stroke(Color("Primary"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: cornerLength, height: cornerLength)
                .offset(x: overlayWidth / 2.2 - cornerLength / 2.2, y: -overlayHeight / 2.2 + cornerLength / 2.2)

            RoundedRectangle(cornerRadius: 2)
                .trim(from: 0, to: 0.25)
                .stroke(Color("Primary"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: cornerLength, height: cornerLength)
                .offset(x: overlayWidth / 2.2 - cornerLength / 2.2, y: overlayHeight / 2.2 - cornerLength / 2.2)

            RoundedRectangle(cornerRadius: 2)
                .trim(from: 0.25, to: 0.5)
                .stroke(Color("Primary"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: cornerLength, height: cornerLength)
                .offset(x: -overlayWidth / 2.2 + cornerLength / 2.2, y: overlayHeight / 2.2 - cornerLength / 2.2)
            
            Rectangle()
                .fill(Color("Primary"))
                .frame(width: overlayWidth - cornerLength + 2, height: 2)
                .offset(y: isScanning ? overlayHeight / 1.8 - cornerLength : -overlayHeight / 1.8 + cornerLength)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: isScanning)
                .onAppear { isScanning.toggle() }
        }
        .frame(width: overlayWidth, height: overlayHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
