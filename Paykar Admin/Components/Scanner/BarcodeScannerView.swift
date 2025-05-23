//
//  ScannerView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 19/10/24.
//
//

import SwiftUI
import AVFoundation

struct BarcodeCamera: UIViewRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeCamera
        var overlayFrame: CGRect
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        init(parent: BarcodeCamera, overlayFrame: CGRect) {
            self.parent = parent
            self.overlayFrame = overlayFrame
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let previewLayer = self.previewLayer else { return }
            
            if let metadataObject = metadataObjects.first,
               let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
               let stringValue = readableObject.stringValue {
                
                let transformedObject = previewLayer.transformedMetadataObject(for: readableObject)
                
                if let transformedBounds = transformedObject?.bounds, overlayFrame.contains(transformedBounds) {
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
        let coordinator = Coordinator(parent: self, overlayFrame: overlayFrame)
        
        coordinator.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        return coordinator
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return view }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return view
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code128]
            
            let viewBounds = UIScreen.main.bounds
            let rectOfInterest = CGRect(
                x: overlayFrame.origin.y / viewBounds.height,
                y: overlayFrame.origin.x / viewBounds.width,
                width: overlayFrame.height / viewBounds.height,
                height: overlayFrame.width / viewBounds.width
            )
            metadataOutput.rectOfInterest = rectOfInterest
        }
        
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = UIScreen.main.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        captureSession.stopRunning()
    }
}

struct BarcodeScannerView: View {
    @Binding var scannedCode: String?
    var title: String
    @State private var isScanning = true
    @Environment(\.dismiss) var dismiss
    
    private let overlayWidth: CGFloat = 300
    private let overlayHeight: CGFloat = 150

    var body: some View {
        ZStack {
            if isScanning {
                GeometryReader { geometry in
                    BarcodeCamera(
                        onCodeScanned: { code in
                            self.scannedCode = code
                            self.isScanning = false
                            if scannedCode != "" {
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
                    Text(title)
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    BarcodeOverlayView()
                        .frame(width: overlayWidth, height: overlayHeight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                Spacer(minLength: 200)
            }
            VStack {
                Button {
                    self.scannedCode = ""
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
}

struct ScannedCode: Identifiable {
    let id = UUID()
    let code: String
}

struct BarcodeOverlayView: View {
    @State private var isScanning = false
    let overlayWidth: CGFloat = 300
    let overlayHeight: CGFloat = 150
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
                .frame(width: overlayWidth - cornerLength, height: 2)
                .offset(y: isScanning ? overlayHeight / 1.5 - cornerLength : -overlayHeight / 1.5 + cornerLength)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: isScanning)
                .onAppear { isScanning.toggle() }
        }
        .frame(width: overlayWidth, height: overlayHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
