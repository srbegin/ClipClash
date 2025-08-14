//
//  MeView.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//

import SwiftUI
import AVKit
import NukeUI

struct MeView: View {
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var removedMediaItemId: Int?
    @State var isPresenting: MediaItem? = nil
    @State var lastScreen = AppConstants.defaultProfileView
    @State var showingEditSheet = false
    @State var isYouPresented = false
    
    
    func signOut() async {
       await LoginManager().doLogout()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
//                    Button(action: {
//
//                    }, label: {
//                        Label {
//                        } icon: {
//                            Image(systemName: "gearshape")
//                                .font(Font.system(.title))
//                        }
//                        .foregroundColor(.black)
//                    }).padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            self.showingEditSheet.toggle()
                        }
                        
                    }, label: {
                        Label {
                        } icon: {
                            Image(systemName: "line.3.horizontal")
                                .font(Font.system(.title))
                        }
                        .foregroundColor(.black)
                    }).padding(.trailing)
                        
                }.sheet(isPresented: $showingEditSheet, onDismiss: {
                    Task {
                        // Doing this here seems weird. How do we dynamically update user state when user model changes?
                        await userState.userModel.profile_pic = LoginManager().getUserById(id: String(userState.userModel.user_id)).profile_pic
                    }
                }) {
                    ProfileEditView()
                }
                
                VStack {
                    Text("@"+userState.userModel.username).font(Font.h3).foregroundColor(.black)
                    Text(userState.userModel.first_name+" "+userState.userModel.last_name).font(Font.body1).foregroundColor(.gray)
                    
                }.padding(.top)
            }
            
            HStack {
                Spacer()
                
                LazyImage(source: userState.userModel.profile_pic, resizingMode: .aspectFill)
                    .clipShape(Circle())
                    .frame(width: 150, height: 150, alignment: .center)
                    .padding(.top)
//                    .onTapGesture {
//                        isYouPresented = true
//                    }
                
                Spacer()
                
            }
            .fullScreenCover(isPresented: $isYouPresented) {
                YouView(youId: userState.userModel.user_id)
            }
            
            ZStack {
                HStack {
                    VStack(spacing: 5) {
                        Button(action: { viewRouter.currentProfileView = .drafts }, label: {Label { } icon: {
                            Image(systemName: "play.rectangle.on.rectangle")
                                .font(Font.system(.title))
                        }
                        .foregroundColor(.black)
                        })
                        Text("Library").font(Font.body1).foregroundColor(.black).bold()
                    }.padding(.leading, 35)
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Button(action: { viewRouter.currentProfileView = .inbox }, label: {Label { } icon: {
                            Image(systemName: "mail")
                                .font(Font.system(.title))
                        }
                        .foregroundColor(.black)
                        })
                        Text("Inbox").font(Font.body1).foregroundColor(.black).bold()
                    }.padding(.trailing, 35)
                    
                }
                
                VStack(alignment: .center) {
                    Button(action: { viewRouter.currentProfileView = .favorites }, label: {Label { } icon: {
                        Image(systemName: "bolt.heart")
                            .font(Font.system(.title))
                    }
                    .foregroundColor(.black)
                    })
                    Text("Favorites").font(Font.body1).foregroundColor(.black).bold()
                }
            }.padding(.top)
            
            
            
            Spacer()
            
            switch viewRouter.currentProfileView {
            case .entries:
                ProfileMediaGridView(userId: userState.userModel.user_id).onAppear { lastScreen = .entries }
                
            case .drafts:
                ProfileMediaGridView(userId: userState.userModel.user_id).onAppear { lastScreen = .drafts }
                
            case .favorites:
                Text("Favorites coming soon...").onAppear { lastScreen = .favorites }
                Spacer()
                
            case .inbox:
                Text("Inbox coming soon...").onAppear { lastScreen = .inbox }
                Spacer()
                
            case .none:
                EmptyView()
                
            }
            
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    struct MyButtonStyle: ButtonStyle {
      let navyBlue = Color(red: 0, green: 0, blue: 0.5)
      
      func makeBody(configuration: Configuration) -> some View {
        configuration.label
          .padding()
          .background(navyBlue)
          .foregroundColor(.white)
          .clipShape(Capsule())
      }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
