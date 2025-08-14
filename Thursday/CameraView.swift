//
//  CameraView.swift
//  Thursday
//
//  Created by Scott Begin on 10/12/22.
//

import SwiftUI
import AVFoundation


struct CameraView: View {
    @EnvironmentObject var cameraModel: CameraViewModel
    
    var body: some View{
        ZStack {
            
            CameraPreview(cameraModel: cameraModel, size: UIScreen.screenSize)
                .onAppear {
                    cameraModel.checkPermission()
                    DispatchQueue.global().async {
                        cameraModel.session.startRunning()
                    }
                }
//                .overlay {
//                    if (!cameraModel.previewLoading) {
//                        Text(String(Int(cameraModel.maxDuration - cameraModel.recordedDuration))).foregroundColor(.white).font(Font.h2)
//                    }
//                }
            
                .alert(isPresented: $cameraModel.alert) {
                    Alert(title: Text("Please Enable Camera Access Or Microphone Access"))
                }
                .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                    
                    if cameraModel.recordedDuration <= cameraModel.maxDuration && cameraModel.isRecording{
                        cameraModel.recordedDuration += 0.01
                    }
                    
                    if cameraModel.recordedDuration >= cameraModel.maxDuration && cameraModel.isRecording{
                        // Stopping the Recording
                        cameraModel.stopRecording()
                        cameraModel.isRecording = false
                    }
                }
        }.overlay {
            if (cameraModel.previewLoading) {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).scaleEffect(5)
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @StateObject var cameraModel : CameraViewModel
    private let sessionQueue = DispatchQueue(label: "com.thursday.SessionQ")
    var size: CGSize
    
    func makeUIView(context: Context) ->  UIView {
        let view = UIView()
        
        //Moved this to CameraViewModel init() so it doesn't attempt reassignment of preview layer when returning to CaptureView
//        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
//        cameraModel.preview.frame.size = size
//        cameraModel.preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(cameraModel.preview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

