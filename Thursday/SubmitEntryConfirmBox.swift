//
//  SubmitEntryConfirmBox.swift
//  Thursday
//
//  Created by Scott Begin on 12/17/22.
//

import SwiftUI

struct SubmitEntryConfirmBox: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var cameraModel: CameraViewModel
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var showSubmitConfirmationAlert = false
    @State private var showChangeContestAlert = false
    
    var entryUrlString: String
    var entryCaption: String
    
    @Binding var enterAnythingGoes: Bool
    @Binding var submitInProgress: Bool
    
    
    var body: some View {
        VStack (alignment: .center) {
            HStack { Spacer() }
            
            if (userState.contestToEnterChosen) {
                AsyncImage(url: URL(string: String(userState.contestToEnter!.image_url!))){ image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .topLeading)
                .scaledToFit()
                .padding(.top)
            } else {
                ImageOnCircle(asset: "icon-trophy-hollow", radius: 50, circleColor: .clear, borderColor: Color.black, borderWidth: 0.5, imageScale: 0.6)
            }
            
            if (userState.contestToEnterChosen) {
                
                Text(userState.contestToEnter!.name).font(Font.h4).foregroundColor(.white).padding(.top)
                
                Button(action: {
                    Task {
                        submitInProgress = true
                        
                        do {
                            //Submit the MediaItem and get the new id
                            let newId = try await String(network.submitMediaItem(userId: String(userState.userModel.id), localVideoURL: entryUrlString, caption: entryCaption))
                            
                            //Submit to intended contest
                            try await network.createEntry(contestId: String(userState.contestToEnter!.contest_id), mediaItemId: String(newId))
                            
                            //And to AnythingGoes contest if desired
                            if (enterAnythingGoes) {
                                try await network.createEntry(contestId: String(AppConstants.anythingGoesContestId), mediaItemId: String(newId))
                            }
                            
                            submitInProgress = false
                            showSubmitConfirmationAlert = true
                            
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    Text("Submit Entry").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
                }
                .frame(width:300).buttonStyle(YellowWideButton())//.padding(.bottom)
                .alert(isPresented: $showSubmitConfirmationAlert) {
                    Alert(title: Text("Thanks for entering!"), dismissButton: Alert.Button.default(
                            Text("OK"), action: {
                                if userState.contestToEnter?.status == "ACTIVE" || userState.contestToEnter?.status == "OPENACTIVE" {
                                    
                                    userState.contestToVoteOn = userState.contestToEnter
                                    viewRouter.currentPage = .vote
                                    userState.clearEntryIntent()
                                    cameraModel.clearCapturedContent()
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } else {
                                    viewRouter.currentPage = .contests
                                }
                            }
                        )
                    )
                }
                
                Button(action: {
                    Task {
                        showChangeContestAlert = true
                    }
                }) {
                    Text("Change Contest?").font(Font.h5).foregroundColor(.white)
                }
                .alert(isPresented: $showChangeContestAlert) {
                    Alert(title: Text("Choose a new contest"), dismissButton: Alert.Button.default(
                        Text("OK"), action: {
                            viewRouter.currentPage = .contests
                            userState.contestToEnterChosen = false
                            userState.entryCaption = self.entryCaption
                            presentationMode.wrappedValue.dismiss()
                            
                        }))}
                .padding()
                
            } else {
                
                Text("Choose A Contest").font(Font.h4).foregroundColor(.white).padding(.top)
                Button(action: {
                    userState.contestBrowsingStatus = .open
                    userState.entryCaption = self.entryCaption
                    viewRouter.currentPage = .contests
                }) {
                    Text("Browse Contests").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
                }.frame(width:300).buttonStyle(YellowWideButton()).padding(.bottom)
            }

        }
        .background(userState.contestToEnterChosen ? Color(.blue) : Color(.clear))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 15)
        .stroke(lineWidth: !userState.contestToEnterChosen ? 0.5 : 0.0)
        .foregroundColor(.black))
        .padding()
    }
}

struct SubmitEntryConfirmBox_Previews: PreviewProvider {
    static var previews: some View {
        SubmitEntryConfirmBox(entryUrlString: "", entryCaption: "", enterAnythingGoes: .constant(false), submitInProgress: .constant(false))
    }
}
