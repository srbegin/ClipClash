//
//  SubmitEntryView.swift
//  Thursday
//
//  Created by Scott Begin on 10/12/22.
//

import SwiftUI
import AVKit
import UIKit


struct SubmitEntryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var cameraModel: CameraViewModel
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var showSubmitConfirmationAlert = false
    @State var entryCaption: String = ""
    @State var showContestPicker = false
    @State var entryUrlString: String = ""
    @State var userId: String
    @State var enterAnythingGoes = false
    @State var submitInProgress = false
    
    
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label {
                        } icon: {
                            Image(systemName: "chevron.left")
                                .font(Font.system(.title).bold())
                        }
                        .foregroundColor(.black)
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Enter Contest").font(Font.h5).foregroundColor(.black).padding(.top)
                    Spacer()
                }
            }
            .padding(.bottom)
            
            Divider().padding(.top, isFocused ? 175 : 0)
            HStack {
                TextEditor(text: $entryCaption)
                        .frame(height: 200)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5.0)
                        .font(Font.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color(.clear))
                        .foregroundColor(.black)
                        .focused($isFocused)
                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .overlay {
                            if (!isFocused && entryCaption == "") {
                                VStack {
                                    Text("Add a caption").foregroundColor(.gray).padding()
                                    Spacer()
                                }
                            }
                        }
                   
                if let _ = userState.entryThumbnail {
                    userState.entryThumbnail!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                } else {
                    Image("icon-t")
                }

            }
            
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                if(!(userState.entryCaption ?? "").isEmpty) {
                    entryCaption = userState.entryCaption!
                }
            }
            
            Divider().padding(.bottom)
            
            if (userState.contestToEnter?.contest_id != AppConstants.anythingGoesContestId) {
                HStack {
                    Image(systemName: "info.circle")
                    //                Text("Also add to 'Anything Goes Contest'?").font(.subheadline).foregroundColor(.black)
                    Spacer()
                    Toggle("Add to 'Anything Goes Contest'?", isOn: $enterAnythingGoes)
                }.padding(.bottom).padding(.horizontal)
                
                Divider().padding(.bottom)
            }
            
            if isFocused { Button("Done") { isFocused = false }.offset(x: 0, y: 0) }


            SubmitEntryConfirmBox(entryUrlString: self.entryUrlString, entryCaption: self.entryCaption, enterAnythingGoes: $enterAnythingGoes, submitInProgress: $submitInProgress)
                .padding(.top, 15)
            
            Button(action: {
                submitInProgress = true
                Task {
                    do {
                        _ = try await network.submitMediaItem(userId: String(userState.userModel.id), localVideoURL: entryUrlString, caption: entryCaption)
                        submitInProgress = false
                        showSubmitConfirmationAlert = true
                    } catch {
                        print(error)
                    }
                                    }
            }) {
                Text("Save As Draft?").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
            }.frame(width:300).buttonStyle(ClearWideButton())
                .alert(isPresented: $showSubmitConfirmationAlert) {
                    Alert(title: Text("Saved as draft"), dismissButton: Alert.Button.default(
                        Text("OK"), action: {
                            userState.contestToVoteOn = userState.contestToEnter
                            viewRouter.currentPage = .vote
                            presentationMode.wrappedValue.dismiss()
                            userState.clearEntryIntent()
                            cameraModel.clearCapturedContent()
                        }
                    ))}
    }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
        .overlay {
            if (submitInProgress) {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).scaleEffect(3)
            }
        }
    }
    
}

struct SubmitEntryView_Previews: PreviewProvider {
    
    static var previews: some View {
        SubmitEntryView(entryUrlString: "url", userId: "1")
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
