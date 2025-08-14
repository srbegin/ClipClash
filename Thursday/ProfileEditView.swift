//
//  ProfileEditView.swift
//  Thursday
//
//  Created by Scott Begin on 12/15/22.
//

import SwiftUI
import PhotosUI

enum ProfileAttributeType {
    case username, name
}

struct ProfileEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    
//    @State private var showingImagePicker = false
    @State private var showingPasswordChange = false
    @State private var showLogoutAlert = false
    @State private var showDeleteAccountAlert = false
    
//    @State private var inputImage: UIImage?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Done")
                    }
                    .padding(.trailing)
                    .padding(.top)
                }
                HStack {
                    Spacer()
                    Text("Edit Profile").font(Font.h5).padding(.top)
                    Spacer()
                }
            }
            .padding(.bottom)
            
            ProfilePhotoChooser(user: userState.userModel)

          
            Divider()
            ProfileEditMenuItem(label: "Username", value: userState.userModel.username, type: .username)
            Divider()
            ProfileEditMenuItem(label: "Name", value: userState.userModel.first_name+" "+userState.userModel.last_name, type: .name)
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    showingPasswordChange = true
                }, label: {
                    Text("Change password?")
                }).sheet(isPresented: $showingPasswordChange) {
                    PasswordChangeView()
                }
                .padding()
           
                Button(action: {
                    showLogoutAlert = true
                }, label: {
                    Text("Log Out")
                })
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showDeleteAccountAlert = true
                    }, label: {
                        Text("Delete Account").font(.caption).foregroundColor(.red)
                    })
                    .padding()
                    
                    Spacer()
                }
                
            }.padding(.top, 15)
                .confirmationDialog("Really Logout?", isPresented: $showLogoutAlert,  titleVisibility: .visible) {
                    Button("OK") {
                        Task {
                            await LoginManager().doLogout()
                            viewRouter.currentPage = .contests
                        }
                    }
                }
                .confirmationDialog("Delete account? THIS CANNOT BE UNDONE!", isPresented: $showDeleteAccountAlert,  titleVisibility: .visible) {
                    Button("OK") {
                        Task {
                            await LoginManager().deactivateUser(id: String(userState.userModel.id))
                            await LoginManager().doLogout()
                        }
                    }
                }
            Spacer()
        }.padding()
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}
