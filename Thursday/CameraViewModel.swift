//
//  CameraViewModel.swift
//  Thursday
//
//  Created by Scott Begin on 10/12/22.
//

import SwiftUI
import AVFoundation
import AssetsLibrary

// MARK: Camera View Model
class CameraViewModel: NSObject,ObservableObject,AVCaptureFileOutputRecordingDelegate{
    @EnvironmentObject var userState: UserState
    
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCaptureMovieFileOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // MARK: Video Recorder Properties
    @Published var isRecording: Bool = false
    @Published var recordedURLs: [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    @Published var previewLoading = false

    
    // Top Progress Bar
    @Published var recordedDuration: CGFloat = 0
    // YOUR OWN TIMING
    @Published var maxDuration: CGFloat = 30
    
//    var sessionQueue: DispatchQueue
    var videoDeviceInput: AVCaptureDeviceInput?
    
    override init() {
        super.init()
             
        let session: AVCaptureSession = AVCaptureSession()
        self.session = session
        
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview.frame.size = UIScreen.screenSize
        self.preview.videoGravity = .resizeAspectFill
    }
    
    func clearCapturedContent() {
        self.recordedDuration = 0
        self.previewURL = nil
        self.recordedURLs = []
        self.showPreview = false
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }

    func switchCamera() {
        guard let currDevicePos = (session.inputs.first as? AVCaptureDeviceInput)?.device.position
        else { return }
        
        //Indicate that some changes will be made to the session
        session.beginConfiguration()
        
        //Get new input
        guard let newCamera = cameraWithPosition(position: (currDevicePos == .back) ? .front : .back )
        else {
            print("ERROR: Issue in cameraWithPosition() method")
            return
        }
        
        do {
            let newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let newAudioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            while session.inputs.count > 0 {
                session.removeInput(session.inputs[0])
            }
            
            session.addInput(newVideoInput)
            session.addInput(newAudioInput)
            
        } catch let err1 as NSError {
            print("Error creating capture device input: \(err1.localizedDescription)")
        }
        
        //Commit all the configuration changes at once
        session.commitConfiguration()
    }
    
    
    func checkPermission(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(){
        
        do{
//            let session: AVCaptureSession = AVCaptureSession()
//            self.session = session
            self.session.beginConfiguration()
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice!)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            // MARK: Audio Input
            
            if self.session.canAddInput(videoInput) && self.session.canAddInput(audioInput){
                self.session.addInput(videoInput)
                self.session.addInput(audioInput)
            }

            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
//            self.preview.session = session
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func startRecording(){
        let tempFileName = UUID().uuidString
//        userState.entryFileName = tempFileName
        let tempURL = NSTemporaryDirectory() + tempFileName + ".mov"
        output.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording(){
        print("in stopRecording")
        output.stopRecording()
        isRecording = false
        previewLoading = true
        showPreview = true
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // CREATED SUCCESSFULLY
        self.recordedURLs.append(outputFileURL)
        
        
        // CONVERTING URLs TO ASSETS
//        let assets = recordedURLs.compactMap { url -> AVURLAsset in
//            return outputFileURL(url: url)
//        }
        
        // If we don't go through mergeVideos (for it's "transform" code), we just uncomment next line
//        self.previewURL = outputFileURL
        
//         MERGING VIDEOS
        mergeVideos(asset: AVURLAsset(url: outputFileURL)) { exporter in
            exporter.exportAsynchronously {
                if exporter.status == .failed{
                    // HANDLE ERROR
                    print(exporter.error!)
                }
                else{
                    if let finalURL = exporter.outputURL{
                        print(finalURL)
                        DispatchQueue.main.async {
                            self.previewURL = finalURL
                        }
                    }
                }
            }
        }
    }
    
    func mergeVideos(asset: AVURLAsset ,completion: @escaping (_ exporter: AVAssetExportSession)->()){
        
        let compostion = AVMutableComposition()
        var lastTime: CMTime = .zero
        
        guard let videoTrack = compostion.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else{return}
        guard let audioTrack = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else{return}
        
//        for asset in assets {
            // Linking Audio and Video
            do{
                try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .video)[0], at: lastTime)
                // Safe Check if Video has Audio
                if !asset.tracks(withMediaType: .audio).isEmpty{
                    try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .audio)[0], at: lastTime)
                }
            }
            catch{
                // HANDLE ERROR
                print(error.localizedDescription)
            }
            
            // Updating Last Time
            lastTime = CMTimeAdd(lastTime, asset.duration)
//        }
        
        // MARK: Temp Output URL
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        
        // VIDEO IS ROTATED
        // BRINGING BACK TO ORIGNINAL TRANSFORM
        
        let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        
        // MARK: Transform
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: 90 * (.pi / 180))
        transform = transform.translatedBy(x: 0, y: -videoTrack.naturalSize.height)
        layerInstructions.setTransform(transform, at: .zero)
        
        let instructions = AVMutableVideoCompositionInstruction()
        instructions.timeRange = CMTimeRange(start: .zero, duration: lastTime)
        instructions.layerInstructions = [layerInstructions]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
        videoComposition.instructions = [instructions]
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
//        guard let exporter = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetHighestQuality) else {return}
        guard let exporter = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetMediumQuality) else {return}
        exporter.outputFileType = .mp4
        exporter.outputURL = tempURL
        exporter.videoComposition = videoComposition
        completion(exporter)
    }
    
   
}



