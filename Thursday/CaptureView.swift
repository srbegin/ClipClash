//
//  CaptureView.swift
//  Thursday
//
//  Created by Scott Begin on 10/12/22.
//

import SwiftUI
import AVKit

struct CaptureView: View {
    @EnvironmentObject var cameraModel: CameraViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userState: UserState
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isCountdown = false
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
            ZStack {
                
                CameraView()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        ZStack {
                            HStack {
                                Button {
                                    if cameraModel.isRecording{
                                        cameraModel.stopRecording()
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                    viewRouter.currentPage = viewRouter.previousPage
                                } label: {
                                    Label {
                                    } icon: {
                                        Image(systemName: "chevron.left")
                                            .font(Font.system(.title).bold())
                                    }
                                    .foregroundColor(.white)
                                }
                                .padding(.leading)
                                .padding(.top)

                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Text("Do Something Cool!").font(Font.h5).foregroundColor(.white).padding(.top)
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                    }.padding(.top, 30)
                    Spacer()
                    VStack {
                        HStack {
                            ZStack {
                                
                                HStack {
                                    Spacer()
                                    Button {
                                        if cameraModel.isRecording{
                                            cameraModel.stopRecording()
                                        }
                                        else{
                                            isCountdown = true
                                            
//                                            cameraModel.startRecording()
                                        }
                                    } label: {
                                        Image(systemName: "camera.circle")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.black)
                                            .opacity(cameraModel.isRecording ? 0 : 1)
                                            .padding(12)
                                            .frame(width: 60, height: 60)
                                            .background{
                                                Circle()
                                                    .stroke(cameraModel.isRecording ? .clear : .black)
                                            }
                                            .padding(6)
                                            .background{
                                                Circle()
                                                    .fill(cameraModel.isRecording ? .red : .white)
                                            }
                                    }
                                    Spacer()
                                }
                                
                                // Switch camera button
                                HStack {
                                    Spacer()
                                    Button (action: { cameraModel.switchCamera() }) {
                                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                    .offset(x: -20, y: 0)
                                }
                            }.padding(.bottom, 10)
                            
                        }
                        
                        //timer here
                        HStack (alignment: .bottom){
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.black.opacity(0.25))
                                
                                Rectangle()
                                    .fill(Color.yellow)
                                    .frame(width: UIScreen.screenWidth * (cameraModel.recordedDuration / cameraModel.maxDuration))
                            }
                            .frame(height: 6)
                        }
                    }.offset(x: 0, y: -35)
                }
              
                
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom,10)
            .overlay(content: {
                if (isCountdown) {
                    Text((timeRemaining == 0) ? "GO!" : "\(timeRemaining)")
                        .font(Font.h1)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                }
                if let url = cameraModel.previewURL,cameraModel.showPreview{
                    FinalPreview(previewUrl: url)
                        .transition(.move(edge: .trailing))
                        .onAppear {
                            cameraModel.previewLoading = false
                        }
                }
            })
            .animation(.easeInOut, value: cameraModel.showPreview)
            .onReceive(timer) { time in
                if (isCountdown && timeRemaining > 0) {
                    timeRemaining -= 1
                } else if (timeRemaining <= 1) {
                    isCountdown = false
                    timeRemaining = 5
                    cameraModel.startRecording()
                }
            }
            //.preferredColorScheme(.dark)
            
        }
}

struct CaptureView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureView()
    }
}


struct FinalPreview: View {
    var previewUrl: URL
   
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var cameraModel: CameraViewModel
    @StateObject var network = Network()
    
    @State var isModal: Bool = false
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var isSubmitPresented = false
    
    var body: some View {
            
//            ThursPlayerView(url: previewUrl.absoluteString)
//                .aspectRatio(contentMode: .fill)
//                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
//                .edgesIgnoringSafeArea(.all)
        CustomPlayerView(player: AVPlayer(url: URL(string: previewUrl.absoluteString)!))
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .edgesIgnoringSafeArea(.all)
                .confirmationDialog("Discard your video?", isPresented: $showingSheet, titleVisibility: .visible) {
                    Button("Discard") {
                        userState.entryCaptured = false
                        cameraModel.clearCapturedContent()
                        FileManager.default.clearTmpDirectory()
                    }
                }
                .onAppear {
                    userState.entryCaptured = true
                    cameraModel.previewLoading = false
                }
                
            // Back Button
                .overlay(alignment: .topLeading) {
                    VStack {
                        HStack {
                            ZStack {
                                HStack {
                                    Button {
                                        showingSheet = true
                                    } label: {
                                        Label {
                                        } icon: {
                                            Image(systemName: "chevron.left")
                                                .font(Font.system(.title).bold())
                                        }
                                        .foregroundColor(.white)
                                    }
                                    .padding(.leading)
                                    .padding(.top)

                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text("Preview").font(Font.h5).foregroundColor(.white).padding(.top)
                                    Spacer()
                                }
                            }
                            .padding(.bottom)
                        }
                            .padding(.top, 20)
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            userState.entryURLString = previewUrl.absoluteString
                            userState.entryThumbnail = Image(uiImage: URL(string: userState.entryURLString!)!.generateThumbnail()!)
                            isSubmitPresented = true
                            
                        }) {
                            Text("Submit")
                                .frame(minWidth: 0, maxWidth: 300)
                                .font(Font.h5)
                                .foregroundColor(.black)
                        }.frame(width:300).buttonStyle(YellowWideButton()).padding()
                        .fullScreenCover(isPresented: $isSubmitPresented) {
                            SubmitEntryView(entryUrlString: userState.entryURLString!, userId: String(userState.userModel.user_id))
                        }
                        .padding(.bottom, 40)
                    }
                    
                }

    }
    
    
}
